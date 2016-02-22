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
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "meson_old"
	name = "cyborg meson module"
	desc = "Provide cyborg meson vision."

/obj/item/robot_parts/equippable/sight/meson/New()
	..()
	lens = new/obj/item/borg/sight/meson(src)

/obj/item/robot_parts/equippable/sight/thermal
	icon = 'icons/mob/robot_items.dmi'
	icon_state = "thermal_old"
	name = "cyborg thermal module"
	desc = "Provide cyborg thermal vision."

/obj/item/robot_parts/equippable/sight/thermal/New()
	..()
	lens = new/obj/item/borg/sight/thermal(src)


/**********************************************************************
						control things
***********************************************************************/

/obj/item/borg/controle
	force = 0
	name = "cyborg cotrole panell"
	desc = "Use to work with some integrated equipment"

/obj/item/robot_parts/controle/New()
	..()
	flags |= NODROP
//want to somehow disable all ways to attack somefing beside other borg control panels, but don't know how.



/obj/item/borg/controle/module_box
	name = "cyborg modular printer"
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "module_box"
	desc = "Activate and choose one of usefull equipment sets"
	var/obj/item/robot_parts/equippable/module_box/Box =null

/obj/item/borg/controle/module_box/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(Box)
			Box.Print_module(user)

/obj/item/borg/controle/module_box/New(var/B)
	..()
	if(istype(loc,/obj/item/robot_parts/equippable/module_box))
		Box = B


/obj/item/borg/controle/module_box/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(Box)
			Box.Print_module(user)
