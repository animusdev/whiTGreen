#define EMPTY 1
#define HAS_GUN 2
#define READY 3
#define DIRECT_CONECT 4
//fot gun holders

/obj/item/robot_parts/equippable/energy
	var/direct_draw = 0
	var/allow_draw = 1

/obj/item/robot_parts/equippable/energy/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(modules && M.module)
		M.module.energy_consumers += src
		for(var/obj/item/robot_parts/O in modules)
			O.attach_to_robot(M)
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/detach_from_robot(var/mob/living/silicon/robot/M)
	if(modules && M.module)
		M.module.energy_consumers.Remove(src)
		for(var/obj/item/robot_parts/O in modules)
			O.detach_from_robot(M)
	holding_robot = null
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/New()
	..()
	SSobj.processing |= src

/obj/item/robot_parts/equippable/energy/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/robot_parts/equippable/energy/process()
	if(!holding_robot)
		return 0

	if(!allow_draw || direct_draw)
		return 0

	return 0

//=======GUNS=======

/obj/item/robot_parts/equippable/energy/gun_holder
	var/obj/item/weapon/gun/energy/gun = null
	var/obj/item/weapon/stock_parts/cell/gun_cell = null
	var/charge_tick = 0
	var/recharge_time = 10
	var/need_draw = 1
	var/stage = EMPTY
	name = "cyborg gunholder"
	desc = "Give your cybor chance to shoot from some guns"
	icon_state = "adv_module_box"					//temporal

/obj/item/robot_parts/equippable/energy/gun_holder/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(gun && M.module)
		M.module.energy_consumers += src
		M.module.modules += gun
		gun.loc = M.module
	if (direct_draw && gun)
		gun.power_supply = M.cell
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/gun_holder/detach_from_robot(var/mob/living/silicon/robot/M)
	if(gun)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(gun)
			M.module.modules.Remove(gun)
		gun.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		if(direct_draw && gun)
			gun.power_supply = null
	holding_robot = null
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/gun_holder/New()
	..()
	need_draw = 1
	direct_draw = 0
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/gun_holder/process()
	if(!holding_robot || !gun)
		return 0

	if(!allow_draw || direct_draw || !need_draw)
		return 0

	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(!gun.power_supply)
		return 0 //sanity
	if(holding_robot && holding_robot.cell)
		var/obj/item/ammo_casing/energy/shot = gun.ammo_type[gun.select] //Necessary to find cost of shot
		if(holding_robot.cell.use(shot.e_cost)) 		//Take power from the borg...
			gun.power_supply.give(shot.e_cost)	//... to recharge the shot

	gun.update_icon()
	return 1

obj/item/robot_parts/equippable/energy/gun_holder/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/gun/energy))
		if(stage == EMPTY)
			var/obj/item/weapon/gun/energy/G = W
			user << "<span class='warning'>You put [W] in [src].</span>"
			user.drop_item()
			W.loc = src
			gun = G
			gun_cell = G.power_supply
			stage = HAS_GUN
			if (istype(W, /obj/item/weapon/gun/energy/kinetic_accelerator))
				need_draw = 0	//these guns dont need any additional energy
			else
				need_draw = 1	//these guns dont need any additional energy
		else
			user << "<span class='warning'>[src] already has [gun] in it.</span>"
	else if(istype(W, /obj/item/weapon/crowbar))
		if (stage == HAS_GUN)
			user << "<span class='warning'>You remove [gun] fron [src].</span>"
			gun.loc = get_turf(src)
			gun_cell = null
			gun = null
			playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		else if (stage == READY || stage == DIRECT_CONECT)
			user << "<span class='warning'>You need to unsecure [gun] fist.</span>"
	else if(istype(W, /obj/item/weapon/screwdriver))
		if (stage == HAS_GUN)
			user << "<span class='warning'>You secure [gun] to the [src].</span>"
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			stage = READY
		else if (stage == READY)
			user << "<span class='warning'>You unsecure [gun] from the [src].</span>"
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			stage = HAS_GUN
		else if (stage == DIRECT_CONECT)
			user << "<span class='warning'>You need disconect [gun] from power wire fist.</span>"
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(stage == READY && need_draw)
			user << "<span class='warning'>You conect [gun] dirctly to the power wire\nIt is definitely a bad idea.</span>"
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			stage = DIRECT_CONECT
			direct_draw = 1
			gun.power_supply = null
		if(stage == DIRECT_CONECT)
			user << "<span class='warning'>You disconect [gun] from the power wire</span>"
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			stage = READY
			direct_draw = 0
			gun.power_supply = gun_cell

