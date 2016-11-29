/datum/data/vending_product
	var/product_name = "generic"
	var/product_path = null
	var/amount = 0
	var/max_amount = 0
	var/display_color = "blue"


/obj/machinery/vending
	name = "\improper Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = 2.9
	anchored = 1
	density = 1
	verb_say = "оповещает"
	verb_engsay = "alerts"
	verb_ask = "оповещает"
	verb_exclaim = "оповещает"
	var/active = 1		//No sales pitches if off!
	var/vend_ready = 1	//Are we ready to vend?? Is it time??
	var/vend_delay = 10	//How long does it take to vend?

	// To be filled out at compile time
	var/list/products	= list()	//For each, use the following pattern:
	var/list/contraband	= list()	//list(/type/path = amount,/type/path2 = amount2)
	var/list/premium 	= list()	//No specified amount = only one in stock

	var/product_slogans = ""	//String of slogans separated by semicolons, optional
	var/product_ads = ""		//String of small ad messages in the vending screen - random chance
	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/coin_records = list()
	var/list/slogan_list = list()
	var/list/small_ads = list()	//Small ad messages in the vending screen - random chance of popping up whenever you open it
	var/vend_reply				//Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0			//When did we last pitch?
	var/slogan_delay = 6000		//How long until we can pitch again?
	var/icon_vend				//Icon_state when vending!
	var/icon_deny				//Icon_state when vending!
	var/shockedby = list()		//List of mobs who electrified this vendomat
	var/seconds_electrified = 0	//Shock customers like an airlock.
	var/shoot_inventory = 0		//Fire items at customers! We're broken!
	var/shut_up = 0				//Stop spouting those godawful pitches!
	var/extended_inventory = 0	//can we access the hidden inventory?
	var/scan_id = 1
	var/obj/item/weapon/coin/coin
	var/datum/wires/vending/wires = null

	var/dish_quants = list()  //used by the snack machine's custom compartment to count dishes.

	var/obj/item/weapon/vending_refill/refill_canister = null		//The type of refill canisters used by this machine.

/obj/machinery/vending/New()
	..()
	wires = new(src)
	if(refill_canister) //constructable vending machine
		component_parts = list()
		var/obj/item/weapon/circuitboard/vendor/V = new(null)
		V.set_type(type)
		component_parts += V
		component_parts += new refill_canister
		component_parts += new refill_canister
		component_parts += new refill_canister
		RefreshParts()
	else
		build_inventory(products)
		build_inventory(contraband, 1)
		build_inventory(premium, 0, 1)

	slogan_list = text2list(product_slogans, "*")
	// So not all machines speak at the exact same time.
	// The first time this machine says something will be at slogantime + this random value,
	// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
	last_slogan = world.time + rand(0, slogan_delay)
	power_change()

/obj/machinery/vending/Destroy()
	qdel(wires)
	wires = null
	qdel(coin)
	coin = null
	..()


/obj/machinery/vending/snack/Destroy()
	for(var/obj/item/weapon/reagent_containers/food/snacks/S in contents)
		S.loc = get_turf(src)
	..()

/obj/machinery/vending/RefreshParts()         //Better would be to make constructable child
	if(component_parts)
		product_records = list()
		hidden_records = list()
		coin_records = list()
		build_inventory(products, start_empty = 1)
		build_inventory(contraband, 1, start_empty = 1)
		build_inventory(premium, 0, 1, start_empty = 1)
		for(var/obj/item/weapon/vending_refill/VR in component_parts)
			refill_inventory(VR, product_records)
			refill_inventory(VR, coin_records)
			refill_inventory(VR, hidden_records)

/obj/machinery/vending/ex_act(severity, target)
	..()
	if(!gc_destroyed)
		if(prob(25))
			malfunction()

/obj/machinery/vending/blob_act()
	if(prob(75))
		malfunction()
	else
		qdel(src)


/obj/machinery/vending/proc/build_inventory(list/productlist, hidden=0, req_coin=0, start_empty = null)
	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		if(isnull(amount))
			amount = 0

		var/atom/temp = new typepath(null)
		var/datum/data/vending_product/R = new /datum/data/vending_product()
		R.product_name = initial(temp.name)
		R.product_path = typepath
		if(!start_empty)
			R.amount = amount
		R.max_amount = amount
		R.display_color = pick("red","blue","green")

		if(hidden)
			hidden_records += R
		else if(req_coin)
			coin_records += R
		else
			product_records += R

/obj/machinery/vending/proc/refill_inventory(obj/item/weapon/vending_refill/refill, datum/data/vending_product/machine)
	var/total = 0

	var/to_restock = 0
	for(var/datum/data/vending_product/machine_content in machine)
		if(machine_content.amount == 0 && refill.charges > 0)
			machine_content.amount++
			refill.charges--
			total++
		to_restock += machine_content.max_amount - machine_content.amount
	if(to_restock <= refill.charges)
		for(var/datum/data/vending_product/machine_content in machine)
			machine_content.amount = machine_content.max_amount
		refill.charges -= to_restock
		total += to_restock
	else
		var/tmp_charges = refill.charges
		for(var/datum/data/vending_product/machine_content in machine)
			if(refill.charges == 0)
				break
			var/restock = Ceiling(((machine_content.max_amount - machine_content.amount)/to_restock)*tmp_charges)
			if(restock > refill.charges)
				restock = refill.charges
			machine_content.amount += restock
			refill.charges -= restock
			total += restock
	return total

/obj/machinery/vending/snack/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		if(!compartment_access_check(user))
			return
		if(junk_check(W))
			if(!iscompartmentfull(user))
				user.drop_item()
				W.loc = src
				food_load(W)
				user << "<span class='notice'>You insert [W] into [src]'s chef compartment.</span>"
		else
			user << "<span class='notice'>[src]'s chef compartment does not accept junk food.</span>"
		return

	if(istype(W, /obj/item/weapon/storage/bag/tray))
		if(!compartment_access_check(user))
			return
		var/obj/item/weapon/storage/T = W
		var/loaded = 0
		var/denied_items = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/S in T.contents)
			if(iscompartmentfull(user))
				break
			if(junk_check(S))
				T.remove_from_storage(S, src)
				food_load(S)
				loaded++
			else
				denied_items++
		if(denied_items)
			user << "<span class='notice'>[src] refuses some items.</span>"
		if(loaded)
			user << "<span class='notice'>You insert [loaded] dishes into [src]'s chef compartment.</span>"
		updateUsrDialog()
		return

	..()

