//happy prigraming word

/obj/item/robot_parts/equippable/simple_tool
	var/obj/tool = null
	force = 0

/obj/item/robot_parts/equippable/simple_tool/attach_to_robot(var/mob/living/silicon/robot/M)
	M.module.modules += tool
	tool.loc = M.module
	M.module.rebuild()  //No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/simple_tool/detach_from_robot(var/mob/living/silicon/robot/M)
	M.uneq_module(tool)
	M.module.modules -= tool
	tool.loc = src
	M.module.rebuild()			//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/simple_tool/small

//======crowbar======

/obj/item/robot_parts/equippable/simple_tool/small/crowbar
	name = "embeddable crowbar"
	desc = "Cyborg module which allows cowbar using."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"

/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red
	name = "embeddable crowbar"
	desc = "Cyborg module which allows cowbar using."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"

/obj/item/robot_parts/equippable/simple_tool/small/crowbar/New()
	..()
	tool = new /obj/item/weapon/crowbar(src)

/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red/New()
	..()
	tool = new /obj/item/weapon/crowbar/red(src)

//======wrench======

/obj/item/robot_parts/equippable/simple_tool/small/wrench
	name = "embeddable wrench"
	desc = "Cyborg module which allows wrench using."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"

/obj/item/robot_parts/equippable/simple_tool/small/wrench/New()
	..()
	tool = new /obj/item/weapon/wrench(src)

//======screwdriver======

/obj/item/robot_parts/equippable/simple_tool/small/screwdriver
	name = "embeddable screwdriver"
	desc = "Cyborg module which allows screwdriver using."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"

/obj/item/robot_parts/equippable/simple_tool/small/screwdriver/New()
	..()
	tool = new /obj/item/weapon/screwdriver(src, "yellow")

//======wirecutters======

/obj/item/robot_parts/equippable/simple_tool/small/wirecutters
	name = "embeddable wirecutters"
	desc = "Cyborg module which allows wirecutters using."
	icon = 'icons/obj/items.dmi'
	icon_state = "wirecutters"

/obj/item/robot_parts/equippable/simple_tool/small/wirecutters/New()
	..()
	tool = new /obj/item/weapon/wirecutters(src, "yellow")

//======analyzer======

/obj/item/robot_parts/equippable/simple_tool/small/analyzer
	name = "embeddable analyzer"
	desc = "Cyborg module which allows analyzer using."
	icon_state = "atmos"
	item_state = "analyzer"

/obj/item/robot_parts/equippable/simple_tool/small/analyzer/New()
	..()
	tool = new /obj/item/device/analyzer(src)