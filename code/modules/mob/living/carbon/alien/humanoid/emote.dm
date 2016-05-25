/mob/living/carbon/alien/humanoid/emote(var/act)

	var/param = null
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))
	var/muzzled = is_muzzled()
	var/m_type = 1
	var/message

	switch(act) //Alphabetical please
		if ("deathgasp")
			message = "<span class='name'>[src]</span> издаёт слабеющий визг, зелёна&#255; кровь пузыритс&#255; из пасти..."
			m_type = 2

		if ("gnarl")
			if (!muzzled)
				message = "<span class='name'>[src]</span> изворачиваетс&#255;, оскалив свои зубы."
				m_type = 2

		if ("hisss")
			if(!muzzled)
				message = "<span class='name'>[src]</span> шипит."
				m_type = 2

		if ("moan")
			message = "<span class='name'>[src]</span> стонет!"
			m_type = 2

		if ("roar")
			if (!muzzled)
				message = "<span class='name'>[src]</span> рычит!"
				m_type = 2

		if ("roll")
			if (!src.restrained())
				message = "<span class='name'>[src]</span> кувыркаетс&#255;."
				m_type = 1

		if ("scratch")
			if (!src.restrained())
				message = "<span class='name'>[src]</span> чешетс&#255;."
				m_type = 1

		if ("scretch")
			if (!muzzled)
				message = "<span class='name'>[src]</span> пот&#255;гиваетс&#255;."
				m_type = 2

		if ("shiver")
			message = "<span class='name'>[src]</span> дрожит."
			m_type = 2

		if ("sign")
			if (!src.restrained())
				message = text("<span class='name'>[src]</span> signs[].", (text2num(param) ? text(" the number []", text2num(param)) : null))
				m_type = 1

		if ("tail")
			message = "<span class='name'>[src]</span> машет хвостом."
			m_type = 1

		if ("help") //This is an exception
			src << "Список эмоций дл&#255; ксеноморфов. Вы можете использовать их, набрав \"*emote\" в \"say\":\naflap, blink, blink_r, blush, bow, burp, choke, chuckle, clap, collapse, cough, dance, deathgasp, drool, flap, frown, gasp, giggle, glare-(none)/mob, gnarl, hiss, jump, laugh, look-atom, me, moan, nod, point-atom, roar, roll, scream, scratch, scretch, shake, shiver, sign-#, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tail, tremble, twitch, twitch_s, wave, whimper, wink, yawn"

		else
			..(act)

	if ((message && src.stat == 0))
		log_emote("[ckey]/[name] : [message]")
		if (act == "roar")
			playsound(src.loc, 'sound/voice/hiss5.ogg', 40, 1, 1)

		if (act == "deathgasp")
			playsound(src.loc, 'sound/voice/hiss6.ogg', 80, 1, 1)

		if (m_type & 1)
			visible_message(message)
		else
			audible_message(message)
	return