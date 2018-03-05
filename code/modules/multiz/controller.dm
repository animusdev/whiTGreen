#define LOCATE_MZ_CONTROLLER(ZLEVEL) (locate(/obj/effect/landmark/zcontroller) in locate(1,1,ZLEVEL))

#define TURF_ACTIVE_UPDATE_DELAY 2

/obj/effect/landmark/zcontroller
	name = "Z-Level Controller"
	var/initialized = 0 // when set to 1, turfs will report to the controller
	var/up = 0	// 1 allows  up movement
	var/up_target = 0 // the Z-level that is above the current one
	var/down = 0 // 1 allows down movement
	var/down_target = 0 // the Z-level that is below the current one

	var/list/turfs = list() //for passive updates

	var/passive_update_delay = 600 //anti-fuckup, passively updates all turfs without causing much lag
	var/last_passive_update = 0
	var/currently_updating = FALSE

	var/list/related_levels = list()  //why look for this every time when we need it, when we can precount it?
	var/first_process = TRUE

/obj/effect/landmark/zcontroller/New()
	..()
	for (var/turf/T in world)
		if (T.z == z)
			turfs += T

	SSobj.processing.Add(src)

	recalibrate_related_levels()

	initialized = 1
	return 1

/obj/effect/landmark/zcontroller/proc/views_init()
	if(!down)
		return //nothing to see below
	var/Ts = turfs //cache?
	for(var/turf/T in Ts)
		if(!T.mz_transparent || istype(T,/turf/space)) //no space redraw at init
			continue
		T.draw_update()

/obj/effect/landmark/zcontroller/Destroy()
	SSobj.processing.Remove(src)
	qdel(src)
	return

/obj/effect/landmark/zcontroller/process()
	if (down && !currently_updating && world.time - last_passive_update > passive_update_delay)
		last_passive_update = world.time
		currently_updating = TRUE
		spawn(0)
			for(var/turf/T in turfs)
				if(!T.mz_transparent)
					continue
				T.draw_update()
				CHECK_TICK
			currently_updating = FALSE

/obj/effect/landmark/zcontroller/proc/add(var/turf/T,var/transfer,var/dir = 0) //dir to prevent recursion stacking (a->b->a)
	if(!T || !istype(T, /turf))
		return
	turfs |= T

	if(transfer > 0)
		if(up && dir >= 0) //so no going back
			var/obj/effect/landmark/zcontroller/controller_up = LOCATE_MZ_CONTROLLER(up_target)
			if(controller_up)
				var/turf/tempT = locate(T.x, T.y, up_target)
				controller_up.add(tempT, transfer-1, 1)

		if(down && dir <= 0) //no going back
			var/obj/effect/landmark/zcontroller/controller_down = LOCATE_MZ_CONTROLLER(down_target)
			if(controller_down)
				var/turf/tempT = locate(T.x, T.y, down_target)
				controller_down.add(tempT, transfer-1, -1)
	return


/atom/proc/mz_controller()
	return LOCATE_MZ_CONTROLLER(z)

/turf
	var/list/z_overlays = list()
	var/last_draw_update = 0
	var/needs_draw_update = FALSE
	var/processing_draw_update = FALSE //not sure if it's needed
	var/mz_transparent = FALSE //can it update visuals based on turfs below

/turf/proc/state_update() //tells turf that it should consider triggering redraw for object above
	needs_draw_update = TRUE
	if(processing_draw_update || world.time - last_draw_update < TURF_ACTIVE_UPDATE_DELAY)
		return
	processing_draw_update = TRUE
	spawn(-1)
		while(needs_draw_update)
			needs_draw_update = FALSE
			last_draw_update = world.time
			var/turf/T = GetAbove(src)
			if(T)
				T.draw_update()
			sleep(CLAMP(last_draw_update + TURF_ACTIVE_UPDATE_DELAY - world.time, 0, TURF_ACTIVE_UPDATE_DELAY)) //CLAMP for sanity (midnight rollover or whatever)
		processing_draw_update = FALSE

/turf/proc/draw_update()
	if(!mz_transparent)
		return //can't see below
	if(!SSmultiz || !SSmultiz.ready)
		return //fucking byond is probably loading maps and will crash if we try to ger image of nonnull but noninitialized turf
	//recalculate overlays
	overlays -= z_overlays
	z_overlays.Cut()
	var/turf/TB = GetBelow(src)
	if(!TB)
		return //nothing to see below
	var/image/new_overlays = list()

	var/image/temp = image(TB, dir=TB.dir, layer = TURF_LAYER + 0.004)
	temp.color = TB.color
	temp.overlays += TB.overlays
	new_overlays += temp

	new_overlays += temp
	for(var/atom/movable/A in TB)
		if(A.invisibility) continue
		temp = image(A, dir=A.dir, layer = TURF_LAYER+0.005*A.layer)
		temp.color = A.color
		temp.overlays += A.overlays
		new_overlays += temp

	z_overlays += new_overlays
	z_overlays -= TB.z_overlays
	z_overlays += image('icons/turf/floors.dmi', icon_state = "osblack_open", layer = TURF_LAYER+0.25)
	overlays += z_overlays

	state_update() //tell turf above that it should redraw

/turf/New()
	..()

	var/obj/effect/landmark/zcontroller/controller = mz_controller()
	if(controller && controller.initialized)
		controller.add(src,1)
	state_update()
	draw_update()

/atom/movable/Destroy()
	if(loc && isturf(loc))
		loc:state_update()
	..()

/atom/movable/Move() //Hackish
	. = ..()

	var/obj/effect/landmark/zcontroller/controller = mz_controller()
	if(controller && (controller.up || controller.down))
		controller.add(get_turf(src),1)

/obj/effect/landmark/zcontroller/proc/recalibrate_related_levels()
	related_levels.Cut()
	var/turf/T = get_turf(src.loc)
	if(T)
		recalibrate_related_level(T.z)

/obj/effect/landmark/zcontroller/proc/recalibrate_related_level(var/Z_level)
	if(related_levels.Find(Z_level))
		return
	related_levels |= Z_level
	var/turf/controllerlocation = locate(1, 1, Z_level)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			if(!(related_levels.Find(controller.down_target)))
				recalibrate_related_level(controller.down_target)
		if(controller.up)
			if(!(related_levels.Find(controller.up_target)))
				recalibrate_related_level(controller.up_target)

proc/get_related_levels(var/Z_level)
	var/turf/controllerlocation = locate(1, 1, Z_level)
	var/obj/effect/landmark/zcontroller/Z_contr
	Z_contr = locate(/obj/effect/landmark/zcontroller) in controllerlocation
	if(!Z_contr)
		return list(Z_level)	//no zcontroller, get only this floor
	if(Z_contr.related_levels)	//sanyty
		return Z_contr.related_levels
	Z_contr.recalibrate_related_levels()
	if(Z_contr.related_levels)  //double check
		return Z_contr.related_levels
	//anithing is bad
	message_admins("A Z-controller falled to found even it's own flor at [Z_level] Z level (<A HREF='?_src_=vars;Vars=\ref[Z_contr]'>VV</A>)(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[Z_contr.x];Y=[Z_contr.y];Z=[Z_contr.z]'>JMP</a>)")
	log_admin("A Z-controller falled calibrate releted levels at [Z_level] Z level")
	return list(Z_level)
