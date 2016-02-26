#define EMPTY 1
#define HAS_GUN 2
#define HAS_CELL 2
#define READY 3
#define DIRECT_CONECT 4
//fot gun holders

/obj/item/robot_parts/equippable/energy
	var/direct_draw = 0
	var/allow_draw = 1

	/obj/item/robot_parts/equippable/energy/proc/cell_upd()
		return

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

/obj/item/robot_parts/equippable/energy/gun_holder/cell_upd()
	if(direct_draw)
		if(holding_robot)
			if(holding_robot.cell && allow_draw && gun)
				gun.power_supply = holding_robot
			else
				gun.power_supply = null
		else
			gun.power_supply = null

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
		if(holding_robot.cell.charge < holding_robot.cell.maxcharge - shot.e_cost)
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
				need_draw = 1	//these guns do need any additional energy
				if(istype(W, /obj/item/weapon/gun/energy/printer))
					recharge_time = 5
				else
					recharge_time = 10
		else
			user << "<span class='warning'>[src] already has [gun] in it.</span>"
	else if(istype(W, /obj/item/weapon/crowbar))
		if (stage == HAS_GUN)
			user << "<span class='warning'>You remove [gun] fron [src].</span>"
			gun.loc = get_turf(src)
			gun_cell = null
			gun = null
			stage = EMPTY
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
		else
			if(stage == DIRECT_CONECT)
				user << "<span class='warning'>You disconect [gun] from the power wire</span>"
				playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
				stage = READY
				direct_draw = 0
				gun.power_supply = gun_cell

/obj/item/robot_parts/equippable/energy/gun_holder/examine(mob/user)
	..()
	switch(stage)
		if(HAS_CELL)
			user << "[src] has [gun] into it, but [gun] isn't secured."
		if(READY)
			user << "[src] has [gun] secured to it and ready for work."
		if(DIRECT_CONECT)
			user << "[src] has [gun] secured to it and [gun] conected directly to power wire\nIt looks dangerous."

/obj/item/robot_parts/equippable/energy/gun_holder/Is_ready()
	return (stage == READY || stage == DIRECT_CONECT)

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

/obj/item/robot_parts/equippable/energy/gun_holder/printer

/obj/item/robot_parts/equippable/energy/gun_holder/printer/New()
	..()
	gun = new/obj/item/weapon/gun/energy/printer(src)
	recharge_time = 5
	gun_cell = gun.power_supply
	stage = READY

//=======reagent_facricators=======

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

/obj/item/robot_parts/equippable/energy/fabricator/extinguisher
	charge_cost = 10
	recharge_time = 15
	name = "cyborg extinguisher module"
	desc = "An fire extinguisher system, designed specifically for cyborg."
	item_state = "fire_extinguisher0"
	icon_state = "fire_extinguisher"

/obj/item/robot_parts/equippable/energy/fabricator/extinguisher/process()
	if(!holding_robot || !fabricator)
		return 0

	if(!allow_draw)
		return 0

	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(fabricator)
		var/obj/item/weapon/extinguisher/F = fabricator
		if(F.reagents.total_volume < F.max_water)
			if(holding_robot.cell.use(charge_cost))
				fabricator.reagents.add_reagent("water", 5)
	return 1

/obj/item/robot_parts/equippable/energy/fabricator/extinguisher/New()
	..()
	fabricator = new/obj/item/weapon/extinguisher(src)

/obj/item/robot_parts/equippable/energy/fabricator/extinguisher/mini
	charge_cost = 10
	recharge_time = 10
	item_state = "miniFE0"
	icon_state = "miniFE"

/obj/item/robot_parts/equippable/energy/fabricator/extinguisher/mini/New()
	..()
	fabricator = new/obj/item/weapon/extinguisher/mini(src)


/obj/item/robot_parts/equippable/energy/fabricator/weldingtool
	charge_cost = 10
	recharge_time = 7
	name = "cyborg welding module"
	desc = "An welding system, designed specifically for cyborg."
	item_state = "welder"
	icon_state = "weldingtool"

/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/process()
	if(!holding_robot || !fabricator)
		return 0

	if(!allow_draw)
		return 0

	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(fabricator)
		var/obj/item/weapon/weldingtool/F = fabricator
		if(F.get_fuel() < F.max_fuel)
			if(holding_robot.cell.use(charge_cost))
				fabricator.reagents.add_reagent("fuel", 1)
	return 1

/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/New()
	..()
	fabricator = new/obj/item/weapon/weldingtool/cyborg(src)

/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/mini
	charge_cost = 10
	recharge_time = 5
	name = "cyborg welding module"
	desc = "An welding system, designed specifically for cyborg."
	item_state = "welder"
	icon_state = "weldingtool_mini"

