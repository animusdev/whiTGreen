
// fun if you want to typecast humans/monkeys/etc without writing long path-filled lines.
/proc/ishuman(A)
	if(istype(A, /mob/living/carbon/human))
		return 1
	return 0

/proc/ismonkey(A)
	if(A && istype(A, /mob/living/carbon/monkey))
		return 1
	return 0

/proc/isbrain(A)
	if(A && istype(A, /mob/living/carbon/brain))
		return 1
	return 0

/proc/isalien(A)
	if(istype(A, /mob/living/carbon/alien))
		return 1
	return 0

/proc/isalienadult(A)
	if(istype(A, /mob/living/carbon/alien/humanoid))
		return 1
	return 0

/proc/islarva(A)
	if(istype(A, /mob/living/carbon/alien/larva))
		return 1
	return 0

/proc/isslime(A)
	if(istype(A, /mob/living/simple_animal/slime))
		return 1
	return 0

/proc/isrobot(A)
	if(istype(A, /mob/living/silicon/robot))
		return 1
	return 0

/proc/isanimal(A)
	if(istype(A, /mob/living/simple_animal))
		return 1
	return 0

/proc/iscorgi(A)
	if(istype(A, /mob/living/simple_animal/pet/corgi))
		return 1
	return 0

/proc/iscrab(A)
	if(istype(A, /mob/living/simple_animal/crab))
		return 1
	return 0

/proc/iscat(A)
	if(istype(A, /mob/living/simple_animal/pet/cat))
		return 1
	return 0

/proc/ismouse(A)
	if(istype(A, /mob/living/simple_animal/mouse))
		return 1
	return 0

/proc/isbear(A)
	if(istype(A, /mob/living/simple_animal/hostile/bear))
		return 1
	return 0

/proc/iscarp(A)
	if(istype(A, /mob/living/simple_animal/hostile/carp))
		return 1
	return 0

/proc/isclown(A)
	if(istype(A, /mob/living/simple_animal/hostile/retaliate/clown))
		return 1
	return 0

/proc/isAI(A)
	if(istype(A, /mob/living/silicon/ai))
		return 1
	return 0

/proc/ispAI(A)
	if(istype(A, /mob/living/silicon/pai))
		return 1
	return 0

/proc/iscarbon(A)
	if(istype(A, /mob/living/carbon))
		return 1
	return 0

/proc/issilicon(A)
	if(istype(A, /mob/living/silicon))
		return 1
	return 0

/proc/isliving(A)
	if(istype(A, /mob/living))
		return 1
	return 0

proc/isobserver(A)
	if(istype(A, /mob/dead/observer))
		return 1
	return 0

proc/isnewplayer(A)
	if(istype(A, /mob/new_player))
		return 1
	return 0

proc/isovermind(A)
	if(istype(A, /mob/camera/blob))
		return 1
	return 0

proc/isdrone(A)
	if(istype(A, /mob/living/simple_animal/drone))
		return 1
	return 0

proc/isorgan(A)
	if(istype(A, /obj/item/organ/limb))
		return 1
	return 0

/proc/isloyal(A) //Checks to see if the person contains a loyalty implant, then checks that the implant is actually inside of them
	for(var/obj/item/weapon/implant/loyalty/L in A)
		if(L && L.implanted)
			return 1
	return 0

/proc/ismetroid(A)
	if(istype(A, /mob/living/simple_animal/metroid))
		return 1
	return 0

/proc/check_zone(zone)
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
		if("l_hand")
			zone = "l_arm"
		if("r_hand")
			zone = "r_arm"
		if("l_foot")
			zone = "l_leg"
		if("r_foot")
			zone = "r_leg"
		if("groin")
			zone = "chest"
	return zone


/proc/ran_zone(zone, probability = 80)

	zone = check_zone(zone)

	if(prob(probability))
		return zone

	var/t = rand(1, 18) // randomly pick a different zone, or maybe the same one
	switch(t)
		if(1)		 return "head"
		if(2)		 return "chest"
		if(3 to 6)	 return "l_arm"
		if(7 to 10)	 return "r_arm"
		if(11 to 14) return "l_leg"
		if(15 to 18) return "r_leg"

	return zone

/proc/above_neck(zone)
	var/list/zones = list("head", "mouth", "eyes")
	if(zones.Find(zone))
		return 1
	else
		return 0

/proc/stars(n, pr)
	n = strip_html_properly(n)
	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
	return sanitize(t)

