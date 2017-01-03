/obj/machinery/power/port_gen/rtg
	name = "RITEG"
	desc = "Radioisotopic thermoelectric generator which uses the heat of decaying radioactive materials to produce power."
	icon = 'icons/obj/machines/rtg.dmi'
	icon_state = "rtg-closed"
	var/sheets = 0
	var/max_sheets = 20
	var/sheet_name = ""
	var/sheet_path = /obj/item/stack/sheet/mineral/uranium
	var/board_path = "/obj/item/weapon/circuitboard/rtg"
	var/halflife = 840
	var/cycle_time = 0
	active = TRUE
	var/switchable = FALSE
	power_gen = 0
	var/power_coeff = 0
	var/unsafe = FALSE

/obj/machinery/power/port_gen/rtg/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stack/cable_coil(src, 1)
	component_parts += new /obj/item/stack/cable_coil(src, 1)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new board_path(src)
	var/obj/sheet = new sheet_path(null)
	sheet_name = sheet.name
	RefreshParts()

/obj/machinery/power/port_gen/rtg/RefreshParts()
	var/temp_rating = 0
	max_sheets = 10
	switchable = FALSE
	for(var/obj/item/weapon/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/weapon/stock_parts/matter_bin))
			max_sheets += SP.rating * 5
			if(SP.rating >= 4)
				switchable = TRUE
		else if(istype(SP, /obj/item/weapon/stock_parts/capacitor))
			temp_rating += SP.rating
	power_coeff = temp_rating * 50


/obj/machinery/power/port_gen/rtg/initialize()
	..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/rtg/Destroy()
	DropFuel()
	..()

/obj/machinery/power/port_gen/rtg/examine(mob/user)
	..()
	user << "It is [anchored?"anchored":"unanchored"]."
	user << "<span class='notice'>The RITEG has [sheets] units of [sheet_name] fuel left, producing [power_gen] per cycle.</span>"
	if(!active) user << "<span class='notice'>Space-time bending is active.</span>"
	if(crit_fail) user << "<span class='danger'>The generator seems to have broken down.</span>"

/obj/machinery/power/port_gen/rtg/DropFuel()
	if(sheets)
		var/fail_safe = 0
		while(sheets > 0 && fail_safe < 100)
			fail_safe += 1
			var/obj/item/stack/sheet/S = new sheet_path(loc)
			var/amount = min(sheets, S.max_amount)
			S.amount = amount
			sheets -= amount
		if (!sheets)
			icon_state = "rtg-open-0"

/obj/machinery/power/port_gen/rtg/process()
	if(HasFuel())
		if(active || prob(25))
			UseFuel()

		if(active && HasFuel() && !crit_fail && anchored && powernet)
			add_avail(power_gen * power_output)

/obj/machinery/power/port_gen/rtg/UseFuel()
	if (sheets > 0)
		if (cycle_time < halflife)
			cycle_time += 1
		else
			cycle_time = 0
			sheets = round(sheets / 2)

		if(unsafe)
			if(prob(40))
				power_gen = round(sheets * power_coeff / 3)
			else
				power_gen = round(sheets * power_coeff / 2)
		else
			power_gen = sheets * power_coeff

		if (panel_open || unsafe)
			for(var/mob/living/l in range(3, src))
				l.irradiate(5 * sqrtTable[Clamp(sheets, 1, 100)])

/obj/machinery/power/port_gen/rtg/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	if(istype(O, sheet_path) && panel_open)
		var/obj/item/stack/addstack = O
		var/amount = min((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			user << "<span class='notice'>The [src.name] is full!</span>"
			return
		user << "<span class='notice'>You add [amount] sheets to the [src.name].</span>"
		sheets += amount
		addstack.use(amount)
		icon_state = "rtg-open-1"
		return

	if(exchange_parts(user, O))
		return

	if(istype(O, /obj/item/weapon/screwdriver))
		panel_open = !panel_open
		if (panel_open)
			user << "<span class='notice'>You open the panel of RITEG.</span>"
			if (sheets > 0)
				icon_state = "rtg-open-1"
			else
				icon_state = "rtg-open-0"
		else
			icon_state = "rtg-closed"
			user << "<span class='notice'>You close the panel of RITEG.</span>"

	else if(istype(O, /obj/item/weapon/wrench))
		if(!anchored && !isinspace())
			connect_to_network()
			user << "<span class='notice'>You secure the generator to the floor.</span>"
			anchored = 1
		else if(anchored)
			disconnect_from_network()
			user << "<span class='notice'>You unsecure the generator from the floor.</span>"
			anchored = 0

		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)

	if(istype(O, /obj/item/weapon/hexkey) && panel_open)
		playsound(loc, 'sound/items/Screwdriver.ogg', 10, 1)
		if(unsafe)
			user << "<span class='notice'>You plase radiation shielding back in it's place.</span>"
			unsafe = 0
		else
			user << "<span class='warning'>You loosen radiation shielding!</span>"
			unsafe = 1

	else if(istype(O, /obj/item/weapon/crowbar) && panel_open)
		default_deconstruction_crowbar(O)


/obj/machinery/power/port_gen/rtg/emag_act(mob/user as mob)
	if(!emagged)
		emagged = 1
		emp_act(1)

/obj/machinery/power/port_gen/rtg/attack_hand(mob/user as mob)
	..()
	if (sheets && panel_open)
		DropFuel()
	else if(!panel_open && switchable)
		if(active)
			user << "<span class='notice'>You enable space-time bending, sloving down radioactive decay of [sheet_name].</span>"
			active = 0
		else
			user << "<span class='notice'>You disable space-time bending.</span>"
			active = 1
