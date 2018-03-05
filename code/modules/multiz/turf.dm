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
	mz_transparent = TRUE

	New()
		..()
		getturfbelow()
		return

	Entered(var/atom/movable/AM)
		. = ..()
		spawn(1)
			// only fall down in defined areas (read: areas with artificial gravity)
			if(!floorbelow) //make sure that there is actually something below
				if(!getturfbelow())
					return
			src.drop_all()
		return
/turf/simulated/open_space/draw_update()
	getturfbelow()
	recalibrate_passability()
	..()

/turf/simulated/open_space/proc/drop_all()
	if(!floorbelow) //make sure that there is actually something below
		if(!getturfbelow())
			return

	for(var/atom/movable/AM in src)
		var/I = AM.falling_check(src)
		if (I)
			AM.falling_do(src, I)

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

	blocked |= floorbelow.falling_check_obstruction_from_abowe(src)	//riiiiiiight, turf isn't contained in itself.

	for(var/atom/A in floorbelow.contents)
		blocked |= A.falling_check_obstruction_from_abowe(src)

	if(passability != blocked)
		passability = blocked
		return 1
	else
		return 0

/turf/simulated/open_space/proc/getturfbelow()
	var/obj/effect/landmark/zcontroller/controller = mz_controller()
	if(!controller)
		return
	if(!controller.down)
		src.ChangeTurf(/turf/space)
		return 0
	else
		floorbelow = locate(src.x, src.y, controller.down_target)
	return floorbelow

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

//looks more logical
/turf/simulated/open_space/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return 1
	return 0

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