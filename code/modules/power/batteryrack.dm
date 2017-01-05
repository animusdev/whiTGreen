/obj/item/weapon/circuitboard/batteryrack
	name = "circuitboard (battery rack PSU)"
	build_path = /obj/machinery/power/smes/batteryrack
	board_type = "machine"
	origin_tech = "powerstorage=1"
	req_components = list(/obj/item/weapon/stock_parts/cell = 3)

/*/datum/design/batteryrack
	name = "Machine Design (Battery Rack Board)"
	desc = "The circuit board for a battery rack PSU."
	id = "batteryrack"
	req_tech = list("powerstorage" = 3, "engineering" = 2)
	build_type = IMPRINTER
	materials = list("$glass" = 1000, "sacid" = 20)
	build_path = /obj/item/weapon/circuitboard/batteryrack
	category = list ("Engineering Machinery")
	//nope
*/
/datum/table_recipe/batteryrack
	name = "batteryrack circitboard"
	result = /obj/item/weapon/circuitboard/batteryrack
	reqs = list(/obj/item/weapon/module/power_control = 1,
				/obj/item/stack/cable_coil = 3,
				/obj/item/weapon/shard = 1,)
	tools = list(/obj/item/weapon/wirecutters,
				/obj/item/weapon/screwdriver)
	time = 50

/obj/machinery/power/smes/batteryrack
	name = "power cell rack PSU"
	desc = "A rack of power cells working as a PSU."
	charge = 0 //you dont really want to make a potato PSU which already is overloaded
	output_attempt = 0
	input_level = 0
	output_level = 0
	input_level_max = 0
	output_level_max = 0
	icon_state = "gsmes"
	var/cells_amount = 0
	var/capacitors_amount = 0
	var/global/list/br_cache = null

/obj/machinery/power/smes/batteryrack/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/batteryrack
	component_parts += new /obj/item/weapon/stock_parts/cell/high
	component_parts += new /obj/item/weapon/stock_parts/cell/high
	component_parts += new /obj/item/weapon/stock_parts/cell/high
	RefreshParts()
	return

/obj/machinery/power/smes/batteryrack/RefreshParts()
	capacitors_amount = 0
	cells_amount = 0
	var/max_level = 0 //for both input and output
	for(var/obj/item/weapon/stock_parts/capacitor/CP in component_parts)
		max_level += CP.rating
		capacitors_amount++
	input_level_max = 50000 + max_level * 20000
	output_level_max = 50000 + max_level * 20000

	var/C = 0
	for(var/obj/item/weapon/stock_parts/cell/PC in component_parts)
		C += PC.maxcharge
		cells_amount++
	capacity = C * 40   //Basic cells are such crap. Hyper cells needed to get on normal SMES levels.


/obj/machinery/power/smes/batteryrack/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	if(!br_cache)
		br_cache = list()
		br_cache.len = 7
		br_cache[1] = image('icons/obj/power.dmi', "gsmes_outputting")
		br_cache[2] = image('icons/obj/power.dmi', "gsmes_charging")
		br_cache[3] = image('icons/obj/power.dmi', "gsmes_overcharge")
		br_cache[4] = image('icons/obj/power.dmi', "gsmes_og1")
		br_cache[5] = image('icons/obj/power.dmi', "gsmes_og2")
		br_cache[6] = image('icons/obj/power.dmi', "gsmes_og3")
		br_cache[7] = image('icons/obj/power.dmi', "gsmes_og4")

	if (output_attempt)
		overlays += br_cache[1]
	if(inputting)
		overlays += br_cache[2]

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += br_cache[3+clevel]
	return


/obj/machinery/power/smes/batteryrack/chargedisplay()
	return round(4 * charge/(capacity ? capacity : 5e6))


/obj/machinery/power/smes/batteryrack/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob) //these can only be moved by being reconstructed, solves having to remake the powernet.
	..() //SMES attackby for now handles screwdriver, cable coils and wirecutters, no need to repeat that here
	if(panel_open)
		if(istype(W, /obj/item/weapon/crowbar))
			if (charge < (capacity / 100))
				if (!output_attempt && !input_attempt)
					playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
					var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
					M.state = 2
					M.icon_state = "box_1"
					for(var/obj/item/I in component_parts)
						if(I.reliability != 100 && crit_fail)
							I.crit_fail = 1
						I.loc = src.loc
					qdel(src)
					return 1
				else
					user << "<span class='warning'>Turn off the [src] before dismantling it.</span>"
			else
				user << "<span class='warning'>Better let [src] discharge before dismantling it.</span>"
		else if ((istype(W, /obj/item/weapon/stock_parts/capacitor) && (capacitors_amount < 5)) || (istype(W, /obj/item/weapon/stock_parts/cell) && (cells_amount < 5)))
			if (charge < (capacity / 100))
				if (!output_attempt && !input_attempt)
					user.drop_item()
					component_parts += W
					W.loc = src
					RefreshParts()
					user << "<span class='notice'>You upgrade the [src] with [W.name].</span>"
				else
					user << "<span class='warning'>Turn off the [src] before dismantling it.</span>"
			else
				user << "<span class='warning'>Better let [src] discharge before putting your hand inside it.</span>"
		else
			user.set_machine(src)
			interact(user)
			return 1
	return
