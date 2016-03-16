/datum/job

	//The name of the job
	var/title = "NOPE"

	var/r_title = "" // Russian title for newbie job description

	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		//Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				//Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	//Determines who can demote this position
	var/department_head = list()

	//Bitflags for the job
	var/flag = 0
	var/department_flag = 0

	//Players will be allowed to spawn in as jobs that are set to "Station"
	var/faction = "None"

	//How many players can be this job
	var/total_positions = 0

	//How many players can spawn in as this job
	var/spawn_positions = 0

	//How many players have this job
	var/current_positions = 0

	//Supervisors, who this person answers to directly
	var/supervisors = ""

	//Sellection screen color
	var/selection_color = "#ffffff"


	//If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/req_admin_notify

	//If you have the use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0

	//Job specific items
	var/default_id				= /obj/item/weapon/card/id //this is just the looks of it
	var/default_pda				= /obj/item/device/pda
	var/default_pda_slot	= slot_belt
	var/default_headset		= /obj/item/device/radio/headset
	var/default_backpack	= /obj/item/weapon/storage/backpack
	var/default_satchel		= /obj/item/weapon/storage/backpack/satchel_norm
	var/default_storagebox= /obj/item/weapon/storage/box/survival

//Only override this proc
/datum/job/proc/equip_items(var/mob/living/carbon/human/H)

//Or this proc
/datum/job/proc/equip_backpack(var/mob/living/carbon/human/H)
	switch(H.backbag)
		if(1) //No backpack or satchel
			H.equip_to_slot_or_del(new default_storagebox(H), slot_r_hand)
		if(2) // Backpack
			var/obj/item/weapon/storage/backpack/BPK = new default_backpack(H)
			new default_storagebox(BPK)
			H.equip_to_slot_or_del(BPK, slot_back,1)
		if(3) //Satchel
			var/obj/item/weapon/storage/backpack/BPK = new default_satchel(H)
			new default_storagebox(BPK)
			H.equip_to_slot_or_del(BPK, slot_back,1)

//But don't override this
/datum/job/proc/equip(var/mob/living/carbon/human/H)
	if(!H)
		return 0

	//Equip backpack
	equip_backpack(H)

	//Equip the rest of the gear
	if(H.dna)
		H.dna.species.before_equip_job(src, H)

	equip_items(H)

	if(H.dna)
		H.dna.species.after_equip_job(src, H)

	//Equip ID
	var/obj/item/weapon/card/id/C = new default_id(H)
	C.access = get_access()
	C.registered_name = H.real_name
	C.assignment = H.job
	C.update_label()
	H.equip_to_slot_or_del(C, slot_wear_id)

	//Equip PDA
	var/obj/item/device/pda/PDA = new default_pda(H)
	PDA.owner = H.real_name
	PDA.ownjob = H.job
	PDA.update_label()
	H.equip_to_slot_or_del(PDA, default_pda_slot)

	//Equip headset
	H.equip_to_slot_or_del(new src.default_headset(H), slot_ears)

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H,1)	//The 1 sets a flag to ignore gloves
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H,1)
	if(H.wear_id)
		H.wear_id.add_fingerprint(H,1)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H,1)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H,1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H,1)
	if(H.head)
		H.head.add_fingerprint(H,1)
	if(H.shoes)
		H.shoes.add_fingerprint(H,1)
	if(H.gloves)
		H.gloves.add_fingerprint(H,1)
	if(H.ears)
		H.ears.add_fingerprint(H,1)
	if(H.glasses)
		H.glasses.add_fingerprint(H,1)
	if(H.belt)
		H.belt.add_fingerprint(H,1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H,1)
	if(H.s_store)
		H.s_store.add_fingerprint(H,1)
	if(H.l_store)
		H.l_store.add_fingerprint(H,1)
	if(H.r_store)
		H.r_store.add_fingerprint(H,1)
	if(H.neck)
		H.neck.add_fingerprint(H,1)
	return 1

/datum/job/proc/get_access()
	if(!config)	//Needed for robots.
		return src.minimal_access.Copy()

	. = list()

	if(config.jobs_have_minimal_access)
		. = src.minimal_access.Copy()
	else
		. = src.access.Copy()

	. |= list(access_maint_tunnels)

/datum/job/proc/config_check()
	return 1
