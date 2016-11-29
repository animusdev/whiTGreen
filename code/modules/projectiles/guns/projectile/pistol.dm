/obj/item/weapon/gun/projectile/automatic/pistol
	name = "small pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon_state = "pistol"
	w_class = 2
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 1
	burst_size = 1
	fire_delay = 0

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol/m1911
	name = "M1911 pistol"
	desc = ".45 huh?"
	icon_state = "m1911"
	w_class = 3
	mag_type = /obj/item/ammo_box/magazine/m45
	can_suppress = 1

/obj/item/weapon/gun/projectile/automatic/m1911/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol/deagle
	name = "desert eagle"
	desc = "A robust .50 AE handgun."
	icon_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	can_suppress = 0

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/gold
	desc = "A gold plated desert eagle folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/automatic/pistol/glock //roy solid
	name = "glock"
	desc = "A glock pistol. Uses 9mm ammo."
	icon_state = "glock"
	force = 10.0
	origin_tech = "combat=4;materials=3"
	mag_type = /obj/item/ammo_box/magazine/m9mm
	can_suppress = 0

/obj/item/glockbarrel
	name = "handgun barrel"
	desc = "One third of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glock1"
	m_amt = 400000 // expensive, will need an autolathe upgrade to hold enough metal to produce the barrel. this way you need cooperation between 3 departments to finish even 1.

/obj/item/glockconstruction
	name = "handgun barrel and grip"
	desc = "Two thirds of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glockstep1"
	var/construction = 0

/obj/item/glockconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/glockslide))
		user << "You attach the slide to the gun."
		construction = 1
		del(W)
		icon_state = "glockstep2"
		name = "unfinished handgun"
		desc = "An almost finished handgun."
		return

	if(istype(W,/obj/item/weapon/screwdriver))
		if(construction)
			user << "You finish the handgun."
			new /obj/item/weapon/gun/projectile/automatic/pistol/glock(user.loc)
			del(src)
			return

/obj/item/glockbarrel/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/glockgrip))
		user << "You attach the grip to the barrel."
		new /obj/item/glockconstruction(user.loc)
		del(W)
		del(src)
		return

/obj/item/glockgrip
	name = "handgun grip"
	desc = "One third of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glock2"

/obj/item/glockslide
	name = "handgun slide"
	desc = "One third of a low-caliber handgun."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "glock3"