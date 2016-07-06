/obj/machinery/stove
	name = "stove"
	desc = "An old ways to grill your meat."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "stove_closed"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 0
	idle_power_usage = 0
	var/ignition = FALSE
	var/opened = FALSE
	var/fuel = 0
	var/ash = 0
	var/max_capasity = 15000
	var/brightness = 0
	var/ignition_chance = 0
	var/cooking = 0
	var/cooking_space = 3

/obj/machinery/stove/proc/updateicon()
	if(opened)
		if(fuel <= 0)
			icon_state = "stove_empty"
		else if (ignition)
			icon_state = "stove_ingited"
		else
			icon_state = "stove_full"
	else
		icon_state = "stove_closed"

/obj/machinery/stove/proc/fuel_capasity()
	return max(0, max_capasity - ash)

/obj/machinery/stove/proc/fuel_fill_stage(stage)
	if(stage == 0)
		return 0
	else if (stage == 1)
		return fuel_capasity() / 30
	else if (stage == 2)
		return fuel_capasity() / 10
	else if (stage == 3)
		return fuel_capasity() / 2
	else if (stage == 4)
		return (fuel_capasity() / 5) * 4
	else if (stage == 5)
		return (fuel_capasity() / 10) * 9
	else if (stage == 6)
		return (fuel_capasity() / 30) * 29
	else if (stage == 7)
		return fuel_capasity()
	else
		return -1

/obj/machinery/stove/proc/get_birnspeed()
	if(fuel < fuel_fill_stage(1))
		return 1
	else if(fuel < fuel_fill_stage(2))
		return 7
	else if(fuel < fuel_fill_stage(3))
		return 8
	else if(fuel < fuel_fill_stage(4))
		return 12
	else if(fuel < fuel_fill_stage(5))
		return 16
	else if(fuel < fuel_fill_stage(6))
		return 20
	else
		return 2

/obj/machinery/stove/proc/get_brightness()
	if(!ignition)
		return 0
	if(fuel < fuel_fill_stage(1))
		return 1
	else if(fuel < fuel_fill_stage(4))
		return 6
	else if(fuel < fuel_fill_stage(6))
		return 8
	else
		return 2

/obj/machinery/stove/proc/get_smokechanse()
	if(ash < max_capasity / 30)
		if(fuel < fuel_fill_stage(1))
			return 0
		else if(fuel < fuel_fill_stage(6))
			return 10
		else
			return 25
	else if(ash < max_capasity / 10)
		if(fuel < fuel_fill_stage(1))
			return 0
		else if(fuel < fuel_fill_stage(5))
			return 10
		else if(fuel < fuel_fill_stage(6))
			return 15
		else
			return 40
	else if(ash < max_capasity / 2)
		if(fuel < fuel_fill_stage(1))
			return 0
		else if(fuel < fuel_fill_stage(4))
			return 10
		else if(fuel < fuel_fill_stage(6))
			return 15
		else
			return 60
	else if(ash < (max_capasity / 4) * 3)
		if(fuel < fuel_fill_stage(1))
			return 5
		else if(fuel < fuel_fill_stage(4))
			return 15
		else if(fuel < fuel_fill_stage(6))
			return 25
		else
			return 60
	else if (ash < (max_capasity / 10) * 9)
		if(fuel < fuel_fill_stage(1))
			return 10
		else if(fuel < fuel_fill_stage(4))
			return 20
		else if(fuel < fuel_fill_stage(6))
			return 50
		else
			return 100

/obj/machinery/stove/Deconstruct()
	if(!loc) //if already qdel'd somehow, we do nothing
		return
	var/obj/item/stack/sheet/metal/stored = new/obj/item/stack/sheet/metal(loc)
	stored.amount = 10
	..()

/obj/machinery/stove/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/stove/attack_ai(mob/user as mob)
	return 0

/obj/machinery/stove/attack_hand(mob/user as mob)
	if (opened)
		user.visible_message( \
			"[user] has closed [src].", \
			"<span class='notice'>You close [src].</span>")
		opened = FALSE
		src.updateicon()
		return
	else
		user.visible_message( \
			"[user] has opened [src].", \
			"<span class='notice'>You open [src].</span>")
		opened = TRUE
		src.updateicon()
		return