proc/slur(phrase)
	var/output = ""

	for(var/i = 1; i <= lentext(phrase); i++)
		var/letter = copytext(phrase, i, i + 1)
		if(letter == " ")
			output += " "
			continue
		if(letter == "&")
			letter = "&#255;"
			i += 5
		if(letter == "�")
			output += "�"
			continue
		if(prob(33))
			if(lowerrustext(letter)=="�")	letter="�"
			if(lowerrustext(letter)=="�")	letter="i"
			if(lowerrustext(letter)=="�")	letter="r"
			if(lowerrustext(letter)=="�")	letter="��"
			if(lowerrustext(letter)=="�")	letter="�"
			if(lowerrustext(letter)=="�")	letter="�"
			if(lowerrustext(letter)=="�")	letter="�"
			if(lowerrustext(letter)=="�")	letter="�"
			if(lowerrustext(letter)=="�")	letter="�"

		switch(rand(1,15))
			if(1,3,5,8)		letter = "[lowerrustext(letter)]"
			if(2,4,6,15)	letter = "[upperrustext(letter)]"
			if(7)			letter += "'"
			if(9,10)		letter = "<b>[letter]</b>"
			if(11,12)		letter = "<big>[letter]</big>"
			if(13)			letter = "<small>[letter]</small>"
		output += letter

	return output

/proc/stutter(phrase)
	var/list/unstuttered_words = text2list(phrase," ") //Split it up into words.
	var/output = ""

	for(var/word in unstuttered_words)
		var/first_letter = copytext(word, 1, 2)
		if(first_letter == "&")
			first_letter = "&#255;"
		if(upperrustext(first_letter) in list("�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�"))
			switch(rand(1,3))
				if(1)
					word = "[first_letter]-[word] "
				if(2)
					word = "[first_letter]-[first_letter]-[word] "
				if(3)
					word = "[first_letter]-[first_letter]-[first_letter]-[word] "
		output += word
	return output

/proc/derpspeech(message, stuttering)
	message = replacetext(message, " am ", " ")
	message = replacetext(message, " is ", " ")
	message = replacetext(message, " are ", " ")
	message = replacetext(message, "you", "u")
	message = replacetext(message, "help", "halp")
	message = replacetext(message, "grief", "grife")
	message = replacetext(message, "space", "spess")
	message = replacetext(message, "carp", "crap")
	message = replacetext(message, "reason", "raisin")
/*	if(prob(50))
		message = uppertext(message)
		if()
		message += "[stutter(pick("!", "!!", "!!!"))]"
*/
	if(!stuttering && prob(15))
		message = stutter(message)
	return message


proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext


/proc/ninjaspeak(n) //NINJACODE
/*
The difference with stutter is that this proc can stutter more than 1 letter
The issue here is that anything that does not have a space is treated as one word (in many instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but not so much with compounds of letters./N
*/
	var/te = rhtml_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <= n)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext(te, p, n+1)
		else
			n_letter = copytext(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]")
			else
				n_letter = text("[n_letter]-[n_letter]")
		else
			n_letter = text("[n_letter]")
		t = text("[t][n_letter]")
		p=p+n_mod
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)


/proc/shake_camera(mob/M, duration, strength=1)
	spawn(0)
		if(!M || !M.client || M.shakecamera)
			return
		var/oldeye=M.client.eye
		var/x
		M.shakecamera = 1
		for(x=0; x<duration, x++)
			if(M && M.client)
				M.client.eye = locate(dd_range(1,M.loc.x+rand(-strength,strength),world.maxx),dd_range(1,M.loc.y+rand(-strength,strength),world.maxy),M.loc.z)
				sleep(1)
		if(M)
			M.shakecamera = 0
			if(M.client)
				M.client.eye=oldeye


/proc/findname(msg)
	if(!istext(msg))
		msg = "[msg]"
	for(var/mob/M in mob_list)
		if(M.real_name == msg)
			return M
	return 0


/mob/proc/abiotic(full_body = 0)
	if(l_hand && !l_hand.flags&ABSTRACT || r_hand && !r_hand.flags&ABSTRACT)
		return 1
	return 0

//converts intent-strings into numbers and back
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if("help")		return 0
			if("disarm")	return 1
			if("grab")		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return "help"
			if(1)			return "disarm"
			if(2)			return "grab"
			else			return "harm"

/proc/IsAdminGhost(var/mob/user)
	return 0

//change a mob's act-intent. Input the intent as a string such as "help" or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1

	if(ishuman(src) || isalienadult(src) || isbrain(src))
		switch(input)
			if("help", "disarm", "grab", "harm")
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent) + 1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent) + 3) % 4)

		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "[a_intent]"

	else if(isrobot(src) || ismonkey(src) || islarva(src))
		switch(input)
			if("help")
				a_intent = "help"
			if("harm")
				a_intent = "harm"
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)

		if(hud_used && hud_used.action_intent)
			if(a_intent == "harm")
				hud_used.action_intent.icon_state = "harm"
			else
				hud_used.action_intent.icon_state = "help"

