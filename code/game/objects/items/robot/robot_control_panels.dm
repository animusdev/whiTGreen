/obj/item/robot_parts/controle
	force = 0
	name = "cyborg cotrole panell"
	desc = "Use to work with some integrated equipment"

/obj/item/robot_parts/controle/New()
	..()
	flags |= NODROP
//want to somehow disable all ways to attack somefing beside other borg control panels, but don't know how.



/obj/item/robot_parts/controle/module_box
	name = "cyborg modular printer"
	icon_state = "module_box"
	desc = "Activate and choose one of usefull equipment sets"
	var/obj/item/robot_parts/equippable/module_box/Box =null

/obj/item/robot_parts/controle/module_box/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(Box)
			Box.Print_module(user)

/obj/item/robot_parts/controle/module_box/New(var/B)
	..()
	if(istype(loc,/obj/item/robot_parts/equippable/module_box))
		Box = B


/obj/item/robot_parts/controle/module_box/attack_self(mob/user as mob)
	if (user.stat)
		return

	if(istype(usr,/mob/living/silicon))
		if(Box)
			Box.Print_module(user)
