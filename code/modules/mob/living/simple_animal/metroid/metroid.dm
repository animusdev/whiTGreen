/mob/living/simple_animal/metroid
	name = "baby metroid"
	icon = 'icons/mob/metroid.dmi'
	icon_state = "baby metroid"
	pass_flags = PASSTABLE
	ventcrawler = 2
	var/is_adult = 0
	var/docile = 0
	languages = SLIME | HUMAN
	faction = list("slime")

	harm_intent_damage = 5
	icon_living = "baby metroid"
	icon_dead = "baby metroid dead"
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("покачиваетс&#255;.", "подпрыгивает на месте.")
	speak_emote = list("гудит")

	layer = 5

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)

	maxHealth = 200
	health = 200
	gender = NEUTER

	nutrition = 500

	see_in_dark = 8

	verb_say = "телепатически шепчет"
	verb_engsay = "hums"
	verb_ask = "телепатически спрашивает"
	verb_exclaim = "телепатически кричит"
	verb_yell = "телепатически вопит"

	status_flags = CANPARALYSE|CANPUSH

	var/cores = 3
	var/tame = 0

	var/list/Friends = list() // A list of potential friends


	var/powerlevel = 0 // 1-10 controls how much electricity they are generating
	var/amount_grown = 0 // controls how long the slime has been overfed, if 10, grows or reproduces

	var/number = 0 // Used to understand when someone is talking to it

	var/mob/living/Victim = null // the person the slime is currently feeding on
	var/mob/living/Target = null // AI variable - tells the slime to hunt this down

	var/attacked = 0 // Determines if it's been attacked recently. Can be any number, is a cooloff-ish variable
	var/rabid = 0 // If set to 1, the slime will attack and eat anything it comes in contact with
	var/holding_still = 0 // AI variable, cooloff-ish for how long it's going to stay in one place
	var/target_patience = 0 // AI variable, cooloff-ish for how long it's going to follow its target

	var/list/speech_buffer = list() // Last phrase said near it and person who said it


	///////////TIME FOR SUBSPECIES

	var/coretype = /obj/item/metroidcore
/obj/item/metroidcore
	var/a = 1

/mob/living/simple_animal/metroid/New()
	if(is_adult)
		health = 200
		maxHealth = 200
	create_reagents(100)
	spawn (0)
		number = rand(1, 1000)
		name = "[is_adult ? "adult" : "baby"] metroid ([number])"
		icon_state = "[is_adult ? "adult" : "baby"] metroid"
		icon_dead = "[icon_state] dead"
		real_name = name
	..()

/mob/living/simple_animal/metroid/regenerate_icons()
	overlays.len = 0
	var/icon_text = "[is_adult ? "adult" : "baby"] metroid"
	icon_dead = "[icon_text] dead"
	if(stat != DEAD)
		icon_state = icon_text
	else
		icon_state = icon_dead
	..()

