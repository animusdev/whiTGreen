/*
 * False Walls
 */
/obj/structure/falsewall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	anchored = 1
	icon = 'icons/turf/walls.dmi'
	var/mineral = "metal"
	var/walltype = "metal"
	var/opening = 0
	density = 1
	opacity = 1
	var/dismantleCallback

/obj/structure/falsewall/New()
	relativewall_neighbours()
	..()

/obj/structure/falsewall/Destroy()

	var/temploc = loc
	loc = null

	for(var/turf/simulated/wall/W in range(temploc,1))
		W.relativewall()

	for(var/obj/structure/falsewall/W in range(temploc,1))
		W.relativewall()
	..()


/obj/structure/falsewall/relativewall()

	if(!density)
		icon_state = "[walltype]fwall_open"
		return

	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	for(var/turf/simulated/wall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(mineral == W.mineral)//Only 'like' walls connect -Sieve
				junction |= get_dir(src,W)
	for(var/obj/structure/falsewall/W in orange(src,1))
		if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
			if(mineral == W.mineral)
				junction |= get_dir(src,W)
	icon_state = "[walltype][junction]"
	return

/obj/structure/falsewall/attack_hand(mob/user)
	if(opening)
		return

	opening = 1
	if(density)
		do_the_flick()
		sleep(4)
		density = 0
		SetOpacity(0)
		update_icon(0)
	else
		var/srcturf = get_turf(src)
		for(var/mob/living/obstacle in srcturf) //Stop people from using this as a shield
			opening = 0
			return
		do_the_flick()
		density = 1
		sleep(4)
		SetOpacity(1)
		update_icon()
	opening = 0

/obj/structure/falsewall/proc/do_the_flick()
	if(density)
		flick("[walltype]fwall_opening", src)
	else
		flick("[walltype]fwall_closing", src)

/obj/structure/falsewall/update_icon(relativewall = 1)//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	if(density)
		icon_state = "[walltype]0"
		if(relativewall)
			relativewall()
	else
		icon_state = "[walltype]fwall_open"

/obj/structure/falsewall/proc/ChangeToWall(delete = 1)
	var/turf/T = get_turf(src)
	if(!walltype || walltype == "metal")
		T.ChangeTurf(/turf/simulated/wall)
	else
		T.ChangeTurf(text2path("/turf/simulated/wall/mineral/[walltype]"))
	if(delete)
		qdel(src)
	return T

/obj/structure/falsewall/attackby(obj/item/weapon/W, mob/user, params)
	if(opening)
		user << "<span class='warning'>You must wait until the door has stopped moving!</span>"
		return

	if(density)
		var/turf/T = get_turf(src)
		if(T.density)
			user << "<span class='warning'>[src] is blocked!</span>"
			return
		if(istype(W, /obj/item/weapon/screwdriver))
			if (!istype(T, /turf/simulated/floor))
				user << "<span class='warning'>[src] bolts must be tightened on the floor!</span>"
				return
			user.visible_message("<span class='notice'>[user] tightens some bolts on the wall.</span>", "<span class='notice'>You tighten the bolts on the wall.</span>")
			ChangeToWall()
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				dismantle(user)
	else
		user << "<span class='warning'>You can't reach, close it first!</span>"

	if(istype(W, /obj/item/weapon/gun/energy/plasmacutter))
		dismantle(user)

	if(istype(W, /obj/item/weapon/pickaxe/drill/jackhammer) || istype(W, /obj/item/weapon/pickaxe/drill/diamonddrill))
		var/obj/item/weapon/pickaxe/D = W
		D.playDigSound()
		dismantle(user)

/obj/structure/falsewall/proc/dismantle(mob/user)
	user.visible_message("<span class='notice'>[user] dismantles the false wall.</span>", "<span class='notice'>You dismantle the false wall.</span>")
	new /obj/structure/girder/displaced(loc)
	var/d_type
	if(mineral == "metal")
		if(istype(src, /obj/structure/falsewall/reinforced))
			d_type = /obj/item/stack/sheet/plasteel
		else
			d_type = /obj/item/stack/sheet/metal
	else
		d_type = text2path("/obj/item/stack/sheet/mineral/[mineral]")

	var/P = new d_type(loc)
	if(dismantleCallback)
		call(P,dismantleCallback)()
	P = new d_type(loc)
	if(dismantleCallback)
		call(P,dismantleCallback)()

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	QDEL_NULL(src)

/*
 * False R-Walls
 */

/obj/structure/falsewall/reinforced
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to seperate rooms."
	icon_state = "r_wall"
	walltype = "rwall"

/obj/structure/falsewall/reinforced/ChangeToWall(delete = 1)
	var/turf/T = get_turf(src)
	T.ChangeTurf(/turf/simulated/wall/r_wall)
	if(delete)
		qdel(src)
	return T

/obj/structure/falsewall/reinforced/do_the_flick()
	if(density)
		flick("frwall_opening", src)
	else
		flick("frwall_closing", src)

/obj/structure/falsewall/reinforced/update_icon(relativewall = 1)
	if(density)
		icon_state = "rwall0"
		src.relativewall()
	else
		icon_state = "frwall_open"

/*
 * Uranium Falsewalls
 */

/obj/structure/falsewall/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon_state = ""
	mineral = "uranium"
	walltype = "uranium"

/obj/structure/falsewall/uranium/enr
	dismantleCallback = "enrich"
	var/rad_buildup = 0

/obj/structure/falsewall/uranium/enr/New()
	SSobj.processing.Add(src)
	..()

/obj/structure/falsewall/uranium/enr/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/structure/falsewall/uranium/enr/process()
	radiate()

/obj/structure/falsewall/uranium/enr/irradiate(rad)
	if(!rad)
		return
	rad_buildup += rad

/obj/structure/falsewall/uranium/enr/proc/radiate(rad)
	for(var/atom/A in orange(1,src))
		A.irradiate(0.6+rad_buildup*IRRADIATION_RADIOACTIVITY_MODIFIER)
	IRRADIATION_RETARDATION(rad_buildup)
/*
 * Other misc falsewall types
 */

/obj/structure/falsewall/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon_state = ""
	mineral = "gold"
	walltype = "gold"

/obj/structure/falsewall/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny."
	icon_state = ""
	mineral = "silver"
	walltype = "silver"

/obj/structure/falsewall/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon_state = ""
	mineral = "diamond"
	walltype = "diamond"

/obj/structure/falsewall/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon_state = ""
	mineral = "plasma"
	walltype = "plasma"

/obj/structure/falsewall/plasma/attackby(obj/item/weapon/W, mob/user, params)
	if(is_hot(W) > 300)
		message_admins("Plasma falsewall ignited by [key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Plasma falsewall ignited by [user.ckey]([user]) in ([x],[y],[z])")
		burnbabyburn()
		return
	..()

/obj/structure/falsewall/plasma/proc/burnbabyburn(user)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	atmos_spawn_air(SPAWN_HEAT | SPAWN_TOXINS, 400)
	new /obj/structure/girder/displaced(loc)
	qdel(src)

/obj/structure/falsewall/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		burnbabyburn()

//-----------wtf?-----------start
/obj/structure/falsewall/clown
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon_state = ""
	mineral = "bananium"
	walltype = "bananium"


/obj/structure/falsewall/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon_state = ""
	mineral = "sandstone"
	walltype = "sandstone"
//------------wtf?------------end

/obj/structure/falsewall/wood
	name = "wooden wall"
	desc = "A wall with wooden plating."
	icon_state = ""
	mineral = "wood"
	walltype = "wood"
