//	 0 = don't fall
//	 1 = dust fall
//	>1 = additional data for falling process
atom/movable/proc/falling_check(var/turf/simulated/open_space/Space)
	if(src.loc != Space)
		return 0	//sanity

	if(Space.passability & OPENSPACE_PASSABILITY_BLOCKED)
		return 0

	if(Space.passability & OPENSPACE_PASSABILITY_GANGWAY && Space.gangway_layer < layer)
		return 0	//it abowe some gangway

	var/area/areacheck = get_area(Space)
	if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))
		return 0	//no gravity, no fall

	if(src.throwing != 0)
		sleep(1)
		if(src.throwing != 0 || src.loc != Space)
			return 0 //It should fly over open space, not fall into

	if (areacheck.name == "Space")
		return 0

	if(Space.passability & OPENSPACE_PASSABILITY_TABLE)
		return 0

	return 1

atom/movable/proc/falling_do(var/turf/simulated/open_space/Space, var/inctruction)
	if(!inctruction)
		return	//sanity. king of.

	if(!Space.floorbelow) //make sure that there is actually something below
		if(!Space.getturfbelow())
			return

	if(src.density)
		for(var/mob/living/M in Space.floorbelow)
			M.Weaken(3)	//so, something heavy falls on someone
			M << "<span class='dange'>\the [src] fell on you!</span>"

	src.Move(Space.floorbelow)

atom/proc/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	if(src.density)
		return OPENSPACE_PASSABILITY_BLOCKED
	else
		return 0

atom/proc/falling_check_obstruction_as_gangway(var/turf/simulated/open_space/Space)
	return 0


/* ========= ========= ========= ======== ========= ========= ======== ========= ========= */

//ghosts shuldnt fall
/mob/dead/observer/falling_check(var/turf/simulated/open_space/Space)
	return 0

/* ========= ========= ========= ======== ========= ========= ======== ========= ========= */

/obj/effect/landmark/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/lattice/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/singularity/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/item/pipe/falling_check(var/turf/simulated/open_space/Space)
	if(Space.passability & (OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS | OPENSPACE_PASSABILITY_PIPE_DISPOSAL))
		return 0
	return ..()

/obj/machinery/atmospherics/pipe/falling_check(var/turf/simulated/open_space/Space)
	if(Space.passability & OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS)
		return 0
	return ..()

/obj/structure/disposalpipe/falling_check(var/turf/simulated/open_space/Space)
	if(Space.passability & OPENSPACE_PASSABILITY_PIPE_DISPOSAL)
		return 0
	return ..()

/obj/item/projectile/falling_check(var/turf/simulated/open_space/Space)
	if(src.original != Space)	//Projectiles shoudn't fall into open space, untill they aimed at one
		return 0
	else
		return 1

/obj/item/falling_check(var/turf/simulated/open_space/Space)
	if(src.loc != Space)
		return 0	//sanity

	if(Space.passability & OPENSPACE_PASSABILITY_BLOCKED)
		return 0

	if(Space.passability & OPENSPACE_PASSABILITY_GANGWAY && Space.gangway_layer < layer)
		return 0	//it abowe some gangway

	var/area/areacheck = get_area(Space)
	if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))
		return 0	//no gravity, no fall

	if(src.throwing != 0)
		sleep(1)
		if(src.throwing != 0 || src.loc != Space)
			return 0 //It should fly over open space, not fall into

	if (areacheck.name == "Space")
		return 0

	if((Space.passability & OPENSPACE_PASSABILITY_TABLE) && (src.w_class > 4))
		return 0

	return 1

/obj/structure/table/falling_check(var/turf/simulated/open_space/Space)
	var/turf/ST
	ST = get_step(src, 1)
	if(!istype(ST, /turf/simulated/open_space) && !istype(ST, /turf/space) && locate(/obj/structure/table) in ST)
		return 1
	ST = get_step(src, 2)
	if(!istype(ST, /turf/simulated/open_space) && !istype(ST, /turf/space) && locate(/obj/structure/table) in ST)
		return 1
	ST = get_step(src, 4)
	if(!istype(ST, /turf/simulated/open_space) && !istype(ST, /turf/space) && locate(/obj/structure/table) in ST)
		return 1
	ST = get_step(src, 8)
	if(!istype(ST, /turf/simulated/open_space) && !istype(ST, /turf/space) && locate(/obj/structure/table) in ST)
		return 1
	return ..()

