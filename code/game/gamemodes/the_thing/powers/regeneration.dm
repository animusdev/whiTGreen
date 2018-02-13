/obj/effect/proc_holder/the_thing/merge
	name = "Merge"
	desc = "Merging youre pice in one."
	req_human = 0

/obj/effect/proc_holder/the_thing/merge/ability_action(var/mob/living/user)
	user.merging_leader()

/obj/effect/proc_holder/the_thing/regeneration
	name = "Regenerate"
	desc = "Regenerate youre limbs"
	req_human = 1

/obj/effect/proc_holder/the_thing/regeneration/ability_action(var/mob/living/user)
	var/mob/living/carbon/human/M
	if(M.organs.len < 6)
		for(var/obj/item/I in user)
			user.unEquip(I)
		M = user.change_mob_type(/mob/living/carbon/human , null, null, 1)
		M.faction |= "the thing"

/obj/effect/proc_holder/the_thing/evolve
	name = "Evolve"
	desc = "Evolve to big form"
	req_human = 1

/obj/effect/proc_holder/the_thing/evolve/ability_action(var/mob/living/user)
	if(user.biopoint < 240)
		user << "<span class='warning'>У вас недостаточно биомассы!</span>"
		return

	var/tempbio = user.biopoint
	animate(user, pixel_x = 16, icon = 'icons/mob/thing_big.dmi', icon_state = "human2big", dir = src.dir)
	playsound(user.loc, 'sound/voice/gib_scream_male.ogg', 50, 1)
	var/mob/living/M = user.change_mob_type(/mob/living/simple_animal/hostile/the_thing/big , null, null, 1)
	M.biopoint = tempbio
