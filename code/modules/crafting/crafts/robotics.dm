/datum/table_recipe/ed209
	name = "ED209"
	result = /obj/machinery/bot/ed209
	reqs = list(/obj/item/robot_parts/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/robot_parts/l_leg = 1,
				/obj/item/robot_parts/r_leg = 1,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weapon/gun/energy/gun/advtaser = 1,
				/obj/item/weapon/stock_parts/cell = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 120

/datum/table_recipe/secbot
	name = "Secbot"
	result = /obj/machinery/bot/secbot
	reqs = list(/obj/item/device/assembly/signaler = 1,
				/obj/item/clothing/head/helmet/sec = 1,
				/obj/item/weapon/melee/baton = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	tools = list(/obj/item/weapon/weldingtool)
	time = 120

/datum/table_recipe/cleanbot
	name = "Cleanbot"
	result = /obj/machinery/bot/cleanbot
	reqs = list(/obj/item/weapon/reagent_containers/glass/bucket = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 80

/datum/table_recipe/floorbot
	name = "Floorbot"
	result = /obj/machinery/bot/floorbot
	reqs = list(/obj/item/weapon/storage/toolbox/mechanical = 1,
				/obj/item/stack/tile/plasteel = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 80

/datum/table_recipe/medbot
	name = "Medbot"
	result = /obj/machinery/bot/medbot
	reqs = list(/obj/item/device/healthanalyzer = 1,
				/obj/item/weapon/storage/firstaid = 1,
				/obj/item/device/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 80


/* ======== Borgs modules ======== */

/datum/table_recipe/borg_module		//some strange coding
	var/tool //put this in the holder
	name = "cyborg toolbox"
	reqs = list(/obj/item/weapon/storage/toolbox = 1,
				/obj/item/weapon/stock_parts/manipulator = 4,
				/obj/item/stack/cable_coil = 5)
	result = /obj/item/robot_parts/equippable/cyborg_toolbox
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 30
	parts = list(/obj/item/weapon/stock_parts/manipulator = 4,
				/obj/item/weapon/storage/toolbox = 1)

/datum/table_recipe/borg_module/crowbar
	name = "modular crowbar"
	reqs = list(/obj/item/weapon/crowbar = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/crowbar
	tool = /obj/item/weapon/crowbar
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/crowbar = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/wrench
	name = "modular wrench"
	reqs = list(/obj/item/weapon/wrench = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/wrench
	tool = /obj/item/weapon/wrench
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/wrench = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/screwdriver
	name = "modular screwdriver"
	reqs = list(/obj/item/weapon/screwdriver = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/screwdriver
	tool = /obj/item/weapon/screwdriver
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/screwdriver = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/wirecutters
	name = "modular wirecutters"
	reqs = list(/obj/item/weapon/wirecutters = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/wirecutters
	tool = /obj/item/weapon/wirecutters
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/wirecutters = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/analyzer
	name = "modular analyzer"
	reqs = list(/obj/item/device/analyzer = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/analyzer
	tool = /obj/item/device/analyzer
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/device/analyzer = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/multitool
	name = "modular multitool"
	reqs = list(/obj/item/device/multitool = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/multitool
	tool = /obj/item/device/multitool
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/device/multitool = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/t_scanner
	name = "modular T-ray scanner"
	reqs = list(/obj/item/device/t_scanner = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/t_scanner
	tool = /obj/item/device/t_scanner
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/device/t_scanner = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/scalpel
	name = "modular scalpel"
	reqs = list(/obj/item/weapon/scalpel = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/scalpel
	tool = /obj/item/weapon/scalpel
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/scalpel = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/circular_saw
	name = "modular circular saw"
	reqs = list(/obj/item/weapon/circular_saw = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/circular_saw
	tool = /obj/item/weapon/circular_saw
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/circular_saw = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/surgical_drapes
	name = "modular surgical drapes"
	reqs = list(/obj/item/weapon/surgical_drapes = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/surgical_drapes
	tool = /obj/item/weapon/surgical_drapes
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/surgical_drapes = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/cautery
	name = "modular cautery"
	reqs = list(/obj/item/weapon/cautery = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/cautery
	tool = /obj/item/weapon/cautery
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/cautery = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/surgicaldrill
	name = "modular surgical drill"
	reqs = list(/obj/item/weapon/surgicaldrill = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/surgicaldrill
	tool = /obj/item/weapon/surgicaldrill
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/surgicaldrill = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/hemostat
	name = "modular hemostat"
	reqs = list(/obj/item/weapon/hemostat = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/hemostat
	tool = /obj/item/weapon/hemostat
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/hemostat = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/retractor
	name = "modular retractor"
	reqs = list(/obj/item/weapon/retractor = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/retractor
	tool = /obj/item/weapon/retractor
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/retractor = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/healthanalyzer
	name = "modular health analyzer"
	reqs = list(/obj/item/device/healthanalyzer = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/healthanalyzer
	tool = /obj/item/device/healthanalyzer
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/device/healthanalyzer = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/mining_scanner
	name = "modular mining scanner"
	reqs = list(/obj/item/device/mining_scanner = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/mining_scanner
	tool = /obj/item/device/mining_scanner
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/device/mining_scanner = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/soap
	name = "modular soap"
	reqs = list(/obj/item/weapon/soap = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/soap
	tool = /obj/item/weapon/soap
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/soap = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/holosign_creator
	name = "modular holosign creator"
	reqs = list(/obj/item/weapon/holosign_creator = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/holosign_creator
	tool = /obj/item/weapon/holosign_creator
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/holosign_creator = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/pen
	name = "modular pen"
	reqs = list(/obj/item/weapon/pen = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/pen
	tool = /obj/item/weapon/pen
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/pen = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/razor
	name = "modular razor"
	reqs = list(/obj/item/weapon/razor = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/razor
	tool = /obj/item/weapon/razor
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/razor = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/zippo
	name = "modular zippo"
	reqs = list(/obj/item/weapon/lighter/zippo = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/zippo
	tool = /obj/item/weapon/lighter/zippo
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/lighter/zippo = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/emag
	name = "modular emag"
	reqs = list(/obj/item/weapon/card/emag = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/small/emag
	tool = /obj/item/weapon/card/emag
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/card/emag = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/drill
	name = "modular drill"
	reqs = list(/obj/item/weapon/pickaxe/drill = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)
	result = /obj/item/robot_parts/equippable/simple_tool/drill
	tool = /obj/item/weapon/pickaxe/drill
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 25
	parts = list(/obj/item/weapon/pickaxe/drill = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)

/datum/table_recipe/borg_module/shovel
	name = "modular shovel"
	reqs = list(/obj/item/weapon/shovel = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)
	result = /obj/item/robot_parts/equippable/simple_tool/small/pen
	tool = /obj/item/weapon/shovel
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 25
	parts = list(/obj/item/weapon/shovel = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)

/datum/table_recipe/borg_module/mop
	name = "modular mop"
	reqs = list(/obj/item/weapon/mop = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)
	result = /obj/item/robot_parts/equippable/simple_tool/mop
	tool = /obj/item/weapon/mop
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 25
	parts = list(/obj/item/weapon/mop = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)

/datum/table_recipe/borg_module/e_sword
	name = "modular energy sword"
	reqs = list(/obj/item/weapon/shovel = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)
	result = /obj/item/robot_parts/equippable/simple_tool/e_sword
	tool = /obj/item/weapon/shovel
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 20
	parts = list(/obj/item/weapon/shovel = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)

/datum/table_recipe/borg_module/sechailer
	name = "modular sechailer"
	reqs = list(/obj/item/clothing/mask/gas/sechailer/cyborg = 1,
				/obj/item/stack/cable_coil = 1)
	result = /obj/item/robot_parts/equippable/simple_tool/sechailer
	tools = list(/obj/item/weapon/wirecutters)
	time = 10
	parts = list()

/datum/table_recipe/borg_module/handcuffs
	name = "modular handcuffs"
	reqs = list(/obj/item/robot_parts/equippable/energy/storage_user/wire = 1,
				/obj/item/weapon/stock_parts/manipulator = 3,
				/obj/item/stack/rods = 3)
	result = /obj/item/robot_parts/equippable/simple_tool/handcuffs
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 25
	parts = list(/obj/item/robot_parts/equippable/energy/storage_user/wire = 1,
				/obj/item/weapon/stock_parts/manipulator = 3)

/datum/table_recipe/borg_module/tray
	name = "modular tray"
	reqs = list(/obj/item/weapon/storage/bag/tray = 1,
				/obj/item/weapon/stock_parts/manipulator = 4)
	result = /obj/item/robot_parts/equippable/storage/tray
	tool = /obj/item/weapon/storage/bag/tray
	tools = list(/obj/item/weapon/weldingtool, /obj/item/weapon/screwdriver)
	time = 25
	parts = list(/obj/item/weapon/storage/bag/tray = 1,
				/obj/item/weapon/stock_parts/manipulator = 4)

/datum/table_recipe/borg_module/beaker
	name = "modular beaker"
	reqs = list(/obj/item/weapon/reagent_containers/glass/beaker = 1,
				/obj/item/weapon/stock_parts/manipulator = 2,
				/obj/item/stack/rods = 1)
	result = /obj/item/robot_parts/equippable/plaseble/beaker
	tool = /obj/item/weapon/reagent_containers/glass/beaker
	tools = list(/obj/item/weapon/wrench , /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/reagent_containers/glass/beaker = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)

/datum/table_recipe/borg_module/bucket
	name = "modular bucket"
	reqs = list(/obj/item/weapon/reagent_containers/glass/bucket = 1,
				/obj/item/weapon/stock_parts/manipulator = 2,
				/obj/item/stack/rods = 1)
	result = /obj/item/robot_parts/equippable/plaseble/bucket
	tool = /obj/item/weapon/reagent_containers/glass/bucket
	tools = list(/obj/item/weapon/wrench , /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/reagent_containers/glass/bucket = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)

/datum/table_recipe/borg_module/drinkingglass
	name = "modular drinkingglass"
	reqs = list(/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 1,
				/obj/item/weapon/stock_parts/manipulator = 2,
				/obj/item/stack/rods = 1)
	result = /obj/item/robot_parts/equippable/plaseble/drinkingglass
	tool = /obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	tools = list(/obj/item/weapon/wrench , /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)

/datum/table_recipe/borg_module/syringe
	name = "modular syringe"
	reqs = list(/obj/item/weapon/reagent_containers/syringe = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/plaseble/syringe
	tool = /obj/item/weapon/reagent_containers/syringe
	tools = list(/obj/item/weapon/wrench , /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/reagent_containers/syringe = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/dropper
	name = "modular dropper"
	reqs = list(/obj/item/weapon/reagent_containers/dropper = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)
	result = /obj/item/robot_parts/equippable/plaseble/dropper
	tool = /obj/item/weapon/reagent_containers/dropper
	tools = list(/obj/item/weapon/wrench , /obj/item/weapon/screwdriver)
	time = 10
	parts = list(/obj/item/weapon/reagent_containers/dropper = 1,
				/obj/item/weapon/stock_parts/manipulator = 1)

/datum/table_recipe/borg_module/weldingtool
	name = "modular weldingtool"
	reqs = list(/obj/item/weapon/weldingtool/cyborg = 1,
				/obj/item/weapon/stock_parts/manipulator = 2,
				/obj/item/weapon/stock_parts/matter_bin = 2,
				/obj/item/stack/cable_coil = 4)
	result = /obj/item/robot_parts/equippable/energy/fabricator/weldingtool
	tool = /obj/item/weapon/weldingtool/cyborg
	tools = list(/obj/item/weapon/wrench, /obj/item/weapon/screwdriver, /obj/item/weapon/wirecutters)
	time = 10
	parts = list(/obj/item/weapon/weldingtool/cyborg = 1,
				/obj/item/weapon/stock_parts/manipulator = 2,
				/obj/item/weapon/stock_parts/matter_bin = 2)
