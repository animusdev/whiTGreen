/*
Spess Bum
*/
/datum/job/bum
	title = "Bum"
	r_title = "бомж"
	flag = BUM
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "абсолютно всем, кто найдет вас ещё живым"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

/datum/job/bum/equip_items(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/pants/jeans(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/jacket/puffer(H), slot_wear_suit)
	if (prob(60))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
	if (prob(40))
		H.equip_to_slot_or_del(new /obj/item/weapon/lighter/random(H), slot_r_store)

/datum/job/bum/get_access()
	. = ..()
	. |= list(access_maint_tunnels)

/datum/job/bum/config_check()
	if(config && !(config.assistant_cap == 0))
		total_positions = config.assistant_cap
		spawn_positions = config.assistant_cap
		return 1
	return 0

/datum/job/bum/apply_fingerprints(var/mob/living/carbon/human/H)
	return

/datum/job/bum/equip(var/mob/living/carbon/human/H)
	if(!H)
		return 0

	//Equip the rest of the gear
	if(H.dna)
		H.dna.species.before_equip_job(src, H)

	equip_items(H)

	if(H.dna)
		H.dna.species.after_equip_job(src, H)

	//Equip ID
	var/obj/item/weapon/card/id/C = new /obj/item/weapon/card/id/bum(H)
	C.access = get_access()
	C.registered_name = "[prob(50)?pick(first_names_male):pick(first_names_female)] [pick(last_names)]"
	C.assignment = H.job
	C.update_label()
	H.equip_to_slot_or_del(C, slot_wear_id)
