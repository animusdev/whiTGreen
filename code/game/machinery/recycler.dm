var/const/SAFETY_COOLDOWN = 100

/obj/machinery/recycler
	name = "crusher"
	desc = "A large crushing machine which is used to recycle small items ineffeciently; there are lights on the side of it."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	layer = MOB_LAYER+1 // Overhead
	anchored = 1
	density = 1
	var/safety_mode = 0 // Temporality stops the machine if it detects a mob
	var/grinding = 0
	var/icon_name = "grinder-o"
	var/blood = 0
	var/eat_dir = WEST
	var/recycle_coeff
	var/recycle_rating
	var/max_recycle_chance = 25

/obj/machinery/recycler/New()
	// On us
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/recycler(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	//materials = new /datum/material_container(src, list(MAT_METAL=1, MAT_GLASS=1, MAT_PLASMA=1, MAT_SILVER=1, MAT_GOLD=1, MAT_DIAMOND=1, MAT_URANIUM=1, MAT_BANANIUM=1))
	RefreshParts()
	update_icon()

/obj/machinery/recycler/RefreshParts()
	var/generate_chance = 0
	var/material_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		generate_chance += B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		material_rating += M.rating
		generate_chance += max(0, M.rating - 2)
	recycle_coeff = max(1, generate_chance)
	recycle_rating = max(1, material_rating)

/obj/machinery/recycler/proc/trash_coeff(var/obj/item/I)

	if(istype(I, /obj/item/ammo_casing))
		return 0 //nope

	if(istype(I, /obj/item/weapon/reagent_containers/food/condiment) || istype(I, /obj/item/weapon/reagent_containers/glass/bottle))
		return 0

	if(istype(I, /obj/item/stack))
		return -1 //do not recycle this

	if (I.w_class <= 1.5)
		return 0.05
	else if (I.w_class <= 2.5)
		return 0.2
	else if (I.w_class <= 4.5)
		return 1
	else if (I.w_class <= 5.5)
		return 1.25
	else if (I.w_class <= 6.5)
		return 1.75

	return 1 //sanity check

/obj/machinery/recycler/examine(mob/user)
	..()
	user << "The power light is [(stat & NOPOWER) ? "off" : "on"]."
	user << "The safety-mode light is [safety_mode ? "on" : "off"]."
	user << "The safety-sensors status light is [emagged ? "off" : "on"]."

/obj/machinery/recycler/power_change()
	..()
	update_icon()


/obj/machinery/recycler/attackby(var/obj/item/I, var/mob/user, params)
	if(default_deconstruction_screwdriver(user, "grinder-oOpen", "grinder-o1", I))
		return

	if(exchange_parts(user, I))
		return

	if(default_pry_open(I))
		return

	if(default_unfasten_wrench(user, I))
		return

	default_deconstruction_crowbar(I)
	..()

	/*
	if(istype(I, /obj/item/weapon/screwdriver))
		if(emagged)
			emagged = 0
			update_icon()
			user << "<span class='notice'>You reset the crusher to its default factory settings.</span>"
	else
		..()
		return
	*/

	add_fingerprint(user)
	return

/obj/machinery/recycler/emag_act(user as mob)
	if(!emagged)
		emagged = 1
		if(safety_mode)
			safety_mode = 0
			update_icon()
		playsound(src.loc, "sparks", 75, 1, -1)
		user << "<span class='notice'>You use the cryptographic sequencer on the [src.name].</span>"

/obj/machinery/recycler/update_icon()
	..()
	var/is_powered = !(stat & (BROKEN|NOPOWER))
	if(safety_mode)
		is_powered = 0
	icon_state = icon_name + "[is_powered]" + "[(blood ? "bld" : "")]" // add the blood tag at the end

// This is purely for admin possession !FUN!.
/obj/machinery/recycler/Bump(var/atom/movable/AM)
	..()
	if(AM)
		Bumped(AM)


/obj/machinery/recycler/Bumped(var/atom/movable/AM)

	if(stat & (BROKEN|NOPOWER))
		return
	if(safety_mode)
		return
	// If we're not already grinding something.
	if(!grinding)
		grinding = 1
		spawn(1)
			grinding = 0
	else
		return

	var/move_dir = get_dir(loc, AM.loc)
	if(move_dir == eat_dir)
		if(isliving(AM))
			if(emagged)
				eat(AM)
			else
				stop(AM)
		else if(istype(AM, /obj/item))
			recycle(AM, trash_coeff(AM))
		else // Can't recycle
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			AM.loc = src.loc

/obj/machinery/recycler/proc/recycle(var/obj/item/I, var/trash_coeff, var/sound = 1)
	I.loc = src.loc

	if(trash_coeff < 0)
		return

	qdel(I)
	if(recycle_rating >= 1)
		if(prob(Clamp(round(10 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
			new /obj/item/stack/sheet/metal(loc)
		if(prob(Clamp(round(8 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
			new /obj/item/stack/sheet/glass(loc)
		if(recycle_rating >= 2)
			if(prob(Clamp(round(6 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
				new /obj/item/stack/sheet/plasteel(loc)
			if(prob(Clamp(round(4 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
				new /obj/item/stack/sheet/rglass(loc)
			if(recycle_rating >= 3)
				if(prob(Clamp(round(2 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
					new /obj/item/stack/sheet/mineral/gold(loc)
				if(prob(Clamp(round(2 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
					new /obj/item/stack/sheet/mineral/silver(loc)
				if(prob(Clamp(round(1 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
					new /obj/item/stack/sheet/mineral/plasma(loc)
				if(recycle_rating >= 4)
					if(prob(Clamp(round(0.5 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
						new /obj/item/stack/sheet/mineral/diamond(loc)
					if(prob(Clamp(round(0.25 * recycle_coeff * trash_coeff), 0, max_recycle_chance)))
						new /obj/item/stack/sheet/mineral/uranium(loc)
	if(sound)
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)


/obj/machinery/recycler/proc/stop(var/mob/living/L)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	safety_mode = 1
	update_icon()
	L.loc = src.loc

	spawn(SAFETY_COOLDOWN)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
		safety_mode = 0
		update_icon()

/obj/machinery/recycler/proc/eat(var/mob/living/L)

	L.loc = src.loc

	if(issilicon(L))
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)

	var/gib = 1
	// By default, the emagged recycler will gib all non-carbons. (human simple animal mobs don't count)
	if(iscarbon(L))
		gib = 0
		if(L.stat == CONSCIOUS)
			L.say("ARRRRRRRRRRRGH!!!")
		add_blood(L)

	if(!blood && !issilicon(L))
		blood = 1
		update_icon()

	// Remove and recycle the equipped items.
	for(var/obj/item/I in L.get_equipped_items())
		if(L.unEquip(I))
			recycle(I, 0)

	// Instantly lie down, also go unconscious from the pain, before you die.
	L.Paralyse(5)

	// For admin fun, var edit emagged to 2.
	if(gib || emagged == 1)
		L.gib()
	// Grief protection removed

/obj/item/weapon/paper/recycler
	name = "paper - 'garbage duty instructions'"
	info = "<h2>New Assignment</h2> You have been assigned to collect garbage from trash bins, located around the station. The crewmembers will put their trash into it and you will collect the said trash.<br><br>There is a recycling machine near your closet, inside maintenance; use it to recycle the trash for a small chance to get useful minerals. Then deliver these minerals to cargo or engineering. You are our last hope for a clean station, do not screw this up!"