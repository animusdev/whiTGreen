/obj/item/ashtray
	var/health
	icon = 'icons/obj/items.dmi'
	var/
		max_butts 	= 0
		empty_desc 	= ""
		icon_empty 	= ""
		icon_half  	= ""
		icon_full  	= ""

/obj/item/ashtray/New()
	..()
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	return

/obj/item/ashtray/attackby(obj/item/W as obj, mob/user as mob, params)
	if (health < 1)
		return
	if (istype(W,/obj/item/weapon/cigbutt) || istype(W,/obj/item/clothing/mask/cigarette) || istype(W, /obj/item/weapon/match))
		if (contents.len >= max_butts)
			user << "This ashtray is full."
			return
		user.unEquip(W)
		W.loc = src

		if (istype(W,/obj/item/clothing/mask/cigarette))
			var/obj/item/clothing/mask/cigarette/cig = W
			if (cig.lit == 1)
				src.visible_message("[user] crushes [cig] in [src], putting it out.")
				user.unEquip(cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				del(cig)
			else if (cig.lit == 0)
				user << "You place [cig] in [src] without even smoking it. Why would you do that?"

		src.visible_message("[user] places [W] in [src].")
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		add_fingerprint(user)
		update_icon()
	else
		health = max(0,health - W.force)
		user << "You hit [src] with [W]."
		if (health < 1)
			die()
	return

/obj/item/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (health < 1)
			die()
			return
		if (contents.len)
			src.visible_message("\red [src] slams into [hit_atom] spilling its contents!")
		for (var/obj/item/O in contents)
			O.loc = src.loc
		update_icon()
	return ..()

/obj/item/ashtray/proc/die()
	src.visible_message("\red [src] shatters spilling its contents!")
	playsound(src, "shatter", 30, 1)
	new /obj/item/weapon/shard(src.loc)
	new /obj/effect/decal/cleanable/ash(src.loc)
	for (var/obj/item/O in contents)
		O.loc = src.loc
		O.pixel_y = rand(-5, 5)
		O.pixel_x = rand(-6, 6)
	qdel(src)

/obj/item/ashtray/update_icon()
	if (contents.len == max_butts)
		icon_state = icon_full
	else if (contents.len > 0)
		icon_state = icon_half
		desc = empty_desc + " It's half-filled."
	else
		icon_state = icon_empty
		desc = empty_desc + " It's stuffed full."
	return ..()

/obj/item/ashtray/glass
	name = "Glass ashtray"
	desc = "Glass ashtray. Looks fragile."
	icon_state = "ashtray_gl"
	icon_empty = "ashtray_gl"
	icon_half  = "ashtray_half_gl"
	icon_full  = "ashtray_full_gl"
	max_butts = 6
	health = 12.0
	g_amt = 60
	empty_desc = "Glass ashtray. Looks fragile."
	throwforce = 6.0

/obj/item/ashtray/glass/New()
	..()
	if(rand(75))
		contents = list()
		new /obj/item/weapon/cigbutt(src)


/obj/item/weapon/fan
	name = "desk fan"
	icon = 'icons/obj/items.dmi'
	icon_state = "fan"
	force = 10
	throwforce = 5
	desc = "A smal desktop fan. Button seems to be stuck in the 'on' position."