/obj/machinery/stove/attackby(obj/item/I, mob/user)
	if(opened)
		//ignite stove
		if(is_hot(I) > 0)
			if(fuel > 0)
				if(ignition)
					user << "<span class='notice'>[src] is already lit.</span>"
				else if(!anchored)
					user << "<span class='notice'>You can not lit [src] while it`s unfastened.</span>"
				else
					if(do_after(user, 50))
						if(prob(Clamp(50 + ignition_chance, 5, 100)))
							ignition_chance = 0
							ignition = TRUE
							src.updateicon()
							user.visible_message( \
								"[user] lights up [src].", \
								"<span class='notice'>You lights up [src].</span>")
						else
							user.visible_message( \
								"[user] fail to light up [src].", \
								"<span class='notice'>You fail to light up [src].</span>")
			else
				user << "<span class='notice'>[src] has no fuel in it.</span>"
		//ignite item
		if(ignition)
			I.fire_act()
		//add fuel
		if(istype(I, /obj/item/stack/sheet/mineral/wood))
			var/obj/item/stack/St = I
			if (fuel + 1000 < fuel_capasity())
				if (St.use(1))  //sanyty check
					fuel = fuel + 1000
					src.updateicon()
					user.visible_message( \
						"[user] add [St] to the [src].", \
						"<span class='notice'>You add [St] to the [src].</span>")
			else
				user << "<span class='notice'>There not enogh spase for [St] in the [src].</span>"
			return
		if(istype(I, /obj/item/stack/sheet/cardboard))
			var/obj/item/stack/St = I
			if (fuel + 75 < fuel_capasity())
				if (St.use(1))  //sanyty check
					fuel = fuel + 75
					ignition_chance += 3
					src.updateicon()
					user.visible_message( \
						"[user] add [St] to the [src].", \
						"<span class='notice'>You add [St] to the [src].</span>")
			else
				user << "<span class='notice'>There not enogh spase for [St] in the [src].</span>"
			return
		if(istype(I, /obj/item/stack/sheet/cloth))
			var/obj/item/stack/St = I
			if (fuel + 300 < fuel_capasity())
				if (St.use(1))  //sanyty check
					fuel = fuel + 300
					ignition_chance += 10
					src.updateicon()
					user.visible_message( \
						"[user] add [St] to the [src].", \
						"<span class='notice'>You add [St] to the [src].</span>")
			else
				user << "<span class='notice'>There not enogh spase for [St] in the [src].</span>"
			return
		if(istype(I, /obj/item/stack/tile/wood))
			var/obj/item/stack/St = I
			if (fuel + 250 < fuel_capasity())
				if (St.use(1))  //sanyty check
					fuel = fuel + 250
					src.updateicon()
					user.visible_message( \
						"[user] add [St] to the [src].", \
						"<span class='notice'>You add [St] to the [src].</span>")
			else
				user << "<span class='notice'>There not enogh spase for [St] in the [src].</span>"
			return
		if(istype(I, /obj/item/stack/tile/carpet))
			var/obj/item/stack/St = I
			if (fuel + 100 < fuel_capasity())
				if (St.use(1))  //sanyty check
					fuel = fuel + 100
					src.updateicon()
					user.visible_message( \
						"[user] add [St] to the [src].", \
						"<span class='notice'>You add [St] to the [src].</span>")
			else
				user << "<span class='notice'>There not enogh spase for [St] in the [src].</span>"
			return
		if(istype(I, /obj/item/stack/tile/grass))
			var/obj/item/stack/St = I
			if (fuel + 50 < fuel_capasity())
				if (St.use(1))  //sanyty check
					fuel = fuel + 50
					ignition_chance -= 2
					src.updateicon()
					user.visible_message( \
						"[user] add [St] to the [src].", \
						"<span class='notice'>You add [St] to the [src].</span>")
			else
				user << "<span class='notice'>There not enogh spase for [St] in the [src].</span>"
			return
		else if(istype(I, /obj/item/weapon/grown/log))
			var/obj/item/weapon/grown/L = I
			if (fuel + 1000 + L.potency * 40 < fuel_capasity())
				fuel = fuel + 1000 + L.potency * 40
				ignition_chance -= 1
				src.updateicon()
				user.visible_message( \
					"[user] add [L] to the [src].", \
					"<span class='notice'>You add [L] to the [src].</span>")
				user.drop_item()
				qdel(L)
			else
				user << "<span class='notice'>There not enogh spase for [L] in the [src].</span>"
			return
		else if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/carpet))
			var/obj/item/weapon/reagent_containers/food/snacks/grown/L = I
			if (fuel + 100 + L.potency * 2 < fuel_capasity())
				fuel = fuel + 100 + L.potency * 2
				if(!L.dry)
					ignition_chance -= 3
				src.updateicon()
				user.visible_message( \
					"[user] add [L] to the [src].", \
					"<span class='notice'>You add [L] to the [src].</span>")
				user.drop_item()
				qdel(L)
			else
				user << "<span class='notice'>There not enogh spase for [L] in the [src].</span>"
			return
		else if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown/grass))
			var/obj/item/weapon/reagent_containers/food/snacks/grown/L = I
			if (fuel + 50 + L.potency < fuel_capasity())
				fuel = fuel + 50 + L.potency
				if(!L.dry)
					ignition_chance -= 10
				else
					ignition_chance += 5
				src.updateicon()
				user.visible_message( \
					"[user] add [L] to the [src].", \
					"<span class='notice'>You add [L] to the [src].</span>")
				user.drop_item()
				qdel(L)
			else
				user << "<span class='notice'>There not enogh spase for [L] in the [src].</span>"
			return
		else if(istype(I, /obj/item/weapon/paper))
			if (fuel + 50 < fuel_capasity())
				fuel = fuel + 50
				ignition_chance += 15
				src.updateicon()
				user.visible_message( \
					"[user] add [I] to the [src].", \
					"<span class='notice'>You add [I] to the [src].</span>")
				user.drop_item()
				qdel(I)
			else
				user << "<span class='notice'>There not enogh spase for [I] in the [src].</span>"
			return
		else if(istype(I, /obj/item/weapon/contraband/poster))
			if (fuel + 75 < fuel_capasity())
				fuel = fuel + 75
				ignition_chance += 5
				src.updateicon()
				user.visible_message( \
					"[user] add [I] to the [src].", \
					"<span class='notice'>You add [I] to the [src].</span>")
				user.drop_item()
				qdel(I)
			else
				user << "<span class='notice'>There not enogh spase for [I] in the [src].</span>"
			return
		else if(istype(I, /obj/item/weapon/coin/plasma))
			if (fuel + 1000 < fuel_capasity())
				if (fuel + 5000 > fuel_capasity() | fuel + 3000 > fuel_fill_stage(6) )
					var/coin_use = alert(user, "You feel this may be waste of [I].", "Put [I] in [src]?", "Put it in", "Hold it")
					if(coin_use == "Hold it" || !in_range(src, user) || !src || !I || user.incapacitated())
						return
				fuel = min(fuel_fill_stage(6), fuel + 15000)
				ignition_chance += 9001
				src.updateicon()
				user.visible_message( \
					"[user] add [I] to the [src].", \
					"<span class='notice'>You add [I] to the [src].</span>")
				user.drop_item()
				qdel(I)
			else
				user << "<span class='notice'>There sure not enogh spase for [I] in the [src].</span>"
			return
		//maininstance
		else if(istype(I, /obj/item/weapon/crowbar) || istype(I, /obj/item/weapon/kitchen/fork) || istype(I, /obj/item/weapon/reagent_containers/glass/rag))
			if(ash <= 0)
				user << "<span class='notice'>[src] is already clean.</span>"
			else
				user.visible_message( \
					"[user] start cleaning [src].", \
					"<span class='notice'>You start cleaning [src].</span>")
				while (ash > 0)
					if (do_after(user, 10))
						if (ash > 500)
							if(prob(50))
								new	/obj/effect/decal/cleanable/ash(loc)
						ash = max(0, ash - 500)
					else
						break
				if(ash <= 1)
					user.visible_message( \
						"[user] finish cleaning [src].", \
						"<span class='notice'>You finish cleaning [src].</span>")
			return
		else if((istype(I, /obj/item/weapon/wrench)) && (istype(loc, /turf/simulated) || anchored))
			if(ignition)
				user << "<span class='notice'>You can not unfasten [src] while it`s ignited.</span>"
			else
				playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = !anchored
				user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] [src].</span>", \
									 "<span class='notice'>You [anchored ? "fasten [src] to" : "unfasten [src] from"] the floor.</span>")
			return
		else if(istype(I, /obj/item/weapon/screwdriver))
			if(fuel > 0 || ash > 0)
				user << "<span class='notice'>[src] must be empty to disasemble.</span>"
				return
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			if (do_after(user, 50))
				Deconstruct()
			return
	else
		//grill some meat
		if(cooking >= cooking_space)
			user << "<span class='notice'>There no more spase on [src] for grilling.</span>"
			return
		if(istype(I, /obj/item/weapon/grab)||istype(I, /obj/item/tk_grab))
			user << "<span class='warning'>That isn't going to fit.</span>"
			return
		if(!ignition)
			user << "<span class='warning'>Start a flame first.</span>"
			return
		else
			user << "<span class='notice'>You put [I] onto [src].</span>"
			cooking += 1
			user.drop_item()
			I.loc = src

			var/image/img = new(I.icon, I.icon_state)
			img.pixel_y = 5
			sleep(round(4000/get_birnspeed()))
			img.color = "#C28566"
			sleep(round(4000/get_birnspeed()))
			img.color = "#A34719"
			sleep(round(100/get_birnspeed()))

			cooking -= 1

			if(istype(I, /obj/item/weapon/reagent_containers/))
				var/obj/item/weapon/reagent_containers/food = I
				food.reagents.add_reagent("nutriment", 10)
				food.reagents.trans_to(I, food.reagents.total_volume)
			I.loc = get_turf(src)
			I.color = "#A34719"
			var/tempname = I.name
			I.name = "grilled [tempname]"



obj/machinery/stove/process()
	if(fuel <= 0)
		ignition = FALSE
		src.updateicon()
	if(ignition)
		if(prob(2))
			if(prob(src.get_smokechanse()))
				new /obj/effect/effect/chem_smoke(loc)
		if(prob(33))
			ash = min(max_capasity, ash + src.get_birnspeed())
		fuel = max(0, fuel - src.get_birnspeed())
		if(src.get_brightness() != src.brightness)
			src.brightness = src.get_brightness()
			SetLuminosity(src.brightness)
	return
