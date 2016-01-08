var/list/kappas // welcome twitch chat

/proc/kappa_parse(text)
	if(!config.emojis)
		return text
	if(!kappas)
		kappas = icon_states(icon('icons/twitchsmiles.dmi'))
	var/parsed = ""
	var/pos = 1
	var/search = 0
	var/kappa = ""
	while(1)
		search = findtext(text, ":", pos)
		parsed += copytext(text, pos, search)
		if(search)
			pos = search
			search = findtext(text, ":", pos+1)
			if(search)
				kappa = copytext(text, pos+1, search)
				if(kappa in kappas)
					parsed += "<img class=icon src=\ref['icons/twitchsmiles.dmi'] iconstate='[kappa]'>"
					pos = search + 1
				else
					parsed += copytext(text, pos, search)
					pos = search
				kappa = ""
				continue
			else
				parsed += copytext(text, pos, search)
		break
	return parsed