/obj/machinery/vending/snack/proc/compartment_access_check(user)
	req_access_txt = chef_compartment_access
	if(!allowed(user) && !emagged && scan_id)
		user << "<span class='warning'>[src]'s chef compartment blinks red: Access denied.</span>"
		req_access_txt = "0"
		return 0
	req_access_txt = "0"
	return 1

/obj/machinery/vending/snack/proc/junk_check(obj/item/weapon/reagent_containers/food/snacks/S)
	if(S.junkiness)
		return 0
	return 1

/obj/machinery/vending/snack/proc/iscompartmentfull(mob/user)
	if(contents.len >= 30) // no more than 30 dishes can fit inside
		user << "<span class='warning'>[src]'s chef compartment is full.</span>"
		return 1
	return 0

/obj/machinery/vending/snack/proc/food_load(obj/item/weapon/reagent_containers/food/snacks/S)
	if(dish_quants[S.name])
		dish_quants[S.name]++
	else
		dish_quants[S.name] = 1
	sortList(dish_quants)

/obj/machinery/vending/attackby(obj/item/weapon/W, mob/user, params)
	if(panel_open)
		if(default_unfasten_wrench(user, W, time = 60))
			return

		if(component_parts && istype(W, /obj/item/weapon/crowbar))
			default_deconstruction_crowbar(W)

	if(istype(W, /obj/item/weapon/screwdriver) && anchored)
		panel_open = !panel_open
		user << "<span class='notice'>You [panel_open ? "open" : "close"] the maintenance panel.</span>"
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, "[initial(icon_state)]-panel")
		updateUsrDialog()
		return
	else if(istype(W, /obj/item/device/multitool)||istype(W, /obj/item/weapon/wirecutters))
		if(panel_open)
			attack_hand(user)
		return
	else if(istype(W, /obj/item/weapon/coin) && premium.len > 0)
		user.drop_item()
		W.loc = src
		coin = W
		user << "<span class='notice'>You insert [W] into [src].</span>"
		return
	else if(istype(W, refill_canister) && refill_canister != null)
		if(stat & (BROKEN|NOPOWER))
			user << "<span class='notice'>It does nothing.</span>"
		else if(panel_open)
			//if the panel is open we attempt to refill the machine
			var/obj/item/weapon/vending_refill/canister = W
			if(canister.charges == 0)
				user << "<span class='notice'>This [canister.name] is empty!</span>"
			else
				var/transfered = refill_inventory(canister,product_records,user)
				if(transfered)
					user << "<span class='notice'>You loaded [transfered] items in \the [name].</span>"
				else
					user << "<span class='notice'>The [name] is fully stocked.</span>"
			return;
		else
			user << "<span class='notice'>You should probably unscrew the service panel first.</span>"
	else
		..()


/obj/machinery/vending/default_deconstruction_crowbar(var/obj/item/O)
	var/list/all_products = product_records + hidden_records + coin_records
	for(var/datum/data/vending_product/machine_content in all_products)
		while(machine_content.amount !=0)
			var/safety = 0 //to avoid infinite loop
			for(var/obj/item/weapon/vending_refill/VR in component_parts)
				safety++
				if(VR.charges < initial(VR.charges))
					VR.charges++
					machine_content.amount--
					if(!machine_content.amount)
						break
				else
					safety--
			if(safety <= 0)
				break
	..()

/obj/machinery/vending/emag_act(user as mob)
	if(!emagged)
		emagged  = 1
		user << "<span class='notice'>You short out the product lock on [src].</span>"

/obj/machinery/vending/attack_paw(mob/user)
	return attack_hand(user)


/obj/machinery/vending/attack_ai(mob/user)
	return attack_hand(user)


/obj/machinery/vending/attack_hand(mob/user)
	var/dat = ""
	if(panel_open)
		dat += wires()
		if(product_slogans != "")
			dat += "The speaker switch is [shut_up ? "off" : "on"]. <a href='?src=\ref[src];togglevoice=[1]'>Toggle</a>"
	else
		if(stat & (BROKEN|NOPOWER))
			return

		dat += "<h3>Select an item</h3>"
		dat += "<div class='statusDisplay'>"
		if(product_records.len == 0)
			dat += "<font color = 'red'>No product loaded!</font>"
		else
			var/list/display_records = product_records
			if(extended_inventory)
				display_records = product_records + hidden_records
			if(coin)
				display_records = product_records + coin_records
			if(coin && extended_inventory)
				display_records = product_records + hidden_records + coin_records
			dat += "<ul>"
			for (var/datum/data/vending_product/R in display_records)
				dat += "<li>"
				if(R.amount > 0)
					dat += "<a href='byond://?src=\ref[src];vend=\ref[R]'>Vend</a> "
				else
					dat += "<span class='linkOff'>Sold out</span> "
				dat += "<font color = '[R.display_color]'><b>[sanitize(R.product_name)]</b>:</font>"
				dat += " <b>[R.amount]</b>"
				dat += "</li>"
			dat += "</ul>"
		dat += "</div>"
		if(premium.len > 0)
			dat += "<b>Coin slot:</b> "
			if (coin)
				dat += "[coin]&nbsp;&nbsp;<a href='byond://?src=\ref[src];remove_coin=1'>Remove</a>"
			else
				dat += "<i>No coin</i>&nbsp;&nbsp;<span class='linkOff'>Remove</span>"
		if(istype(src, /obj/machinery/vending/snack))
			dat += "<h3>Chef's Food Selection</h3>"
			dat += "<div class='statusDisplay'>"
			for (var/O in dish_quants)
				if(dish_quants[O] > 0)
					var/N = dish_quants[O]
					dat += "<a href='byond://?src=\ref[src];dispense=[sanitize(O)]'>Dispense</A> "
					dat += "<B>[capitalize(O)]: [N]</B><br>"
			dat += "</div>"
	user.set_machine(src)
	if(seconds_electrified && !(stat & NOPOWER))
		if(shock(user, 100))
			return

	//user << browse(dat, "window=vending")
	//onclose(user, "")
	var/datum/browser/popup = new(user, "vending", (name))
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()


// returns the wire panel text
/obj/machinery/vending/proc/wires()
	return wires.GetInteractWindow()


/obj/machinery/vending/Topic(href, href_list)
	if(..())
		return


	if(istype(usr,/mob/living/silicon))
		if(istype(usr,/mob/living/silicon/robot))
