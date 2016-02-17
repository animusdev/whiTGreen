/obj/machinery/metal_detector
	name = "metal detector"
	desc = ""
	icon = 'icons/obj/machines/metal_detector.dmi'
	icon_state = "metal-detector"
	anchored = 0
	var/on = 0
	var/locked = 0
	density = 0
	layer = 3
	req_access = list(access_security)

/obj/machinery/metal_detector/attackby(obj/item/weapon/W, mob/user)
	if(W.GetID())
		if(!anchored)
			user << "<span class='warning'>It must be secured first!</span>"
			return
		if (allowed(user))
			locked = !locked
			if(locked)
				user << "You lock [src]."
				desc = "It's locked."
			else
				user << "You unlock [src]."
				desc = ""
			return
		else
			user << "<span class='warning'>Access denied.</span>"
			playsound(loc, 'sound/machines/buzz-two.ogg', 50, 1)
			return

	if(istype(W,obj/item/weapon/card/emag))
		emag_act(user)
		return

	if(locked)
		user << "<span class='warning'>It's locked!</span>"
		playsound(loc, 'sound/machines/buzz-two.ogg', 50, 1)
		return

	if(on)
		user << "<span class='warning'>It must be turned off first!</span>"
		playsound(loc, 'sound/machines/buzz-two.ogg', 50, 1)
		return

	if(istype(W,/obj/item/weapon/wrench))
		user << "<span class='notice'>You begin [anchored ? "un" : ""]securing [name]...</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20))
			user << "<span class='notice'>You [anchored ? "un" : ""]secure [name].</span>"
			anchored = !anchored
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)

/obj/machinery/metal_detector/attack_hand(mob/user as mob)
	if(locked)
		user << "<span class='warning'>It's locked!</span>"
		playsound(loc, 'sound/machines/buzz-two.ogg', 50, 1)
		return
	else if(!anchored)
		user << "<span class='warning'>It must be secured first!</span>"
		return
	else
		on = !on
		update_icon()
		user << "You turn [src] [on ? "on" : "off"]."


/obj/machinery/metal_detector/update_icon()
	if(anchored && on)
		icon_state = "metal-detector-working"
	else
		icon_state = "metal-detector"

/obj/machinery/metal_detector/proc/try_detect_gun(obj/item/I) //meh
	if(istype(I,/obj/item/weapon/gun))
		icon_state = "metal-detector-warning"
		playsound(loc, 'sound/effects/alert.ogg', 50, 1)
		spawn(15)
			update_icon()
			return 1
	else return 0

/obj/machinery/metal_detector/Crossed(var/mob/living/carbon/M)
	if(anchored && on)
		if(emagged && M)
			if (electrocute_mob(M, get_area(src), src))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
				playsound(loc, 'sound/effects/sparks1.ogg', 100, 0)
			return

		if(M && !allowed(M))
			for(var/obj/item/O in M.contents)
				if(istype(O, /obj/item/weapon/storage))
					var/obj/item/weapon/storage/S = O
					for(var/obj/item/I in S.contents)
						if(try_detect_gun(I))
							return
				else
					if(try_detect_gun(O))
						return

/obj/machinery/metal_detector/emag_act(mob/user)
	if(!emagged)
		emagged = 1
		user << "<span class='warning'>You emag the [src]!</span>"
		desc += "<span class='warning'>It seems malfunctioning.</span>"
		playsound(src.loc, 'sound/effects/sparks4.ogg', 50, 1)
		return
