/obj/item/weapon/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	flags = CONDUCT
	force = 8.0
	hitsound = "swing_hit"
	throw_speed = 2
	throw_range = 4
	w_class = 4.0
	max_w_class = 3
	max_combined_w_class = 21
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	burn_state = 0
	burntime = 20

/obj/item/weapon/storage/briefcase/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()

/obj/item/weapon/storage/briefcase/attack_hand(mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()

/obj/item/weapon/storage/briefcase/MouseDrop(obj/over_object)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()

/obj/item/weapon/storage/briefcase/New()
	..()
