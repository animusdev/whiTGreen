/mob/living/simple_animal/metroid/emote(var/act)


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
			message = "<B>The [src.name]</B> покачивается!"
			m_type = 1

		if("light")
			message = "<B>The [src.name]</B> засветился на мгновение, но погас."
			m_type = 1

		if("moan")
			message = "<B>The [src.name]</B> стонет."
			m_type = 2

		if("shiver")
			message = "<B>The [src.name]</B> дрожит."
			m_type = 2

		if("sway")
			message = "<B>The [src.name]</B> шатается."
			m_type = 1

		if("twitch")
			message = "<B>The [src.name]</B> дергается."
			m_type = 1

		if("vibrate")
			message = "<B>The [src.name]</B> вибрирует!"

		if ("help") //This is an exception
			src << "Список эмоций для метроидов. Вы можете использовать их, набрав \"*emote\" в \"say\":\nbounce, jiggle, light, moan, shiver, sway, twitch, vibrate."

		else
			src << "<span class='notice'>Неиспользуемая эмоция '[act]'. Наберите \"*help\" в \"say\" для полного списка.</span>"

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