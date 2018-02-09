/obj/machinery/cell_charger
	name = "cell charger"
	desc = "It charges power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 60
	power_channel = EQUIP
	var/obj/item/weapon/stock_parts/cell/charging = null
	var/chargelevel = -1
	var/recharge_coeff = 1

/obj/machinery/cell_charger/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/cell_charger()
	component_parts += new /obj/item/weapon/stock_parts/capacitor()
	RefreshParts()

/obj/machinery/cell_charger/RefreshParts()
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		recharge_coeff = C.rating

/obj/machinery/cell_charger/proc/updateicon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(charging && !(stat & (BROKEN|NOPOWER)))
		var/newlevel = 	round(charging.percent() * 4 / 100)

		if(chargelevel != newlevel)
			chargelevel = newlevel

			overlays.Cut()
			overlays += "ccharger-o[newlevel]"

	else
		overlays.Cut()

/obj/machinery/cell_charger/examine(mob/user)
	..()
	user << "There's [charging ? "a" : "no"] cell in the charger."
	if(charging)
		user << "Current charge: [round(charging.percent(), 1)]%"


/obj/machinery/cell_charger/attackby(obj/item/weapon/G, mob/user, params)
	if(istype(G, /obj/item/weapon/wrench))
		if(charging)
			user << "<span class='warning'>Remove the cell first!</span>"
			return
		anchored = !anchored
		power_change()
		user << "<span class='notice'>You [anchored ? "attach" : "detach"] [src] [anchored ? "to" : "from"] the ground</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		return
	if(istype(user,/mob/living/silicon))
		return
	if(istype(G, /obj/item/weapon/stock_parts/cell) && anchored)
		if(istype(G, /obj/item/weapon/stock_parts/cell/peps))
			user << "<span class='warning'>You cannot recharge PEPS cells in this charger!</span>"
			return
		if(charging)
			user << "<span class='warning'>There is already a cell in the charger!</span>"
			return
		else
			var/area/a = loc.loc // Gets our locations location, like a dream within a dream
			if(!isarea(a) || a.power_equip == 0)
				user << "<span class='notice'>[src] blinks red as you try to insert [G].</span>"
				return

			if(!user.drop_item())
				return

			G.loc = src
			charging = G
			user.visible_message("[user] inserts a cell into the charger.", "<span class='notice'>You insert a cell into the charger.</span>")
			chargelevel = -1
			updateicon()

	if (anchored && !charging)
		if(default_deconstruction_screwdriver(user, "ccharger0", "ccharger0", G)) //change from ccharger0 to new sprite
			return

		if(panel_open && istype(G, /obj/item/weapon/crowbar))
			default_deconstruction_crowbar(G)
			return


/obj/machinery/cell_charger/proc/removecell()
	charging.updateicon()
	charging = null
	chargelevel = -1
	updateicon()

/obj/machinery/cell_charger/attack_hand(mob/user)
	if(issilicon(user))
		return

	add_fingerprint(user)
	if(charging)
		charging.loc = loc
		user.put_in_hands(charging)
		user.visible_message("[user] removes the cell from the charger.", "<span class='notice'>You remove the cell from the charger.</span>")
		removecell()

/obj/machinery/cell_charger/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/cell_charger/attack_tk(mob/user)
	if(!charging)
		return

	charging.loc = loc
	user << "<span class='notice'>You telekinetically remove [charging] from [src].</span>"

	removecell()

/obj/machinery/cell_charger/attack_ai(mob/user)
	return

/obj/machinery/cell_charger/power_change()
	..()
	update_icon()

/obj/machinery/cell_charger/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return

	if(charging)
		charging.emp_act(severity)

	..(severity)


/obj/machinery/cell_charger/process()
	if(stat & (NOPOWER|BROKEN) || !anchored || !charging)
		return

	if(charging.percent() >= 100)
		return

	use_power(CLAMP(200*recharge_coeff,200,800))		//this used to use CELLRATE, but CELLRATE is fucking awful. feel free to fix this properly!
	charging.give(CLAMP(200*recharge_coeff,200,800)*CLAMP(0.85+0.025*recharge_coeff,0.85,0.95))	//inefficiency.

	updateicon()
