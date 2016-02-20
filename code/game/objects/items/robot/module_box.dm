//happy prigraming word

/obj/item/robot_parts/equippable/module_box
	name = "cyborg modular printer"
	desc = "Prints chosen equipmen from itself"
	icon_state = "module_box"
	item_state = "syringe_kit"
	origin_tech = "materials=1;programming=1;powerstorage=1"
	force = 3
	throwforce = 5
	var/obj/control_panell = null
	var/list/avalable_equipment_sets = list("Standard", "Engineering", "Medical")
	// for save list("Standard", "Engineering", "Medical", "Miner", "Janitor","Service", "Security")

	/obj/item/robot_parts/equippable/module_box/proc/Print_module(var/mob/living/silicon/robot/M)
		if (!istype(loc, /obj/item/robot_parts/chest))
			return
			// cat print equipmen only in borg chests
		var/obj/item/robot_parts/chest/CH = loc
		var/chosen_set = input("Please, select a equipment set!", "Robot", null, null) in avalable_equipment_sets
		if(!src.check_enough_plase(chosen_set, CH))
			M << "<span class='warning'>There are not enogh plase for [chosen_set] equipment set.</span>"
			return

		src.detach_from_robot(M)
		CH.modules -= src
		CH.free_module_slots += 1
		switch(chosen_set)
			if("Standard")
				modules += new /obj/item/robot_parts/equippable/simple_tool/small/crowbar/red(CH)
				modules += new /obj/item/robot_parts/equippable/simple_tool/small/wrench(CH)

			if("Engineering")
				modules += new /obj/item/robot_parts/equippable/cyborg_toolbox/engineering(CH)

			if("Medical")
				modules += new /obj/item/robot_parts/equippable/cyborg_toolbox/medical(CH)



		for (var/obj/item/robot_parts/T in modules)
			CH.modules += T
			CH.free_module_slots -= 1
			T.attach_to_robot(M)
			modules -= T
		M.hud_used.update_robot_modules_display()
		qdel(src)

	/obj/item/robot_parts/equippable/module_box/proc/check_enough_plase(var/chosen_set, var/obj/item/robot_parts/chest/CH)
		switch(chosen_set)
			if("Standard")
				return (CH.free_module_slots >= 1)

			if("Engineering")
				return (CH.free_module_slots >= 0)

			if("Medical")
				return (CH.free_module_slots >= 0)

		return 0


/obj/item/robot_parts/module_box_control_panell
	force = 0
	name = "cyborg modular printer"
	icon_state = "module_box"
	desc = "Activate and choose one of usefull equipment sets"
	var/obj/item/robot_parts/equippable/module_box/Box =null

/obj/item/robot_parts/equippable/module_box/New()
	..()
	control_panell = new/obj/item/robot_parts/module_box_control_panell(src)

/obj/item/robot_parts/module_box_control_panell/New(var/B)
	..()
	if(istype(loc,/obj/item/robot_parts/equippable/module_box))
		Box = B


/obj/item/robot_parts/equippable/module_box/attach_to_robot(var/mob/living/silicon/robot/M)
	M.module.modules += control_panell
	control_panell.loc = M.module
	M.module.rebuild()  		//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/module_box/detach_from_robot(var/mob/living/silicon/robot/M)
	M.uneq_module(control_panell)
	M.module.modules -= control_panell
	control_panell.loc = src
	M.module.rebuild()

/obj/item/robot_parts/module_box_control_panell/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(Box)
			Box.Print_module(user)
