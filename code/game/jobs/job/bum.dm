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
	if (prob(80))
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/vodka(H), slot_r_hand)
	if (prob(60))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette(H), slot_wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
	if (prob(40))
		H.equip_to_slot_or_del(new /obj/item/weapon/lighter/random(H), slot_r_store)
	if (prob(20))
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(H), slot_l_store)

/datum/job/bum/get_access()
	. = ..()
	. |= list(access_maint_tunnels)

/datum/job/bum/config_check()
	if(config && !(config.assistant_cap == 0))
		total_positions = config.assistant_cap
		spawn_positions = config.assistant_cap
		return 1
	return 0

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
	var/obj/item/weapon/card/id/C = new default_id(H)
	C.access = get_access()
	C.registered_name = H.real_name
	C.assignment = H.job
	C.update_label()
	H.equip_to_slot_or_del(C, slot_wear_id)

	//Equip headset
	H.equip_to_slot_or_del(new src.default_headset(H), slot_ears)