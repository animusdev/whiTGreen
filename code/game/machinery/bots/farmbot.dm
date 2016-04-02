// Farmbots originally implemented by GauHelldragon - 12/30/2012
// Ported and reworked by fluorescent-net - 23/02/2016

// A new type of buildable aiBot that helps out in hydroponics
// Made by using a robot arm on a water tank and then adding:
// A plant analyzer, a bucket, a cultivator and then a proximity sensor (in that order)

// Will water, weed and fertilize plants that need it
// When emagged, it will "water", "weed" and "fertilize" humans instead
// Can hold a beaker with chemicals to fertilize plants
// It will fill up it's water tank at a sink when low.

// The behavior panel can be unlocked with hydroponics access and be modified to disable certain behaviors
// By default, it will ignore weeds and mushrooms, but can be set to tend to these types of plants as well.

#define FARMBOT_MODE_WATER			1
#define FARMBOT_MODE_FERTILIZE	 	2
#define FARMBOT_MODE_WEED			3
#define FARMBOT_MODE_REFILL			4
#define FARMBOT_MODE_WAITING		5

#define FARMBOT_ANIMATION_TIME		25 //How long it takes to use one of the action animations
#define FARMBOT_EMAG_DELAY			60 //How long of a delay after doing one of the emagged attack actions
#define FARMBOT_ACTION_DELAY		35 //How long of a delay after doing one of the normal actions

/obj/machinery/bot/farmbot
	name = "Farmbot"
	desc = "The botanist's best friend."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "farmbot0"
	layer = 5.0
	density = 1
	anchored = 0
	health = 50
	maxhealth = 50
	req_access = list(access_hydroponics)

	var/setting_water = 1
	var/setting_refill = 1
	var/setting_fertilize = 1
	var/setting_weed = 1
	var/setting_ignoreWeeds = 1
	var/setting_ignoreMushrooms = 1

	var/atom/target //Current target, can be a human, a hydroponics tray, or a sink

	var/obj/structure/reagent_dispensers/watertank/tank
	var/obj/item/weapon/reagent_containers/glass/beaker/beaker

/obj/machinery/bot/farmbot/New()
	..()
	icon_state = "farmbot[on]"
	var/datum/job/hydro/H = new/datum/job/hydro
	botcard.access += H.get_access()

	if(!tank)
		tank = new /obj/structure/reagent_dispensers/watertank(src)

/obj/machinery/bot/farmbot/turn_on()
	. = ..()
	update_icon()
	updateUsrDialog()

/obj/machinery/bot/farmbot/turn_off()
	..()
	update_icon()
	updateUsrDialog()

/obj/machinery/bot/farmbot/update_icon()
	icon_state = "farmbot[on]"
	..()

/obj/machinery/bot/farmbot/attack_hand(mob/user as mob)
	. = ..()
	if (.)
		return
	add_fingerprint(usr)
	if(!emagged)
		interact(user)
		usr.set_machine(src)
	else
		user << "<span class='warning'>ERROR</span>"
		return

