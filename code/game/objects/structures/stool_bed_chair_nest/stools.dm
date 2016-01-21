/obj/structure/stool
	name = "stool"
	r_name = "табурет"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1.0
	pressure_resistance = 15

/obj/structure/stool/bar
	name = "bar stool"
	accusative_case = "барный стул"
	icon_state = "barstool"

/obj/structure/stool/ex_act(severity, target)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
	return

/obj/structure/stool/blob_act()
	if(prob(75))
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)

/obj/structure/stool/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)
	return

/obj/structure/stool/attack_hand(mob/user)
	var/obj/item/weapon/stool/S = new /obj/item/weapon/stool(get_turf(src))
	usr.put_in_hands(S)
	qdel(src)

// stool in hands
/obj/item/weapon/stool
	name = "stool"
	r_name = "табурет"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 10
	throwforce = 10
	w_class = 5

/obj/item/weapon/stool/attack_self(mob/user)
	new /obj/structure/stool(user.loc)
	qdel(src)