//			var/mob/living/silicon/robot/R = usr
//			if(!(R.module && istype(R.module,/obj/item/weapon/robot_module/butler) ))
//				usr << "<span class='notice'>The vending machine refuses to interface with you, as you are not in its target demographic!</span>"
//				return
		else
			usr << "<span class='notice'>The vending machine refuses to interface with you, as you are not in its target demographic!</span>"
			return

	if(href_list["remove_coin"])
		if(!coin)
			usr << "<span class='notice'>There is no coin in this machine.</span>"
			return

		coin.loc = loc
		if(!usr.get_active_hand())
			usr.put_in_hands(coin)
		usr << "<span class='notice'>You remove [coin] from [src].</span>"
		coin = null


	usr.set_machine(src)

	if((href_list["dispense"]) && (vend_ready))
		var/N = href_list["dispense"]
		if(dish_quants[N] <= 0) // Sanity check, there are probably ways to press the button when it shouldn't be possible.
			return
		vend_ready = 0
		use_power(5)

		spawn(vend_delay)
			dish_quants[N] = max(dish_quants[N] - 1, 0)
			for(var/obj/O in contents)
				if(O.name == N)
					O.loc = src.loc
					break
			vend_ready = 1
			updateUsrDialog()
		return

	if((href_list["vend"]) && (vend_ready))
		if(panel_open)
			usr << "<span class='notice'>The vending machine cannot dispense products while its service panel is open!</span>"
			return

		if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
			usr << "<span class='warning'>Access denied.</span>"	//Unless emagged of course
			flick(icon_deny,src)
			return

		vend_ready = 0 //One thing at a time!!

		var/datum/data/vending_product/R = locate(href_list["vend"])
		if(!R || !istype(R) || !R.product_path)
			vend_ready = 1
			return

		if(R in hidden_records)
			if(!extended_inventory)
				vend_ready = 1
				return
		else if(R in coin_records)
			if(!coin)
				usr << "<span class='warning'>You need to insert a coin to get this item!</span>"
				vend_ready = 1
				return
			if(coin.string_attached)
				if(prob(50))
					if(usr.put_in_hands(coin))
						usr << "<span class='notice'>You successfully pull [coin] out before [src] could swallow it.</span>"
						coin = null
					else
						usr << "<span class='warning'>You couldn't pull [coin] out because your hands are full!</span>"
						qdel(coin)
						coin = null
				else
					usr << "<span class='warning'>You weren't able to pull [coin] out fast enough, the machine ate it, string and all!</span>"
					qdel(coin)
					coin = null
			else
				qdel(coin)
				coin = null
		else if (!(R in product_records))
			vend_ready = 1
			message_admins("Vending machine exploit attempted by [key_name(usr, usr.client)]!")
			return

		if (R.amount <= 0)
			usr << "<span class='warning'>Sold out.</span>"
			vend_ready = 1
			return
		else
			R.amount--

		if(((last_reply + (vend_delay + 200)) <= world.time) && vend_reply)
			speak(vend_reply)
			last_reply = world.time

		use_power(5)
		if(icon_vend) //Show the vending animation if needed
			flick(icon_vend,src)
		spawn(vend_delay)
			new R.product_path(get_turf(src))
			vend_ready = 1
			return

		updateUsrDialog()
		return

	else if(href_list["togglevoice"] && panel_open)
		shut_up = !shut_up

	updateUsrDialog()


/obj/machinery/vending/process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(last_slogan + slogan_delay <= world.time && slogan_list.len > 0 && !shut_up && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(2))
		throw_item()


/obj/machinery/vending/proc/speak(message)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!message)
		return

	say(message)

/obj/machinery/vending/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(powered())
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			icon_state = "[initial(icon_state)]-off"
			stat |= NOPOWER


//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/data/vending_product/R in product_records)
		if(R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if(!dump_path)
			continue

		while(R.amount>0)
			new dump_path(loc)
			R.amount--
		continue

	stat |= BROKEN
	icon_state = "[initial(icon_state)]-broken"
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/data/vending_product/R in product_records)
		if(R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if(!dump_path)
			continue

		R.amount--
		throw_item = new dump_path(loc)
		break
	if(!throw_item)
		return 0

	throw_item.throw_at(target, 16, 3)
	visible_message("<span class='danger'>[src] launches [throw_item] at [target]!</span>")
	return 1


/obj/machinery/vending/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		add_logs(user, src, "shocked by", admin=0, addition="at [loc.x],[loc.y],[loc.z]")
		return 1
	else
		return 0

/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

IF YOU MODIFY THE PRODUCTS LIST OF A MACHINE, MAKE SURE TO UPDATE ITS RESUPPLY CANISTER CHARGES in vending_items.dm
*/

/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/weapon/tank/internals/oxygen;/obj/item/weapon/tank/internals/plasma;/obj/item/weapon/tank/internals/emergency_oxygen;/obj/item/weapon/tank/internals/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	product_amounts = "10;10;10;5;25"
	vend_delay = 0
*/

/obj/machinery/vending/boozeomat
	name = "\improper Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequila = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 5,/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 5,/obj/item/weapon/reagent_containers/food/drinks/beer = 6,
					/obj/item/weapon/reagent_containers/food/drinks/ale = 6,/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 4,/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 4,/obj/item/weapon/reagent_containers/food/drinks/soda_cans/tonic = 8,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola = 8, /obj/item/weapon/reagent_containers/food/drinks/soda_cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 30,/obj/item/weapon/reagent_containers/food/drinks/ice = 10,
					/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shotglass = 8)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/tea = 10)
	vend_delay = 15
	product_slogans = "Надеюсь, никто не попросит у мен&#255; чашку ча&#255;...*Алкоголь - друг человека! Бросишь ли ты своего друга?*Рад служить вам!*Разве никто не страдает от жажды на станции?"
	product_ads = "Губит людей не пиво, губит людей вода!*До дна!*Выпивка на благо!*Алкоголь - лучший друг человека!*Рад служить!*Не хочешь ли хорошего, холодного пива?*Ничто не исцел&#255;ет так, как это делает выпивка!*Всего глоток!*Выпей!*Закажи пива!*Пиво на пользу тебе!*Только лучший алкоголь!*Лучшее качество выпивки с начала двухтыс&#255;челети&#255;!*Лучшее вино!*М-М-Максимум алкогол&#255;!*Мужчина предпочитает пиво.*Тост дл&#255; прогресса!"
	req_access_txt = "25"
	refill_canister = /obj/item/weapon/vending_refill/boozeomat

/obj/machinery/vending/assist
	products = list(	/obj/item/device/assembly/prox_sensor = 5,/obj/item/device/assembly/igniter = 3,/obj/item/device/assembly/signaler = 4,
						/obj/item/weapon/wirecutters = 1, /obj/item/weapon/cartridge/signal = 4)
	contraband = list(/obj/item/device/flashlight = 5,/obj/item/device/assembly/timer = 2, /obj/item/device/assembly/voice = 2)
	product_ads = "Только лучшее!*Экипируйс&#255;!*Сама&#255; крепка&#255; экипировка!*Лучшее снар&#255;жение в секторе!"