proc/is_blind(A)
	if(ismob(A))
		var/mob/B = A
		return	B.eye_blind
	return 0

proc/is_special_character(mob/M) // returns 1 for special characters and 2 for heroes of gamemode //moved out of admins.dm because things other than admin procs were calling this.
	if(!ticker || !ticker.mode)
		return 0
	if(!istype(M))
		return 0
	if(issilicon(M))
		if(isrobot(M)) //For cyborgs, returns 1 if the cyborg has a law 0 and special_role. Returns 0 if the borg is merely slaved to an AI traitor.
			var/mob/living/silicon/robot/R = M
			if(R.emagged || R.syndicate) //Count as antags
				return 1
			if(R.mind && R.mind.special_role && R.laws && R.laws.zeroth).
				if(R.connected_ai)
					if(is_special_character(R.connected_ai) && R.connected_ai.laws && (R.connected_ai.laws.zeroth_borg == R.laws.zeroth || R.connected_ai.laws.zeroth == R.laws.zeroth))
						return 0 //AI is the real traitor here, so the borg itself is not a traitor
					return 1 //Slaved but also a traitor
				return 1 //Unslaved, traitor
		else if(isAI(M))
			var/mob/living/silicon/ai/A = M
			if(A.laws && A.laws.zeroth && A.mind && A.mind.special_role)
				if(ticker.mode.config_tag == "malfunction" && M.mind in ticker.mode.malf_ai)//Malf law is a law 0
					return 2
				return 1
		return 0
	if(M.mind && M.mind.special_role)//If they have a mind and special role, they are some type of traitor or antagonist.
		switch(ticker.mode.config_tag)
			if("revolution")
				if((M.mind in ticker.mode.head_revolutionaries) || (M.mind in ticker.mode.revolutionaries))
					return 2
			if("cult")
				if(M.mind in ticker.mode.cult)
					return 2
			if("nuclear")
				if(M.mind in ticker.mode.syndicates)
					return 2
			if("changeling")
				if(M.mind in ticker.mode.changelings)
					return 2
			if("wizard")
				if(M.mind in ticker.mode.wizards)
					return 2
			if("monkey")
				if(M.viruses && (locate(/datum/disease/transformation/jungle_fever) in M.viruses))
					return 2
			if("abductor")
				if(M.mind in ticker.mode.abductors)
					return 2
			if("the thing")
				if(M.mind in ticker.mode.things)
					return 2
		return 1
	return 0

/mob/proc/has_mutation(var/mutation)
	return mutation in src.mutations ? 1 : 0

/proc/get_both_hands(mob/living/carbon/M)
	var/list/hands = list(M.l_hand, M.r_hand)
	return hands

/mob/proc/reagent_check(var/datum/reagent/R) // utilized in the species code
	return 1

/proc/notify_ghosts(var/message, var/ghost_sound = null) //Easy notification of ghosts.
	for(var/mob/dead/observer/O in player_list)
		if(O.client)
			O << "<span class='ghostalert'>[message]<span>"
			if(ghost_sound)
				O << sound(ghost_sound)

/proc/item_heal_robotic(var/mob/living/carbon/human/H, var/mob/user, var/brute, var/burn)
	var/obj/item/organ/limb/affecting = H.get_organ(check_zone(user.zone_sel.selecting))

	var/dam //changes repair text based on how much brute/burn was supplied

	if(brute > burn)
		dam = 1
	else
		dam = 0

	if(affecting.status == ORGAN_ROBOTIC)
		if(brute > 0 && affecting.brute_dam > 0 || burn > 0 && affecting.burn_dam > 0)
			affecting.heal_damage(brute,burn,1)
			H.update_damage_overlays(0)
			H.updatehealth()
			user.visible_message("[user] has fixed some of the [dam ? "dents on" : "burnt wires in"] [H]'s [affecting.getDisplayName()].", "<span class='notice'>You fix some of the [dam ? "dents on" : "burnt wires in"] [H]'s [affecting.getDisplayName()].</span>")
			return
		else
			user << "<span class='warning'>[H]'s [affecting.getDisplayName()] is already in good condition!</span>"
			return
	else
		return

/proc/get_limb(var/limb, var/mob/living/carbon/human/H)
	for(var/obj/item/organ/limb/T in H.organs)
		if(T.name == limb)
			return T