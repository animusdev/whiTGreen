//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
//Might want to move this into several files later but for now it works here
/obj/item/borg/stun
	name = "electrified arm"
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "elecarm"

/obj/item/borg/stun/attack(mob/M as mob, mob/living/silicon/robot/user as mob)

	user.cell.charge -= 30

	M.Weaken(5)
	if (M.stuttering < 5)
		M.stuttering = 5
	M.Stun(5)

	for(var/mob/O in viewers(M, null))
		if (O.client)
			O.show_message("<span class='danger'>[user] has prodded [M] with an electrically-charged arm!</span>", 1,
							 "<span class='italics'>You hear someone fall.</span>", 2)
	add_logs(user, M, "stunned", object="[src.name]", addition="(INTENT: [uppertext(user.a_intent)])")

/obj/item/borg/overdrive
	name = "overdrive"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/fist
	name = "cyborg fist"
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "elecarm"
	force = 10
	hitsound = 'sound/weapons/smash.ogg'
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")


/obj/item/borg/stun/attack(mob/M as mob, mob/living/silicon/robot/user as mob)
	..()

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	var/sight_mode = null


/obj/item/borg/sight/xray
	name = "\proper x-ray Vision"
	sight_mode = BORGXRAY
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "x_ray"


/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "thermal"


/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "meson"


/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "healthhud"


/obj/item/borg/sight/hud/med/New()
	..()
	hud = new /obj/item/clothing/glasses/hud/health(src)
	return


/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "securityhud"

/obj/item/borg/sight/hud/sec/New()
	..()
	hud = new /obj/item/clothing/glasses/hud/security(src)
	return

/obj/item/robot_parts/equippable/sight
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "lens_holder"
	var/obj/item/borg/sight/lens

/obj/item/robot_parts/equippable/sight/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(lens && M.module)
		M.module.modules += lens
		lens.loc = M.module

/obj/item/robot_parts/equippable/sight/detach_from_robot(var/mob/living/silicon/robot/M)
	if(lens)
		if(M.module)
			M.uneq_module(lens)
			M.module.modules.Remove(lens)
		lens.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
	holding_robot = null

/obj/item/robot_parts/equippable/sight/meson
	name = "cyborg meson module"
	desc = "Provide cyborg meson vision."

/obj/item/robot_parts/equippable/sight/meson/New()
	..()
	lens = new/obj/item/borg/sight/meson(src)
	src.overlays += "meson"

/obj/item/robot_parts/equippable/sight/thermal
	name = "cyborg thermal module"
	desc = "Provide cyborg thermal vision."

/obj/item/robot_parts/equippable/sight/thermal/New()
	..()
	lens = new/obj/item/borg/sight/thermal(src)
	src.overlays += "thermal"


/**********************************************************************
						control things
***********************************************************************/

/obj/item/borg/controle
	force = 0
	icon = 'icons/mob/robot_items.dmi'
	name = "cyborg cotrole panell"
	desc = "Use to work with some integrated equipment"

/obj/item/borg/controle/New()
	..()
	flags |= NODROP

//disallow ani controle to be used on other things
/obj/item/borg/controle/afterattack(atom/target, mob/user, proximity_flag)
	if(istype(target, /obj/item/borg/controle))
		..()

/obj/item/borg/controle/module_box
	name = "cyborg modular printer"
	icon_state = "box_controle"
	desc = "Activate and choose one of usefull equipment sets"
	var/obj/item/robot_parts/equippable/module_box/Box =null

/obj/item/borg/controle/module_box/sindicate
	icon_state = "box_controle_sindi"
	desc = "Activate when it's time to bring yours gund out."

/obj/item/borg/controle/module_box/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(Box)
			Box.Print_module(user)

/obj/item/borg/controle/module_box/New(var/B)
	..()
	if(istype(B,/obj/item/robot_parts/equippable/module_box))
		Box = B

/obj/item/borg/controle/extra_cell
	icon = 'icons/mob/robot_items.dmi'
	name = "additional cell cotrole panell"
	var/obj/item/robot_parts/equippable/energy/extra_cell/extra_cell = null

/obj/item/borg/controle/extra_cell/New(var/C)
	..()
	if(istype(C, /obj/item/robot_parts/equippable/energy/extra_cell))
		extra_cell = C

/obj/item/borg/controle/extra_cell/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(extra_cell)
			extra_cell.charge_itself = !extra_cell.charge_itself
			update_icon()

/obj/item/borg/controle/extra_cell/update_icon()
	if(!extra_cell)
		icon_state = "cell_off"

	if(!extra_cell.allow_draw)
		icon_state = "cell_off"

	if(extra_cell.charge_itself)
		if(extra_cell.cell.charge >= extra_cell.cell.maxcharge)
			icon_state = "cell_charged"
		else
			icon_state = "cell_charging"
	else
		if(extra_cell.cell.charge < extra_cell.recharge_amount)
			icon_state = "cell_discharged"
		else
			icon_state = "cell_discharging"

/obj/item/borg/controle/extra_cell/examine(mob/user)
	var/msg = ""
	if(!extra_cell)
		msg += "<span class='warning'>It's disconected</span>"
	else
		if(!extra_cell.cell)
			msg += "<span class='warning'>cell is missing</span>"
		else
			msg += "Instaled [extra_cell.cell] has carge of [extra_cell.cell.charge] / [extra_cell.cell.maxcharge]\nIt's curently [extra_cell.charge_itself ? "charging from cyborg power sorse" : "recharging cyborg"]."

	user << msg

/obj/item/borg/controle/radio
	name = "cyborg radio calibrator"
	desc = "Activate and choose one of radio chanels sets"
	var/obj/item/robot_parts/integrated/simple_integrated/radio/radio_call = null
	icon = 'icons/obj/radio.dmi'
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

/obj/item/borg/controle/radio/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(radio_call)
			var/chosen_set = input("Please, select a equipment set!", "Robot", null, null) in list("Standard", "Service", "Cargo", "Medical", "Security", "Engineering")
			var/obj/item/device/encryptionkey/newkey = null
			switch (chosen_set)
				if("Standard")
					newkey = new/obj/item/device/encryptionkey(radio_call.holding_robot.radio)

				if("Service")
					newkey = new/obj/item/device/encryptionkey/headset_service(radio_call.holding_robot.radio)

				if("Cargo")
					newkey = new/obj/item/device/encryptionkey/headset_cargo(radio_call.holding_robot.radio)

				if("Medical")
					newkey = new/obj/item/device/encryptionkey/headset_med(radio_call.holding_robot.radio)

				if("Security")
					newkey = new/obj/item/device/encryptionkey/headset_sec(radio_call.holding_robot.radio)

				if("Engineering")
					newkey = new/obj/item/device/encryptionkey/headset_eng(radio_call.holding_robot.radio)
			if(radio_call.holding_robot.radio.keyslot)
				qdel(radio_call.holding_robot.radio.keyslot)
			radio_call.holding_robot.radio.keyslot = newkey
			radio_call.holding_robot.radio.recalculateChannels()
			radio_call.detach_from_robot(radio_call.holding_robot)
			qdel(radio_call)

/obj/item/borg/controle/radio/New(var/R)
	..()
	if(istype(R,/obj/item/robot_parts/integrated/simple_integrated/radio))
		radio_call = R