/obj/machinery/vending/coffee
	name = "\improper Solar's Best Hot Drinks"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Напитки дл&#255; теб&#255;!*Утоли жажду!*Вам понравитс&#255;!*Чашечку кофе?*Я бы убил ради глотка кофе!*Лучшие бобы в секторе!*Только лучшие напитки дл&#255; вас.*М-м-м, бесподобное кофе.*Я люблю кофе, а вы?*Кофе в помощь дл&#255; работы!*Попробуйте наш чай.*Надеюсь, вам нравитс&#255; лучшее!*Попробуйте наш новый шоколад!"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	products = list(/obj/item/weapon/reagent_containers/food/drinks/coffee = 25,/obj/item/weapon/reagent_containers/food/drinks/tea = 25,/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 25)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/ice = 10)
	refill_canister = /obj/item/weapon/vending_refill/coffee

/obj/machinery/vending/snack
	name = "\improper Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars"
	product_slogans = "Попробуйте нугу!*Двойна&#255; порци&#255; калорий за пол-цены!"
	product_ads = "Самое натуральное!*Лучшие плитки шоколада! Не пытайтесь кидатьс&#255; ими!*М-м-м, так вкусно.*Господи, он такой сочный!*Перекуси!*Перекуси, тебе понравитс&#255;!*Больше шоколада господу шоколада!*Вкусности лучшего качества пр&#255;миком с Марса!*Все мы любим шоколад!*Попробуйте наше в&#255;леное м&#255;со!"
	icon_state = "snack"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/candy = 5,/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 5,/obj/item/weapon/reagent_containers/food/snacks/chips =5,
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky = 5,/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 5,/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 5,
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 5)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/syndicake = 7)
	refill_canister = /obj/item/weapon/vending_refill/snack
	var/chef_compartment_access = "28"

/obj/machinery/vending/sustenance
	name = "\improper Sustenance Vendor"
	desc = "A vending machine which vends food, as required by section 47-C of the NT's Prisoner Ethical Treatment Agreement."
	product_slogans = "Наслаждайс&#255; едой, пока можешь.*Достаточно калорий дл&#255; теб&#255; и твоих исправительных работ."
	product_ads = "Достаточно полезно.*Тофу без затрат!*М-м-м, как вкусно!*Перекуси.*Тебе нужна еда дл&#255; выживани&#255;!*Сладкий попкорн!*Попробуй наш отменный лёд, грызи лёд во славу Корпорации!"
	icon_state = "sustenance"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/tofu = 24,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 12,
					/obj/item/weapon/reagent_containers/food/snacks/candy_corn = 6)
	contraband = list(/obj/item/weapon/kitchen/knife = 6)


/obj/machinery/vending/cola
	name = "\improper Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Крепкие Напитки: бьют в голову сильнее огнетушител&#255;!"
	product_ads = "Освежает!*Надеюсь, вы хотите пить!*Больше миллиона проданных напитков!*Умираете от жаджы? Может, лучше кола?*Пожалуйста, получите ваш напиток!*Выпейте!*Лучше напитки в секторе!"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola = 10,/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_mountain_wind = 10,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/dr_gibb = 10,/obj/item/weapon/reagent_containers/food/drinks/soda_cans/starkist = 10,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_up = 10,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/lemon_lime = 10)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/soda_cans/thirteenloko = 6)
	refill_canister = /obj/item/weapon/vending_refill/cola

//This one's from bay12
/obj/machinery/vending/cart
	name = "\improper PTech"
	desc = "Cartridges for PDAs"
	product_slogans = "Маленькие картриджи маленьких ПДА!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	products = list(/obj/item/weapon/cartridge/cmo = 1,/obj/item/weapon/cartridge/medical = 5,/obj/item/weapon/cartridge/chemistry = 2,
					/obj/item/weapon/cartridge/ce = 1,/obj/item/weapon/cartridge/engineering = 5,/obj/item/weapon/cartridge/atmos = 2,
					/obj/item/weapon/cartridge/hos = 1,/obj/item/weapon/cartridge/security = 5,/obj/item/weapon/cartridge/detective = 1,
					/obj/item/weapon/cartridge/rd = 1,/obj/item/weapon/cartridge/signal/toxins = 5,/obj/item/weapon/cartridge/roboticist = 2,
					/obj/item/weapon/cartridge/head = 3,/obj/item/weapon/cartridge/janitor = 2,/obj/item/weapon/cartridge/lawyer = 2,
					/obj/item/weapon/cartridge/hop = 1,/obj/item/weapon/cartridge/quartermaster = 1,/obj/item/weapon/cartridge/clown = 1,/obj/item/weapon/cartridge/mime = 1,
					/obj/item/weapon/cartridge/captain = 1,
					/obj/item/device/pda = 10)

/obj/machinery/vending/liberationstation
	name = "\improper Liberation Station"
	desc = "An overwhelming amount of <b>ancient patriotism</b> washes over you just by looking at the machine."
	icon_state = "liberationstation"
	req_access_txt = "1"
	product_slogans = "Liberation Station: Your one-stop shop for all things second ammendment!*Be a patriot today, pick up a gun!*Quality weapons for cheap prices!*Better dead than red!"
	product_ads = "Float like an astronaut, sting like a bullet!*Express your second ammendment today!*Guns don't kill people, but you can!*Who needs responsibilities when you have guns?"
	vend_reply = "Remember the name: Liberation Station!"
	products = list(/obj/item/weapon/gun/projectile/automatic/pistol/deagle/gold = 2,/obj/item/weapon/gun/projectile/automatic/pistol/deagle/camo = 2,
					/obj/item/weapon/gun/projectile/automatic/pistol/m1911 = 2,/obj/item/weapon/gun/projectile/automatic/proto = 2,
					/obj/item/weapon/gun/projectile/shotgun/automatic/combat = 2,/obj/item/weapon/gun/projectile/automatic/gyropistol = 1,
					/obj/item/weapon/gun/projectile/shotgun = 2,/obj/item/weapon/gun/projectile/automatic/ar = 2)
	premium = list(/obj/item/ammo_box/magazine/smgm9mm = 2,/obj/item/ammo_box/magazine/m50 = 4,/obj/item/ammo_box/magazine/m45 = 2,/obj/item/ammo_box/magazine/m75 = 2)
	contraband = list(/obj/item/clothing/under/patriotsuit = 1,/obj/item/weapon/bedsheet/patriot = 3)

