/proc/is_donator(var/key as text)
	if(key in donator_icons)
		return 1
	return 0