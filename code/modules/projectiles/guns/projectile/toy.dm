/obj/item/weapon/gun/projectile/automatic/toy
	name = "foam force SMG"
	desc = "A prototype three-round burst toy submachine gun. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "saber"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = 0
	clumsy_check = 0
	needs_permit = 0

/obj/item/weapon/gun/projectile/automatic/toy/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/toy/pistol
	name = "foam force pistol"
	desc = "A small, easily concealable toy handgun. Ages 8 and up."
	icon_state = "pistol"
	w_class = 2
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	fire_sound = 'sound/weapons/Gunshot.ogg'
	can_suppress = 0
	burst_size = 1
	fire_delay = 0
	action_button_name = null








/obj/item/weapon/gun/projectile/automatic/toy/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/toy/pistol/riot
	mag_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/weapon/gun/projectile/automatic/toy/pistol/riot/New()
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	..()

/obj/item/weapon/gun/projectile/shotgun/toy
	name = "foam force shotgun"
	desc = "A toy shotgun with wood furniture and a four-shell capacity underneath. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	force = 0
	throwforce = 0
	origin_tech = null
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy
	clumsy_check = 0
	needs_permit = 0

/obj/item/weapon/gun/projectile/shotgun/toy/process_chamber()
	..()
	if(chambered && !chambered.BB)
		qdel(chambered)

/obj/item/weapon/gun/projectile/shotgun/toy/crossbow
	name = "foam force crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamcrossbow"
	item_state = "crossbow"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = SLOT_BELT
	w_class = 2

/obj/item/weapon/gun/projectile/automatic/c20r/toy
	name = "donksoft SMG"
	desc = "A bullpup two-round burst toy SMG, designated 'C-20r'. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	can_suppress = 0
	needs_permit = 0
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/weapon/gun/projectile/automatic/c20r/toy/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/toy
	name = "donksoft LMG"
	desc = "A heavily modified toy light machine gun, designated 'L6 SAW'. Ages 8 and up."
	icon = 'icons/obj/guns/toy.dmi'
	can_suppress = 0
	needs_permit = 0
	mag_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/weapon/gun/projectile/automatic/l6_saw/toy/process_chamber(eject_casing = 0, empty_chamber = 1)
	..()

/obj/item/weapon/gun/projectile/automatic/speargun/toy_pulse
	name = "pulse rifle"
	desc = "A compact variant of the pulse rifle with less firepower but easier storage. It seems suspiciously light-weighted."
	w_class = 4
	force = 5
	slot_flags = SLOT_BELT
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "pulse"
	item_state = "pulse"
	mag_type = /obj/item/ammo_box/magazine/internal/pulse_beam
	fire_sound = 'sound/effects/pewpew.ogg'
	burst_size = 1
	fire_delay = 0
	var/mode = "fun"

/obj/item/weapon/gun/projectile/automatic/speargun/toy_pulse/attack_self(mob/user)
	switch(mode)
		if("fun")
			mode = "serious"
			fire_sound = 'sound/weapons/pulse.ogg'
		if("serious")
			mode = "fun"
			fire_sound = 'sound/effects/pewpew.ogg'
	user << "<span class='notice'>[src] is now set to [mode] mode"



/obj/item/weapon/gun/projectile/automatic/speargun/toy_pulse/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		user << "<span class='notice'>You load [num_loaded] foam pulse beam\s into \the [src].</span>"
		update_icon()
		chamber_round()