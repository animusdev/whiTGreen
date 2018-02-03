/obj/item/robot_parts/equippable/storage
	var/obj/item/storage = null
	force = 0

/obj/item/robot_parts/equippable/storage/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(storage)
		if(M.module)
			M.module.modules += storage
			storage.loc = M.module
	M.module.rebuild()  		//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/storage/detach_from_robot(var/mob/living/silicon/robot/M)
	if(storage)
		if(M.module)
			M.uneq_module(storage)
			M.module.modules.Remove(storage)
		storage.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		if(istype(storage, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = storage
			S.dump_contents(ignore_time = 1)
	holding_robot = null


/obj/item/robot_parts/equippable/storage/roller_dock
	name = "cyborg roller bed module"
	desc = "A roller bed dock for cyborg use."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"

/obj/item/robot_parts/equippable/storage/roller_dock/New()
	..()
	storage = new/obj/item/roller/robo(src) //ROLLER ROBO DA!


/obj/item/robot_parts/equippable/storage/ore_bag
	name = "cyborg mining satchel module"
	desc = "A  mining satchel for mining cyborg."
	icon_state = "ore_bag"

/obj/item/robot_parts/equippable/storage/ore_bag/New()
	..()
	storage = new/obj/item/weapon/storage/bag/ore(src)

/obj/item/robot_parts/equippable/storage/ore_bag/holding
	name = "cyborg mining satchel of holding module"
	desc = "A bottomless mining satchel for mining cyborg. Your little iron friend should no longer meet those terrible boxes."
	icon_state = "ore_bagoH"

/obj/item/robot_parts/equippable/storage/ore_bag/holding/New()
	..()
	if(storage)
		qdel(storage)
	storage = new/obj/item/weapon/storage/bag/ore/holding(src)

/obj/item/robot_parts/equippable/storage/sheetsnatcher
	name = "cyborg sheet snatcher module"
	desc = "A patented Nanotrasen storage system designed for any kind of mineral sheet."
	icon_state = "sheetsnatcher"

/obj/item/robot_parts/equippable/storage/sheetsnatcher/New()
	..()
	storage = new/obj/item/weapon/storage/bag/sheetsnatcher/borg(src)

/obj/item/robot_parts/equippable/storage/trash
	name = "cyborg trash bag module"
	desc = "It's the heavy-duty black polymer kind trashbag adapted for the cyborgs."
	icon_state = "trashbag"
	item_state = "trashbag"

/obj/item/robot_parts/equippable/storage/trash/New()
	..()
	storage = new/obj/item/weapon/storage/bag/trash/cyborg(src)

/obj/item/robot_parts/equippable/storage/tray
	name = "cyborg tray module"
	desc = "A metal tray adapted for the cyborgs."
	icon_state = "tray"

/obj/item/robot_parts/equippable/storage/tray/New()
	..()
	storage = new/obj/item/weapon/storage/bag/tray(src)
