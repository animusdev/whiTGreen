/obj/machinery/brewery
	name = "brewery keg"
	desc = "An old way to brew some wine."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor"
	layer = 2.9
	density = 1
	anchored = 0
	var/brewing = 0
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/processing_speed = 30 //time for 1(1) brewering reaction
	var/max_growns = 10
	var/closed = FALSE


/obj/machinery/brewery/New()
	create_reagents(900)

	if(!closed)
		flags |= OPENCONTAINER
	else
		flags &= ~OPENCONTAINER

/obj/machinery/brewery/hi_tec
	name = "brewery"
	desc = "Create brand new bio-frendly alcogol with power of SIENCE!"
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 400
	var/default_flags

/obj/item/weapon/circuitboard/brewery
	name = "circuit board (brewery)"
	build_path = /obj/machinery/brewery/hi_tec
	board_type = "machine"
	origin_tech = "programming=1;biotech=1;materials=1"
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/weapon/reagent_containers/glass/beaker = 2)

/obj/machinery/brewery/hi_tec/New()
	create_reagents(100)

	default_flags = flags

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/brewery(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(null)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(null)
	RefreshParts()

/obj/machinery/brewery/hi_tec/RefreshParts()
	reagents.maximum_volume = 0
	processing_speed = 10
	max_growns = 4

	flags = default_flags
	for(var/obj/item/weapon/reagent_containers/glass/beaker/B in component_parts)
		reagents.maximum_volume += B.reagents.maximum_volume
		if(B.flags & NOREACT)
			flags |= NOREACT

	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		processing_speed = max(2, processing_speed - 2 * M.rating)

	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		max_growns += 4 * MB.rating

	if(!closed)
		flags |= OPENCONTAINER
	else
		flags &= ~OPENCONTAINER

/obj/machinery/brewery/proc/select_recipe()
	for (var/Type in typesof(/datum/brewery_procces) - /datum/brewery_procces)
		var/datum/brewery_procces/P = new Type()
		var/has_no_reagents
		for(var/GR_need in P.growns)
			has_no_reagents = TRUE
			for(var/GR in contents)
				if(istype(GR, GR_need))
					has_no_reagents = FALSE

			if(has_no_reagents)
				break
		if(has_no_reagents)
			continue

		for(var/BR_need in P.brew_base)
			if(!src.reagents.has_reagent(BR_need))
				has_no_reagents = TRUE
				break
		if(has_no_reagents)
			continue

		return P
	return 0

/obj/machinery/brewery/proc/brew()

	if(brewing)
		return	//sanity

	var/datum/brewery_procces/P = select_recipe()
	if(!P)
		log_admin("DEBUG: contents in brewery havent suitable recipe. How do you put it in?") //sanity
		return

	brewing = TRUE
	P.process_brew(src)
	brewing = FALSE

/obj/machinery/brewery/attackby(obj/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/grown))
		if(closed)
			user << "<span class='warning'>\the [src] is closed, open it first!</span>"
			return 0
		if(src.contents.len >= max_growns)
			user << "<span class='warning'>Thre is no more free space in \the [src]!</span>"
			return 0
		if(!user.unEquip(I))
			user << "<span class='warning'>\the [I] is stuck to your hand, you cannot put it in \the [src]!</span>"
			return 0

		I.loc = src // well i hope
		return
	if(istype(I, /obj/item/weapon/reagent_containers) && (I.flags | OPENCONTAINER))
		if(closed)
			if(src.reagents.trans_to(I, I.reagents.maximum_volume - I.reagents.total_volume))
				user << "<span class='notice'>You fill [I] with contents of [src].</span>"