/obj/machinery/bot/farmbot/interact(mob/user as mob)
	var/dat
	dat += "Status: <a href='?src=\ref[src];on=1'>[on ? "On" : "Off"]</a><br>"
	if(tank)
		dat += "Water tank: \[[tank.reagents.total_volume]/[tank.reagents.maximum_volume]\]<br>"
	else
		dat += "Error: water tank not found.<br>"

	if(beaker)
		dat += "<Reagent Storage:<br>"
		dat += "<a href='?src=\ref[src];eject=1'>\[[beaker.reagents.total_volume]/[beaker.reagents.maximum_volume]\]</a><br>"
		for (var/datum/reagent/R in beaker.reagents.reagent_list)
			dat += "[R.volume] units of [R.name]<br>"
	else
		dat += "No beaker loaded.<br>"

	dat += "<br>Behaviour controls are [locked ? "locked" : "unlocked"]<br><hr>"
	if(!src.locked)
		dat += text({"
			<tt>Watering Controls:<br>
			Water Plants: <a href='?src=\ref[src];water=1'>[setting_water ? "Yes" : "No"]</a><br>
			Refill Watertank: <a href='?src=\ref[src];refill=1'>[setting_refill ? "Yes" : "No"]</a><br>
			Fertilizer Controls:<br>
			Fertilize Plants: <a href='?src=\ref[src];fertilize=1'>[setting_fertilize ? "Yes" : "No"]</a><br>
			Weeding Controls:<br>
			Weed Plants: <a href='?src=\ref[src];weed=1'>[setting_weed ? "Yes" : "No"]</A><br>
			Ignore Weeds: <a href='?src=\ref[src];ignoreWeed=1'>[setting_ignoreWeeds ? "Yes" : "No"]</a><br>
			Ignore Mushrooms: <a href='?src=\ref[src];ignoreMush=1'>[setting_ignoreMushrooms ? "Yes" : "No"]</a><br>
			</tt>"})

	var/datum/browser/popup = new(user, "autofarm", "Automatic Hyrdoponic Assisting Unit v1.0")
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/bot/farmbot/Topic(href, href_list)
	..()

	if ((href_list["on"]) && (allowed(usr)))
		if(on)
			turn_off()
		else
			turn_on()

	else if((href_list["water"]) && (!locked))
		setting_water = !setting_water
	else if((href_list["refill"]) && (!locked))
		setting_refill = !setting_refill
	else if((href_list["fertilize"]) && (!locked))
		setting_fertilize = !setting_fertilize
	else if((href_list["weed"]) && (!locked))
		setting_weed = !setting_weed
	else if((href_list["ignoreWeed"]) && (!locked))
		setting_ignoreWeeds = !setting_ignoreWeeds
	else if((href_list["ignoreMush"]) && (!locked))
		setting_ignoreMushrooms = !setting_ignoreMushrooms
	else if (href_list["eject"] )

		usr << "<span class='notice'>You remove \the [beaker] from the [src].</span>"
		if(!usr.get_active_hand())
			usr.put_in_hands(beaker)
		else
			beaker.loc = get_turf(src)
		src.beaker = null

	updateUsrDialog()
	return

/obj/machinery/bot/farmbot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))
		if(allowed(user) && !emagged)
			locked = !src.locked
			user << "<span class='notice'>Controls are now [src.locked ? "locked." : "unlocked."]</span>"
			updateUsrDialog()
			return
		else
			user << "<span class='warning'>Access denied.</span>"
			return
		if(emagged)
			user << "<span class='warning'>ERROR</span>"
			return

	else if(istype(W, /obj/item/weapon/reagent_containers))
		if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/))
			if(!beaker)
				src.beaker = W
				user.drop_item()
				W.loc = src
				user << "<span class='notice'>You add the [W] to \the [src].</span>"
				updateUsrDialog()
				return
			else if(beaker)
				user << "<span class='warning'>[src] already has a [beaker]!</span>"
				return

	else if(istype(W, /obj/item/weapon/screwdriver)) //we have no wires to access
		return

	else if(istype(W, /obj/item/weapon/card/emag) && emagged) //prevent emagging emagged bot
		return

	else
		..()

/obj/machinery/bot/farmbot/Emag(mob/user as mob)
	..()
	if(user)
		user << "<span class='warning'>You short out [src]'s plant identifier circuits.</span>"
	spawn(0)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='warning'>[src] buzzes oddly!</span>", 1)
	flick("farmbot_broke", src)
	emagged = 1
	on = 1
	icon_state = "farmbot[on]"
	target = null
	mode = FARMBOT_MODE_WAITING //Give the emagger a chance to get away! 15 seconds should be good.
	spawn(150)
		mode = 0

/obj/machinery/bot/farmbot/explode()
	visible_message("<span class='boldannounce'>[src] blows apart!</span>", 1)
	var/turf/T = get_turf(src)

	if (tank)
		tank.loc = T

	if (prob(50))
		new /obj/item/robot_parts/l_arm(T)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	return ..()