/obj/structure/cable/falling_check(var/turf/simulated/open_space/Space) //ow boy, here we go
	if(src.loc != Space)
		return 0	//sanity

	if(Space.passability & OPENSPACE_PASSABILITY_BLOCKED)
		return 0

	if(Space.passability & OPENSPACE_PASSABILITY_GANGWAY && Space.gangway_layer < layer)
		return 0	//it abowe some gangway

	var/area/areacheck = get_area(Space)
	if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))
		return 0	//no gravity, no fall

	if(src.throwing != 0)
		sleep(1)
		if(src.throwing != 0 || src.loc != Space)
			return 0 //It should fly over open space, not fall into

	if (areacheck.name == "Space")
		return 0

	var/count = 0	//1 - falling, 2 - d1 is unsequred. 4 - d2 is unsequred, 8 - knot cable

	if(!src.d1)	//knot
		count |= 11
	else if(src.d1 & 16)	//up
		var/turf/UP = GetAbove(src)
		var/F = 0
		for(var/obj/structure/cable/C in UP)
			if(C.d1 & 32 || C.d2 & 32)
				F = 1
				break
		if(!F)
			count |= 2
	else if(src.d2 & 32)	//down. this shouldnt happen
		count |= 2
	else
		var/turf/UP = get_step(src, d1)
		var/fdir = turn(d1, 180) //flip the direction, to match with the source position on its turf
		var/F = 0
		for(var/obj/structure/cable/C in UP)
			if(C.d1 == fdir || C.d2 == fdir)
				F = 1
				break
		if(!F)
			count |= 2

	if(!src.d2)	//knot/ this shouldnt happen
		count |= 13
	else if(src.d2 & 16)	//up
		var/turf/UP = GetAbove(src)
		var/F = 0
		for(var/obj/structure/cable/C in UP)
			if(C.d1 & 32 || C.d2 & 32)
				F = 1
				break
		if(!F)
			count |= 4
	else if(src.d2 & 32)	//down.
		count |= 4
	else
		var/turf/UP = get_step(src, d2)
		var/fdir = turn(d2, 180) //flip the direction, to match with the source position on its turf
		var/F = 0
		for(var/obj/structure/cable/C in UP)
			if(C.d1 == fdir || C.d2 == fdir)
				F = 1
				break
		if(!F)
			count |= 4

	if(!(count & 6) || (!(count & 2) && (d2 & 32)))
		return 0

	return count | 1