/obj/machinery/brewery/hi_tec/attackby(obj/I, mob/user as mob)
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		return

	if(exchange_parts(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(panel_open)
		return

	..()

/obj/machinery/brewery/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/brewery/attack_ai(mob/user as mob)
	return 0

/obj/machinery/brewery/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	interact(user)

/obj/machinery/brewery/interact(mob/user as mob)
	var/dat = "<div class='statusDisplay'>"
	if(brewing)
		dat += "Brewing in progress...<BR>Please wait...!</div>"
	else
		var/list/items_counts = new
		for (var/obj/O in contents)
			items_counts[O.name]++

		for (var/O in items_counts)
			var/N = items_counts[O]
			dat += "[capitalize(O)]: [N]<BR>"

		if (items_counts.len==0)
			dat += "The [src] has no growns.</div>"
		else
			dat = "<h3>Ingredients:</h3>[dat]</div>"
		if(closed)
			dat += "[src] is closed now. <A href='?src=\ref[src];action=open'>Open</A><BR>"
			dat += "<A href='?src=\ref[src];action=brew'>Start brewing</A>"
		else
			dat += "[src] is opened now. <A href='?src=\ref[src];action=close'>Close</A><BR>"
			dat += "<A href='?src=\ref[src];action=dispose'>Eject ingredients</A><BR>"

	var/datum/browser/popup = new(user, "brewery", name, 300, 300)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/brewery/hi_tec/interact(mob/user as mob)
	var/dat = "<div class='statusDisplay'>"
	if(brewing)
		dat += "Brewing in progress...<BR>Please wait...!</div>"
	else
		var/list/items_counts = new
		for (var/obj/O in contents)
			items_counts[O.name]++

		for (var/O in items_counts)
			var/N = items_counts[O]
			dat += "[capitalize(O)]: [N]<BR>"

		if (items_counts.len==0)
			dat += "The [src] has no growns.</div>"
		else
			dat = "<h3>Ingredients:</h3>[dat]</div>"
		if(closed)
			dat += "[src] is closed now. <A href='?src=\ref[src];action=open'>Open</A><BR>"
			dat += "<A href='?src=\ref[src];action=brew'>Start brewing</A>"
		else
			dat += "[src] is opened now. <A href='?src=\ref[src];action=close'>Close</A><BR>"
			dat += "<A href='?src=\ref[src];action=dispose'>Eject ingredients</A><BR>"
	if(reagents.total_volume)
		dat += "<h3>Reagents:</h3><div class='statusDisplay'>"
		for(var/datum/reagent/N in reagents.reagent_list)
			dat += "<LI>[N.name], [N.volume] Units - "
			dat += "<A href='?src=\ref[src];action=dispense;id=[N.id]'>dispense</A><BR>"
		dat += "</div>"
	else
		dat += "<div class='statusDisplay'> The [src] has no reagents. </div>"

	var/datum/browser/popup = new(user, "brewery", name, 300, 300)
	popup.set_content(dat)
	popup.open()
	return


/obj/machinery/brewery/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	if(brewing)
		updateUsrDialog()
		return

	switch(href_list["action"])
		if ("brew")
			if(use_power)
				use_power = 2
			brew()
			if(use_power)
				use_power = 1
		if ("dispose")
			dispose()
		if ("open")
			closed = FALSE
			flags |= OPENCONTAINER
		if ("close")
			closed = TRUE
			flags &= ~OPENCONTAINER
		if ("dispense")
			var/name = reject_bad_text(stripped_input(usr, "Name:","Name your bottle!", " ", MAX_NAME_LEN))
			if(!name)
				return
			var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
			P.name = trim("[name] bottle")
			P.pixel_x = rand(-7, 7) //random position
			P.pixel_y = rand(-7, 7)
			reagents.trans_id_to(P, href_list["id"], 30)

	updateUsrDialog()
	return

/obj/machinery/brewery/proc/dispose()
	if (contents.len == 0)
		return
	for (var/obj/O in contents)
		O.loc = src.loc
	usr << "<span class='notice'>You dispose off the brewery contents.</span>"
	updateUsrDialog()

/obj/machinery/brewery/proc/spill()
	return // пиздуй работать, а пока тут повисит placeholder

/datum/brewery_procces
	var/name = "" //in-game display name
	var/growns[] = list() //type paths of growns needed for brew
	var/growns_sub[] = list() //type paths of growns wich can be used for brew, but not required
	var/brew_base[] = list() //type paths of reagents consumed from keg inself. Note that ALL OF THEM NEEDED FOR REACTION
	var/brew_use[] = list() //type paths of reagents consumed from growns. Note that ANY OF THEM NEEDED FOR REACTION. also 0 amount shows that it only diapiar insted of going into brew
	var/brew_results[] = list() //type path of reagent resulting from this craft

/datum/brewery_procces/proc/process_brew(var/obj/machinery/brewery/brewery)
	for(var/obj/item/weapon/reagent_containers/GR in brewery.contents)
		if(is_type_in_list(GR, growns + growns_sub))
			for(var/RB in brew_base)
				if(!brewery.reagents.has_reagent(RB))
					return					//sanity
			for(var/datum/reagent/RG in GR.reagents.reagent_list)
				for(var/RU in brew_use)
					if(RG.id == RU)
						if(brew_use[RU] == 0)
							GR.reagents.del_reagent(RU)
							break

						for(var/RB in brew_base)
							if(!brewery.reagents.has_reagent(RB))
								GR.reagents.trans_to(brewery, GR.reagents.total_volume)
								qdel(GR)
								return

						var/reaction_coeff = RG.volume / brew_use[RU]

						for(var/RB in brew_base)
							reaction_coeff = min(reaction_coeff, brewery.reagents.get_reagent_amount(RB) / brew_base[RB])

						sleep(round(brewery.processing_speed * reaction_coeff))

						for(var/RB in brew_base)
							brewery.reagents.remove_reagent(RB, brew_base[RB]*reaction_coeff)
						GR.reagents.remove_reagent(RU, brew_use[RU]*reaction_coeff)
						for(var/RR in brew_results)
							brewery.reagents.add_reagent(RR, brew_results[RR] * reaction_coeff, null, brewery.reagents.chem_temp)

						brewery.reagents.update_total()
						GR.reagents.update_total()


				if(RG.volume > 0)
					GR.reagents.trans_id_to(brewery, RG.id, RG.volume)
			qdel(GR)
		else
			GR.reagents.trans_to(brewery, GR.reagents.total_volume)
			qdel(GR)

/datum/brewery_procces/test
	name = "test"
	growns = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana )
	brew_base = list("water" = 1)
	brew_use = list("nutriment" = 1, "banana" = 0)
	brew_results = list("carbon" = 2)