/obj/machinery/bot/farmbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return

	if (emagged && prob(1))
		flick("farmbot_broke", src)

	if (mode == FARMBOT_MODE_WAITING)
		return

	if (!mode || !target || !(target in view(7,src))) //Don't bother chasing down targets out of view

		mode = 0
		target = null
		if (!find_target())
			// Couldn't find a target, wait a while before trying again.
			mode = FARMBOT_MODE_WAITING
			spawn(100)
				mode = 0
			return

	if (mode && target)
		if (get_dist(target,src) <= 1 || (emagged && mode == FARMBOT_MODE_FERTILIZE ))
			// If we are in emagged fertilize mode, we throw the fertilizer, so distance doesn't matter
			frustration = 0
			use_farmbot_item()
		else
			move_to_target()
	return

/obj/machinery/bot/farmbot/proc/use_farmbot_item()
	if (!target)
		mode = 0
		return 0

	if (emagged && !ismob(target)) // Humans are plants!
		mode = 0
		target = null
		return 0

	if (!emagged && !istype(target,/obj/machinery/hydroponics) && !istype(target,/obj/structure/sink)) // Humans are not plants!
		mode = 0
		target = null
		return 0

	if (mode == FARMBOT_MODE_FERTILIZE)
		fertilize()

	if (mode == FARMBOT_MODE_WEED)
		weed()

	if (mode == FARMBOT_MODE_WATER)
		water()

	if (mode == FARMBOT_MODE_REFILL)
		refill()

/obj/machinery/bot/farmbot/proc/find_target()
	if (emagged) //Find a human and help them!
		for (var/mob/living/carbon/human/human in view(7,src))
			if (human.stat == 2)
				continue

			var list/options = list(FARMBOT_MODE_WEED)
			if(beaker && beaker.reagents.total_volume)
				options.Add(FARMBOT_MODE_FERTILIZE)
			if(tank && tank.reagents.total_volume)
				options.Add(FARMBOT_MODE_WATER)
			mode = pick(options)
			target = human
			return mode
		return 0
	else
		if (setting_refill && tank && tank.reagents.total_volume < 100)
			for (var/obj/structure/sink/source in view(7,src))
				target = source
				mode = FARMBOT_MODE_REFILL
				return 1
		for (var/obj/machinery/hydroponics/tray in view(7,src))
			var newMode = GetNeededMode(tray)
			if (newMode)
				mode = newMode
				target = tray
				return 1
		return 0

/obj/machinery/bot/farmbot/proc/GetNeededMode(obj/machinery/hydroponics/tray)
	if (!tray.planted || tray.dead)
		return 0
	if (tray.myseed.plant_type == 1 && setting_ignoreWeeds)
		return 0
	if (tray.myseed.plant_type == 2 && setting_ignoreMushrooms)
		return 0

	if (setting_water && tray.waterlevel <= 10 && tank && tank.reagents.total_volume)
		return FARMBOT_MODE_WATER

	if (setting_weed && tray.weedlevel >= 3)
		return FARMBOT_MODE_WEED

	if (setting_fertilize && tray.nutrilevel <= 2 && beaker && beaker.reagents.total_volume)
		return FARMBOT_MODE_FERTILIZE

	return 0

/obj/machinery/bot/farmbot/proc/move_to_target()
	//Mostly copied from medibot code.

	if(frustration > 8)
		target = null
		mode = 0
		frustration = 0
		path = new()
	if(target && path && path.len && (get_dist(target, path[path.len]) > 2))
		src.path = new()
	if(target && path && (path.len == 0) && (get_dist(src, target) > 1))
		spawn(0)
			var/turf/dest = get_step_towards(target, src)  //Can't pathfind to a tray, as it is dense, so pathfind to the spot next to the tray

			path = AStar(loc, dest, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30,id=botcard)
			if(src.path.len == 0)
				for ( var/turf/spot in orange(1,target) ) //The closest one is unpathable, try  the other spots
					if (spot == dest) //We already tried this spot
						continue
					if (spot.density)
						continue
					path = AStar(src.loc, spot, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30,id=botcard)
					path = reverseRange(src.path)
					if (src.path.len > 0)
						break

				if (path.len == 0)
					target = null
					mode = 0
		return

	if(path.len > 0 && target)
		step_to(src, path[1])
		path -= path[1]
		spawn(3)
			if(src.path.len)
				step_to(src, path[1])
				path -= path[1]

	if(path.len > 8 && target)
		frustration++


