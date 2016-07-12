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

/obj/machinery/brewery/New()
	create_reagents(1000)
	src.reagents.add_reagent("water", 50, null, src.reagents.chem_temp)	//it`s here for testing. it will be remowed later.
	new/obj/item/weapon/reagent_containers/food/snacks/grown/banana(src)

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
		I.loc = src // well i hope
		return

/obj/machinery/brewery/interact(mob/user as mob) // The microwave Menu
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
			dat += "The brewery is empty.</div>"
		else
			dat = "<h3>Ingredients:</h3>[dat]</div>"
		dat += "<A href='?src=\ref[src];action=brew'>Turn on</A>"
		dat += "<A href='?src=\ref[src];action=dispose'>Eject ingredients</A><BR>"
		dat += "<A href='?src=\ref[src];action=spill'>Spill the liquid</A>"

	var/datum/browser/popup = new(user, "brewery", name, 300, 300)
	popup.set_content(dat)
	popup.open()
	return

/obj/machinery/brewery/Topic(href, href_list)
	if(..() || panel_open)
		return

	usr.set_machine(src)
	if(operating)
		updateUsrDialog()
		return

	switch(href_list["action"])
		if ("brew")
			brew()

		if ("dispose")
			dispose()
		if ("spill")
			spill()

	updateUsrDialog()
	return

/obj/machinery/brewery/proc/dispose()
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

/datum/brewery_procces/test
	name = "test"
	growns = list(/obj/item/weapon/reagent_containers/food/snacks/grown/banana )
	brew_base = list("water" = 1)
	brew_use = list("nutriment" = 1, "banana" = 0)
	brew_results = list("carbon" = 2)
