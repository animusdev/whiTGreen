/obj/machinery/button_signaler
	name = "button"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl-o-e"
	desc = "A remote control switch for something."
	power_channel = ENVIRON
	anchored = 1
	var/obj/item/weapon/airlock_electronics/board
	var/obj/item/device/assembly/signaler/signaler
	var/wired = 0
	var/unlocked = 1
	panel_open = 1

/obj/machinery/button_signaler/attack_ai(mob/user as mob)
	return src.attack_hand(user, 0)

/obj/machinery/button_signaler/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/button_signaler/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/device/detective_scanner))
		return

	if(panel_open)
		if(!board)
			if(istype(W, /obj/item/weapon/airlock_electronics))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message("[user] installs the electronics into the button assembly.", "You install the electronics into the button assembly.")
				user.drop_item()
				board = W
				if(board.use_one_access)
					req_one_access = board.conf_access
				else
					req_access = board.conf_access
				board.loc = src

			if(istype(W, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				user.visible_message("[user] unsecures the button assembly.", "You unsecure the button assembly.")
				new /obj/item/wallframe/button(get_turf(src))
				del(src)
		if(board && !wired && istype(W, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/coil = W
			user.visible_message("[user] wires the button assembly.", "You wire the button assembly.")
			coil.use(1)
			wired = 1
		if(wired && !signaler)
			if(istype(W, /obj/item/device/assembly/signaler))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message("[user] installs [W] into the button assembly.", "You install [W] into the button assembly.")
				user.drop_item()
				signaler = W
				signaler.loc = src
			else if(istype(W, /obj/item/weapon/wirecutters))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
				user.visible_message("[user] cuts the wires from the button assembly.", "You cut the wires from button assembly.")
				new/obj/item/stack/cable_coil(get_turf(src), 1)
				wired = 0


		if(signaler && istype(W, /obj/item/weapon/crowbar))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			panel_open = 0
			user.visible_message("[user] closes button panel.", "You close button panel.")

		update_icon()

	else
		if(istype(W, /obj/item/weapon/screwdriver))
			unlocked = !unlocked
			if(unlocked)
				user.visible_message("[user] unfastens button bolts.", "You unfasten button bolts.")
			else
				user.visible_message("[user] fastens button bolts.", "You fasten button bolts.")
			update_icon()
			return

		if(istype(W, /obj/item/weapon/card/emag))
			req_access = list()
			req_one_access = list()
			playsound(src.loc, "sparks", 100, 1)
			flick("doorctrl-emag", src)
			return
		return src.attack_hand(user)

/obj/machinery/button_signaler/attack_hand(mob/user as mob, var/can_open=1)
	src.add_fingerprint(usr)
	if(stat & (NOPOWER|BROKEN))
		return

	if(panel_open)
		if(can_open)
			if(signaler)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message("[user] removes [signaler] from the button assembly.", "You remove [signaler] from the button assembly.")
				signaler.loc = get_turf(src)
				signaler = null

			else if(!wired && board)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
				user.visible_message("[user] removes [board] from the button assembly.", "You remove [board] from the button assembly.")
				board.loc = get_turf(src)
				board = null
				req_one_access = list()
				req_access = list()

			update_icon()
		return


	add_fingerprint(user)
	if(!allowed(user))
		user << "<span class='warning'>Access Denied</span>"
		flick("doorctrl-denied", src)
		return

	if(unlocked && can_open)
		panel_open = 1
		user.visible_message("[user] opens button panel.", "You open button panel.")
		update_icon()
	else
		use_power(5)
		icon_state = "doorctrl1"

		signaler.activate(src, user)

		spawn(15)
			update_icon()

/obj/machinery/button_signaler/power_change()
	..()
	update_icon()

/obj/machinery/button_signaler/update_icon()
	if(panel_open)
		if(!board)
			icon_state = "doorctrl-o-e"
		else if(!wired)
			icon_state = "doorctrl-o-c"
		else if(!signaler)
			icon_state = "doorctrl-o-w"
		else
			icon_state = "doorctrl-o"

	else if((stat & NOPOWER) || unlocked)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/obj/machinery/button_signaler/New(loc, dir, building)
	..()

	if(loc)
		src.loc = loc

	if(dir)
		src.dir = dir

	if(building)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

	update_icon()


/obj/item/wallframe/button
	name = "button frame"
	desc = "Used for building wall mounted buttons."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "button-item"

/obj/item/wallframe/button/try_build(turf/on_wall)
	if(!..())
		return

	var/ndir = get_dir(on_wall,usr)
	var/turf/loc = get_turf(usr)

	new /obj/machinery/button_signaler(loc, ndir, 1)
	qdel(src)