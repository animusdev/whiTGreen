/mob/living/simple_animal/metroid/death(gibbed)
	if(stat == DEAD)
		return
	if(!gibbed)
		if(is_adult)
			var/mob/living/simple_animal/metroid/M = new /mob/living/simple_animal/metroid(loc)
			M.rabid = 1
			M.regenerate_icons()
			is_adult = 0
			maxHealth = 150
			revive()
			regenerate_icons()
			number = rand(1, 1000)
			name = "[is_adult ? "adult" : "baby"] metroid ([number])"
			return

	stat = DEAD
	overlays.len = 0

	update_canmove()

	if(ticker && ticker.mode)
		ticker.mode.check_win()

	return ..(gibbed)

/mob/living/simple_animal/metroid/gib()
	death(1)
	qdel(src)
