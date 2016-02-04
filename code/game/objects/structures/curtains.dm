#define SHOWER_OPEN_LAYER OBJ_LAYER + 0.4
#define SHOWER_CLOSED_LAYER MOB_LAYER + 0.1

/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/curtain.dmi'
	icon_state = "closed"
	layer = SHOWER_CLOSED_LAYER
	opacity = 1
	density = 0
	anchored = 1
	var/open = 0
	var/opacity_closed = 1

/obj/structure/curtain/open
	icon_state = "open"
	layer = SHOWER_OPEN_LAYER
	opacity = 0
	open = 1

/obj/structure/curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message("<span class='warning'>[P] tears [src] down!</span>")
		del(src)
	else
		..(P, def_zone)

/obj/structure/curtain/attack_hand(mob/user)
	playsound(src.loc, 'sound/effects/rustle1.ogg', 25, 1)
	toggle()
	..()

/obj/structure/curtain/attackby(obj/item/I as obj, mob/user as mob, params)
	if(istype(I, /obj/item/weapon/wrench))
		if(!src) return
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			user << "<span class='notice'>You unfasten the [src] from the floor.</span>"
			anchored = 0
		else
			user << "<span class='notice'>You fasten the [src] to the floor.</span>"
			anchored = 1



/obj/structure/curtain/verb/toggle()
	set name = "Toggle curtains"
	set category = "Object"
	set src in orange(1)
	open = !open
	if(open)
		icon_state = "open"
		layer = SHOWER_OPEN_LAYER
		opacity = 0
	else
		icon_state = "closed"
		layer = SHOWER_CLOSED_LAYER
		opacity = opacity_closed

/obj/structure/curtain/AltClick(var/mob/user)
	if(in_range(user,src))
		src.toggle()

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200


/obj/structure/curtain/open/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/open/shower/engineering
	color = "#FFA500"

/obj/structure/curtain/open/shower/security
	color = "#AA0000"

#undef SHOWER_OPEN_LAYER
#undef SHOWER_CLOSED_LAYER
