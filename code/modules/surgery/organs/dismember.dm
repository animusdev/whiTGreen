///////////////////
// Dismemberment //
///////////////////

//handle the removal of limbs

/obj/item/organ/limb/proc/dismember(var/obj/item/I, var/removal_type, var/overide)
	var/obj/item/organ/limb/affecting = src

//	if(istype(src, /obj/item/organ/limb/head))
//		return


	if(affecting.state == ORGAN_REMOVED)
		return
	if(affecting.body_part == CHEST)
		return
	var/mob/living/carbon/human/owner = affecting.owner

	var/dismember_chance = 0 //Chance to fall off, tends to be the Item's force
	var/succesful = 0 //Did they lose the limb?

	if(!overide)
		switch(removal_type)
			if(EXPLOSION_DISMEMBERMENT)
				dismember_chance = 45
			if(GUN_DISMEMBERMENT)
				dismember_chance = 30
			if(MELEE_DISMEMBERMENT)
				if(I)
					dismember_chance = I.force
	else
		dismember_chance = overide //So you can specify an overide chance to dismember, for Unique weapons / Non weapon dismemberment

	if(affecting.body_part == HEAD || affecting.body_part == CHEST)
		dismember_chance -= 25 //25% more likely to remain on the body

	if(I)
		if((affecting.brute_dam + I.force) >= (affecting.max_damage / 2) && affecting.state != ORGAN_REMOVED)
			succesful++

	else
		if((affecting.brute_dam) >= (affecting.max_damage / 2) && affecting.state != ORGAN_REMOVED)
			succesful++

	if(succesful)
		if(prob(dismember_chance))

			owner.apply_damage(30, "brute","[affecting]")
			affecting.state = ORGAN_REMOVED
			affecting.dismember_act()
			affecting.drop_limb(owner)
			affecting.brutestate = 0
			affecting.burnstate = 0

			owner.visible_message("<span class='danger'><B>[owner]'s [affecting.getDisplayName()] has been violently dismembered!</B></span>")

			owner.drop_r_hand() //Removes any items they may be carrying in their now non existant arms
			owner.drop_l_hand() //Handled here due to the "shock" of losing any limb

		if(vital)
			owner.death()
		owner.regenerate_icons()  //Redraw the mob and all it's clothing
		owner.update_canmove()
		owner.update_damage_overlays()

////////////////////
// Dismember acts //
////////////////////

//For each limb type's individual code to run on dismembering


/obj/item/organ/limb/proc/dismember_act()
	return

/obj/item/organ/limb/head/dismember_act()
	if(!owner)
		return

	if(status == ORGAN_ORGANIC)
		var/obj/item/organ/brain/B = new /obj/item/organ/brain (get_turf(owner))
		B.transfer_identity(owner)
		owner.internal_organs -= B

	if(status == ORGAN_ROBOTIC)
		var/obj/item/organ/limb/robot/R = new /obj/item/organ/limb/robot/head (get_turf(owner))
		R.name = "[owner.name]'s robotic head"
		R.pixel_y = -15


/obj/item/organ/limb/chest/dismember_act()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	var/obj/item/organ/limb/L = pick(H.organs)

	L.dismember_act()
	return


/obj/item/organ/limb/r_arm/dismember_act()
	handle_arm_removal()

/obj/item/organ/limb/l_arm/dismember_act()
	handle_arm_removal()

/obj/item/organ/limb/r_leg/dismember_act()
	handle_leg_removal()

/obj/item/organ/limb/l_leg/dismember_act()
	handle_leg_removal()


///////////////////////
// Arm & Leg helpers //
///////////////////////

//Exists soley to prevent copy paste

/obj/item/organ/limb/proc/handle_arm_removal()
	if(!owner || !ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	if(H.handcuffed)
		H.handcuffed.loc = get_turf(owner)
		H.handcuffed = null
		H.update_inv_handcuffed(0)
	if(!handle_removed_arms(H))
		H.unEquip(H.gloves)

/obj/item/organ/limb/proc/handle_leg_removal()
	if(!owner || !ishuman(owner))
		return


	var/mob/living/carbon/human/H = owner
	H.update_inv_shoes()
	if(H.legcuffed)
		H.legcuffed.loc = get_turf(owner)
		H.legcuffed = null
		H.update_inv_legcuffed(0)
	if(!handle_removed_legs(H))
		H.unEquip(H.shoes)
