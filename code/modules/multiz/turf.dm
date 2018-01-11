/turf/simulated/open_space
	name = "open space"
	intact = 0
	density = 0
	icon_state = "osblack"
	var/icon/darkoverlays = null
	var/turf/floorbelow
	var/list/overlay_references
	var/passability					//flags, yoused to chek when we need to try to drop ALL
	var/gangway_layer = INFINITY	//layer of gangway
	var/atom/movable/under_space/markerbelow

	New()
		..()
		getturfbelow()
		return

	Enter(var/atom/movable/AM)
		if (..())
			spawn(1)
				// only fall down in defined areas (read: areas with artificial gravitiy)
				if(!floorbelow) //make sure that there is actually something below
					if(!getturfbelow())
						return
				if(AM)
					if(src.recalibrate_passability())
						src.drop_all()

					var/I
					if (I = AM.falling_check(src))	//All hail 511
						AM.falling_do(src, I)
		return ..()

/*/turf/simulated/open_space/proc/check_falling(var/atom/movable/AM)
	var/area/areacheck = get_area(src)

	if(AM.loc != src)
		return 0	//sanity

	if(istype(AM, /obj/effect/landmark/zcontroller))
		return 0	//sanity

	if(passability & (OPENSPACE_PASSABILITY_BLOCKED | OPENSPACE_PASSABILITY_GANGWAY))
		return 0

	if(passability & OPENSPACE_PASSABILITY_TABLE)
		if(istype(AM, /obj/item))
			var/obj/item/I = AM
			if(I.w_class > 4)
				return 0
		else
			return 0

	if(istype(AM, /obj/structure/lattice))
		return 0	//this shouldn't fall

	if(istype(AM, /obj/structure/cable))
		return 0

	if(istype(AM, /obj/singularity))
		return 0 	//singulo should trevel betvin Z levels by itself

	if(istype(AM,/obj/item/pipe) && (passability & (OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS | OPENSPACE_PASSABILITY_PIPE_DISPOSAL)))
		return 0

	if(istype(AM,/obj/machinery/atmospherics/pipe) && (passability & OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS))
		return 0

	if(istype(AM,/obj/structure/disposalpipe) && (passability & OPENSPACE_PASSABILITY_PIPE_DISPOSAL))
		return 0

	if(istype(AM, /obj/item/projectile)) //Projectiles shoudn't fall into open space...
		var/obj/item/projectile/P = AM
		if(P.original != src)	//... untill they aimed at one
			return 0
		else
			return 1

	if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))
		return 0	//no gravity, no fall

	if(AM.throwing != 0)
		sleep(1)
		if(AM.throwing != 0 || AM.loc != src)
			return 0 //It should fly over open space, not fall into

	if (areacheck.name == "Space")
		return 0

	if(istype(AM, /obj/structure/table) && AM.density)
		for(var/obj/structure/table/T in orange(1, src))
			if(!istype(T.loc, /turf/simulated/open_space) && !istype(T.loc, /turf/space))
				return 0

	return 1*/

/turf/simulated/open_space/proc/drop_all()
	if(!floorbelow) //make sure that there is actually something below
		if(!getturfbelow())
			return

	for(var/atom/movable/AM in src)
		var/I
		if (I = AM.falling_check(src))	//All hail 511
			AM.falling_do(src, I)

/*/turf/simulated/open_space/proc/drop(var/atom/movable/AM)
	if(!floorbelow) //make sure that there is actually something below
		if(!getturfbelow())
			return
	//so we DO fall
	if(AM.density)
		for(var/mob/living/M in floorbelow)
			M.Weaken(3)	//so, something heavy falls on someone
			M << "<span class='dange'>\the [AM] fell on you!</span>"
			if (istype(AM, /obj/structure/piano))
				spawn(10)
					AM.visible_message("[AM.name] squashes [M.name]!")
					M.gib()
	AM.Move(floorbelow)
	if(locate(AM) in floorbelow)
		if ( istype(AM, /mob/living/carbon/human))
			var/area/areacheck = get_area(src)
			if(AM:back && istype(AM:back, /obj/item/weapon/tank/jetpack))
				return
			else if (istype(floorbelow, /turf/space))
				return //You broke you legs on space no more!
			else if(istype(floorbelow, /turf/simulated/open_space))
				return //You get stannet only when you hawe impact TODO: increase damage on long fals
			else if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))
				return
			else
				var/mob/living/carbon/human/H = AM
				var/damage = 10
//				H.apply_damage(rand(0,damage), BRUTE, "groin") // Õ¿ Õ¿’”… œŒ √–Œ»Õ”
				H.apply_damage(rand(0,damage), BRUTE, "l_leg")
				H.apply_damage(rand(0,damage), BRUTE, "r_leg")
				H.apply_damage(rand(2,damage), BRUTE, "l_foot")
				H.apply_damage(rand(2,damage), BRUTE, "r_foot")
				H.Weaken(3)
				H:updatehealth()*/

/turf/simulated/open_space/proc/recalibrate_passability()
	var/blocked = 0

	for(var/atom/A in src)
		blocked |= A.falling_check_obstruction_as_gangway(src)

	if(!floorbelow) //make sure that there is actually something below
		if(!getturfbelow())
			if(passability != blocked)
				passability = blocked
				return 1
			else
				return 0

	for(var/atom/A in floorbelow.contents)
		blocked |= A.falling_check_obstruction_from_abowe(src)

	if(passability != blocked)
		passability = blocked
		return 1
	else
		return 0


