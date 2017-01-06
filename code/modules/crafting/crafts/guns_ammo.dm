/datum/table_recipe/flamethrower
	name = "Flamethrower"
	result = /obj/item/weapon/flamethrower
	reqs = list(/obj/item/weapon/weldingtool = 1,
				/obj/item/device/assembly/igniter = 1,
				/obj/item/stack/rods = 1)
	parts = list(/obj/item/device/assembly/igniter = 1,
				/obj/item/weapon/weldingtool = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 20

/datum/table_recipe/ishotgun
	name = "Improvised Shotgun"
	result = /obj/item/weapon/gun/projectile/revolver/doublebarrel/improvised
	reqs = list(/obj/item/weaponcrafting/reciever = 1,
				/obj/item/pipe = 1,
				/obj/item/weaponcrafting/stock = 1,
				/obj/item/stack/packageWrap = 5,)
	tools = list(/obj/item/weapon/screwdriver)
	time = 200


// Ammo

/datum/table_recipe/dragonsbreath
	name = "Dragonsbreath Shell"
	result = /obj/item/ammo_casing/shotgun/incendiary/dragonsbreath
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/phosphorus = 5,)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/frag12
	name = "FRAG-12 Shell"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/datum/reagent/glycerol = 5,
				/datum/reagent/toxin/acid = 5,
				/datum/reagent/toxin/acid/fluacid = 5,)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/ionslug
	name = "Ion Scatter Shell"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/stock_parts/micro_laser/ultra = 1,
				/obj/item/weapon/stock_parts/subspace/crystal = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/improvisedslug
	name = "Improvised Shotgun Shell"
	result = /obj/item/ammo_casing/shotgun/improvised
	reqs = list(/obj/item/weapon/grenade/chem_grenade = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 1,
				/datum/reagent/fuel = 10)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/improvisedslugoverload
	name = "Overload Improvised Shell"
	result = /obj/item/ammo_casing/shotgun/improvised/overload
	reqs = list(/obj/item/ammo_casing/shotgun/improvised = 1,
				/datum/reagent/blackpowder = 5)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5


/datum/table_recipe/implantershell
	name = "Implanter Shell"
	result = /obj/item/ammo_casing/shotgun/implanter
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/implanter = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/meteorshot
	name = "Meteorshot Shell"
	result = /obj/item/ammo_casing/shotgun/meteorshot
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/rcd_ammo = 1,
				/obj/item/weapon/stock_parts/manipulator = 2)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/pulseslug
	name = "Pulse Slug Shell"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/stock_parts/capacitor/adv = 2,
				/obj/item/weapon/stock_parts/micro_laser/ultra = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5

/datum/table_recipe/laserslug
	name = "Laser Slug Shell"
	result = /obj/item/ammo_casing/shotgun/laserslug
	reqs = list(/obj/item/ammo_casing/shotgun/techshell = 1,
				/obj/item/weapon/stock_parts/capacitor/adv = 1,
				/obj/item/weapon/stock_parts/micro_laser/high = 1)
	tools = list(/obj/item/weapon/screwdriver)
	time = 5
