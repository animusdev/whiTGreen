var/list/ability_paths

/obj/effect/proc_holder/the_thing
	panel = "The Thing"
	name = "Prototype ability"
	desc = "" // Fluff
	var/helptext = "" // Details
	var/req_human = 0 //if you need to be human to use this ability
	var/req_stat = CONSCIOUS // CONSCIOUS, UNCONSCIOUS or DEAD

/obj/effect/proc_holder/the_thing/Click()
	var/mob/user = usr
	if(!user || !user.mind || !user.mind.the_thing)
		return
	try_to_ability(user)

/obj/effect/proc_holder/the_thing/proc/try_to_ability(var/mob/user, var/mob/target)
	if(!can_ability(user, target))
		return
	if(ability_action(user, target))
		return 1

/obj/effect/proc_holder/the_thing/proc/ability_action(var/mob/user, var/mob/target)
	return 0


//Fairly important to remember to return 1 on success >.<
/obj/effect/proc_holder/the_thing/proc/can_ability(var/mob/user, var/mob/target)
	if(!ishuman(user)&&!istype(user, /mob/living/simple_animal/hostile/the_thing))// && !ismonkey(user)) //typecast everything from mob to carbon from this point onwards
		return 0
	if(req_human && !ishuman(user))
		user << "<span class='warning'>Ìû íå ìîæåì ñäåëàòü ýòîãî â äàííîé ôîðìå!</span>"
		return 0

	return 1

//used in /mob/Stat()
/obj/effect/proc_holder/the_thing/proc/can_be_used_by(var/mob/user)
	if(!ishuman(user))// && !ismonkey(user))
		return 0
	if(req_human && !ishuman(user))
		return 0
	return 1

/datum/the_thing/proc/has_ability(obj/effect/proc_holder/the_thing/power)
	for(var/obj/effect/proc_holder/the_thing/P in purchasedpowers)
		if(power.name == P.name)
			return 1
	return 0

/mob/proc/remove_thing_powers(var/keep_free_powers=0)
	if(ishuman(src))// || ismonkey(src))
		if(mind && mind.the_thing)
			for(var/obj/effect/proc_holder/the_thing/p in mind.the_thing.purchasedpowers)
				if(!(keep_free_powers))
					mind.the_thing.purchasedpowers -= p
		if(hud_used)
			hud_used.thingabilitydisplay.icon_state = null
			hud_used.thingabilitydisplay.invisibility = 101

/mob/proc/make_the_thing()
	if(!mind)
		return
	if(!ishuman(src))
		return
	if(!mind.the_thing)
		mind.the_thing = new /datum/the_thing
	if(!ability_paths)
		ability_paths = init_paths(/obj/effect/proc_holder/the_thing)
	if(mind.the_thing.purchasedpowers)
		remove_thing_powers(1)
	// purchase free powers.
	for(var/path in ability_paths)
		var/obj/effect/proc_holder/the_thing/S = new path()
		if(!mind.the_thing.has_ability(S))
			mind.the_thing.purchasedpowers+=S

	var/mob/living/carbon/human/H = src
	faction |= "the thing"
	mind.the_thing.absorbed_dna |= H.dna
	for(var/obj/item/organ/limb/L in H.organs)
		if(L.vital)
			L.vital = 0
	return 1