/turf/simulated/open_space/proc/refresh_wiew()
	var/new_list = 0

	src.overlays -= src.z_overlays
	src.z_overlays -= src.z_overlays

	if(!floorbelow) //make sure that there is actually something below
		if(!getturfbelow())
			return new_list

	if(!(istype(floorbelow, /turf/space) || istype(floorbelow, /turf/simulated/open_space)))
		var/image/t_img = list()
		new_list = 1

		var/image/temp = image(floorbelow, dir=floorbelow.dir, layer = TURF_LAYER + 0.04)
		temp.color = floorbelow.color//rgb(127,127,127)
		temp.overlays += floorbelow.overlays
		t_img += temp
		src.overlays += t_img
		src.z_overlays += t_img

	// get objects
	var/image/o_img = list()
	for(var/obj/o in floorbelow)
		// ingore objects that have any form of invisibility
		if(o.invisibility) continue
		new_list = 2
		var/image/temp2 = image(o, dir=o.dir, layer = TURF_LAYER+0.05*o.layer)
		temp2.color = o.color//rgb(127,127,127)
		temp2.overlays += o.overlays
		o_img += temp2
		// you need to add a list to .overlays or it will not display any because space
	src.overlays += o_img
	src.z_overlays += o_img

	// get mobs
	var/image/m_img = list()
	for(var/mob/m in floorbelow)
		// ingore mobs that have any form of invisibility
		if(m.invisibility) continue
		// only add this tile to fastprocessing if there is a living mob, not a dead one
		if(istype(m, /mob/living)) new_list = 3
		var/image/temp2 = image(m, dir=m.dir, layer = TURF_LAYER+0.05*m.layer)
		temp2.color = m.color//rgb(127,127,127)
		temp2.overlays += m.overlays
		m_img += temp2
		// you need to add a list to .overlays or it will not display any because space
	src.overlays += m_img
	src.z_overlays += m_img

	src.overlays -= floorbelow.z_overlays
	src.z_overlays -= floorbelow.z_overlays

	src.overlays += image('icons/turf/floors.dmi', icon_state = "osblack_open", layer = TURF_LAYER+0.4)
	src.z_overlays += image('icons/turf/floors.dmi', icon_state = "osblack_open", layer = TURF_LAYER+0.4)

	return new_list


/turf/simulated/open_space/proc/getturfbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(/turf/space)
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
			if(floorbelow && !markerbelow)
				markerbelow = new/atom/movable/under_space(floorbelow, src)
			return 1
	return 1

// override to make sure nothing is hidden
/turf/simulated/open_space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

/turf/simulated/open_space/ex_act(severity)
	// cant destroy empty space with an ordinary bomb
	return

//Singulo shuldn't feed from it, fucken duck.
/turf/simulated/open_space/singularity_act()
	return

/turf/simulated/open_space/singularity_pull()
	return

// Straight copy from space.
/turf/simulated/open_space/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			user << "<span class='warning'>There is already a catwalk here!</span>"
			return
		if(L)
			if(R.use(1))
				user << "<span class='notice'>You begin constructing catwalk...</span>"
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				qdel(L)
				ReplaceWithCatwalk()
			else
				user << "<span class='warning'>You need two rods to build a catwalk!</span>"
			return
		if(R.use(1))
			user << "<span class='notice'>Constructing support lattice...</span>"
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		else
			user << "<span class='warning'>You need one rod to build a lattice.</span>"
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				user << "<span class='notice'>You build a floor.</span>"
				ChangeTurf(/turf/simulated/floor/plating/airless)
			else
				user << "<span class='warning'>You need one floor tile to build a floor!</span>"
		else
			user << "<span class='warning'>The plating is going to need some support! Place metal rods first.</span>"
	if(istype(C, /obj/item/weapon/wirecutters))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			L.attackby(C, user)

	if(istype(C, /obj/item/weapon/weldingtool))
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			W.attackby(C, user)

	if(istype(C, /obj/item/stack/cable_coil))
		return ..()

/atom/movable/under_space
	icon = null
	icon_state = null
	layer = 15
	mouse_opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	anchored = 1
	var/turf/simulated/open_space/above_space

/atom/movable/under_space/New(var/loc, var/turf/simulated/open_space/par = null)
	..()
	if(!par)
		qdel(src)	//It shouldnt exist
		return
	above_space = par

/atom/movable/under_space/proc/refresh()
	if(!above_space || !istype(above_space))
		qdel(src)	//It shouldnt exist
		return

	above_space.refresh_wiew()

	if(above_space.recalibrate_passability())
		above_space.drop_all()

/atom/movable/under_space/Move()
	return

/atom/movable/under_space/Cross()
//	spawn(1) refresh()
	refresh()
	return 1

/atom/movable/under_space/Uncross()
//	spawn(2) refresh()
	spawn(1) refresh()
	return 1

/atom/movable/under_space/ex_act(severity)
	return

//Singulo shuldn't feed from it, fucken duck.
/atom/movable/under_space/singularity_act()
	return

/atom/movable/under_space/singularity_pull()
	return