/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/mini/New()
	..()
	fabricator = new/obj/item/weapon/weldingtool/mini(src)

/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/largetank
	charge_cost = 10
	recharge_time = 7
	name = "cyborg welding module"
	desc = "An welding system, designed specifically for cyborg."
	item_state = "welder"
	icon_state = "weldingtool_large"

/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/largetank/New()
	..()
	fabricator = new/obj/item/weapon/weldingtool/largetank(src)

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

/obj/item/robot_parts/equippable/energy/fabricator/enzyme
	charge_cost = 5
	recharge_time = 2
	name = "cyborg enzyme module"
	desc = "An advanced enzyme synthesizer system, designed specifically for cyborg."
	item_state = "hypo"
	icon_state = "fabricator_bottle"

/obj/item/robot_parts/equippable/energy/fabricator/enzyme/New()
	..()
	fabricator = new/obj/item/weapon/reagent_containers/borghypo/borgshaker/enzyme(src)

/obj/item/robot_parts/equippable/energy/fabricator/shaker
	charge_cost = 3
	recharge_time = 3
	name = "cyborg shaker"
	desc = "An advanced enzyme synthesizer system, designed specifically for cyborg."
	item_state = "hypo"
	icon_state = "shaker"

/obj/item/robot_parts/equippable/energy/fabricator/shaker/New()
	..()
	fabricator = new/obj/item/weapon/reagent_containers/borghypo/borgshaker(src)

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

//=======rapid-something-something=======

/obj/item/robot_parts/equippable/energy/RCD
	var/obj/item/weapon/rcd/borg/RCD = null
	direct_draw = 1
	icon_state = "RCD"
	name = "cyborg RCD module"
	desc = "An RCD for cyborg."

/obj/item/robot_parts/equippable/energy/RCD/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(RCD && M.module)
		M.module.energy_consumers += src
		M.module.modules += RCD
		RCD.loc = M.module
		allow_draw = 1
		RCD.cell = M.cell

/obj/item/robot_parts/equippable/energy/RCD/detach_from_robot(var/mob/living/silicon/robot/M)
	if(RCD)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(RCD)
			M.module.modules.Remove(RCD)
		RCD.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		allow_draw = 1
		RCD.cell = null
	holding_robot = null

/obj/item/robot_parts/equippable/energy/RCD/New()
	..()
	RCD = new/obj/item/weapon/rcd/borg(src)

/obj/item/robot_parts/equippable/energy/RPD  //let's count this one as energy consumer
	var/obj/item/weapon/rcd/borg/RPD = null
	direct_draw = 1
	icon_state = "RPD"
	name = "cyborg RPD module"
	desc = "An RPD for cyborg."

/obj/item/robot_parts/equippable/energy/RPD/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(RPD && M.module)
		M.module.energy_consumers += src
		M.module.modules += RPD
		RPD.loc = M.module
		allow_draw = 1

/obj/item/robot_parts/equippable/energy/RPD/detach_from_robot(var/mob/living/silicon/robot/M)
	if(RPD)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(RPD)
			M.module.modules.Remove(RPD)
		RPD.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		allow_draw = 1
	holding_robot = null

/obj/item/robot_parts/equippable/energy/RPD/New()
	..()
	RPD = new/obj/item/weapon/pipe_dispenser(src)

/obj/item/robot_parts/equippable/energy/RSF  //so many shitcode
	var/obj/item/weapon/rsf/RSF = null
	direct_draw = 1
	icon_state = "RCD"
	name = "cyborg RSF module"
	desc = "An RSF for cyborg."

/obj/item/robot_parts/equippable/energy/RSF/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(RSF && M.module)
		M.module.energy_consumers += src
		M.module.modules += RSF
		RSF.loc = M.module
		allow_draw = 1
	RSF.borg_cell = M.cell

/obj/item/robot_parts/equippable/energy/RSF/detach_from_robot(var/mob/living/silicon/robot/M)
	if(RSF)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(RSF)
			M.module.modules.Remove(RSF)
		RSF.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		allow_draw = 1
	holding_robot = null
	RSF.borg_cell = null

/obj/item/robot_parts/equippable/energy/RSF/New()
	..()
	RSF = new/obj/item/weapon/rsf(src)
	RSF.matter = 30

//=======lightreplacer=======

/obj/item/robot_parts/equippable/energy/lightreplacer
	var/obj/item/device/lightreplacer/lightreplacer = null
	allow_draw = 0
	name = "cyborg lightreplacer module"
	desc = "An lightreplacer for cyborg."
	icon_state = "lightreplacer"
	item_state = "electronic"
	var/charge_tick = 0
	var/recharge_time = 10