/obj/structure/cable/falling_do(var/turf/simulated/open_space/Space, var/inctruction)
	if(!Space.floorbelow) //make sure that there is actually something below
		if(!Space.getturfbelow())
			return
	//so we DO fall
	if((inctruction & 8) || (inctruction & 6) == 6)
		src.Deconstruct()
		for(var/obj/item/stack/cable_coil/C in Space)
			var/I = C.falling_check(Space)
			if(I)
				C.falling_do(Space, I)
	else
		var/D
		if(inctruction & 2)
			D = d2
		else
			D = d1
		cut_cable_from_powernet()
		d1 = D
		d2 = 32
		src.updateicon()
		src.mergeConnectedNetworks(src.d1) //merge the powernet with adjacents powernets
		src.mergeConnectedNetworksOnTurf() //merge the powernet with on turf powernets

		if(src.d1 & (src.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			src.mergeDiagonalsNetworks(src.d1)

		if(src.d2 & 48)//	multiZ cable cant be checked by common merge
			src.mergeMultizNetworks(src.d2)

/mob/living/carbon/human/falling_do(var/turf/simulated/open_space/Space, var/inctruction)
	if(!Space.floorbelow) //make sure that there is actually something below
		if(!Space.getturfbelow())
			return
	//so we DO fall
	if(src.density)
		for(var/mob/living/M in Space.floorbelow)
			M.Weaken(3)	//so, something heavy falls on someone
			M << "<span class='dange'>\the [src] fell on you!</span>"

	src.Move(Space.floorbelow)

	if(locate(src) in Space.floorbelow)
		var/area/areacheck = get_area(Space)
		if(src:back && istype(src:back, /obj/item/weapon/tank/jetpack))
			return
		else if (istype(Space.floorbelow, /turf/space))
			return //You broke you legs on space no more!
		else if(istype(Space.floorbelow, /turf/simulated/open_space))
			return //You get stannet only when you hawe impact TODO: increase damage on long fals
		else if(!(length(gravity_generators["[src.z]"]) || areacheck.has_gravity))
			return
		else
			var/damage = 10
//			src.apply_damage(rand(0,damage), BRUTE, "groin") // Õ¿ Õ¿’”… œŒ √–Œ»Õ”
			src.apply_damage(rand(0,damage), BRUTE, "l_leg")
			src.apply_damage(rand(0,damage), BRUTE, "r_leg")
			src.apply_damage(rand(2,damage), BRUTE, "l_foot")
			src.apply_damage(rand(2,damage), BRUTE, "r_foot")
			src.Weaken(3)
			src:updatehealth()

/obj/structure/piano/falling_do(var/turf/simulated/open_space/Space, var/inctruction)
	if(!inctruction)
		return	//sanity. king of.

	if(!Space.floorbelow) //make sure that there is actually something below
		if(!Space.getturfbelow())
			return

	if(src.density)
		for(var/mob/living/M in Space.floorbelow)
			M.Weaken(3)	//so, something heavy falls on someone
			M << "<span class='dange'>\the [src] fell on you!</span>"
			spawn(10)
				src.visible_message("[src.name] squashes [M.name]!")
				M.gib()

	src.Move(Space.floorbelow)



/mob/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/table/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	if(src.density)
		return OPENSPACE_PASSABILITY_TABLE
	return 0

/obj/structure/rack/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	if(src.density)
		return OPENSPACE_PASSABILITY_TABLE
	return 0

/obj/structure/closet/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	if(src.density)
		if(src.opened)
			return OPENSPACE_PASSABILITY_TABLE
		else
			return OPENSPACE_PASSABILITY_BLOCKED
	return 0

/obj/machinery/atmospherics/pipe/zpipe/up/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	return OPENSPACE_PASSABILITY_PIPE_ATMOSPHERICS

/obj/structure/disposalpipe/crossZ/up/falling_check_obstruction_from_abowe(var/turf/simulated/open_space/Space)
	return OPENSPACE_PASSABILITY_PIPE_DISPOSAL



/obj/structure/table/falling_check_obstruction_as_gangway(var/turf/simulated/open_space/Space)
	if(src.density || !src.flipped)
		if(!src.falling_check(Space))
			Space.gangway_layer = min(src.layer, Space.gangway_layer)
			return OPENSPACE_PASSABILITY_GANGWAY
	return 0

/obj/structure/lattice/catwalk/falling_check_obstruction_as_gangway(var/turf/simulated/open_space/Space)
	Space.gangway_layer = min(src.layer, Space.gangway_layer)
	return OPENSPACE_PASSABILITY_GANGWAY


/* ========= ========= ========= ======== ========= ========= ======== ========= ========= */
// things hanging on walls

/obj/machinery/keycard_auth/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/item/device/radio/intercom/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/requests_console/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/alarm/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/firealarm/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/camera/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/computer/security/telescreen/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/ai_status_display/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/item/weapon/storage/secure/safe/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/extinguisher_cabinet/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/closet/fireaxecabinet/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/newscaster/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/status_display/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/sign/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/vending/wallmed/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/power/apc/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/sparker/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/flasher/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/light/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/light_switch/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/door_control/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/machinery/flasher_button/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/reagent_dispensers/peppertank/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/reagent_dispensers/virusfood/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/mirror/falling_check(var/turf/simulated/open_space/Space)
	return 0

/obj/structure/sink/falling_check(var/turf/simulated/open_space/Space)
	return 0