/obj/item/robot_parts/equippable/energy/gun_holder/kinetic_accelerator
	need_draw = 0

/obj/item/robot_parts/equippable/energy/gun_holder/kinetic_accelerator/New()
	..()
	gun = new/obj/item/weapon/gun/energy/kinetic_accelerator(src)
	gun_cell = gun.power_supply
	stage = READY
	need_draw = 0

/obj/item/robot_parts/equippable/energy/gun_holder/direct_conected_laser
	direct_draw = 1

/obj/item/robot_parts/equippable/energy/gun_holder/direct_conected_laser/New()
	..()
	gun = new/obj/item/weapon/gun/energy/laser(src)
	gun_cell = gun.power_supply
	gun.power_supply = null
	stage = DIRECT_CONECT
	direct_draw = 1


/obj/item/robot_parts/equippable/energy/gun_holder/advtaser

/obj/item/robot_parts/equippable/energy/gun_holder/advtaser/New()
	..()
	gun = new/obj/item/weapon/gun/energy/gun/advtaser(src)
	gun_cell = gun.power_supply
	stage = READY

//=======borghydro=======

/obj/item/robot_parts/equippable/energy/fabricator
	var/obj/item/weapon/reagent_containers/borghypo/fabricator = null
	var/charge_cost = 0
	var/charge_tick = 0
	var/recharge_time = 5
	name = "cyborg fabricator module"
	desc = "An advanced chemical synthesizer system, designed specifically for cyborg."

/obj/item/robot_parts/equippable/energy/fabricator/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(fabricator && M.module)
		M.module.energy_consumers += src
		M.module.modules += fabricator
		fabricator.loc = M.module
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/fabricator/detach_from_robot(var/mob/living/silicon/robot/M)
	if(fabricator)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(fabricator)
			M.module.modules.Remove(fabricator)
		fabricator.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
	holding_robot = null
	allow_draw = 1

/obj/item/robot_parts/equippable/energy/fabricator/process()
	if(!holding_robot || !fabricator)
		return 0

	if(!allow_draw)
		return 0

	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(fabricator)
		fabricator.regenerate_reagents(holding_robot, charge_cost)
//	fabricator.update_icon()
	return 1


/obj/item/robot_parts/equippable/energy/fabricator/borghypo
	charge_cost = 50
	recharge_time = 5
	name = "cyborg hypospray module"
	desc = "An advanced chemical synthesizer and injection system, designed specifically for cyborg."
	item_state = "hypo"
	icon_state = "hypospray"

/obj/item/robot_parts/equippable/energy/fabricator/borghypo/New()
	..()
	fabricator = new/obj/item/weapon/reagent_containers/borghypo(src)

//=======stanbaton=======

/obj/item/robot_parts/equippable/energy/stanbaton
	var/obj/item/weapon/melee/baton/cyborg/stanbaton = null
	direct_draw = 1
	icon_state = "stanbaton"
	name = "cyborg stabaton module"
	desc = "An advanced cyborg stick for puting down any criminal scum."

/obj/item/robot_parts/equippable/energy/stanbaton/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(stanbaton && M.module)
		M.module.energy_consumers += src
		M.module.modules += stanbaton
		stanbaton.loc = M.module
		allow_draw = 1
		stanbaton.bcell = M.cell
		stanbaton.update_icon()

/obj/item/robot_parts/equippable/energy/stanbaton/detach_from_robot(var/mob/living/silicon/robot/M)
	if(stanbaton)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(stanbaton)
			M.module.modules.Remove(stanbaton)
		stanbaton.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		allow_draw = 1
		stanbaton.bcell = null
		stanbaton.update_icon()
	holding_robot = null

/obj/item/robot_parts/equippable/energy/stanbaton/New()
	..()
	stanbaton = new/obj/item/weapon/melee/baton/cyborg(src)