/obj/machinery/bot/farmbot/proc/fertilize()
	if (!beaker || !beaker.reagents.total_volume)
		target = null
		mode = 0
		return 0

	if (emagged) // Warning, hungry humans detected: throw fertilizer at them
		spawn(0)
			if(beaker)
				beaker.reagents.reaction(target, TOUCH)
				beaker.reagents.clear_reagents()
				visible_message("<span class='warning'>[src] launches solution at [target.name]!</span>")
				flick("farmbot_broke", src)
				spawn (FARMBOT_EMAG_DELAY)
					mode = 0
					target = null
				return 1

	// feed them plants~
	var/obj/machinery/hydroponics/tray = target
	if(beaker && tray)
		if(tray.nutrilevel < 3)
			var/datum/reagents/S = new /datum/reagents()
			var/amount = tray.maxnutri - tray.nutrilevel
			beaker.reagents.trans_to(S, amount)
			S.my_atom = tray
			tray.applyChemicals(S)
			visible_message("<span class='notice'>[src] transfers [amount] units of solution to [tray].</span>")
			S.clear_reagents()
			qdel(S)
			tray.update_icon()
			icon_state = "farmbot_fertile"
			mode = FARMBOT_MODE_WAITING

			spawn (FARMBOT_ACTION_DELAY)
				mode = 0
				target = null
			spawn (FARMBOT_ANIMATION_TIME)
				icon_state = "farmbot[src.on]"
			return 1

/obj/machinery/bot/farmbot/proc/weed()
	if(emagged) // Warning, humans infested with weeds!
		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_EMAG_DELAY)
			mode = 0

		if(prob(50)) // better luck next time little guy
			visible_message("<span class='boldannounce'>[src] swings wildly at [target] with a cultivator, missing completely!</span>")

		else // yayyy take that weeds~
			var /mob/living/carbon/human/human = target
			var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
			var/obj/item/organ/limb/affecting = human.get_organ(ran_zone(dam_zone))
			var/armor = human.run_armor_check(affecting, "melee")
			human.apply_damage(5, BRUTE, affecting, armor)

			visible_message("<span class='boldannounce'>[src] has sliced [human] in the [dam_zone] with cultivator!</span>")
			playsound(src.loc, 'sound/weapons/slice.ogg', 75, 1)
			flick("farmbot_hoe", 1)
			update_icon()

	else // warning, plants infested with weeds!
		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_ACTION_DELAY)
			mode = 0

		var/obj/machinery/hydroponics/tray = target
		visible_message("<span class='notice'>[src] starts removing weeds from [target].</span>")
		flick("farmbot_hoe", 1)
		spawn(50)
			tray.weedlevel = 0
			tray.update_icon()
			visible_message("<span class='notice'>[src] completely removed weeds from [target].</span>")
			mode = 0
			update_icon()

/obj/machinery/bot/farmbot/proc/water()
	if (!tank || !tank.reagents.total_volume)
		mode = 0
		target = null
		return 0

	icon_state = "farmbot_water"
	spawn(FARMBOT_ANIMATION_TIME)
		icon_state = "farmbot[on]"

	if (emagged) // warning, humans are thirsty!
		var splashAmount = min(70,tank.reagents.total_volume)
		visible_message("<span class='warning'>[src] splashes [target] with a bucket of water!</span>")
		playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)
		if (prob(50))
			tank.reagents.reaction(target, TOUCH) //splash the human!
		else
			tank.reagents.reaction(target.loc, TOUCH) //splash the human's roots!
		spawn(5)
			tank.reagents.remove_any(splashAmount)

		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_EMAG_DELAY)
			mode = 0
	else
		var /obj/machinery/hydroponics/tray = target
		var/water_amount = tank.reagents.get_reagent_amount("water")
		if(water_amount > 0 && tray.waterlevel < 100)
			if(water_amount + tray.waterlevel > 100)
				water_amount = 100 - tray.waterlevel
			tank.reagents.remove_reagent("water", water_amount)
			tray.waterlevel += water_amount
			playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)

			// Toxicity dilutation code. The more water you put in, the lesser the toxin concentration.
			tray.toxic -= round(water_amount/4)
			if (tray.toxic < 0 ) // Make sure it won't go overboard
				tray.toxic = 0

		tray.update_icon()
		mode = FARMBOT_MODE_WAITING
		spawn(FARMBOT_ACTION_DELAY)
			mode = 0