/obj/item/robot_parts/equippable/energy/lightreplacer/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(lightreplacer && M.module)
		M.module.energy_consumers += src
		M.module.modules += lightreplacer
		lightreplacer.loc = M.module
		allow_draw = 0

/obj/item/robot_parts/equippable/energy/lightreplacer/detach_from_robot(var/mob/living/silicon/robot/M)
	if(lightreplacer)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(lightreplacer)
			M.module.modules.Remove(lightreplacer)
		lightreplacer.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		allow_draw = 0
	holding_robot = null

/obj/item/robot_parts/equippable/energy/lightreplacer/process()
	if(!holding_robot)
		return 0

	if(!allow_draw)
		return 0
	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(lightreplacer)
		if(lightreplacer.uses < lightreplacer.max_uses)
			if(holding_robot.cell.use(100))
				lightreplacer.uses = lightreplacer.uses + 1

	return 1

/obj/item/robot_parts/equippable/energy/lightreplacer/New()
	..()
	lightreplacer = new/obj/item/device/lightreplacer(src)

//=======additional cell=======


/obj/item/robot_parts/equippable/energy/extra_cell
	var/obj/item/weapon/stock_parts/cell/cell = null
	var/obj/item/borg/controle/controle = null
	allow_draw = 1
	direct_draw = 0
	name = "cyborg additional power cell"
	desc = "More working time before recharge!"
	icon_state = "cell"
	item_state = "electronic"
	var/charge_tick = 0
	var/recharge_time = 1
	var/recharge_amount = 10
	var/charge_itself = 0
	var/stage = EMPTY

/obj/item/robot_parts/equippable/energy/extra_cell/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(controle && cell && M.module)
		M.module.energy_consumers += src
		M.module.modules += controle
		controle.loc = M.module
		allow_draw = 1
		controle.update_icon()

/obj/item/robot_parts/equippable/energy/extra_cell/detach_from_robot(var/mob/living/silicon/robot/M)
	if(controle && cell)
		if(M.module)
			M.module.energy_consumers.Remove(src)
			M.uneq_module(controle)
			M.module.modules.Remove(controle)
		controle.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
		allow_draw = 1
		controle.update_icon()
	holding_robot = null

/obj/item/robot_parts/equippable/energy/extra_cell/process()
	if(!holding_robot)
		return 0

	if(!allow_draw)
		return 0
	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(cell)
		if(charge_itself)
			if(cell.charge < cell.maxcharge - recharge_amount)
				if(holding_robot.cell.use(recharge_amount))
					cell.give(recharge_amount)
		else
			if(holding_robot.cell.charge < holding_robot.cell.maxcharge - recharge_amount)
				if(cell.use(recharge_amount))
					holding_robot.cell.give(recharge_amount)
	controle.update_icon()
	return 1

/obj/item/robot_parts/equippable/energy/extra_cell/examine(mob/user)
	..()
	switch(stage)
		if(HAS_CELL)
			user << "[src] has [cell] into it, but [cell] isn't secured."
		if(READY)
			user << "[src] has [cell] secured to it and ready for work."

obj/item/robot_parts/equippable/energy/extra_cell/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/stock_parts/cell))
		if(stage == EMPTY)
			user << "<span class='warning'>You put [W] in [src].</span>"
			user.drop_item()
			W.loc = src
			cell = W
			stage = HAS_CELL
		else
			user << "<span class='warning'>[src] already has [cell] in it.</span>"
	else if(istype(W, /obj/item/weapon/crowbar))
		if (stage == HAS_CELL)
			user << "<span class='warning'>You remove [cell] fron [src].</span>"
			cell.loc = get_turf(src)
			cell = null
			playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		else if (stage == READY)
			user << "<span class='warning'>You need to unsecure [cell] fist.</span>"
	else if(istype(W, /obj/item/weapon/screwdriver))
		if (stage == HAS_CELL)
			user << "<span class='warning'>You secure [cell] to the [src].</span>"
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			stage = READY
		else if (stage == READY)
			user << "<span class='warning'>You unsecure [cell] from the [src].</span>"
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			stage = HAS_CELL

/obj/item/robot_parts/equippable/energy/extra_cell/New()
	..()
	controle = new/obj/item/borg/controle/extra_cell(src)

/obj/item/robot_parts/equippable/energy/extra_cell/full/New()
	..()
	cell = new/obj/item/weapon/stock_parts/cell(src)
	stage = READY

/obj/item/robot_parts/equippable/energy/extra_cell/Is_ready()
	return (stage == READY)