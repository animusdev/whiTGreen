/mob/living/simple_animal/hostile/the_thing
	name = "Strange piece of biomass"
	desc = "It is a strange piece of biomass with tentacle... AND IT'S ALIVE!"
	ventcrawler = 2
	maxHealth = 100
	health = 100
	icon = 'icons/mob/thing.dmi'
	icon_state = "thing_tors"
	icon_living = "thing_tors"
	icon_dead = "thing_dead"
	a_intent = "harm"
	density = 0
	canmove = 0
	anchored = 1
	harm_intent_damage = 3
	melee_damage_lower = 20
	melee_damage_upper = 30
	turns_per_move = 4
	speed = 1
	attacktext = "claws"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	minbodytemp = 0
	maxbodytemp = 1500
	robust_searching = 1
	stat_attack = 2
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	layer = MOB_LAYER + 0.1
	environment_smash = 0
	move_to_delay = 3
	see_in_dark = 9
	status_flags = 0
	faction = list("the thing")
	pass_flags = PASSTABLE
	var/datum/mind/leader_mind = null

	var/devouring = 0
	var/merging_proc = 0
	biopoint = 10
	var/feedon = 0
	var/mob/living/Victim = null // the person the slime is currently feeding on
	var/obj/effect/proc_holder/the_thing/devour/devour = new()

/mob/living/simple_animal/hostile/the_thing/big
	name = "The Thing"
	maxHealth = 500
	health = 500
	melee_damage_lower = 50
	melee_damage_upper = 70
	ventcrawler = 0
	layer = MOB_LAYER
	icon = 'icons/mob/thing_big.dmi'
	icon_state = "big_thing"
	icon_living = "big_thing"
	icon_dead = "big_thing_dead"
	pixel_x = -16
	environment_smash = 3

/mob/living/simple_animal/hostile/the_thing/leg
	name = "Strange piece of biomass"
	desc = "It is a strange leg with tentacle... AND IT'S ALIVE!"
	icon_state = "thing_leg"
	icon_living = "thing_leg"

/mob/living/simple_animal/hostile/the_thing/arm
	name = "Strange piece of biomass"
	desc = "It is a strange arm with tentacle... AND IT'S ALIVE!"
	icon_state = "thing_arm"
	icon_living = "thing_arm"

/mob/living/simple_animal/hostile/the_thing/head
	name = "Strange piece of biomass"
	desc = "It is a strange head with tentacle... AND IT'S ALIVE!"
	icon_state = "thing_head"
	icon_living = "thing_head"

/mob/living/simple_animal/hostile/the_thing/biomass
	name = "Strange biomass"
	desc = "It is a strange piece of biomass with tentacle... AND IT'S ALIVE!"
	icon_state = "thing_biomass1"
	icon_living = "thing_biomass1"

/mob/living/simple_animal/hostile/the_thing/biomass/New()
	..()
	var/N = rand(1, 3)
	icon_state = "thing_biomass[N]"
	icon_living = "thing_biomass[N]"

/mob/living/simple_animal/hostile/the_thing/Stat()
	if(..())
		stat(null,"biomass points: [round(biopoint)]")

/mob/living/simple_animal/hostile/the_thing/start_pulling(var/atom/movable/AM)
	return

///SEPARATION///
/mob/living/simple_animal/hostile/the_thing/proc/take_thing_organ_damage(var/mob/living/carbon/human/H, var/obj/item/organ/limb/dismembered)
	for(var/obj/item/organ/limb/L in H.organs)
		if(dismembered.body_part == L.body_part)
			var/brute = dismembered.brute_dam * (biopoint / dismembered.max_damage)
			var/burn = dismembered.burn_dam * (biopoint / dismembered.max_damage)
			src.apply_damages(brute, burn)
	updatehealth()

/mob/living/simple_animal/hostile/the_thing/proc/separation_spawn()
	var/list/dirs = alldirs.Copy()
	spawn(0)
		var/direction = pick(dirs)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (step_to(src, get_step(src, direction), 0))
				break

///MERGE///
/mob/living/simple_animal/hostile/the_thing/verb/Merge()
	set category = "The Thing"
	merging_leader()

/mob/living/proc/merging_leader()
	for(var/mob/living/simple_animal/hostile/the_thing/T in oview(7))
		spawn(9) T.merging()