/obj/machinery/bot/farmbot/proc/refill()
	if (!tank || !tank.reagents.total_volume > 600 || !istype(target,/obj/structure/sink))
		mode = 0
		target = null
		return

	mode = FARMBOT_MODE_WAITING
	playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)
	visible_message("<span class='notice'>[src] starts filling it's tank from [target].</span>")
	spawn(150)
		visible_message("<span class='notice'>[src] finishes filling it's tank.</span>")
		mode = 0
		tank.reagents.add_reagent("water", tank.reagents.maximum_volume - tank.reagents.total_volume)
		playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)

// Farmbot construction //

/obj/item/weapon/farmbot_arm_assembly
	name = "water tank/robot arm assembly"
	desc = "A water tank with a robot arm permanently grafted to it."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "water_arm"
	var/build_step = 0
	var/created_name = "Farmbot" //To preserve the name if it's a unique farmbot I guess
	w_class = 3.0

	New()
		..()
		spawn(4) // If an admin spawned it, it won't have a watertank it, so lets make one for em!
			if(!locate(/obj/structure/reagent_dispensers/watertank) in contents)
				new /obj/structure/reagent_dispensers/watertank(src)


/obj/structure/reagent_dispensers/watertank/attackby(var/obj/item/robot_parts/S, mob/user as mob)

	if ((!istype(S, /obj/item/robot_parts/l_arm)) && (!istype(S, /obj/item/robot_parts/r_arm)))
		..()
		return

	//Making a farmbot!

	var/obj/item/weapon/farmbot_arm_assembly/A = new /obj/item/weapon/farmbot_arm_assembly

	A.loc = src.loc
	user << "<span class='notice'>You add the robot arm to the [src]</span>"
	src.loc = A //Place the water tank into the assembly, it will be needed for the finished bot
	user.unEquip(S)
	qdel(S)

/obj/item/weapon/farmbot_arm_assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if((istype(W, /obj/item/device/analyzer/plant_analyzer)) && (!build_step))
		build_step++
		user << "<span class='notice'>You add the plant analyzer to [src].</span>"
		name = "farmbot assembly"
		user.unEquip(W)
		qdel(W)

	else if((istype(W, /obj/item/weapon/reagent_containers/glass/bucket)) && (build_step == 1))
		build_step++
		user << "<span class='notice'>You add a [W] to [src].</span>"
		name = "farmbot assembly with bucket"
		user.unEquip(W)
		qdel(W)

	else if((istype(W, /obj/item/weapon/cultivator)) && (build_step == 2))
		build_step++
		user << "<span class='notice'>You add a [W] to [src].</span>"
		name = "farmbot assembly with bucket and cultivator"
		user.unEquip(W)
		qdel(W)

	else if((isprox(W)) && (build_step == 3))
		build_step++
		user << "<span class='notice'>You complete the Farmbot! Beep boop.</span>"
		var/obj/machinery/bot/farmbot/S = new /obj/machinery/bot/farmbot
		for (var/obj/structure/reagent_dispensers/watertank/wTank in src.contents)
			wTank.loc = S
			S.tank = wTank
		S.loc = get_turf(src)
		S.name = src.created_name
		user.unEquip(W)
		qdel(W)
		qdel(src)

	else if(istype(W, /obj/item/weapon/pen))
		var/t = sanitize_russian(input(user, "Enter new robot name", src.name, src.created_name) as text)
		t = copytext(sanitize(t), 1, MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t

/obj/item/weapon/farmbot_arm_assembly/attack_hand(mob/user as mob)
	return //it's a converted watertank, no you cannot pick it up and put it in your backpack

#undef FARMBOT_MODE_WATER
#undef FARMBOT_MODE_FERTILIZE
#undef FARMBOT_MODE_WEED
#undef FARMBOT_MODE_REFILL
#undef FARMBOT_MODE_WAITING
#undef FARMBOT_ANIMATION_TIME
#undef FARMBOT_EMAG_DELAY
#undef FARMBOT_ACTION_DELAY
