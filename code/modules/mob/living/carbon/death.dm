/mob/living/carbon/death(gibbed)
	silent = 0
	med_hud_set_health()
	med_hud_set_status()
	var/sound/URDEADSOUND = sound('sound/effects/urdead.ogg')
	URDEADSOUND.volume = 80
	src << URDEADSOUND
	..(gibbed)
