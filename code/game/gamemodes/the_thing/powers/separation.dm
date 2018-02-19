/obj/effect/proc_holder/the_thing/separation
	name = "Separation"
	desc = "Devour victim."
	req_human = 1

/obj/effect/proc_holder/the_thing/separation/ability_action(var/mob/living/carbon/human/user)
	if(!istype(user, /mob/living/carbon/human || !user.mind)) //sanity check
		return
	user.mind.the_thing.thing_list.Remove(user)
	var/list/obj/item/organ/limb/thing_part = new()
	var/mob/living/carbon/human/H = user
	for(var/obj/item/organ/limb/L in H.organs)
		H.organs  -=  L
		thing_part.Add(L.drop_limb())
	H.mind.transfer_to(pick(thing_part))
	for(var/obj/item/I in H)
		H.unEquip(I)
	H.gib()

/mob/living/carbon/human/proc/on_limb_dismember(var/obj/item/organ/limb/dismembered)
	var/mob/living/simple_animal/hostile/the_thing/H
	if(mind && mind.the_thing && dismembered.status == ORGAN_ORGANIC)
		switch(dismembered.body_part)
			if(CHEST)
				H = new/mob/living/simple_animal/hostile/the_thing(dismembered.loc)
			if(ARM_RIGHT )
				H = new/mob/living/simple_animal/hostile/the_thing/arm(dismembered.loc)
			if(ARM_LEFT)
				H = new/mob/living/simple_animal/hostile/the_thing/arm(dismembered.loc)
			if(LEG_RIGHT)
				H = new/mob/living/simple_animal/hostile/the_thing/leg(dismembered.loc)
			if(LEG_LEFT)
				H = new/mob/living/simple_animal/hostile/the_thing/leg(dismembered.loc)
			if(HEAD)
				H = new/mob/living/simple_animal/hostile/the_thing/head(dismembered.loc)

		H.biopoint = biopoint / (organs.len + 1)
		biopoint -= H.biopoint
		H.take_thing_organ_damage(src, dismembered)
		H.leader_mind = mind
		mind.the_thing.thing_list.Add(H)
		H.separation_spawn()
		qdel(dismembered)
		H.maxHealth = H.biopoint*2
		H.health = H.biopoint*2
		.= H
	else
		if(dismembered.status == ORGAN_ORGANIC)
			biopoint -= 10

/mob/living/carbon/human/Life()
	if(mind && mind.the_thing && InCritical())
		mind.the_thing.separation.try_to_ability(src)
	..()