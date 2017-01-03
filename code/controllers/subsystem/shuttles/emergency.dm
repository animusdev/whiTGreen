/obj/docking_port/mobile/emergency
	name = "emergency shuttle"
	id = "emergency"

	dwidth = 9
	width = 22
	height = 11
	dir = 4
	travelDir = -90

/obj/docking_port/mobile/emergency/New()
	..()
	SSshuttle.emergency = src

/obj/docking_port/mobile/emergency/timeLeft(divisor)
	if(divisor <= 0)
		divisor = 10
	if(!timer)
		return round(SSshuttle.emergencyCallTime/divisor, 1)

	var/dtime = world.time - timer
	switch(mode)
		if(SHUTTLE_ESCAPE)
			dtime = max(SSshuttle.emergencyEscapeTime - dtime, 0)
		if(SHUTTLE_DOCKED)
			dtime = max(SSshuttle.emergencyDockTime - dtime, 0)
		else
			dtime = max(SSshuttle.emergencyCallTime - dtime, 0)
	return round(dtime/divisor, 1)

/obj/docking_port/mobile/emergency/request(obj/docking_port/stationary/S, coefficient=1, area/signalOrigin, reason, redAlert)
	SSshuttle.emergencyCallTime = initial(SSshuttle.emergencyCallTime) * coefficient
	switch(mode)
		if(SHUTTLE_RECALL)
			mode = SHUTTLE_CALL
			timer = world.time - timeLeft(1)
		if(SHUTTLE_IDLE)
			mode = SHUTTLE_CALL
			timer = world.time
		if(SHUTTLE_CALL)
			if(world.time < timer)	//this is just failsafe
				timer = world.time
		else
			return

	if(prob(70))
		SSshuttle.emergencyLastCallLoc = signalOrigin
	else
		SSshuttle.emergencyLastCallLoc = null

	priority_announce("Вызван эвакуационный шаттл. [redAlert ? "Red Alert state confirmed: Dispatching priority shuttle. " : "" ]Ожидаемое врем&#255; прибыти&#255;: [timeLeft(600)] минут.[reason][SSshuttle.emergencyLastCallLoc ? "\n\nИсточник сигнала идентифицирован, данные о его местоположении доступны с любой коммуникационной консоли." : "" ]", null, 'sound/AI/shuttlecalled.ogg', "Priority")

/obj/docking_port/mobile/emergency/cancel(area/signalOrigin)
	if(mode != SHUTTLE_CALL)
		return

	timer = world.time - timeLeft(1)
	mode = SHUTTLE_RECALL

	if(prob(70))
		SSshuttle.emergencyLastCallLoc = signalOrigin
	else
		SSshuttle.emergencyLastCallLoc = null
	priority_announce("Эвакуационный шаттл был отозван.[SSshuttle.emergencyLastCallLoc ? " Источник сигнала идентифицирован, данные о его местоположении доступны с любой коммуникационной консоли." : "" ]", null, 'sound/AI/shuttlerecalled.ogg', "Priority")

/*
/obj/docking_port/mobile/emergency/findTransitDock()
	. = SSshuttle.getDock("emergency_transit")
	if(.)	return .
	return ..()
*/


/obj/docking_port/mobile/emergency/check()
	if(!timer)
		return

	var/time_left = timeLeft(1)
	switch(mode)
		if(SHUTTLE_RECALL)
			if(time_left <= 0)
				mode = SHUTTLE_IDLE
				timer = 0
		if(SHUTTLE_CALL)
			if(time_left <= 0)
				//move emergency shuttle to station
				if(dock(SSshuttle.getDock("emergency_home")))
					setTimer(20)
					return
				mode = SHUTTLE_DOCKED
				timer = world.time
				priority_announce("Эвакуационный шаттл прибыл на станцию. В вашем распор&#255;жении [timeLeft(600)] минуты на посадку.", null, 'sound/AI/shuttledock.ogg', "Priority")
		if(SHUTTLE_DOCKED)
			if(time_left <= 0 && SSshuttle.emergencyNoEscape)
				priority_announce("Hostile enviroment detected. Departure has been postponed indefinitely pending conflict resolution.", null, 'sound/misc/notice1.ogg', "Priority")
				mode = SHUTTLE_STRANDED
			if(time_left <= 0 && !SSshuttle.emergencyNoEscape)
				//move each escape pod to its corresponding transit dock
				for(var/obj/docking_port/mobile/pod/M in SSshuttle.mobile)
					M.enterTransit()
				//now move the actual emergency shuttle to its transit dock
				enterTransit()
				mode = SHUTTLE_ESCAPE
				timer = world.time
				priority_announce("Эвакуационный шаттл покинул станцию. Осталось [timeLeft(600)] минуты до прибыти&#255; в доки Центрального Коммандовани&#255;.", null, null, "Priority")
		if(SHUTTLE_ESCAPE)
			if(time_left <= 0)
				//move each escape pod to its corresponding escape dock
				for(var/obj/docking_port/mobile/pod/M in SSshuttle.mobile)
					M.dock(SSshuttle.getDock("[M.id]_away"))
				//now move the actual emergency shuttle to centcomm
				dock(SSshuttle.getDock("emergency_away"))
				mode = SHUTTLE_ENDGAME
				timer = 0


/obj/docking_port/mobile/pod
	name = "escape pod"
	id = "pod"

	dwidth = 1
	width = 3
	height = 4

	New()
		if(id == "pod")
			WARNING("[type] id has not been changed from the default. Use the id convention \"pod1\" \"pod2\" etc.")
		..()

	request()
		return

	cancel()
		return

/*
	findTransitDock()
		. = SSshuttle.getDock("[id]_transit")
		if(.)	return .
		return ..()
*/