/mob/living/simple_animal/metroid/movement_delay()
	if(bodytemperature >= 330.23) // 135 F
		return -1	// slimes become supercharged at high temperatures

	var/tally = 0

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45)
		tally += (health_deficiency / 25)

	if(bodytemperature < 183.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	if(reagents)
		if(reagents.has_reagent("morphine")) // morphine slows slimes down
			tally *= 2

		if(reagents.has_reagent("frostoil")) // Frostoil also makes them move VEEERRYYYYY slow
			tally *= 5

	if(health <= 0) // if damaged, the slime moves twice as slow
		tally *= 2

	return tally + config.slime_delay

/mob/living/simple_animal/metroid/ObjBump(obj/O)
	if(!client && powerlevel > 0)
		var/probab = 10
		switch(powerlevel)
			if(1 to 2)	probab = 20
			if(3 to 4)	probab = 30
			if(5 to 6)	probab = 40
			if(7 to 8)	probab = 60
			if(9)		probab = 70
			if(10)		probab = 95
		if(prob(probab))
			if(istype(O, /obj/structure/window) || istype(O, /obj/structure/grille))
				if(nutrition <= get_hunger_nutrition() && !Atkcool)
					if (is_adult || prob(10))
						O.attack_slime(src)
						Atkcool = 1
						spawn(15)
							Atkcool = 0

/mob/living/simple_animal/metroid/Process_Spacemove(var/movement_dir = 0)
	return 2

/mob/living/simple_animal/metroid/Stat()
	if(..())

		if(!docile)
			stat(null, "Nutrition: [nutrition]/[get_max_nutrition()]")
		if(amount_grown >= 10)
			if(is_adult)
				stat(null, "You can reproduce!")
			else
				stat(null, "You can evolve!")

		stat(null,"Power Level: [powerlevel]")

/mob/living/simple_animal/metroid/adjustFireLoss(amount)
	..(-abs(amount)) // Heals them
	return

/mob/living/simple_animal/metroid/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return
	attacked += 10
	if((Proj.damage_type == BURN))
		adjustBruteLoss(-abs(Proj.damage)) //fire projectiles heals slimes.
		Proj.on_hit(src, 0)
	else
		..(Proj)
	return 0

/mob/living/simple_animal/metroid/emp_act(severity)
	powerlevel = 0 // oh no, the power!
	..()

/mob/living/simple_animal/metroid/MouseDrop(var/atom/movable/A as mob|obj)
	if(isliving(A) && A != src)
		var/mob/living/Food = A
		if(CanFeedon(Food))
			Feedon(Food)
	..()

/mob/living/simple_animal/metroid/unEquip(obj/item/W as obj)
	return

/mob/living/simple_animal/metroid/start_pulling(var/atom/movable/AM)
	return

/mob/living/simple_animal/metroid/attack_ui(slot)
	return

/mob/living/simple_animal/metroid/attack_slime(mob/living/simple_animal/slime/M as mob)
	if(..()) //successful slime attack
		if(M == src)
			return
		if(Victim)
			Victim = null
			visible_message("<span class='danger'>[M] pulls [src] off!</span>")
			return
		attacked += 5
		if(nutrition >= 100) //steal some nutrition. negval handled in life()
			nutrition -= (50 + (40 * M.is_adult))
			M.add_nutrition(50 + (40 * M.is_adult))
		if(health > 0)
			M.adjustBruteLoss(-10 + (-10 * M.is_adult))
			M.updatehealth()

/mob/living/simple_animal/metroid/attack_animal(mob/living/simple_animal/M as mob)
	if(..())
		attacked += 10


/mob/living/simple_animal/metroid/attack_paw(mob/living/carbon/monkey/M as mob)
	if(..()) //successful monkey bite.
		attacked += 10

/mob/living/simple_animal/metroid/attack_larva(mob/living/carbon/alien/larva/L as mob)
	if(..()) //successful larva bite.
		attacked += 10

/mob/living/simple_animal/metroid/attack_hulk(mob/living/carbon/human/user)
	if(user.a_intent == "harm")
		adjustBruteLoss(10)
		discipline_slime(user)


/mob/living/simple_animal/metroid/attack_hand(mob/living/carbon/human/M as mob)
	if(Victim)
		if(Victim == M)
			if(prob(60))
				visible_message("<span class='warning'>[M] attempts to wrestle \the [name] off!</span>")
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			else
				visible_message("<span class='warning'> [M] manages to wrestle \the [name] off!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

				discipline_slime(M)

		else
			M.do_attack_animation(src)
			if(prob(30))
				visible_message("<span class='warning'>[M] attempts to wrestle \the [name] off of [Victim]!</span>")
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

			else
				visible_message("<span class='warning'> [M] manages to wrestle \the [name] off of [Victim]!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

				discipline_slime(M)
	else
		if(stat == DEAD && surgeries.len)
			if(M.a_intent == "help")
				for(var/datum/surgery/S in surgeries)
					if(S.next_step(M, src))
						return 1
		if(..()) //successful attack
			attacked += 10

/mob/living/simple_animal/metroid/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(..()) //if harm or disarm intent.
		attacked += 10
		discipline_slime(M)


/mob/living/simple_animal/metroid/attackby(obj/item/W, mob/living/user, params)
	if(stat == DEAD && surgeries.len)
		if(user.a_intent == "help")
			for(var/datum/surgery/S in surgeries)
				if(S.next_step(user, src))
					return 1
	if(W.force > 0)
		attacked += 10
		if(prob(25))
			user.do_attack_animation(src)
			user.changeNext_move(CLICK_CD_MELEE)
			user << "<span class='danger'>[W] passes right through [src]!</span>"
			return
		if(Discipline && prob(50)) // wow, buddy, why am I getting attacked??
			Discipline = 0
	if(W.force >= 3)
		var/force_effect = 2 * W.force
		if(is_adult)
			force_effect = round(W.force/2)
		if(prob(10 + force_effect))
			discipline_slime(user)
	..()

/mob/living/simple_animal/metroid/show_inv(mob/user)
	return

/mob/living/simple_animal/metroid/proc/apply_water()
	adjustBruteLoss(rand(15,20))
	if(!client)
		if(Target) // Like cats
			Target = null
			++Discipline
	return

/mob/living/simple_animal/metroid/getTrail()
	return null

/mob/living/simple_animal/metroid/examine(mob/user)

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	if (src.stat == DEAD)
		msg += "<span class='deadsay'>It is limp and unresponsive.</span>\n"
	else
		if (src.getBruteLoss())
			msg += "<span class='warning'>"
			if (src.getBruteLoss() < 40)
				msg += "It has some punctures in its flesh!"
			else
				msg += "<B>It has severe punctures and tears in its flesh!</B>"
			msg += "</span>\n"

		switch(powerlevel)

			if(2 to 3)
				msg += "It is flickering gently with a little electrical activity.\n"

			if(4 to 5)
				msg += "It is glowing gently with moderate levels of electrical activity.\n"

			if(6 to 9)
				msg += "<span class='warning'>It is glowing brightly with high levels of electrical activity.</span>\n"

			if(10)
				msg += "<span class='warning'><B>It is radiating with massive levels of electrical activity!</B></span>\n"

	msg += "*---------*</span>"
	user << msg
	return

/mob/living/simple_animal/metroid/proc/discipline_slime(mob/user)

	if(stat == DEAD)
		return

	if(prob(80) && !client)
		Discipline++

		if(!is_adult)
			if(Discipline == 1)
				attacked = 0

	if(Victim || Target)
		Victim = null
		Target = null
		anchored = 0

	spawn(0)
		SStun = 1
		sleep(rand(20,60))
		SStun = 0

	spawn(0)
		canmove = 0
		if(user)
			step_away(src,user,15)
		sleep(3)
		if(user)
			step_away(src,user,15)
		canmove = 1