/obj/machinery/vending/cigarette
	name = "\improper ShadyCigs Deluxe"
	desc = "Хотите рак - получите его со стилем."
	product_slogans = "Космосигареты на вкус почти как насто&#255;щие!*Предпочитаю смерть смене привычки!*Кури!*Не верь статистике - покури!"
	product_ads = "Может и не навредит!*Не верь учёным!*Это полезно дл&#255; теб&#255;!*Не бросай, купи ещё!*Кури!*Никотиновый рай.*Лучшие раковые палочки на прот&#255;жении четырёх веков.*Лучшие сигареты!"
	vend_delay = 34
	icon_state = "cigs"
	products = list(/obj/item/weapon/storage/fancy/cigarettes = 5,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_uplift = 3,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_robust = 2,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_carp = 3,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori = 3,
					/obj/item/weapon/storage/box/matches = 10,
					/obj/item/weapon/lighter/grayscale = 4,
					/obj/item/weapon/storage/fancy/rollingpapers = 5)
	contraband = list(/obj/item/weapon/lighter/zippo = 4)
	premium = list(/obj/item/weapon/storage/fancy/cigarettes/cigpack_robustgold = 2, \
	/obj/item/weapon/storage/fancy/cigars = 1, /obj/item/weapon/storage/fancy/cigars/havana = 1, /obj/item/weapon/storage/fancy/cigars/cohiba = 1)
	refill_canister = /obj/item/weapon/vending_refill/cigarette

/obj/machinery/vending/medical
	name = "\improper NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Самое врем&#255; спасать жизни!*Лучшее дл&#255; медотсека!*Натуральна&#255; хими&#255;!*ЭТО спасает жизни!*Не хочешь немного медицины? Легально!"
	req_access_txt = "5"
	products = list(/obj/item/weapon/reagent_containers/syringe = 12,/obj/item/stack/medical/gauze = 8,/obj/item/weapon/reagent_containers/pill/patch/styptic = 5, /obj/item/weapon/reagent_containers/pill/insulin = 10,
				/obj/item/weapon/reagent_containers/pill/patch/silver_sulf = 5,/obj/item/weapon/reagent_containers/glass/bottle/charcoal = 4,
				/obj/item/weapon/reagent_containers/glass/bottle/epinephrine = 4,/obj/item/weapon/reagent_containers/glass/bottle/morphine = 4,
				/obj/item/weapon/reagent_containers/glass/bottle/toxin = 3,/obj/item/weapon/reagent_containers/syringe/antiviral = 6,/obj/item/weapon/reagent_containers/pill/salbutamol = 2, /obj/item/weapon/storage/pill_bottle/haloperidol = 2, /obj/item/device/healthanalyzer = 4, /obj/item/device/sensor_device = 2)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3,/obj/item/weapon/reagent_containers/pill/morphine = 4,/obj/item/weapon/reagent_containers/pill/charcoal = 6)


//This one's from bay12
/obj/machinery/vending/plasmaresearch
	name = "\improper Toximate 3000"
	desc = "Всё дл&#255; теб&#255; и твоих взрывоопасных желаний!"
	products = list(/obj/item/clothing/under/rank/scientist = 6,/obj/item/clothing/suit/bio_suit = 6,/obj/item/clothing/head/bio_hood = 6,
					/obj/item/device/transfer_valve = 6,/obj/item/device/assembly/timer = 6,/obj/item/device/assembly/signaler = 6,
					/obj/item/device/assembly/prox_sensor = 6,/obj/item/device/assembly/igniter = 6)

/obj/machinery/vending/wallmed
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	product_ads = "Самое врем&#255; спасать жизни!*Лучшее дл&#255; медотсека!*Натуральна&#255; хими&#255;!*ЭТО спасает жизни!*Не хочешь немного медицины? Легально!"
	req_access_txt = "5"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/weapon/reagent_containers/syringe = 6,/obj/item/weapon/reagent_containers/pill/patch/styptic = 5,
					/obj/item/weapon/reagent_containers/pill/patch/silver_sulf = 5,/obj/item/weapon/reagent_containers/glass/bottle/charcoal = 2,
					/obj/item/weapon/reagent_containers/glass/bottle/epinephrine = 2,/obj/item/weapon/reagent_containers/glass/bottle/morphine = 2,
					/obj/item/weapon/reagent_containers/glass/bottle/diphenhydramine = 2,/obj/item/weapon/reagent_containers/glass/bottle/potass_iodide = 2,
					/obj/item/weapon/reagent_containers/glass/bottle/salglu_solution = 3,/obj/item/weapon/reagent_containers/glass/bottle/atropine = 2,/obj/item/weapon/reagent_containers/syringe/antiviral = 3,
					/obj/item/weapon/reagent_containers/syringe/calomel = 5,/obj/item/weapon/reagent_containers/pill/salbutamol = 5,/obj/item/weapon/reagent_containers/pill/mannitol = 5,
					/obj/item/weapon/reagent_containers/pill/mutadone = 3,/obj/item/device/healthanalyzer = 2, /obj/item/device/sensor_device = 1,/obj/item/weapon/reagent_containers/glass/bottle/toxin = 2)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 2,/obj/item/weapon/reagent_containers/pill/morphine = 2,/obj/item/weapon/reagent_containers/pill/charcoal = 3)

/obj/machinery/vending/security
	name = "\improper SecTech"
	desc = "A security equipment vendor"
	product_ads = "Кроши черепа!*Разбивай головы!*Не забудь: вред - хорошо!*Твоё оружие ждёт теб&#255;!*Наручники!*Сто&#255;ть, ублюдок!*Не оглушай - выбивай дух из них!*Оглуши их!*Может, пончик?*И запомни: ни слова при задержании!"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access_txt = "1"
	products = list(/obj/item/weapon/restraints/handcuffs = 8,/obj/item/weapon/restraints/handcuffs/cable/zipties = 10,/obj/item/weapon/grenade/flashbang = 4,/obj/item/device/flash/handheld = 5,
					/obj/item/weapon/reagent_containers/food/snacks/donut = 12,/obj/item/weapon/storage/box/evidence = 6,/obj/item/device/flashlight/seclite = 4,/obj/item/device/flashlight/heavy = 2)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/weapon/storage/fancy/donut_box = 2)
	premium = list(/obj/item/weapon/coin/antagtoken = 1)

