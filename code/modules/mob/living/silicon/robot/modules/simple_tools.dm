//happy prigraming word

/obj/item/robot_parts/simple_tool
	var/obj/tool = null
	force = 0

/obj/item/robot_parts/simple_tool/attach_to_robot(var/mob/living/silicon/robot/M)
	M.module.modules += tool
	tool.loc = M.module
	M.module.rebuild()  //No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/simple_tool/detach_from_robot(var/mob/living/silicon/robot/M)//take robot from wich will be detach
	M.uneq_module(tool)
	M.module.modules -= tool
	tool.loc = src
	M.module.rebuild()  //No need to fix modules, as it's done in rebild()


//======crowbar======

/obj/item/robot_parts/simple_tool/crowbar
	name = "Embeddable crowbar"
	desc = "Cyborg module which allows cowbar using."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"

/obj/item/robot_parts/simple_tool/crowbar/red
	name = "Embeddable crowbar"
	desc = "Cyborg module which allows cowbar using."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"

/obj/item/robot_parts/simple_tool/crowbar/New()
	..()
	tool = new /obj/item/weapon/crowbar/cyborg

/obj/item/robot_parts/simple_tool/crowbar/red/New()
	..()
	var/obj/item/weapon/crowbar/cyborg/C = new /obj/item/weapon/crowbar/cyborg
	C.icon_state = "red_crowbar"
	tool = C

/obj/item/weapon/crowbar/cyborg
	name = "cyborg crowbar"
	desc = "A small crowbar. This handy tool is useful for lots of things, such as prying floor tiles or opening unpowered doors."
	var/storing_part = null

/obj/item/weapon/crowbar/cyborg/New(loc)
	..()
	if(istype(loc, /obj/item/robot_parts/simple_tool))  //do not put equipments into wrong places
		storing_part = loc

