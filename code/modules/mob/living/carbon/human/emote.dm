/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = is_muzzled()
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	var/miming=0
	if(mind)
		miming=mind.miming

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	switch(act) //Please keep this alphabetically ordered when adding or changing emotes.
		if ("aflap") //Any emote on human that uses miming must be left in, oh well.
			if (!src.restrained())
				message = "<B>[src]</B> машет своими крыль&#255;ми В ЯРОСТИ!"
				m_type = 2

		if ("choke")
			if (miming)
				message = "<B>[src]</B> хватаетс&#255; за горло в отча&#255;нии!"
			else
				..(act)

		if ("chuckle")
			if(miming)
				message = "<B>[src]</B> беззвучно посмеиваетс&#255;."
			else
				..(act)

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> аплодирует."
				m_type = 2

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> изнурённо падает!"
			m_type = 2

		if ("cough")
			if (miming)
				message = "<B>[src]</B> беззвучно кашл&#255;ет!"
			else
				if (!muzzled)
					message = "<B>[src]</B> кашл&#255;ет!"
					m_type = 2
				else
					message = "<B>[src]</B> издаёт громкий звук."
					m_type = 2

		if ("cry")
			if (miming)
				message = "<B>[src]</B> плачет."
			else
				if (!muzzled)
					message = "<B>[src]</B> плачет."
					m_type = 2
				else
					message = "<B>[src]</B> издаёт тихий всхлип, нахмурива&#255;сь."
					m_type = 2

		if ("custom")
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			if(copytext(input,1,5) == "говорит")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,9) == "восклицает")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,6) == "орёт")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,5) == "спрашивает")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if(miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

		if ("dap")					//MOB NEEDED
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("eyebrow")
			message = "<B>[src]</B> приподнимает бровь."
			m_type = 1

		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> машет крыль&#255;ми."
				m_type = 2

		if ("gasp")
			if (miming)
				message = "<B>[src]</B> ловит воздух ртом!"
			else
				..(act)

		if ("giggle")
			if (miming)
				message = "<B>[src]</B> беззвучно хихикает!"
			else
				..(act)

		if ("groan")
			if (miming)
				message = "<B>[src]</B> беззвучно охает!"
			else
				if (!muzzled)
					message = "<B>[src]</B> охает!"
					m_type = 2
				else
					message = "<B>[src]</B> издаёт громкий звук."
					m_type = 2

		if ("grumble")
			if (!muzzled)
				message = "<B>[src]</B> ворчит!"
			else
				message = "<B>[src]</B> издаёт звук."
				m_type = 2

		if ("handshake")				//MOB NEEDED
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> пожимает руку [M]."
					else
						message = "<B>[src]</B> прот&#255;гивает свою руку [M]."

		if ("hug")						//MOB NEEDED
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					message = "<B>[src]</B> обнимает [M]."
				else
					message = "<B>[src]</B> обнимает себ&#255;. Жалкое зрелище."

		if ("laugh")
			if(miming || silent)
				message = "<B>[src]</B>беззвучно смеётс&#255;."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> смеётс&#255;."
					m_type = 2
					call_sound_emote("laugh")

		if("elaugh")
			if(miming || silent)
				message = "<B>[src]</B>беззвучно смеётс&#255;."
				m_type = 1
				return
			if (mind.special_role)
				if (!ready_to_elaugh())
					if (world.time % 3)
						usr << "<span class='warning'>Вы ещё не готовы засме&#255;тьс&#255; вновь!"
				else
					message = "<B>[src]</B> дь&#255;вольски хохочет!"
					m_type = 2
					call_sound_emote("elaugh")
			else
				if (!muzzled)
					if (!ready_to_emote())
						if (world.time % 3)
							usr << "<span class='warning'>Вы ещё не готовы засме&#255;тьс&#255; вновь!"
					else
						message = "<B>[src]</B> смеётс&#255;."
						m_type = 2
						call_sound_emote("laugh")

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<span class='danger'>Что-то мешает вам (muted).</span>"
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			if(copytext(message,1,5) == "говорит")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,9) == "восклицает")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,6) == "орёт")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,5) == "спрашивает")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				message = "<B>[src]</B> [message]"

		if ("moan")
			if(miming)
				message = "<B>[src]</B> беззвучно стонет!"
			else
				message = "<B>[src]</B> стонет!"
				m_type = 2

		if ("mumble")
			message = "<B>[src]</B> бормочет!"
			m_type = 2

		if ("pale")
			message = "<B>[src]</B> бледнеет на мгновение."
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> поднимает руку."
			m_type = 1

		if ("salute")							//MOB NEEDED
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> приветствует [param]."
				else
					message = "<B>[src]</b> отдаёт честь."
			m_type = 1

		if ("scream")
			if (miming || silent)
				message = "<B>[src]</B> открыл рот в беззвучном крике!"
			else
				if (!muzzled)
					message = "<B>[src]</B> кричит от боли!"
					m_type = 2
					call_sound_emote("scream")
				else
					..(act)

		if ("shiver")
			message = "<B>[src]</B> дрожит."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> пожимает плечами."
			m_type = 1

		if ("sigh")
			if(miming)
				message = "<B>[src]</B> вздыхает."
			else
				..(act)

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<B>[src]</B> чихает."
			else
				..(act)

		if ("sniff")
			message = "<B>[src]</B> шмыгает носом."
			m_type = 2

		if ("snore")
			if (miming)
				message = "<B>[src]</B> ворочаетс&#255;."
			else
				..(act)

		if ("whimper")
			if (miming)
				message = "<B>[src]</B> кривитс&#255; в боли."
			else
				..(act)

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> зевает."
				m_type = 2

		if ("help") //This can stay at the bottom.
			src << "Список эмоций дл&#255; людей. Вы можете использовать их, набрав \"*emote\" в \"say\":\naflap, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, dance, dap, deathgasp, drool, eyebrow, faint, flap, frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, jump, laugh, look-(none)/mob, me, moan, mumble, nod, pale, point-(atom), raise, salute, scream, shake, shiver, shrug, sigh, signal-#1-10, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tremble, twitch, twitch_s, wave, whimper, wink, yawn"

		if("meow")
			if(head)
				if(istype(head,/obj/item/clothing/head/kitty) || istype(head,/obj/item/clothing/head/collectable/kitty))
					message = "<B>[src]</B> м&#255;укает."
					playsound(src.loc, pick('sound/voice/meow1.ogg', 'sound/voice/meow2.ogg', 'sound/voice/meow3.ogg'), 100, 1)

		if("quack")
			message = "<B>[src]</B> кр&#255;кает."
			playsound(src.loc,'sound/items/quack.ogg', 100, 1)

		else
			..(act)

	if(miming)
		m_type = 1



	if (message)
		log_emote("[ckey]/[name] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			visible_message(message)
		else if (m_type & 2)
			audible_message(message)

/mob/living/carbon/human/proc/call_sound_emote(var/E)
	switch(E)
		if("scream")
			if (src.gender == "male")
				playsound(src.loc, pick('sound/voice/Screams_Male_1.ogg', 'sound/voice/Screams_Male_2.ogg', 'sound/voice/Screams_Male_3.ogg'), 100, 1)
			else
				playsound(src.loc, pick('sound/voice/Screams_Woman_1.ogg', 'sound/voice/Screams_Woman_2.ogg', 'sound/voice/Screams_Woman_3.ogg'), 100, 1)

		if("laugh")
			if(src.gender == "male")
				playsound(src.loc, pick('sound/voice/laugh1.ogg', 'sound/voice/laugh2.ogg', 'sound/voice/laugh3.ogg'), 100, 1)
			else
				playsound(src.loc, pick('sound/voice/female_laugh_1.ogg', 'sound/voice/female_laugh_2.ogg'), 100, 1)

		if("elaugh")
			if(prob (50))
				playsound(src.loc, 'sound/voice/elaugh.ogg', 100, 1)
			else
				if(src.gender == "male")
					playsound(src.loc,pick('sound/voice/elaugh2.ogg','sound/voice/elaugh3.ogg'), 100, 1)
				else
					playsound(src.loc, 'sound/voice/female_elaugh.ogg', 100, 1)


/mob/living/carbon/human/var/emote_delay = 30
/mob/living/carbon/human/var/elaugh_delay = 600
/mob/living/carbon/human/var/last_emoted = 0


/mob/living/carbon/human/proc/ready_to_emote()
	if(world.time >= last_emoted + emote_delay)
		last_emoted = world.time
		return 1
	else
		return 0

/mob/living/carbon/human/proc/ready_to_elaugh()
	if(world.time >= last_emoted + elaugh_delay)
		last_emoted = world.time
		return 1
	else
		return 0
