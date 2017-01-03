/mob/living/simple_animal/slime/emote(var/act)


	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		//param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/m_type = 1
	var/regenerate_icons
	var/message

	switch(act) //Alphabetical please
		if("bounce")
			message = "<B>The [src.name]</B> подпрыгивает на месте."
			m_type = 1

		if("jiggle")
			message = "<B>The [src.name]</B> покачиваетс&#255;!"
			m_type = 1

		if("light")
			message = "<B>The [src.name]</B> засветилс&#255; на мгновение, но погас."
			m_type = 1

		if("moan")
			message = "<B>The [src.name]</B> стонет."
			m_type = 2

		if("shiver")
			message = "<B>The [src.name]</B> дрожит."
			m_type = 2

		if("sway")
			message = "<B>The [src.name]</B> шатаетс&#255;."
			m_type = 1

		if("twitch")
			message = "<B>The [src.name]</B> дергаетс&#255;."
			m_type = 1

		if("vibrate")
			message = "<B>The [src.name]</B> вибрирует!"
			m_type = 1

		if("noface") //mfw I have no face
			mood = null
			regenerate_icons = 1

		if("smile")
			mood = "mischevous"
			regenerate_icons = 1

		if(":3")
			mood = ":33"
			regenerate_icons = 1

		if("pout")
			mood = "pout"
			regenerate_icons = 1

		if("frown")
			mood = "sad"
			regenerate_icons = 1

		if("scowl")
			mood = "angry"
			regenerate_icons = 1

		if ("help") //This is an exception
			src << "Список эмоций дл&#255; слизней. Вы можете использовать их, набрав \"*emote\" в \"say\":\nbounce, jiggle, light, moan, shiver, sway, twitch, vibrate. \n\nВы также можете помен&#255;ть своё \"настроение\": \n\nsmile, :3, pout, frown, scowl, noface"

		else
			src << "<span class='notice'>Неиспользуема&#255; эмоци&#255; '[act]'. Наберите \"*help\" в \"say\" дл&#255; полного списка.</span>"

	if ((message && stat == CONSCIOUS))
		if(client)
			log_emote("[ckey]/[name] : [message]")
		if (m_type & 1)
			visible_message(message)
		else
			audible_message(message)

	if (regenerate_icons)
		regenerate_icons()

	return