mob/proc/getorgan()
	return

mob/proc/getorgansloc()
	return

mob/living/carbon/getorgan(typepath)
	return (locate(typepath) in internal_organs)

mob/living/carbon/getorgansloc(zone)
	var/list/returnorg = list()
	for(var/obj/item/organ/internal/O in internal_organs)
		if(zone == O.zone)
			returnorg += O

	return returnorg

mob/proc/getlimb()
	return

mob/living/carbon/human/getlimb(typepath)
	return (locate(typepath) in organs)

/obj/item/organ/limb/proc/release_restraints()
	if (owner.handcuffed && body_part in list(ARM_LEFT, ARM_RIGHT))
		owner.visible_message(\
			"\The [owner.handcuffed.name] falls off of [owner.name].",\
			"\The [owner.handcuffed.name] falls off you.")

		owner.update_inv_handcuffed(0)

	if (owner.legcuffed && body_part in list(LEG_LEFT, LEG_RIGHT))
		owner.visible_message(\
			"\The [owner.legcuffed.name] falls off of [owner.name].",\
			"\The [owner.legcuffed.name] falls off you.")

		owner.update_inv_legcuffed(0)

