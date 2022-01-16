/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	r_title = "ассистент"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "абсолютно всем"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

/datum/job/assistant/equip_items(var/mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(H), slot_shoes)
	if (prob(15) && H.gender == "male")
		H.equip_to_slot_or_del(new /obj/item/dogtag/jobspawn(H), slot_neck)
	if (config.grey_assistants)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/color/random(H), slot_w_uniform)

/datum/job/assistant/get_access()
		. = ..()
		. |= list(access_maint_tunnels)

/datum/job/assistant/config_check()
	if(config && !(config.assistant_cap == 0))
		total_positions = config.assistant_cap
		spawn_positions = config.assistant_cap
		return 1
	return 0
