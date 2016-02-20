//happy prigraming word

/obj/item/robot_parts/equippable/cyborg_toolbox
	var/max_module_slots = 7
	var/free_module_slots = 7
	name = "cyborg toolbox"
	desc = "Provides robots acsess to it's contents.\nUsefull to save some free space"
	icon_state = "toolbox"
	item_state = "syringe_kit"
	origin_tech = "combat=1"
	force = 15
	throwforce = 18

/obj/item/robot_parts/equippable/cyborg_toolbox/attack_self(mob/user as mob)
	if (user.stat)
		return

	var/turf/T = get_turf(src)
	if (modules)
		for(var/obj/C in modules)
			C.loc = T
			modules -= C
	free_module_slots = max_module_slots


/obj/item/robot_parts/equippable/cyborg_toolbox/attackby(var/obj/item/robot_parts/equippable/simple_tool/small/T as obj, mob/user as mob, params)
	if(!istype(T, /obj/item/robot_parts/equippable/simple_tool/small))
		user << "<span class='warning'>You can't put [T] in [src]. [T] won't fit in.</span>"
		return
	else
		if(free_module_slots <= 0)
			user << "<span class='warning'> There are no more free space in [src]</span>"
			return
		else
			free_module_slots -= 1
			user.drop_item()
			T.loc = src
			modules += T

//for engenering boorgs

/obj/item/robot_parts/equippable/cyborg_toolbox/engineering
	desc = "Provides robots acsess to it's contents.\nGoes with some enginering tools"
	icon_state = "toolbox_eng"

/obj/item/robot_parts/equippable/cyborg_toolbox/engineering/New()
	..()
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/crowbar(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/screwdriver(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/wirecutters(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/analyzer(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/wrench(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/t_scanner(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/multitool(src)
	free_module_slots = 0

//for medical borgs

/obj/item/robot_parts/equippable/cyborg_toolbox/medical
	desc = "Provides robots acsess to it's contents.\nGoes with some medical tools"
	icon_state = "toolbox_med"

/obj/item/robot_parts/equippable/cyborg_toolbox/medical/New()
	..()
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/retractor(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/hemostat(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/surgicaldrill(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/cautery(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/surgical_drapes(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/circular_saw(src)
	modules += new/obj/item/robot_parts/equippable/simple_tool/small/scalpel(src)
	free_module_slots = 0
