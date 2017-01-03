/mob/living/carbon/human/movement_delay()
	if(dna)
		. += dna.species.movement_delay(src)

	. += ..()
	. += config.human_delay
	. += handle_legs_delay()

/mob/living/carbon/human/Process_Spacemove(var/movement_dir = 0)

	if(..())
		return 1

	//Do we have a working jetpack
	if(istype(back, /obj/item/weapon/tank/jetpack) && isturf(loc)) //Second check is so you can't use a jetpack in a mech
		var/obj/item/weapon/tank/jetpack/J = back
		if((movement_dir || J.stabilization_on) && J.allow_thrust(0.01, src))
			return 1
	if(istype(wear_suit, /obj/item/clothing/suit/space/hardsuit) && isturf(loc)) //Second check is so you can't use a jetpack in a mech
		var/obj/item/clothing/suit/space/hardsuit/C = wear_suit
		if(C.jetpack)
			if((movement_dir || C.jetpack.stabilization_on) && C.jetpack.allow_thrust(0.01, src))
				return 1

	return 0


/mob/living/carbon/human/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	if(isobj(shoes) && (shoes.flags&NOSLIP) && !(lube&GALOSHES_DONT_HELP))
		return 0
	.=..()

/mob/living/carbon/human/mob_has_gravity()
	. = ..()
	if(!.)
		if(mob_negates_gravity())
			. = 1

/mob/living/carbon/human/mob_negates_gravity()
	return shoes && shoes.negates_gravity()

/mob/living/carbon/human/Move(NewLoc, direct)
	..()
	if(abs(handle_removed_legs(src)) == 1)
		if(prob(40) && !lying)
			if(!has_gravity(loc) || istype(r_hand, /obj/item/weapon/support) || istype(l_hand, /obj/item/weapon/support))
				return
			lay_down()
			src << "<span class='warning'>You fell because of your decapitated leg!</span>"



	if(shoes)
		if(!lying)
			if(loc == NewLoc)
				if(!has_gravity(loc))
					return
				var/obj/item/clothing/shoes/S = shoes
				S.step_action()

/mob/living/carbon/human/update_canmove() //TODO: add crunches support
	if(..())
		handle_legs()

/proc/handle_removed_legs(var/mob/M)
	if(!ishuman(M))
		return 2
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/limb/L = get_limb("l_leg", H)
	var/obj/item/organ/limb/R = get_limb("r_leg", H)

	if(L.state == ORGAN_REMOVED && R.state == ORGAN_REMOVED)
		return 0
	if(L.state == ORGAN_REMOVED && R.state == ORGAN_FINE)
		return -1
	if(L.state == ORGAN_FINE && R.state == ORGAN_REMOVED)
		return 1
	return 2 // both_legs are fine

/mob/living/carbon/human/proc/handle_legs()
	if(!handle_removed_legs(src))
		lay_down()


/mob/living/carbon/human/proc/handle_legs_delay()
	if(handle_removed_legs(src) == 2)
		return 0 // no movement delay
	var/list/hands
	var/delay = 10  //base movement delay without one leg
	hands = get_both_hands(src)
	for(var/obj/hand in hands)
		if(istype(hand, /obj/item/weapon/support))
			delay -= 4
	return delay