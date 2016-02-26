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
	if(!tool)
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

//======healthanalyzer======

/obj/item/robot_parts/equippable/simple_tool/small/healthanalyzer
	name = "modular health analyzer"
	desc = "Cyborg module which allows health analyzer using."
	icon_state = "retractor"

/obj/item/robot_parts/equippable/simple_tool/small/healthanalyzer/New()
	tool = new/obj/item/device/healthanalyzer(src)
	..()

//======mining_scanner======

/obj/item/robot_parts/equippable/simple_tool/small/mining_scanner
	name = "modular mining scanner"
	desc = "Cyborg module which allows mining scanner using."
	icon_state = "mining_scanner"

/obj/item/robot_parts/equippable/simple_tool/small/mining_scanner/New()
	if(!tool)
		tool = new/obj/item/device/mining_scanner(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/small/mining_scanner/advanced
	name = "modular mining scanner"
	desc = "Cyborg module which allows mining scanner using, put some microprocessors in use."
	icon_state = "mining_scanner"

/obj/item/robot_parts/equippable/simple_tool/small/mining_scanner/advanced/New()
	tool = new/obj/item/device/t_scanner/adv_mining_scanner(src)
	..()

//=======SOAP=======

/obj/item/robot_parts/equippable/simple_tool/small/soap
	name = "modular soap"
	desc = "Cyborg module which allows soap using."
	icon_state = "soap"

/obj/item/robot_parts/equippable/simple_tool/small/soap/New()
	if(!tool)
		tool = new/obj/item/weapon/soap(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/small/soap/nanotrasen
	name = "modular soap"
	desc = "Cyborg module which allows soap using. Smells of plasma"
	icon_state = "soap_nt"

/obj/item/robot_parts/equippable/simple_tool/small/soap/nanotrasen/New()
	tool = new/obj/item/weapon/soap/nanotrasen(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/small/soap/deluxe
	name = "modular soap"
	desc = "Cyborg module which allows soap using."
	icon_state = "soap_deluxe"

/obj/item/robot_parts/equippable/simple_tool/small/soap/deluxe/New()
	tool = new/obj/item/weapon/soap/deluxe(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/small/soap/syndie
	name = "modular soap"
	desc = "Cyborg module which allows soap using."
	icon_state = "soap_sindi"

/obj/item/robot_parts/equippable/simple_tool/small/soap/syndie/New()
	tool = new/obj/item/weapon/soap/syndie(src)
	..()

//=======holosign_creator=======

/obj/item/robot_parts/equippable/simple_tool/small/holosign_creator
	name = "modular holographic sign projector"
	desc = "Cyborg module which allows holographic sign projector using."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "signmaker"
	item_state = "electronic"

/obj/item/robot_parts/equippable/simple_tool/small/holosign_creator/New()
	tool = new/obj/item/weapon/holosign_creator(src)
	..()

//=======pen=======

/obj/item/robot_parts/equippable/simple_tool/small/pen
	name = "modular pen"
	desc = "Cyborg module which allows pen using."
	icon_state = "pen"
	item_state = "pen"

/obj/item/robot_parts/equippable/simple_tool/small/pen/New()
	tool = new/obj/item/weapon/pen(src)
	..()

//=======pen=======

/obj/item/robot_parts/equippable/simple_tool/small/razor
	name = "modular razor"
	desc = "Cyborg module which allows razor using."
	icon_state = "razor"


/obj/item/robot_parts/equippable/simple_tool/small/razor/New()
	tool = new/obj/item/weapon/razor(src)
	..()

//=======zippo=======

/obj/item/robot_parts/equippable/simple_tool/small/zippo
	name = "modular zippo"
	desc = "Cyborg module which allows zippo using."
	icon_state = "zippo"


/obj/item/robot_parts/equippable/simple_tool/small/zippo/New()
	var/obj/item/weapon/lighter/zippo/Z = new/obj/item/weapon/lighter/zippo(src)
	Z.lit = 1
	tool = Z
	..()

//=======flash=======

/obj/item/robot_parts/equippable/simple_tool/small/flash
	name = "modular flash"
	desc = "Cyborg module which allows flash using."
	icon_state = "flash"
	item_state = "flashtool"
	icon = 'icons/obj/device.dmi'

/obj/item/robot_parts/equippable/simple_tool/small/flash/New()
	tool = new/obj/item/device/flash/cyborg(src)
	..()

//=======emag=======

/obj/item/robot_parts/equippable/simple_tool/small/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "modular cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	icon = 'icons/obj/card.dmi'

/obj/item/robot_parts/equippable/simple_tool/small/emag/New()
	tool = new/obj/item/weapon/card/emag(src)
	..()










//=======drill=======

/obj/item/robot_parts/equippable/simple_tool/drill
	name = "cyborg mining drill"
	desc = "An integrated electric mining drill."
	icon_state = "drill"

/obj/item/robot_parts/equippable/simple_tool/drill/New()
	if(!tool)
		tool = new/obj/item/weapon/pickaxe/drill(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/drill/diamond
	name = "cyborg mining drill"
	name = "diamond-tipped cyborg mining drill"
	icon_state = "drill_diamond"

/obj/item/robot_parts/equippable/simple_tool/drill/diamond/New()
	tool = new/obj/item/weapon/pickaxe/drill/diamonddrill(src)
	..()

//=======shovel=======

/obj/item/robot_parts/equippable/simple_tool/shovel
	name = "cyborg shovel"
	desc = "An integrated mining shovel."
	icon_state = "shovel"

/obj/item/robot_parts/equippable/simple_tool/shovel/New()
	tool = new/obj/item/weapon/shovel(src)
	..()

//=======mop=======

/obj/item/robot_parts/equippable/simple_tool/mop
	name = "cyborg mop"
	desc = "An integrated mop."
	icon_state = "mop"

/obj/item/robot_parts/equippable/simple_tool/mop/New()
	if(!tool)
		tool = new/obj/item/weapon/mop/cyborg(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/mop/advanced
	name = "cyborg mop"
	desc = "An integrated mop."
	icon_state = "mop_adv"

/obj/item/robot_parts/equippable/simple_tool/mop/advanced/New()
	tool = new/obj/item/weapon/mop/advanced/cyborg(src)
	..()

//=======violin=======

/obj/item/robot_parts/equippable/simple_tool/violin
	name = "cyborg violin"
	desc = "An integrated violin."
	icon_state = "violin"

/obj/item/robot_parts/equippable/simple_tool/violin/New()
	tool = new/obj/item/device/instrument/violin/cyborg(src)
	..()

//=======handcuffs=======

/obj/item/robot_parts/equippable/simple_tool/handcuffs
	name = "cyborg handcuffs"
	desc = "Advanset cable layer, allows to shackle all the criminl scum."
	icon_state = "handcuffs"

/obj/item/robot_parts/equippable/simple_tool/handcuffs/New()
	tool = new/obj/item/weapon/restraints/handcuffs/cable/zipties/cyborg(src)
	..()

//=======sechailer=======

/obj/item/robot_parts/equippable/simple_tool/sechailer
	name = "cyborg Compli-o-nator 3000"
	desc = "A set of recognizable pre-recorded messages for cyborgs to use when apprehending criminals."
	icon_state = "speaker"

/obj/item/robot_parts/equippable/simple_tool/sechailer/New()
	tool = new/obj/item/clothing/mask/gas/sechailer/cyborg(src)
	..()

//=======energy_sword=======

/obj/item/robot_parts/equippable/simple_tool/e_sword
	name = "cyborg energy sword"
	desc = "An integrated energy sword."
	icon_state = "speaker"

/obj/item/robot_parts/equippable/simple_tool/e_sword/New()
	tool = new/obj/item/weapon/melee/energy/sword/cyborg(src)
	..()

//=======operative_pinpointer=======

/obj/item/robot_parts/equippable/simple_tool/pinpointer/operative
	name = "cyborg operative pinpointer"
	icon = 'icons/obj/device.dmi'
	desc = "An integrated pinpointer that leads to the first Syndicate operative detected."
	icon_state = "pinoff"

/obj/item/robot_parts/equippable/simple_tool/pinpointer/operative/New()
	tool = new/obj/item/weapon/pinpointer/operative(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/jetpack
	name = "cyborg jetpack"
	desc = "An integrated carbondioxide jetpack."
	icon_state = "jetpack-black"
	item_state =  "jetpack-black"
	icon = 'icons/obj/tank.dmi'


//Don't know where to put this

/obj/item/robot_parts/equippable/simple_tool/jetpack/New()
	tool = new/obj/item/weapon/tank/jetpack/carbondioxide(src)
	..()

/obj/item/robot_parts/equippable/simple_tool/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(tool)
		if(M.module)
			M.module.modules += tool
			M.internals = tool
			tool.loc = M.module
	M.module.rebuild()  		//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/simple_tool/detach_from_robot(var/mob/living/silicon/robot/M)
	if(tool)
		if(M.module)
			M.uneq_module(tool)
			M.module.modules.Remove(tool)
		M.internals = null
		tool.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
			for(var/obj/item/weapon/tank/jetpack/carbondioxide/J in M.module.modules)
				M.internals = J
	holding_robot = null