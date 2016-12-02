#define OPENSPACE_PASSABILITY_BLOCKED 1
#define OPENSPACE_PASSABILITY_TABLE 2
#define OPENSPACE_PASSABILITY_GANGWAY 4
#define OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS 8
#define OPENSPACE_PASSABILITY_PIPE_DISPOSAL 16


/turf/simulated/open_space
	name = "open space"
	intact = 0
	density = 0
	icon_state = "osblack"
	var/icon/darkoverlays = null
	var/turf/floorbelow
	var/list/overlay_references
	var/passability	//flags, yoused to chek when we need to try to drop ALL

	New()
		..()
		getbelow()
		return

	Enter(var/atom/movable/AM)
		if (..())
			spawn(1)
				// only fall down in defined areas (read: areas with artificial gravitiy)
				if(!floorbelow) //make sure that there is actually something below
					if(!getbelow())
						return
				if(AM)
					if(src.recalibrate_passability())
						src.drop_all()

					if (src.check_falling(AM))
						src.drop(AM)
		return ..()

/turf/simulated/open_space/proc/check_falling(var/atom/movable/AM)
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

	return 1

/turf/simulated/open_space/proc/drop_all()
	if(!floorbelow) //make sure that there is actually something below
		if(!getbelow())
			return

	for(var/atom/movable/AM in src)
		if(src.check_falling(AM))
			src.drop(AM)

/turf/simulated/open_space/proc/drop(var/atom/movable/AM)
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
				H:updatehealth()

/turf/simulated/open_space/proc/recalibrate_passability()
	var/blocked = 0

	for(var/atom/A in src)
		if(istype(A, /obj/structure/table) && A.density)
			var/obj/structure/table/Tb = A
			if(!Tb.flipped)
				for(var/obj/structure/table/T in orange(1, src))
					if(!istype(T.loc, /turf/simulated/open_space) && !istype(T.loc, /turf/space))
						blocked |= OPENSPACE_PASSABILITY_GANGWAY
		else if(istype(A, /obj/structure/lattice/catwalk))
			blocked |= OPENSPACE_PASSABILITY_GANGWAY

	if(!floorbelow) //make sure that there is actually something below
		if(!getbelow())
			if(passability != blocked)
				passability = blocked
				return 1
			else
				return 0

	for(var/atom/A in floorbelow.contents)
		if(A.density && !istype(A, /mob))
			if(istype(A, /obj/structure/table) || istype(A, /obj/structure/rack))
				blocked |= OPENSPACE_PASSABILITY_TABLE
			else if (istype(A, /obj/structure/closet))
				var/obj/structure/closet/CL = A
				if(CL.opened)
					blocked |= OPENSPACE_PASSABILITY_TABLE
				else
					blocked |= OPENSPACE_PASSABILITY_BLOCKED
			else
				blocked |= OPENSPACE_PASSABILITY_BLOCKED
		else if(istype(A, /obj/machinery/atmospherics/pipe/zpipe/up))
			blocked |= OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS
		else if(istype(A, /obj/structure/disposalpipe/crossZ/up))
			blocked |= OPENSPACE_PASSABILITY_PIPE_DISPOSAL

	if(passability != blocked)
		passability = blocked
		return 1
	else
		return 0


/turf/simulated/open_space/proc/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(/turf/space)
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
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
