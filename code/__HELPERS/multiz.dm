proc/HasAbove(var/z)
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		return controller.up
	return 0

proc/HasBelow(var/z)
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		return controller.down
	return 0

proc/GetLevelAbove(var/z)
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.up)
			return controller.up_target
	return 0

proc/GetLevelBelow(var/z)
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			return controller.down_target
	return 0

proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	var/Z = GetLevelAbove(turf.z)
	return Z ? locate(turf.x, turf.y, Z) : null

proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	var/Z = GetLevelBelow(turf.z)
	return Z ? locate(turf.x, turf.y, Z) : null
