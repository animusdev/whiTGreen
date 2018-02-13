/obj/effect/proc_holder/the_thing/devour
	name = "Devour"
	desc = "Devour victim."
	req_human = 0


/obj/effect/proc_holder/the_thing/devour/can_ability(var/mob/living/carbon/user)
	if(!..())
		return

	var/thing = null
	if(user && user.mind && user.mind.the_thing)
		thing = user.mind.the_thing
	else
		thing = user

	if(thing:devouring)
		user << "<span class='warning'>We are already devouring!</span>"
		return

	var/obj/item/weapon/grab/G = user.get_active_hand()
	if(!istype(G))
		user << "<span class='warning'>We must be grabbing a creature in our active hand to devour them!</span>"
		return
	if(G.state <= GRAB_NECK)
		user << "<span class='warning'>We must have a tighter grip to devour this creature!</span>"
		return
	return 1



/obj/effect/proc_holder/the_thing/devour/ability_action(var/mob/living/user)
	var/thing = null
	var/havemind = 0
	if(user && user.mind && user.mind.the_thing)
		thing = user.mind.the_thing
		havemind = 1
	else
		thing = user
	var/obj/item/weapon/grab/G = user.get_active_hand()
	var/mob/living/carbon/human/target = G.affecting
	thing:devouring = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				user << "<span class='notice'>This creature is compatible. We must hold still...</span>"
			if(2)
				user.visible_message("<span class='warning'>[user] extends a proboscis!</span>", "<span class='notice'>We extend a proboscis.</span>")
			if(3)
				user.visible_message("<span class='danger'>[user] stabs [target] with the proboscis!</span>", "<span class='notice'>We stab [target] with the proboscis.</span>")
				target << "<span class='userdanger'>You feel a sharp stabbing pain!</span>"
				target.take_overall_damage(40)

		if(!do_mob(user, target, 50))
			user << "<span class='warning'>Our absorption of [target] has been interrupted!</span>"
			thing:devouring = 0
			return

	user.visible_message("<span class='danger'>[user] sucks the fluids from [target]!</span>", "<span class='notice'>We have absorbed [target].</span>")
	target << "<span class='userdanger'>You are devoured by the the thing!</span>"

	if(havemind)
		if(thing:can_devour_dna(user,target))
			thing:absorb_dna(target, user)


	if(target.mind)//if the victim has got a mind

		target.mind.show_memory(src, 0) //I can read your mind, kekeke. Output all their notes.

		var/list/recent_speech = list()

		if(target.say_log.len > LING_ABSORB_RECENT_SPEECH)
			recent_speech = target.say_log.Copy(target.say_log.len-LING_ABSORB_RECENT_SPEECH+1,0) //0 so len-LING_ARS+1 to end of list
		else
			for(var/spoken_memory in target.say_log)
				if(recent_speech.len >= LING_ABSORB_RECENT_SPEECH)
					break
				recent_speech += spoken_memory

		if(recent_speech.len)
			user.mind.store_memory("<B>Some of [target]'s speech patterns, we should study these to better impersonate them!</B>")
			user << "<span class='boldnotice'>Some of [target]'s speech patterns, we should study these to better impersonate them!</span>"
			for(var/spoken_memory in recent_speech)
				user.mind.store_memory("\"[spoken_memory]\"")
				user << "<span class='notice'>\"[spoken_memory]\"</span>"
			user.mind.store_memory("<B>We have no more knowledge of [target]'s speech patterns.</B>")
			user << "<span class='boldnotice'>We have no more knowledge of [target]'s speech patterns.</span>"

		if(target.mind.changeling)//If the target was a changeling, suck out their extra juice and objective points!
			if(havemind)
				thing:absorbedcount += (target.mind.the_thing.absorbedcount)

				target.mind.changeling.absorbed_dna.len = 1
				target.mind.changeling.absorbedcount = 0

	thing:devouring = 0
	user.biopoint += target.biopoint
	target.gib()
	return 1

//Absorbs the target DNA.
/datum/the_thing/proc/absorb_dna(mob/living/carbon/T, var/mob/user)
	if(absorbed_dna.len)
		absorbed_dna.Cut(1,2)
	T.dna.real_name = T.real_name //Set this again, just to be sure that it's properly set.
	var/datum/dna/new_dna = new T.dna.type
	new_dna.uni_identity = T.dna.uni_identity
	new_dna.struc_enzymes = T.dna.struc_enzymes
	new_dna.real_name = T.dna.real_name
	new_dna.species = T.dna.species
	new_dna.mutant_color = T.dna.mutant_color
	new_dna.blood_type = T.dna.blood_type
	absorbedcount++
	absorbed_dna |= new_dna