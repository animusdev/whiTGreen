/obj/docking_port/mobile/advanced

/obj/docking_port/mobile/advanced/dock(obj/docking_port/stationary/S1)
	. = canDock(S1)
	if(.)
		ERROR("[type](\"[name]\") cannot dock at [S1]")
		return .

	if(canMove())
		return -1

	closePortDoors()

//		//rotate transit docking ports, so we don't need zillions of variants
//		if(istype(S1, /obj/docking_port/stationary/transit))
//			S1.dir = turn(NORTH, -travelDir)

	var/obj/docking_port/stationary/S0 = get_docked()
	var/turf_type = /turf/space
	var/area_type = /area/space
	if(S0)
		if(S0.turf_type)
			turf_type = S0.turf_type
		if(S0.area_type)
			area_type = S0.area_type

	var/list/L0 = return_ordered_turfs()
	var/list/L1 = return_ordered_turfs(S1.x, S1.y, S1.z, S1.dir)

	//remove area surrounding docking port

	if(areaInstance.contents.len)
		var/area/A0 = locate("[area_type]")
		if(!A0)
			A0 = new area_type(null)
		for(var/turf/T0 in L0)
			A0.contents += T0

	//move or squish anything in the way ship at destination
	roadkill(L1, S1.dir)
	//areaInstance.SetDynamicLighting()
	areaInstance.lighting_use_dynamic=1
	for(var/i=1, i<=L0.len, ++i)
		var/turf/T0 = L0[i]
		if(!T0)
			continue

		var/turf/T1 = L1[i]
		if(!T1)
			continue

		if(T0 != /turf/space && T0 != /turf/simulated/floor/plating/asteroid) //So if there is a hole in the shuttle we don't drag along the space/asteroid/etc to wherever we are going next
			T0.copyTurf(T1)
			areaInstance.contents += T1

			//copy over air
			if(istype(T1, /turf/simulated))
				var/turf/simulated/Ts1 = T1
				Ts1.copy_air_with_tile(T0)

			//move mobile to new location
			for(var/atom/movable/AM in T0)
				AM.onShuttleMove(T1)

		T0.ChangeTurf(turf_type)
	//air system updates
	for(var/turf/T1 in L1)
		for(var/turf/space/S in orange(src,1))
			S.update_starlight()
		T1.init_lighting()
		T1.update_lumcount(0)
		T1.redraw_lighting()
		SSair.remove_from_active(T1)
		T1.CalculateAdjacentTurfs()
		SSair.add_to_active(T1,1)


	for(var/turf/T0 in L0)
		T0.redraw_lighting()
		SSair.remove_from_active(T0)
		T0.CalculateAdjacentTurfs()
		SSair.add_to_active(T0,1)

/atom/movable/proc/onShuttleMove(turf/T1) //, rotation)
//	if(rotation)
//		shuttleRotate(rotation)
	loc = T1
	return 1

///obj/onShuttleMove()
//	if(invisibility >= INVISIBILITY_ABSTRACT)
//		return 0
//	. = ..()

/atom/movable/light/onShuttleMove()
	return 0

/obj/machinery/door/onShuttleMove()
	. = ..()
	if(!.)
		return
	addtimer(src, "close", 0)

/mob/onShuttleMove()
	if(!move_on_shuttle)
		return 0
	. = ..()
	if(!.)
		return
	if(client)
		if(buckled)
			shake_camera(src, 2, 1) // turn it down a bit come on
		else
			shake_camera(src, 7, 1)

/mob/living/carbon/onShuttleMove()
	. = ..()
	if(!.)
		return
	if(!buckled)
		Weaken(3)

/area/ntrec
	name = "NT Recovery White-Ship"
	icon_state = "green"
	has_gravity = 1