/obj/machinery/vending/hydronutrients
	name = "\improper NutriMax"
	desc = "A plant nutrients vendor"
	product_slogans = "Не рад тому, что не нужно удобр&#255;ть как в старые добрые?*Теперь в два раза меньше вони!*Растени&#255; - тоже люди!"
	product_ads = "Все мы любим растени&#255;!*Не вздумайте пить аммиак!*Дл&#255; самых извращённых садоводов!*Мне нрав&#255;тс&#255; БОЛЬШИЕ растени&#255;"
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(/obj/item/weapon/reagent_containers/glass/bottle/nutrient/ez = 30,/obj/item/weapon/reagent_containers/glass/bottle/nutrient/l4z = 10,/obj/item/weapon/reagent_containers/glass/bottle/nutrient/rh = 20,/obj/item/weapon/reagent_containers/spray/pestspray = 20,
					/obj/item/weapon/reagent_containers/syringe = 5,/obj/item/weapon/storage/bag/plants = 5)
	contraband = list(/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 10,/obj/item/weapon/reagent_containers/glass/bottle/diethylamine = 5)

/obj/machinery/vending/hydroseeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "РОДИНА СЕМЯН, СПЕШИ ЛИШИТЬ ИХ СВОЕГО ДОМА!*Семена лучшей селекции, их даже можно потрогать!*Большой ассортимент грибов! Ещё больше дл&#255; <I>экспертов</I>! Получи свой гриб совершенно легально!"
	product_ads = "Все мы любим семена!*Не забудь собрать урожай!*Расти, детка, расти, господи, расти, расти, расти!*ТАК И НАДО С ЭТИМИ СЕМЕНАМИ, СЫНОК!"
	icon_state = "seeds"
	products = list(/obj/item/seeds/ambrosiavulgarisseed = 3,/obj/item/seeds/appleseed = 3,/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,
						/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/chantermycelium = 3,
						/obj/item/seeds/chiliseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/coffee_arabica_seed = 3,/obj/item/seeds/cornseed = 3,
						/obj/item/seeds/eggplantseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/lemonseed = 3,
						/obj/item/seeds/limeseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/potatoseed = 3,/obj/item/seeds/poppyseed = 3,
						/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,/obj/item/seeds/sunflowerseed = 3,
						/obj/item/seeds/tea_aspera_seed = 3,/obj/item/seeds/tobacco_seed = 3,/obj/item/seeds/tomatoseed = 3,
						/obj/item/seeds/towermycelium = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/whitebeetseed = 3,
						/obj/item/seeds/riceseed = 3)
	contraband = list(/obj/item/seeds/amanitamycelium = 2,/obj/item/seeds/glowshroom = 2,/obj/item/seeds/libertymycelium = 2,/obj/item/seeds/nettleseed = 2,
						/obj/item/seeds/plumpmycelium = 2,/obj/item/seeds/reishimycelium = 2)
	premium = list(/obj/item/weapon/reagent_containers/spray/waterflower = 1)


/obj/machinery/vending/magivend
	name = "\improper MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Заклинани&#255;-М1 в МагиТорге!*Стань Гудини! Используй МагиТорг!"
	vend_delay = 15
	vend_reply = "Волшебного вечера!"
	product_ads = "SKYAR NILA BRIDGE*STY KALY*FORTY GY AMA!*Непередаваемое чувство убийства!*ГДЕ ДИСК?!*ХОНК!*EI NATH*Уничтожь станцию!*Гни свою временную линию!"
	products = list(/obj/item/clothing/head/wizard = 1,/obj/item/clothing/suit/wizrobe = 1,/obj/item/clothing/head/wizard/red = 1,/obj/item/clothing/suit/wizrobe/red = 1,/obj/item/clothing/head/wizard/yellow = 1,/obj/item/clothing/suit/wizrobe/yellow = 1,/obj/item/clothing/shoes/sandal = 1,/obj/item/device/flashlight/staff = 2)
	contraband = list(/obj/item/weapon/reagent_containers/glass/bottle/wizarditis = 1)	//No one can get to the machine to hack it anyways; for the lulz - Microwave

/obj/machinery/vending/autodrobe
	name = "AutoDrobe"
	desc = "A vending machine for costumes."
	icon_state = "theater"
	icon_deny = "theater-deny"
	req_access_txt = "46" //Theatre access needed, unless hacked.
	product_slogans = "Нар&#255;дись дл&#255; успеха!*Обут и одет!*Врем&#255; дл&#255; подиума!*Зачем бросать стиль на самотёк? Используй АвтоРоб!"
	vend_delay = 15
	vend_reply = "Спасибо вам за использование АвтоРоба!"
	products = list(/obj/item/clothing/suit/chickensuit = 1,/obj/item/clothing/head/chicken = 1,/obj/item/clothing/under/gladiator = 1,
					/obj/item/clothing/head/helmet/gladiator = 1,/obj/item/clothing/under/gimmick/rank/captain/suit = 1,/obj/item/clothing/head/flatcap = 1,
					/obj/item/clothing/suit/toggle/labcoat/mad = 1,/obj/item/clothing/glasses/gglasses = 1,/obj/item/clothing/shoes/jackboots = 1,
					/obj/item/clothing/under/schoolgirl = 1,/obj/item/clothing/under/schoolgirl/red = 1,/obj/item/clothing/under/schoolgirl/green = 1,/obj/item/clothing/under/schoolgirl/orange = 1,/obj/item/clothing/head/kitty = 1,/obj/item/clothing/under/blackskirt = 1,/obj/item/clothing/head/beret = 1,
					/obj/item/clothing/tie/waistcoat = 1,/obj/item/clothing/under/suit_jacket = 1,/obj/item/clothing/head/that =1,/obj/item/clothing/under/kilt = 1,/obj/item/clothing/head/beret = 1,/obj/item/clothing/tie/waistcoat = 1,
					/obj/item/clothing/glasses/monocle =1,/obj/item/clothing/head/bowler = 1,/obj/item/weapon/support/cane = 1,/obj/item/clothing/under/sl_suit = 1,
					/obj/item/clothing/mask/fakemoustache = 1,/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 1,/obj/item/clothing/head/plaguedoctorhat = 1,/obj/item/clothing/mask/gas/plaguedoctor = 1,
					/obj/item/clothing/suit/toggle/owlwings = 1, /obj/item/clothing/under/owl = 1,/obj/item/clothing/mask/gas/owl_mask = 1,
					/obj/item/clothing/suit/toggle/owlwings/griffinwings = 1, /obj/item/clothing/under/griffin = 1, /obj/item/clothing/shoes/griffin = 1, /obj/item/clothing/head/griffin = 1,
					/obj/item/clothing/suit/apron = 1,/obj/item/clothing/under/waiter = 1,
					/obj/item/clothing/under/pirate = 1,/obj/item/clothing/suit/pirate = 1,/obj/item/clothing/head/pirate = 1,/obj/item/clothing/head/bandana = 1,
					/obj/item/clothing/head/bandana = 1,/obj/item/clothing/under/soviet = 1,/obj/item/clothing/head/ushanka = 1,/obj/item/clothing/suit/imperium_monk = 1,
					/obj/item/clothing/mask/gas/cyborg = 1,/obj/item/clothing/suit/holidaypriest = 1,/obj/item/clothing/head/wizard/marisa/fake = 1,
					/obj/item/clothing/suit/wizrobe/marisa/fake = 1,/obj/item/clothing/under/sundress = 1,/obj/item/clothing/head/witchwig = 1,/obj/item/weapon/broom = 1,
					/obj/item/clothing/suit/wizrobe/fake = 1,/obj/item/clothing/head/wizard/fake = 1,/obj/item/device/flashlight/staff = 3,/obj/item/clothing/mask/gas/sexyclown = 1,
					/obj/item/clothing/under/sexyclown = 1,/obj/item/clothing/mask/gas/sexymime = 1,/obj/item/clothing/under/sexymime = 1,/obj/item/clothing/suit/apron/overalls = 1,
					/obj/item/clothing/head/rabbitears =1, /obj/item/clothing/head/sombrero = 1, /obj/item/clothing/head/sombrero/green = 1, /obj/item/clothing/suit/poncho = 1,
					/obj/item/clothing/suit/poncho/green = 1, /obj/item/clothing/suit/poncho/red = 1,
					/obj/item/clothing/under/maid = 1, /obj/item/clothing/under/janimaid = 1,/obj/item/clothing/glasses/cold=1,/obj/item/clothing/glasses/heat=1,
					/obj/item/clothing/suit/whitedress = 1, /obj/item/clothing/suit/batman = 1, /obj/item/clothing/under/king = 1, /obj/item/clothing/head/crown = 1, /obj/item/clothing/head/turban = 1, /obj/item/clothing/head/batman = 1,/obj/item/clothing/head/crown/dark = 1, /obj/item/clothing/under/chaps = 1, /obj/item/clothing/under/dolan = 1, /obj/item/clothing/under/safari = 1, /obj/item/clothing/shoes/king = 1, /obj/item/clothing/cloak/king = 1,
					/obj/item/collar/spiked = 1)
	contraband = list(/obj/item/clothing/suit/judgerobe = 1,/obj/item/clothing/head/powdered_wig = 1,/obj/item/weapon/gun/magic/wand = 1,/obj/item/clothing/glasses/sunglasses/garb = 1, /obj/item/clothing/suit/armor/viking = 1)
	premium = list(/obj/item/clothing/suit/hgpirate = 1, /obj/item/clothing/head/hgpiratecap = 1, /obj/item/clothing/head/helmet/roman = 1, /obj/item/clothing/head/helmet/roman/legionaire = 1, /obj/item/clothing/under/roman = 1, /obj/item/clothing/shoes/roman = 1, /obj/item/weapon/shield/riot/roman = 1, /obj/item/weapon/shield/riot/buckler)
	refill_canister = /obj/item/weapon/vending_refill/autodrobe

