/obj/machinery/power/port_gen/rtg
	name = "RITEG"
	desc = "Radioisotopic thermoelectric generator which uses the heat of decaying radioactive materials to produce power."
	icon = 'icons/obj/machines/rtg.dmi'
	icon_state = "rtg-closed"
	var/sheets = 0
	var/max_sheets = 20
	var/sheet_name = ""
	var/sheet_path = /obj/item/stack/sheet/mineral/uranium
	var/halflife = 840
	active = 1
	power_gen = 0
/obj/machinery/power/port_gen/rtg/initialize()
	..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/rtg/New()
	..()
	var/obj/sheet = new sheet_path(null)
	sheet_name = sheet.name

/obj/machinery/power/port_gen/rtg/Destroy()
	DropFuel()
	..()

/obj/machinery/power/port_gen/rtg/examine(mob/user)
	..()
	user << "It is [anchored?"anchored":"unanchored"]."
	user << "<span class='notice'>The RITEG has [sheets] units of [sheet_name] fuel left, producing [power_gen] per cycle.</span>"
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
	if(active && HasFuel() && !crit_fail && anchored && powernet)
		add_avail(power_gen * power_output)
		UseFuel()

/obj/machinery/power/port_gen/rtg/UseFuel()
	if (sheets > 0)
		if (halflife > 0)
			halflife -= 1
		else
			halflife = 840
			sheets = round(sheets / 2)

		power_gen = sheets * 100

	if (panel_open && sheets > 0)
		for(var/mob/living/l in range(3))
			l.irradiate(5)

/obj/machinery/power/port_gen/rtg/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
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

	else if(istype(O, sheet_path) && panel_open)
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

/obj/machinery/power/port_gen/rtg/emag_act(mob/user as mob)
	if(!emagged)
		emagged = 1
		emp_act(1)

/obj/machinery/power/port_gen/rtg/attack_hand(mob/user as mob)
	..()
	if (sheets && panel_open)
		DropFuel()