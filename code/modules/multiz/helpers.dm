/*proc/HasAbove(var/z)
	return (z-1 in multiz_levels) ? 1 : 0

proc/HasBelow(var/z)
	return (z+1 in multiz_levels) ? 1 : 0

// Thankfully, no bitwise magic is needed here.
proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null*/ //Last time I tried to use it it didn't work, so I guess it still doesn't, but I'll better leave it commented than deleting

/proc/get_multiz_controller(atom/A)
	var/z=0
	if(A)
		z=A.z
	if(z==null)
		return null
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		return controller

/proc/turf_below(atom/A)
	if(!istype(A))
		return null
	var/obj/effect/landmark/zcontroller/mzc=get_multiz_controller(A)
	if(!mzc||mzc.down==null)
		return null
	return locate(A.x,A.y,mzc.down_target)

/proc/turf_above(atom/A)
	if(!istype(A))
		return null
	var/obj/effect/landmark/zcontroller/mzc=get_multiz_controller(A)
	if(!mzc||mzc.up==null)
		return null
	return locate(A.x,A.y,mzc.up_target)