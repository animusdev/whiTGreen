/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"
	buckle_lying = 0 //you sit in a chair, not lay
	anchored=1
	burn_state = -1
	var/unstable = 0

/obj/structure/stool/bed/chair/New()
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_layer()
	return

/obj/structure/stool/bed/chair/Move(atom/newloc, direct)
	..()
	handle_rotation()

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		user.drop_item()
		var/obj/structure/stool/bed/chair/e_chair/E
		if( istype(src,/obj/structure/stool/bed/chair/modern) )
			E= new /obj/structure/stool/bed/chair/e_chair/modern(src.loc)
		else
			E= new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)

	if(istype(W, /obj/item/weapon/screwdriver))
		if(!src) return
		playsound(loc, 'sound/items/Screwdriver.ogg', 10, 1)
		if(anchored)
			user << "<span class='notice'>You unfasten the [src] from the floor.</span>"
			anchored = 0
		else
			user << "<span class='notice'>You fasten the [src] to the floor.</span>"
			anchored = 1

	if(istype(W, /obj/item/weapon/hexkey))
		playsound(loc, 'sound/items/Screwdriver.ogg', 10, 1)
		if(unstable)
			user << "<span class='notice'>You tighten the bolts.</span>"
			unstable = 0
		else
			user << "<span class='warning'>You loosen the bolts!</span>"
			unstable = 1

/obj/structure/stool/bed/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/stool/bed/chair/proc/handle_rotation(direction)
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		if(!direction || !buckled_mob.Move(get_step(src, direction), direction))
			buckled_mob.buckled = src
			dir = buckled_mob.dir
			return 0
		buckled_mob.buckled = src //Restoring
	handle_layer()
	return 1

/obj/structure/stool/bed/chair/proc/handle_layer()
	if(dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

/obj/structure/stool/bed/chair/proc/spin()
	src.dir = turn(src.dir, 90)
	handle_layer()
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/stool/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		spin()
	else
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return
		spin()


/obj/structure/stool/bed/chair/AltClick(var/mob/user)
	if(in_range(user,src))
		src.rotate()

/obj/structure/stool/bed/chair/pre_buckle_mob(mob/living/M)
	if (unstable)
		M << "<span class='warning'>This [name] feels unstable!</span>"
		M << "<span class='userdanger'>AWWWW FUUUCK</span>"
		playsound(src.loc, 'sound/effects/bang.ogg', 50, 1)
		M.Weaken(3)
		if (istype(src, /obj/structure/stool/bed/chair/wood))
			new /obj/item/stack/sheet/mineral/wood(src.loc)
		else
			new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)
		return 0xDEADBEEF

// Chair types
/obj/structure/stool/bed/chair/modern
	icon_state = "chair_modern"
	var/image/armrest = null

/obj/structure/stool/bed/chair/modern/New()
	armrest = image(icon = 'icons/obj/objects.dmi', icon_state = "chair_over_modern")
	armrest.layer = MOB_LAYER + 0.1

/obj/structure/stool/bed/chair/modern/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

obj/structure/stool/bed/chair/wood
	burn_state = 0
	burntime = 20

/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/mineral/wood(src.loc)
		qdel(src)
	else
		..()

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."
	icon_state = "comfychair"
	color = rgb(255,255,255)
	var/image/armrest = null
	anchored = 0
	burn_state = 0
	burntime = 30

/obj/structure/stool/bed/chair/shuttle
	name = "shuttle chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "schair"
	anchored = 1

/obj/structure/stool/bed/chair/comfy/New()
	armrest = image("icons/obj/objects.dmi", "comfychair_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/stool/bed/chair/comfy/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

/obj/structure/stool/bed/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/stool/bed/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/stool/bed/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/stool/bed/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/stool/bed/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/stool/bed/chair/office
	anchored = 0

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/stool/bed/chair/sofa
	name = "old ratty sofa"
	icon_state = "sofamiddle"
	anchored = 1

/obj/structure/stool/bed/chair/sofa/left
	icon_state = "sofaend_left"
/obj/structure/stool/bed/chair/sofa/right
	icon_state = "sofaend_right"
/obj/structure/stool/bed/chair/sofa/corner
	icon_state = "sofacorner"