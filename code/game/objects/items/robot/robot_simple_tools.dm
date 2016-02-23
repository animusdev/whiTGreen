//happy prigraming word

/obj/item/robot_parts/equippable/simple_tool
	var/obj/item/tool = null
	force = 0

/obj/item/robot_parts/equippable/simple_tool/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(tool)
		if(M.module)
			M.module.modules += tool
			tool.loc = M.module
	M.module.rebuild()  		//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/simple_tool/detach_from_robot(var/mob/living/silicon/robot/M)
	if(tool)
		if(M.module)
			M.uneq_module(tool)
			M.module.modules.Remove(tool)
		tool.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
	holding_robot = null

/obj/item/robot_parts/equippable/simple_tool/New()
	..()
	if(tool.m_amt != 0 || tool.g_amt != 0)
		m_amt = tool.m_amt + 30
	if(tool.m_amt != 0 || tool.g_amt != 0)
		g_amt = tool.g_amt
	if(tool.origin_tech)
		origin_tech = tool.origin_tech

/obj/item/robot_parts/equippable/simple_tool/small

//======crowbar======

/obj/item/robot_parts/equippable/simple_tool/small/crowbar
	name = "modular crowbar"
	desc = "Cyborg module which allows cowbar using."
	icon_state = "crowbar"

/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red

/obj/item/robot_parts/equippable/simple_tool/small/crowbar/New()
	tool = new /obj/item/weapon/crowbar(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red/New()
	tool = new/obj/item/weapon/crowbar/red(src)
	..()

//======wrench======

/obj/item/robot_parts/equippable/simple_tool/small/wrench
	name = "modular wrench"
	desc = "Cyborg module which allows wrench using."
	icon_state = "wrench"

/obj/item/robot_parts/equippable/simple_tool/small/wrench/New()
	tool = new/obj/item/weapon/wrench(src)
	..()

//======screwdriver======

/obj/item/robot_parts/equippable/simple_tool/small/screwdriver
	name = "modular screwdriver"
	desc = "Cyborg module which allows screwdriver using."
	icon_state = "screwdriver"

/obj/item/robot_parts/equippable/simple_tool/small/screwdriver/New()
	tool = new/obj/item/weapon/screwdriver(src, "yellow")
	..()

//======wirecutters======

/obj/item/robot_parts/equippable/simple_tool/small/wirecutters
	name = "modular wirecutters"
	desc = "Cyborg module which allows wirecutters using."
	icon_state = "wirecutters"

/obj/item/robot_parts/equippable/simple_tool/small/wirecutters/New()
	tool = new/obj/item/weapon/wirecutters(src, "yellow")
	..()

//======analyzer======

/obj/item/robot_parts/equippable/simple_tool/small/analyzer
	name = "modular analyzer"
	desc = "Cyborg module which allows analyzer using."
	icon_state = "atmos_analyzer"

/obj/item/robot_parts/equippable/simple_tool/small/analyzer/New()
	tool = new/obj/item/device/analyzer(src)
	..()

//======multitool======

/obj/item/robot_parts/equippable/simple_tool/small/multitool
	name = "modular multitool"
	desc = "Cyborg module which allows multitool using."
	icon_state = "multitool"

/obj/item/robot_parts/equippable/simple_tool/small/multitool/New()
	tool = new/obj/item/device/multitool(src)
	..()

//======t_scanner======

/obj/item/robot_parts/equippable/simple_tool/small/t_scanner
	name = "modular T-ray scanner"
	desc = "Cyborg module which allows T-ray scanner using."
	icon_state = "t_scanner"

/obj/item/robot_parts/equippable/simple_tool/small/t_scanner/New()
	tool = new/obj/item/device/t_scanner(src)
	..()

//======scalpel======

/obj/item/robot_parts/equippable/simple_tool/small/scalpel
	name = "modular scalpel"
	desc = "Cyborg module which allows scalpel using."
	icon_state = "scalpel"

/obj/item/robot_parts/equippable/simple_tool/small/scalpel/New()
	tool = new/obj/item/weapon/scalpel(src)
	..()

//======circular_saw======

/obj/item/robot_parts/equippable/simple_tool/small/circular_saw
	name = "modular circular saw"
	desc = "Cyborg module which allows circular saw using."
	icon_state = "circular_saw"

/obj/item/robot_parts/equippable/simple_tool/small/circular_saw/New()
	tool = new/obj/item/weapon/circular_saw(src)
	..()

//======surgical_drapes======

/obj/item/robot_parts/equippable/simple_tool/small/surgical_drapes
	name = "modular surgical drapes"
	desc = "Cyborg module which allows surgical drapes using."
	icon_state = "surgical_drapes"

/obj/item/robot_parts/equippable/simple_tool/small/surgical_drapes/New()
	tool = new/obj/item/weapon/surgical_drapes(src)
	..()

//======cautery======

/obj/item/robot_parts/equippable/simple_tool/small/cautery
	name = "modular cautery"
	desc = "Cyborg module which allows cautery using."
	icon_state = "cautery"

/obj/item/robot_parts/equippable/simple_tool/small/cautery/New()
	tool = new/obj/item/weapon/cautery(src)
	..()

//======surgical_drill======

/obj/item/robot_parts/equippable/simple_tool/small/surgicaldrill
	name = "modular surgical drill"
	desc = "Cyborg module which allows surgical drill using."
	icon_state = "surgicaldrill"

/obj/item/robot_parts/equippable/simple_tool/small/surgicaldrill/New()
	tool = new/obj/item/weapon/surgicaldrill(src)
	..()

//======hemostat======

/obj/item/robot_parts/equippable/simple_tool/small/hemostat
	name = "modular hemostat"
	desc = "Cyborg module which allows hemostat using."
	icon_state = "hemostat"

/obj/item/robot_parts/equippable/simple_tool/small/hemostat/New()
	tool = new/obj/item/weapon/hemostat(src)
	..()

//======retractor======

/obj/item/robot_parts/equippable/simple_tool/small/retractor
	name = "modular retractor"
	desc = "Cyborg module which allows retractor using."
	icon_state = "retractor"

/obj/item/robot_parts/equippable/simple_tool/small/retractor/New()
	tool = new/obj/item/weapon/retractor(src)
	..()