/obj/machinery/vending/dinnerware
	name = "\improper Plasteel Chef's Dinnerware Vendor"
	desc = "A kitchen and restaurant equipment vendor"
	product_ads = "М-м-м, еда!*Еда, еда и еда!*Получите свои тарелки!*Нрав&#255;тс&#255; вилки, м-м?*Я люблю вилки.*Ух, посуда!*Она тебе не понадобитс&#255;..."
	icon_state = "dinnerware"
	products = list(/obj/item/weapon/storage/bag/tray = 8,/obj/item/weapon/kitchen/fork = 6,/obj/item/weapon/kitchen/knife = 3,/obj/item/weapon/kitchen/rollingpin = 2,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 8,/obj/item/clothing/suit/apron/chef = 2,/obj/item/weapon/reagent_containers/food/condiment/pack/ketchup = 5,/obj/item/weapon/reagent_containers/food/condiment/pack/hotsauce = 5,/obj/item/weapon/reagent_containers/glass/bowl = 20)
	contraband = list(/obj/item/weapon/kitchen/rollingpin = 2, /obj/item/weapon/kitchen/knife/butcher = 2)

/obj/machinery/vending/sovietsoda
	name = "\improper BODA"
	desc = "Old sweet water vending machine"
	icon_state = "sovietsoda"
	product_ads = "За веру, Цар&#255; и Отечество!*Вы выполнили свою пищевую квоту?*Очень хорошо!*Мы простые люди, нам этого хватает.*Есть люди - есть проблемы. Нет людей - нет проблем!"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/filled/soda = 30)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/filled/cola = 20)

/obj/machinery/vending/tool
	name = "\improper YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	//req_access_txt = "12" //Maintenance access
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/weapon/crowbar = 5,/obj/item/weapon/weldingtool = 3,/obj/item/weapon/wirecutters = 5,
					/obj/item/weapon/wrench = 5,/obj/item/device/analyzer = 5,/obj/item/device/t_scanner = 5,/obj/item/weapon/screwdriver = 5)
	contraband = list(/obj/item/weapon/weldingtool/hugetank = 2,/obj/item/clothing/gloves/color/fyellow = 2)
	premium = list(/obj/item/clothing/gloves/color/yellow = 1)

/obj/machinery/vending/engivend
	name = "\improper Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access_txt = "11" //Engineering Equipment access
	products = list(/obj/item/clothing/glasses/meson/engine = 2,/obj/item/device/multitool = 4,/obj/item/weapon/airlock_electronics = 10,/obj/item/weapon/module/power_control = 10,/obj/item/weapon/airalarm_electronics = 10,/obj/item/weapon/stock_parts/cell/high = 10)
	contraband = list(/obj/item/weapon/stock_parts/cell/potato = 3)
	premium = list(/obj/item/weapon/storage/belt/utility = 3)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "\improper Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access_txt = "11"
	products = list(/obj/item/clothing/under/rank/chief_engineer = 4,/obj/item/clothing/under/rank/engineer = 4,/obj/item/clothing/shoes/sneakers/orange = 4,/obj/item/clothing/head/hardhat = 4,
					/obj/item/weapon/storage/belt/utility = 4,/obj/item/clothing/glasses/meson/engine = 4,/obj/item/clothing/gloves/color/yellow = 4, /obj/item/weapon/screwdriver = 12,
					/obj/item/weapon/crowbar = 12,/obj/item/weapon/wirecutters = 12,/obj/item/device/multitool = 12,/obj/item/weapon/wrench = 12,/obj/item/device/t_scanner = 12,
					/obj/item/weapon/stock_parts/cell = 8, /obj/item/weapon/weldingtool = 8,/obj/item/clothing/head/welding = 8,
					/obj/item/weapon/light/tube = 10,/obj/item/clothing/suit/fire = 4, /obj/item/weapon/stock_parts/scanning_module = 5,/obj/item/weapon/stock_parts/micro_laser = 5,
					/obj/item/weapon/stock_parts/matter_bin = 5,/obj/item/weapon/stock_parts/manipulator = 5,/obj/item/weapon/stock_parts/console_screen = 5)

