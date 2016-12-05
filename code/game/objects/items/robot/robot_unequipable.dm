/obj/item/robot_parts/integrated/simple_integrated
	var/obj/item/tool = null
	force = 0

/obj/item/robot_parts/integrated/simple_integrated/attach_to_robot(var/mob/living/silicon/robot/M)
	holding_robot = M
	if(tool)
		if(M.module)
			M.module.modules += tool
			tool.loc = M.module
	M.module.rebuild()  		//No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/integrated/simple_integrated/detach_from_robot(var/mob/living/silicon/robot/M)
	if(tool)
		if(M.module)
			M.uneq_module(tool)
			M.module.modules.Remove(tool)
		tool.loc = src
		if(M.module)
			M.module.rebuild()			//No need to fix modules, as it's done in rebild()
	holding_robot = null

/obj/item/robot_parts/integrated/simple_integrated/New()
	..()
	if(tool.m_amt != 0 || tool.g_amt != 0)
		m_amt = tool.m_amt + 30
	if(tool.m_amt != 0 || tool.g_amt != 0)
		g_amt = tool.g_amt
	if(tool.origin_tech)
		origin_tech = tool.origin_tech

//=======cyborg fist=======
/obj/item/robot_parts/integrated/simple_integrated/fist
	force = 10
	name = "cyborg's fist"
	hitsound = 'sound/weapons/smash.ogg'
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

/obj/item/robot_parts/integrated/simple_integrated/fist/r/New()
	tool = new/obj/item/borg/fist(src)
	tool.name = "right cyborg fist"
	..()

/obj/item/robot_parts/integrated/simple_integrated/fist/l/New()
	tool = new/obj/item/borg/fist(src)
	tool.name = "left cyborg fist"
	..()

//=======radio=======
/obj/item/robot_parts/integrated/simple_integrated/radio
	name = "cyborg's radio calibrator"

/obj/item/robot_parts/integrated/simple_integrated/radio/New()
	tool = new/obj/item/borg/controle/radio(src)
