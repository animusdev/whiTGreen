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
	var/list/avalable_equipment_sets = list("Standard", "Engineering", "Medical", "Miner")
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
				modules += new/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red(CH)
				modules += new/obj/item/robot_parts/equippable/simple_tool/small/wrench(CH)

			if("Engineering")
				modules += new/obj/item/robot_parts/equippable/cyborg_toolbox/engineering(CH)
				modules += new/obj/item/robot_parts/equippable/sight/meson(CH)

			if("Medical")
				modules += new/obj/item/robot_parts/equippable/cyborg_toolbox/medical(CH)
				modules += new/obj/item/robot_parts/equippable/energy/fabricator/borghypo(CH)

			if("Miner")
				modules += new/obj/item/robot_parts/equippable/energy/gun_holder/kinetic_accelerator(CH)


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
				return (CH.free_module_slots >= 1)

			if("Medical")
				return (CH.free_module_slots >= 1)

			if("Miner")
				return (CH.free_module_slots >= 0)

		return 0

/obj/item/robot_parts/equippable/module_box/New()
	..()
	control_panell = new/obj/item/borg/controle/module_box(src)


/obj/item/robot_parts/equippable/module_box/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(M.module)
		if(control_panell)
			M.module.modules += control_panell
			control_panell.loc = M.module
			M.module.rebuild()  		//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/module_box/detach_from_robot(var/mob/living/silicon/robot/M)
	if(control_panell)
		M.uneq_module(control_panell)
		if(M.module)
			M.module.modules.Remove(control_panell)
		control_panell.loc = src
		if(M.module)
			M.module.rebuild()
	holding_robot = null