//This one's from bay12
/obj/machinery/vending/robotics
	name = "\improper Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access_txt = "29"
	products = list(/obj/item/clothing/suit/toggle/labcoat = 4,/obj/item/clothing/under/rank/roboticist = 4,/obj/item/stack/cable_coil = 4,/obj/item/device/flash/handheld = 4,
					/obj/item/weapon/stock_parts/cell/high = 12, /obj/item/device/assembly/prox_sensor = 3,/obj/item/device/assembly/signaler = 3,/obj/item/device/healthanalyzer = 3,
					/obj/item/weapon/scalpel = 2,/obj/item/weapon/circular_saw = 2,/obj/item/weapon/tank/internals/anesthetic = 2,/obj/item/clothing/mask/breath/medical = 5,
					/obj/item/weapon/screwdriver = 5,/obj/item/weapon/crowbar = 5)

//This one's from NTstation
//don't forget to change the refill size if you change the machine's contents!
/obj/machinery/vending/clothing
	name = "ClothesMate" //renamed to make the slogan rhyme
	desc = "A vending machine for clothing."
	icon_state = "clothes"
	product_slogans = "Нар&#255;дись дл&#255; успеха!*Готовьс&#255; выгл&#255;деть освэгенно!*Только посмотри на всё это!*Зачем бросать стиль на самотёк? Используй ОдежТорг!"
	vend_delay = 15
	vend_reply = "Thank you for using the ClothesMate!"
	products = list(/obj/item/clothing/head/that=2,/obj/item/clothing/head/fedora=1,/obj/item/clothing/glasses/monocle=1, /obj/item/clothing/under/training = 2, /obj/item/clothing/under/cosby = 1, /obj/item/clothing/under/cosby/cosby2 = 1, /obj/item/clothing/under/cosby/cosby3 = 1, /obj/item/clothing/under/rasta = 2, /obj/item/clothing/head/rasta = 2,/obj/item/clothing/under/rank/chaplain/buddhist = 3, /obj/item/clothing/suit/jacket=3,/obj/item/clothing/under/suit_jacket/navy=2,/obj/item/clothing/under/suit_jacket/really_black=2,/obj/item/clothing/under/kilt=1,/obj/item/clothing/under/overalls=1,
	/obj/item/clothing/under/sl_suit=1,/obj/item/clothing/under/pants/jeans=3,/obj/item/clothing/under/pants/classicjeans=2, /obj/item/clothing/suit/jacket/puffer = 1, /obj/item/clothing/suit/jacket/puffer/vest = 1, /obj/item/clothing/suit/jacket/puffer = 1, /obj/item/clothing/suit/jacket/puffer/vest = 1, /obj/item/clothing/suit/sweater = 1, /obj/item/clothing/suit/sweater/green = 1, /obj/item/clothing/suit/sweater/red = 1,
	/obj/item/clothing/under/pants/camo = 1,/obj/item/clothing/under/pants/blackjeans=2,/obj/item/clothing/under/pants/khaki=2,
	/obj/item/clothing/under/pants/white=2,/obj/item/clothing/under/pants/red=1,/obj/item/clothing/under/pants/black=2,
	/obj/item/clothing/under/pants/tan=2,/obj/item/clothing/under/pants/track=1,
	/obj/item/clothing/tie/blue=1, /obj/item/clothing/tie/red=1,/obj/item/clothing/tie/black=1, /obj/item/clothing/tie/horrible=1,
	/obj/item/clothing/scarf/red=1,/obj/item/clothing/scarf/green=1,/obj/item/clothing/scarf/darkblue=1,
	/obj/item/clothing/scarf/purple=1,/obj/item/clothing/scarf/yellow=1,/obj/item/clothing/scarf/orange=1,
	/obj/item/clothing/scarf/lightblue=1,/obj/item/clothing/scarf/white=1,/obj/item/clothing/scarf/black=1,
	/obj/item/clothing/scarf/zebra=1,/obj/item/clothing/scarf/christmas=1,/obj/item/clothing/scarf/stripedredscarf=1,
	/obj/item/clothing/scarf/stripedbluescarf=1,/obj/item/clothing/scarf/stripedgreenscarf=1,/obj/item/clothing/tie/waistcoat=1,
	/obj/item/clothing/under/blackskirt=1,/obj/item/clothing/under/sundress=2,/obj/item/clothing/under/stripeddress=1, /obj/item/clothing/under/sailordress=1, /obj/item/clothing/under/redeveninggown=1,/obj/item/clothing/under/blacktango=1,/obj/item/clothing/under/wedding=1,/obj/item/clothing/under/wedding/bride_red=1,/obj/item/clothing/suit/toggle/hoodie/black=1,/obj/item/clothing/suit/toggle/hoodie=1,/obj/item/clothing/suit/kimono=1,/obj/item/clothing/under/plaid_skirt=1,/obj/item/clothing/under/plaid_skirt/blue=1,/obj/item/clothing/under/plaid_skirt/purple=1,
	/obj/item/clothing/glasses/regular=2,/obj/item/clothing/head/sombrero=1,/obj/item/clothing/suit/poncho=1,
	/obj/item/clothing/suit/ianshirt=1,/obj/item/clothing/shoes/laceup=2,/obj/item/clothing/shoes/sneakers/black=4,
	/obj/item/clothing/shoes/sandal=1, /obj/item/clothing/gloves/fingerless=2,/obj/item/clothing/glasses/orange=1,/obj/item/clothing/glasses/red=1, /obj/item/clothing/glasses/sunglasses/aviator=1,
	/obj/item/weapon/storage/belt/fannypack=1, /obj/item/weapon/storage/belt/fannypack/blue=1, /obj/item/weapon/storage/belt/fannypack/red=1)
	contraband = list(/obj/item/clothing/under/syndicate/tacticool=1,/obj/item/clothing/mask/balaclava=1,/obj/item/clothing/head/ushanka=1,/obj/item/clothing/under/soviet=1,/obj/item/weapon/storage/belt/fannypack/black=1,/obj/item/clothing/suit/leathercoat=1)
	premium = list(/obj/item/clothing/under/suit_jacket/checkered=1,/obj/item/clothing/head/mailman=1,/obj/item/clothing/under/rank/mailman=1,/obj/item/clothing/suit/jacket/leather=1,/obj/item/clothing/under/pants/mustangjeans=1)
	refill_canister = /obj/item/weapon/vending_refill/clothing

