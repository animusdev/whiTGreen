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
	if(how_many_legs() == 1)
		if(prob(40) && !lying)
			if(!has_gravity(loc) || istype(r_hand, /obj/item/weapon/crowbar/large) || istype(l_hand, /obj/item/weapon/crowbar/large))
				return
			lay_down()
			usr << "<span class='warning'>You fell because of your decapitated leg!</span>"



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

/mob/living/proc/how_many_legs()
	if(!ishuman(src))
		return
	var/mob/living/carbon/human/H = src
	var/obj/item/organ/limb/L
	var/legs = 0
	for(L in H.organs)
		if(L.name == "l_leg" || L.name == "r_leg")
			if(L.state == ORGAN_FINE)
				legs++
	return legs


/mob/living/carbon/human/proc/handle_legs()
	if(!how_many_legs())
		lay_down()


/mob/living/carbon/human/proc/handle_legs_delay()
	if(how_many_legs() == 2)
		return 0 // no movement delay
	var/list/hands
	var/delay = 10  //base movement delay without one leg
	hands = get_both_hands(src)
	for(var/obj/hand in hands)
		if(istype(hand, /obj/item/weapon/crowbar/large))
			delay -= 4
	return delay