/mob/living/proc/update_biomass(var/mob/living/simple_animal/hostile/the_thing/T)
	var/mob/living/M = src
	var/tempbio = biopoint + T.biopoint
	var/datum/mind/temp_leader = M.mind
	switch(tempbio)
		if(11 to 59)
			if(!istype(src, /mob/living/simple_animal/hostile/the_thing/biomass) && istype(src, /mob/living/simple_animal/hostile/the_thing))
				M.mind.the_thing.thing_list.Remove(M)
				M = src.change_mob_type(/mob/living/simple_animal/hostile/the_thing/biomass , null, null, 1)
				M:leader_mind = temp_leader
				M.mind.the_thing.thing_list.Add(M)

		if(60 to 1.#INF)
			if(!istype(src, /mob/living/carbon/human) && !istype(src, /mob/living/simple_animal/hostile/the_thing/big))
				M.mind.the_thing.thing_list.Remove(M)
				M = src.change_mob_type(/mob/living/carbon/human , null, null, 1)
				M.faction |= "the thing"

	M.biopoint = tempbio
	M.maxHealth = biopoint*2
	M.health += T.health
	M.updatehealth()

/mob/living/simple_animal/hostile/the_thing/proc/merging()
	LoseTarget()
	if(merging_proc)
		return
	merging_proc = 1
	while(merging_proc)
		if(leader_mind.current in oviewers(, src))
			if(canmove && isturf(loc))
				if(get_dist(src, leader_mind.current)>1)
					step_to(src, leader_mind.current)
				else
					playsound(loc, 'sound/hallucinations/growl1.ogg', 50, 1)
					merging_proc = 0
					sleep(5)
					leader_mind.current.update_biomass(src)
					leader_mind.the_thing.thing_list.Remove(src)
					qdel(src)
					return
		else
			break
		var/sleeptime = movement_delay()
		if(sleeptime <= 0) sleeptime = 1
		sleep((sleeptime + 2))
	merging_proc = 0

///REGENERATION///
/mob/living/simple_animal/hostile/the_thing/verb/Regeneration()
	set category = "The Thing"
	regen()

/mob/living/simple_animal/hostile/the_thing/proc/regen()
	if(biopoint < 60)
		src << "<span class='warning'>У нас недостаточно биомассы!</span>"
		return

	if(istype(src, /mob/living/simple_animal/hostile/the_thing/big))
		src << "<span class='warning'>Мы не можем сделать это в данном форме!</span>"
		return

	regenerate_icons()
	notransform = 1
	canmove = 0
	stunned = 6
	icon = null
	overlays.Cut()
	invisibility = 101

	anim(src.loc,src,'icons/mob/thing.dmi',,"gib2human", 65,src.dir)
	var/tempbio = biopoint
	var/mob/living/M = src.change_mob_type(/mob/living/carbon/human , null, null, 1)
	M.faction |= "the thing"
	M.biopoint = tempbio
	anim(src.loc,src,'icons/mob/thing.dmi',,"thing2human", 12,src.dir)

///SWAP///
/mob/living/simple_animal/hostile/the_thing/verb/Swaping()
	set category = "The Thing"
	swap()

/mob/living/simple_animal/hostile/the_thing/proc/swap()
	if(!istype(src, /mob/living/simple_animal/hostile/the_thing))
		src << "<span class='warning'>Не возможно сделать в данный момент!</span>"
		return
	if(mind && mind.the_thing && mind.the_thing.thing_list.len > 1)
		mind.transfer_to(pick(mind.the_thing.thing_list))

/mob/living/simple_animal/hostile/the_thing/DblClick()
	if(stat == DEAD)
		return ..()
	if(mind)
		return ..()
	if(istype(usr, /mob/living/simple_animal/hostile/the_thing))
		var/mob/living/simple_animal/hostile/the_thing/T = usr
		T.mind.transfer_to(src)
	return ..()

///HIDE///
/mob/living/simple_animal/hostile/the_thing/verb/Hide()
	set category = "The Thing"
	hide(src)

/mob/living/simple_animal/hostile/the_thing/proc/hide(var/mob/living/user)
	if(user.stat != CONSCIOUS)
		return

	if(istype(src, /mob/living/simple_animal/hostile/the_thing/big))
		user << "<span class='warning'>Мы не можем сделать это в данном форме!</span>"
		return

	if(user.layer != TURF_LAYER+0.2)
		user.layer = TURF_LAYER+0.2
		user.visible_message("<span class='name'>[user] scurries to the ground!</span>", \
						"<span class='noticealien'>You are now hiding.</span>")
	else
		user.layer = MOB_LAYER
		user.visible_message("[user.] slowly peaks up from the ground...", \
					"<span class='noticealien'>You stop hiding.</span>")
	return 1

///////////

/mob/living/simple_animal/hostile/the_thing/death(gibbed)
	leader_mind.the_thing.thing_list.Remove(src)
	if(mind && mind == leader_mind)
		swap()
	return ..(gibbed)

/mob/living/simple_animal/hostile/the_thing/say()
	return

/mob/living/simple_animal/hostile/the_thing/CanAttack()
	if(devouring)
		return 0
	return ..()

/mob/living/simple_animal/hostile/the_thing/AttackingTarget()
	if(!ismob(target))
		return ..()
	var/mob/T = target

	if(!feedon && T.stat && CanFeedon(T) && prob(40))
		Feedon(T)
		return
	else
		return ..()
