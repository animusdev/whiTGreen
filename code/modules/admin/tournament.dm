var/list/classes = list("Assistant", "Chef", "Addict", "Survivor", "Clown")

var/end = 0
//-------------------------------------------------------------------------------------------------------------------
#define GREEN "#00ff00"
#define RED "#ff0000"
//-------------------------------------------------------------------------------------------------------------------
var/list/tourn_verbs = list(/client/proc/add_green,
/client/proc/add_red,
/client/proc/announce_banning,
/client/proc/send_combatants,
/client/proc/clear_thunder1,
/client/proc/clear_thunder2,
/client/proc/set_green_equip,
/client/proc/set_red_equip,
/client/proc/toggle_the_doors,
/client/proc/start_fight,
/client/proc/activate_timer,
/client/proc/deactivate_timer,
/client/proc/unfreeze,
/client/proc/equipment_panel,
/client/proc/make_test_site
)
/client/add_admin_verbs()
	..()
	if (holder)
		verbs += tourn_verbs // Adds tournament verbs

//-------------------------------------------------------------------------------------------------------------------
/client/proc/add_green()
	set name = "Add green player"
	set category = "Tournaments"
	if (!holder)	return

	var/list/keys = list()
	for(var/mob/dead/M in player_list)
		keys += M.client
	var/client/selection = input("Please, select a player!", "Add player", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection:mob

	M = M.change_mob_type(/mob/living/carbon/human, pick(tdome2), selection.ckey, 1)
	M.client = selection
	M << "\red You've been sent to thunderdome as the green team and frozen"
	M.stunned = 99999
	M.Life()
	M.color = GREEN
	M.name = "\proper [selection.ckey]"
	M.real_name = "\proper [selection.ckey]"
	M.voice_name = "\proper [selection.ckey]"

/client/proc/add_red()
	set name = "Add red player"
	set category = "Tournaments"
	if (!holder)	return

	var/list/keys = list()
	for(var/mob/dead/M in player_list)
		keys += M.client
	var/client/selection = input("Please, select a player!", "Add player", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection:mob

	M = M.change_mob_type(/mob/living/carbon/human, pick(tdome1), selection.ckey, 1)
	M.client = selection
	M << "\red You've been sent to thunderdome as the red team and frozen"
	M.stunned = 99999
	M.Life()
	M.color = RED
	M.name = "\proper [selection.ckey]"
	M.real_name = "\proper [selection.ckey]"
	M.voice_name = "\proper [selection.ckey]"
//-------------------------------------------------------------------------------------------------------------------
/client/proc/ban_class()
	set name = "Exclude class"
	set category = "Tournaments"

	var/ban_class = input("Please, select a class to be excluded", "Class exclusion", null, null) as anything in classes
	classes -= ban_class
	world << "\red \bold [ckey] has excluded [lowertext(ban_class)]s"
	verbs -= /client/proc/ban_class
	if (classes.len == 1)
		world << "\red The players have chosen to fight using [lowertext(classes[1])]s"
		return

	for (var/mob/living/carbon/human/M in world)
		if (M.color != usr.color)
			M.verbs += /client/proc/ban_class
		else if (M != usr)
			M.verbs -= /client/proc/ban_class

/client/proc/announce_banning()
	set name = "Announce exclusion"
	set category = "Tournaments"
	if (!holder)	return

	classes = list("Assistant", "Chef", "The Stoner", "The Survivor", "The Motherfucking Clown")
	world << "\red \bold The red team starts excluding classes"
	for (var/mob/living/carbon/human/M in world)
		if (M.color == RED)
			M.verbs += /client/proc/ban_class
//-------------------------------------------------------------------------------------------------------------------
/client/proc/send_combatants()
	set name = "Send combatants away"
	set category = "Tournaments"
	if (!holder)	return

	for (var/mob/living/carbon/human/M in world)
		if (M.color == RED)
			M.loc = pick(tdome1)
		if (M.color == GREEN)
			M.loc = pick(tdome2)
		M.revive()
		M.weakened = 2
		M.Life()

	for (var/obj/machinery/door/poddoor/P in world)
		if (P.id == "thunderdome")
			spawn(0)	P.close(1)
//-------------------------------------------------------------------------------------------------------------------
/client/proc/clear_thunder1()
	set name = "Remove general mess"
	set category = "Tournaments"
	if (!holder)	return

	for (var/obj/item/I in get_area_all_atoms(/area/tdome))
		qdel(I)
	for (var/obj/item/clothing/C in get_area_all_atoms(/area/tdome))
		qdel(C)
	for (var/obj/effect/decal/D in get_area_all_atoms(/area/tdome))
		qdel(D)
	for (var/obj/item/ammo_casing/X in get_area_all_atoms(/area/tdome))
		qdel(X)
	for (var/mob/living/simple_animal/X in get_area_all_atoms(/area/tdome))
		qdel(X)

/client/proc/clear_thunder2()
	set name = "Remove players"
	set category = "Tournaments"
	if (!holder)	return
	for (var/mob/living/carbon/human/M in get_area_all_atoms(/area/tdome))
		if (M.color in list(RED, GREEN))
			for (var/obj/item/I in M)
				if (istype(I, /obj/item/weapon/implant))
					continue
				qdel(I)
			M.ghostize(0)
			qdel(M)
	end = 1
//-------------------------------------------------------------------------------------------------------------------
/client/proc/set_green_equip()
	set name = "Set green tea equipment"
	set category = "Tournaments"
	if (!holder)	return

	set_equip_tournament(GREEN)

/client/proc/set_red_equip()
	set name = "Set red team equipment"
	set category = "Tournaments"
	if (!holder)	return

	set_equip_tournament(RED)
//-------------------------------------------------------------------------------------------------------------------
/client/proc/toggle_the_doors()
	set name = "Toggle doors"
	set category = "Tournaments"
	if (!holder)	return

	for (var/obj/machinery/door/poddoor/P in world)
		if (P.id == "thunderdome")
			if (P.density) //What the fuck?
				spawn(0)	P.open(1)
			else
				spawn(0)	P.close(1)
//-------------------------------------------------------------------------------------------------------------------
/client/proc/unfreeze()
	set name = "Unfreeze combatants"
	set category = "Tournaments"
	if (!holder)	return

	for (var/mob/living/carbon/human/M in get_area_all_atoms(/area/tdome))
		if (M.color in list(RED, GREEN))
			M.stunned = 0
			M << "\red \bold You've been unfrozen"
//-------------------------------------------------------------------------------------------------------------------
/client/proc/start_fight()
	set name = "Start"
	set category = "Tournaments"
	if (!holder)	return

	end = 0

	for (var/mob/living/carbon/human/M in get_area_all_atoms(/area/tdome))
		if (M.color in list(RED, GREEN))
			M.stunned = 0

	for (var/obj/machinery/door/poddoor/P in world)
		if (P.id == "thunderdome")
			spawn(0)	P.open(1)

	players_tracker()
	world << "\red \bold The fight starts!"

/proc/players_tracker()
	var/list/mob/living/carbon/mobs = list()
	var/list/teams = list()
	var/list/people_alive = list()

	people_alive["Red"] = 0
	people_alive["Green"] = 0

	for (var/mob/living/carbon/human/X in get_area_all_atoms(/area/tdome))
		if (X.color == RED)
			mobs[X.ckey] = X
			teams[X.ckey] = RED
			people_alive["Red"]++

		if (X.color == GREEN)
			mobs[X.ckey] = X
			teams[X.ckey] = GREEN
			people_alive["Green"]++

	spawn while (1)
		if (end)
			for (var/datum/tournament/timer/T in timers)
				T.deactivated = 1
			return

		for (var/ckey in mobs)
			var/mob/living/carbon/the_mob = mobs[ckey]
			if (!the_mob || the_mob.health <= 0)
				people_alive[teams[ckey] == RED ? "Red" : "Green"]--
				world << "\red \bold The [teams[ckey] == RED ? "red" : "green"] team has lost [ckey]. Alive left: [people_alive[teams[ckey] == RED ? "red" : "green"]]"

		if (people_alive["Red"] == 0 && people_alive["Red"] == people_alive["Green"])
			world << "\red \bold Draw!"
			end = 1

		else if (!people_alive["Red"])
			world << "\red \bold The green team wins!<br>Alive:"
			for (var/ckey in mobs)
				if (teams[ckey] == GREEN)
					world << "\red \bold	[ckey]"
			end = 1

		else if (!people_alive["Green"])
			world << "\red \bold The red team wins!<br>Alive:"
			for (var/ckey in mobs)
				if (teams[ckey] == RED)
					world << "\red \bold	[ckey]"
			end = 1

		if (end)
			for (var/datum/tournament/timer/T in timers)
				T.deactivated = 1
			return
		sleep(1)
//-------------------------------------------------------------------------------------------------------------------
var/datum/tournament/timer/timers = list()

/client/proc/activate_timer()
	set name = "Activate timer"
	set category = "Tournaments"
	if (!holder)	return

	var/timer_types = list("Damage", "Force", "Speed")

	var/set_to = input(usr) as num
	var/timer_type = input(usr) in timer_types

	new /datum/tournament/timer(set_to, timer_type)

/client/proc/deactivate_timer()
	set name = "Deactivate timers"
	set category = "Tournaments"
	if (!holder)	return

	for (var/datum/tournament/timer/T in timers)
		T.deactivated = 1

/datum/tournament/timer
	var/timer_type = 0
	var/timer_set = 0
	var/counter = 0
	var/lst_announce = 0
	var/deactivated = 0
	var/name = ""

	New(setting, timer_type)
		..()
		src.timer_type = timer_type
		src.timer_set = setting
		timers += src
		announce()
		activate_timer()

	proc/announce()
		var/type_string = ""
		switch (timer_type)
			if ("Damage")
				type_string = "damaging"
			if ("Force")
				type_string = "instagib"
			if ("Speed")
				type_string = "slowing"
		var/what_it_does = ""
		switch (timer_type)
			if ("Damage")
				what_it_does = "All players will get [100/timer_set] damage a sec."
			if ("Force")
				what_it_does = "All weapons will gain additional damage."
			if ("Speed")
				what_it_does = "All players will lose their body temperature until -273.15 C"

		world << "\red \bold \A [type_string] timer for [timer_set] seconds has been set. [what_it_does]"

	proc/activate_timer()
		spawn while (1)
			if (deactivated)
				timers -= src
				del(src)
				return
			for (var/mob/living/carbon/human/M in get_area_all_atoms(/area/tdome))
				if (M.color in list(RED, GREEN))
					switch(timer_type)
						if ("Speed")
							M.bodytemperature = BODYTEMP_COLD_DAMAGE_LIMIT - ((counter / timer_set) * (10*COLD_SLOWDOWN_FACTOR))
							// At the end they get +10 movement delay
							M.Life()
						if ("Damage")
							M.adjustCloneLoss(100 / timer_set)

				for (var/obj/item/I in M)
					if (timer_type != "Force")	break
					if (I.force)
						I.force = (counter / timer_set) * (100 - initial(I.force)) + initial(I.force)
					if (I.throwforce)
						I.throwforce = (counter / timer_set) * (100 - initial(I.throwforce)) + initial(I.throwforce)

			for (var/obj/item/I in get_area_all_atoms(/area/tdome))
				if (timer_type != "Force")	break
				if (I.force)
					I.force = (counter / timer_set) * (100 - initial(I.force)) + initial(I.force)
				if (I.throwforce)
					I.throwforce = (counter / timer_set) * (100 - initial(I.throwforce)) + initial(I.throwforce)

			if (round(counter / (timer_set / 10)) > lst_announce)
				world << "\red \bold Time left: [timer_set - counter] seconds"
				lst_announce = round(counter / (timer_set / 10))

			counter++

			if (timer_set <= counter)
				world << "\red \bold Time is up"
				timers -= src
				del(src)
				return
			sleep(10)
//-------------------------------------------------------------------------------------------------------------------

/*
Done :1. Implement V+
*/


var/datum/tournament/equipment_controller/EController = new

/client/proc/equipment_panel()
	set name = "Equipment panel"
	set category = "Tournaments"
	if (!holder)	return

	EController.open_for(usr)

/datum/tournament/equip_set
	var/name = ""
	var/list/datum/tournament/equip_piece/pieces = list()

/datum/tournament/equip_piece
	var/spawn_type = /obj
	var/list/datum/tournament/equip_piece/to_pieces = list()
	var/datum/tournament/equip_piece/from_piece
	var/datum/tournament/equip_set/super
	var/list/vars_names = list()
	var/list/new_values = list()

/datum/tournament/equipment_controller
	var/list/datum/tournament/equip_set/sets = list()

	proc/get_tabs(number)
		var/result = ""
		for (var/i=1, i<=number, i++)
			result += "  "
		return result

	var/data_html = ""
	proc/recursive_depth_data_html(datum/tournament/equip_piece/curnode, depth) //
		data_html += "[get_tabs(depth)][curnode.spawn_type] <a href='?src=\ref[src];add_content=\ref[curnode]'>+</a> <a href='?src=\ref[src];delete_piece=\ref[curnode]'>-</a> <a href='?src=\ref[src];add_var=\ref[curnode]'>v+</a><br>"

		for (var/indx = 1, indx<=curnode.vars_names.len, indx++)
			data_html += "[get_tabs(depth+1)][curnode.vars_names[indx]] = [curnode.new_values[indx]] <a href='?src=\ref[src];source=\ref[curnode];delete_var=[indx]'>v-</a> <a href='?src=\ref[src];source=\ref[curnode];edit_varname=[indx]'>~n</a> <a href='?src=\ref[src];source=\ref[curnode];edit_varvalue=[indx]'>~v</a><br>"

		for (var/datum/tournament/equip_piece/E in curnode.to_pieces)
			recursive_depth_data_html(E, depth+1)


	var/export_string = ""


	proc/recursive_depth_export_string(datum/tournament/equip_piece/curnode)
		export_string += "\[[curnode.spawn_type]:"
		for (var/indx = 1, indx<=curnode.vars_names.len, indx++)
			export_string += "[curnode.vars_names[indx]]=[curnode.new_values[indx]]"
			if (indx < curnode.vars_names.len)
				export_string += ","
		export_string += ":"
		var/i = 0 //Fuck you
		for (var/datum/tournament/equip_piece/E in curnode.to_pieces)
			i++
			recursive_depth_export_string(E)
			if (i < curnode.to_pieces.len)
				export_string += ","
		export_string += "\]"


	proc/get_equip_data()
		data_html = "" //Null the data
		for (var/datum/tournament/equip_set/E in sets)
			data_html += "[E.name] <a href='?src=\ref[src];add_piece_to=\ref[E]'>+</a> <a href='?src=\ref[src];delete_set=\ref[E]'>-</a> <a href='?src=\ref[src];export_set=\ref[E]'>S</a><br>"
			for (var/datum/tournament/equip_piece/F in E.pieces)
				recursive_depth_data_html(F, 1)
		return data_html

	proc/get_export_string_of_sets(list/datum/tournament/equip_set/E)
		export_string = ""
		for (var/datum/tournament/equip_set/F in E)
			export_string += "{"
			export_string += "[F.name]:"
			for (var/datum/tournament/equip_piece/G in F.pieces)
				recursive_depth_export_string(G)
			export_string += "}"
		return export_string

	proc/perform_import(the_string)


	proc/open_for(var/mob/user)
		var/dat = ""

		dat += "<a href='?src=\ref[src];add_set=1'>+</a> <a href='?src=\ref[src];import_sets=1'>G</a> <a href='?src=\ref[src];export_sets=1'>S</a><br><br>"
		dat += get_equip_data()

		user << browse(dat, "window=equippanel")

	Topic(href, href_list)
		if (href_list["add_set"])
			var/set_name = input(usr, "Enter a name for new set") as text
			if (!set_name)
				return
			var/datum/tournament/equip_set/new_set = new /datum/tournament/equip_set
			new_set.name = set_name
			sets += new_set

		if (href_list["add_piece_to"])
			var/piece_type = input(usr, "Enter a type for new piece") as text
			if (!piece_type)
				return
			if (text2path(piece_type))
				var/datum/tournament/equip_piece/new_piece = new
				new_piece.spawn_type = text2path(piece_type)
				var/datum/tournament/equip_set/source = locate(href_list["add_piece_to"])
				source.pieces += new_piece
				new_piece.super = source
			else
				usr << "\red Incorrect path"

		if (href_list["add_content"])
			var/piece_type = input(usr, "Enter a type for new piece") as text
			if (!piece_type)
				return
			if (text2path(piece_type))
				var/datum/tournament/equip_piece/new_piece = new
				var/datum/tournament/equip_piece/source = locate(href_list["add_content"])
				new_piece.spawn_type = text2path(piece_type)
				new_piece.from_piece = source
				source.to_pieces += new_piece
			else
				usr << "\red Incorrect path"

		if (href_list["delete_piece"])
			var/datum/tournament/equip_piece/piece = locate(href_list["delete_piece"]) // Piece in question
			if (piece.super) // Parent piece
				piece.super.pieces -= piece // Exclude the piece
				piece.super = null
			if (piece.from_piece)
				piece.from_piece.to_pieces -= piece
				piece.from_piece = null

		if (href_list["delete_set"])
			sets ^= locate(href_list["delete_set"])
			del(locate(href_list["delete_set"]))

		if (href_list["export_set"])
			usr << browse(get_export_string_of_sets(list(locate(href_list["export_set"]))), "window=setstring")

		if (href_list["export_sets"])
			usr << browse(get_export_string_of_sets(sets), "window=setstring")

		if (href_list["add_var"])
			var/datum/tournament/equip_piece/piece = locate(href_list["add_var"])
			var/varname = input(usr, "Enter the name of var (or multiple references ending each with . as in obj1.obj2.var)")
			var/list/types = list("num", "text")
			var/vartype = input(usr, "Select the type of the var") in types
			var/varvalue
			switch (vartype)
				if ("num")
					varvalue = input(usr, "Enter the value") as num
				if ("text")
					varvalue = input(usr, "Enter the value") as text
			piece.vars_names += varname
			piece.new_values += varvalue

		if (href_list["delete_var"])
			var/datum/tournament/equip_piece/piece = locate(href_list["source"])
			var/indx = text2num(href_list["delete_var"])
			var/list/new_vars_names = list()
			var/list/new_new_values = list()
			for (var/i = 1, i<=length(piece.vars_names), i++)
				if (i != indx)
					new_vars_names += piece.vars_names[i]
					new_new_values += piece.new_values[i]
			piece.vars_names = new_vars_names
			piece.new_values = new_new_values

		if (href_list["edit_varname"])
			var/datum/tournament/equip_piece/piece = locate(href_list["source"])
			var/indx = text2num(href_list["edit_varname"])
			piece.vars_names[indx] = input(usr, "Enter new name")

		if (href_list["edit_varvalue"])
			var/datum/tournament/equip_piece/piece = locate(href_list["source"])
			var/indx = text2num(href_list["edit_varvalue"])
			var/t = (isnum(piece.new_values[indx]) ? 1 : 0)
			if (t)
				piece.new_values[indx] = input(usr, "Enter new value") as num
			else
				piece.new_values[indx] = input(usr, "Enter new value")

		open_for(usr)

/proc/set_equip_tournament(the_color) //Copypaste of cmd
	var/list/dresspacks = list(
		"naked",
		"as job...",
		"standard space gear",
		"Emergency Response Team Engineer",
		"Emergency Response Team Medic",
	    "Emergency Response Team Commander",
	    "SWAT",
		"SpecOps" ,
		"death commando",
		"centcom official",
		"tournament standard red",
		"tournament standard green",
		"tournament botanist",
		"tournament chef",
		"tournament assistant",
		"laser tag red",
		"laser tag blue",
		"pirate",
		"knight",
		"soviet admiral",
		"tunnel clown",
		"masked killer",
		"assassin",
		"mobster",
		"blue wizard",
		"red wizard",
		"marisa wizard",
		"Crowd Control"
		)
	var/dresscode = input("Select dress for the team of [the_color] HEX color", "Robust quick dress shop") as null|anything in dresspacks
	if (isnull(dresscode))
		return

	var/datum/job/jobdatum
	if (dresscode == "as job...")
		var/jobname = input("Select job", "Robust quick dress shop") as null|anything in get_all_jobs()
		if(isnull(jobname))
			return
		jobdatum = SSjob.GetJob(jobname)

	for (var/mob/living/carbon/human/M in get_area_all_atoms(/area/tdome))
		if(M.color == the_color)
			for (var/obj/item/I in M)
				if (istype(I, /obj/item/weapon/implant))
					continue
				qdel(I)
			switch(dresscode)
				if("SWAT")
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat/swat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent/commander(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/military(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/weapon/katana/energy(M), slot_l_hand)
					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Emergency Response Team")
					W.assignment = "Special Ops Officer"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/holster(M), slot_belt)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/shield/energy(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife/combat(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse/pistol/m1911(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/swat(M), slot_head)

				if("Crowd Control")

					M.equip_to_slot_or_del(new /obj/item/clothing/under/lawyer/blacksuit, slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/weapon/scrying/control(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/crowdcontrol(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/tie/waistcoat(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)

				if ("naked")
					//do nothing

				if ("as job...")
					if(jobdatum)
						dresscode = jobdatum.title
						M.job = jobdatum.title
						jobdatum.equip(M)

				if ("standard space gear")
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)

					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/space(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space(M), slot_head)
					var /obj/item/weapon/tank/jetpack/J = new /obj/item/weapon/tank/jetpack/oxygen(M)
					M.equip_to_slot_or_del(J, slot_back)
					J.toggle()
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(M), slot_wear_mask)
					J.Topic(null, list("stat" = 1))

				if ("tournament standard red","tournament standard green") //we think stunning weapon is too overpowered to use it on tournaments. --rastaf0
					if (dresscode=="tournament standard red")
						M.equip_to_slot_or_del(new /obj/item/clothing/under/color/red(M), slot_w_uniform)
					else
						M.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)

					M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/thunderdome(M), slot_head)

					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse/destroyer(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/grenade/smokebomb(M), slot_r_store)

				if ("Emergency Response Team Engineer") //Special for Vadkop Code Red or Delta


					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat/swat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/saber(M), slot_l_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/hardsuit/ert/engi(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(M), slot_belt)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent/commander(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/engi(M), slot_s_store)
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/sechailer(M), slot_wear_mask)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/meson/engine(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse(M), slot_r_hand)

					M.equip_to_slot_or_del(new /obj/item/weapon/rcd/combat(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(M), slot_back)
					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Emergency Response Team")
					W.assignment = "Emergency Response Team Commander"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)
				if ("Emergency Response Team Medic") //Special for Vadkop. Code Red or Delta
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat/swat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/saber(M), slot_l_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)   ///obj/item/weapon/storage/belt/medical
					M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical(M), slot_belt)


					M.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/engi(M), slot_s_store)
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/sechailer(M), slot_wear_mask)

					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent/commander(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/hardsuit/ert/med(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/engi(M), slot_s_store)

					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse(M), slot_r_hand)

					M.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/tactical(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box/bodybags(M), slot_in_backpack)
					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Emergency Response Team")
					W.assignment = "Emergency Response Team Commander"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)



				if ("Emergency Response Team Commander") //Special for Vadkop. Code Red or Delta
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat/swat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box/handcuffs(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/sechailer(M), slot_wear_mask)

					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/engi(M), slot_s_store)

					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent/commander(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/hardsuit/ert(M), slot_wear_suit)


					M.equip_to_slot_or_del(new /obj/item/weapon/grenade/flashbang(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/engi(M), slot_s_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/mateba(M), slot_belt)

					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse(M), slot_r_hand)

					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(M), slot_back)

					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Emergency Response Team")
					W.assignment = "Emergency Response Team Commander"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)



				if("death commando")

					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent/commander(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat/swat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/hardsuit/deathsquad(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)

					M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/sechailer(M), slot_wear_mask)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(M), slot_glasses)

					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)

					M.equip_to_slot_or_del(new /obj/item/ammo_box/a357(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/regular(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box/flashbangs(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/device/flashlight(M), slot_in_backpack)

					M.equip_to_slot_or_del(new /obj/item/weapon/c4(M), slot_in_backpack)

					M.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(M), slot_l_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/grenade/flashbang(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/tank/internals/emergency_oxygen/engi (M), slot_s_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/mateba(M), slot_belt)

					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/shield/energy(M), slot_l_hand)

					var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(M)
					L.imp_in = M
					L.implanted = 1

					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Death Commando")
					W.assignment = "Death Commando"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)

				if("centcom official")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/headset_com(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(M), slot_belt)
					M.equip_to_slot_or_del(new /obj/item/weapon/pen(M), slot_l_store)

					var/obj/item/device/pda/heads/pda = new(M)
					pda.owner = M.real_name
					pda.ownjob = "Centcom Official"
					pda.update_label()

					M.equip_to_slot_or_del(pda, slot_r_store)

					M.equip_to_slot_or_del(new /obj/item/weapon/clipboard(M), slot_l_hand)

					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_centcom_access("Centcom Official")
					W.assignment = "Centcom Official"
					W.registered_name = M.real_name//No station access
					W.access += access_weapons
					W.update_label()
					M.equip_to_slot_or_del(W, slot_wear_id)


				if ("tournament botanist")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics (M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)

					M.equip_to_slot_or_del(new /obj/item/clothing/suit/sweater/green(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/rasta(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/hatchet(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/hatchet(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/hatchet(M), slot_l_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/hatchet(M), slot_r_store)


				if ("SpecOps") //Special for Gazbax
					M.equip_to_slot_or_del(new /obj/item/clothing/under/syndicate(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat/swat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent/commander(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/cigar/havana(M), slot_wear_mask)

					M.equip_to_slot_or_del(new /obj/item/clothing/suit/space/officer(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/beret(M), slot_head)


					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse/pistol/m1911(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/shield/energy(M), slot_l_store)

					M.equip_to_slot_or_del(new /obj/item/weapon/lighter/zippo(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)

					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Special Ops Officer")
					W.assignment = "Special Ops Officer"
					W.registered_name = M.real_name
					W.update_label()
					M.equip_to_slot_or_del(W, slot_wear_id)

				if ("tournament chef") //Steven Seagal FTW
					M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/toggle/chef(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/rollingpin(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife(M), slot_s_store)

				if ("tournament assistant")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/extinguisher(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)


				if ("laser tag red")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/red(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/red(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/red(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/redtaghelm(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/redtag(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/laser/redtag(M), slot_s_store)

				if ("laser tag blue")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/blue(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/blue(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/blue(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/bluetaghelm(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/bluetag(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/laser/bluetag(M), slot_s_store)

				if ("pirate")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/pirate(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/bandana(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/pirate(M), slot_r_hand)

				if ("knight")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/brown(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/knight/red(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/knight/red(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/weapon/shield/riot/buckler(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/claymore(M), slot_r_hand)

				if("tunnel clown")//Tunnel clowns rule!
					M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/black(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(M), slot_wear_mask)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/hooded/chaplain_hoodie(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(M), slot_l_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(M), slot_r_store)

					var/obj/item/weapon/card/id/W = new(M)
					W.access = get_all_accesses()
					W.assignment = "Tunnel Clown!"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)

					var/obj/item/weapon/twohanded/fireaxe/fire_axe = new(M)
					M.equip_to_slot_or_del(fire_axe, slot_r_hand)

				if("masked killer")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/overalls(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/white(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/latex(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(M), slot_wear_mask)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/welding(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/kitchen/knife(M), slot_l_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/scalpel(M), slot_r_store)

					var/obj/item/weapon/twohanded/fireaxe/fire_axe = new(M)
					M.equip_to_slot_or_del(fire_axe, slot_r_hand)

					for(var/obj/item/carried_item in M.contents)
						if(!istype(carried_item, /obj/item/weapon/implant))//If it's not an implant.
							carried_item.add_blood(M)//Oh yes, there will be blood...

				if("assassin")
					var/obj/item/clothing/under/U = new /obj/item/clothing/under/suit_jacket(M)
					M.equip_to_slot_or_del(U, slot_w_uniform)
					U.attachTie(new /obj/item/clothing/tie/waistcoat(M))
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/black(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/black(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword/saber(M), slot_l_store)

					var/obj/item/weapon/storage/secure/briefcase/sec_briefcase = new(M)
					for(var/obj/item/briefcase_item in sec_briefcase)
						qdel(briefcase_item)
					for(var/i=3, i>0, i--)
						sec_briefcase.contents += new /obj/item/stack/spacecash/c1000
					sec_briefcase.contents += new /obj/item/weapon/gun/energy/kinetic_accelerator/crossbow
					sec_briefcase.contents += new /obj/item/weapon/gun/projectile/revolver/mateba
					sec_briefcase.contents += new /obj/item/ammo_box/a357
					sec_briefcase.contents += new /obj/item/weapon/c4
					M.equip_to_slot_or_del(sec_briefcase, slot_l_hand)

					var/obj/item/device/pda/heads/pda = new(M)
					pda.owner = M.real_name
					pda.ownjob = "Reaper"
					pda.update_label()

					M.equip_to_slot_or_del(pda, slot_belt)

					var/obj/item/weapon/card/id/syndicate/W = new(M)
					W.access = get_all_accesses()
					W.assignment = "Reaper"
					W.registered_name = M.real_name
					W.update_label(M.real_name)
					M.equip_to_slot_or_del(W, slot_wear_id)

				if("blue wizard")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/spellbook(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/device/flashlight/staff(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)

				if("red wizard")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/red(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/red(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/spellbook(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/device/flashlight/staff(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)

				if("marisa wizard")
					M.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(M), slot_w_uniform)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/marisa(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal/marisa(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/marisa(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/weapon/teleportation_scroll(M), slot_r_store)
					M.equip_to_slot_or_del(new /obj/item/weapon/spellbook(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/device/flashlight/staff(M), slot_l_hand)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/box(M), slot_in_backpack)

				if("soviet admiral")
					M.equip_to_slot_or_del(new /obj/item/clothing/head/hgpiratecap(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cent(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/eyepatch(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/clothing/suit/hgpirate(M), slot_wear_suit)
					M.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(M), slot_back)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/mateba(M), slot_belt)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/soviet(M), slot_w_uniform)

					var/obj/item/weapon/card/id/W = new(M)
					W.icon_state = "centcom"
					W.access = get_all_accesses()
					W.access += get_centcom_access("Admiral")
					W.assignment = "Admiral"
					W.registered_name = M.real_name
					W.update_label()
					M.equip_to_slot_or_del(W, slot_wear_id)

				if("mobster")
					M.equip_to_slot_or_del(new /obj/item/clothing/head/fedora(M), slot_head)
					M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
					M.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/black(M), slot_gloves)
					M.equip_to_slot_or_del(new /obj/item/device/radio/headset(M), slot_ears)
					M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(M), slot_glasses)
					M.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/tommygun(M), slot_r_hand)
					M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/really_black(M), slot_w_uniform)

					var/obj/item/weapon/card/id/W = new(M)
					W.assignment = "Assistant"
					W.registered_name = M.real_name
					W.update_label()
					M.equip_to_slot_or_del(W, slot_wear_id)



			M.regenerate_icons()

/client/proc/make_test_site()
	set name = "Make a test site"
	set category = "Tournaments"
	set background = 1
	if (!holder)	return

	var/turf/center = get_turf(usr)
	var/radius = input(usr, "Enter the radius of the test site") as num

	var/turf/left_up_tile = locate(center.x - radius - 1, center.y - radius - 1, center.z)
	var/turf/right_down_tile = locate(center.x + radius + 1, center.y + radius + 1, center.z)
	var/list/turf/affected = block(left_up_tile, right_down_tile)

	// Clear up the area

	for (var/turf/T in affected)
		new /area/space (T)
		var/dist = round(((T.x - center.x)**2 + (T.y - center.y)**2)**0.5)
		if (dist <= radius)
			for (var/atom/X in T)
				if (!istype(X, /mob/dead/observer))
					qdel(X)
			new /area/toxins/test_area(T)
		if (dist == radius)
			var/turf/W = new /turf/simulated/wall(T)
			W.CalculateAdjacentTurfs()
			SSair.add_to_active(W,1)
		if (dist < radius)
			var/turf/W = new /turf/simulated/floor(T)
			W.CalculateAdjacentTurfs()
			SSair.add_to_active(W,1)

	usr << "\red \bold The test site has been created"

#undef RED
#undef GREEN