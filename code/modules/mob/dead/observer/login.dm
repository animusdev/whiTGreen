/mob/dead/observer/Login()
	..()
	icon_state = client.prefs.ghost_form
	if (ghostimage)
		ghostimage.icon_state = src.icon_state

	updateghostimages()
	update_interface()
