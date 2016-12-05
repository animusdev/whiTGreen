//=======chest=======

/obj/item/robot_parts/chest/feeled
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell.\n Comes with some usefull cyborg equipments."

/obj/item/robot_parts/chest/feeled/New()
	..()
	modules += new/obj/item/robot_parts/equippable/module_box(src)
	free_module_slots = free_module_slots - 1

/obj/item/robot_parts/chest/sindicate
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell.\n"

/obj/item/robot_parts/chest/sindicate/New()
	..()
	modules += new/obj/item/robot_parts/equippable/module_box/sindicate(src)
	free_module_slots = free_module_slots - 1

//=======hands=======

/obj/item/robot_parts/l_arm/fist
	name = "cyborg left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"

/obj/item/robot_parts/l_arm/fist/New()
	modules += new/obj/item/robot_parts/integrated/simple_integrated/fist/l(src)
	..()

/obj/item/robot_parts/r_arm/fist
	name = "cyborg right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"

/obj/item/robot_parts/r_arm/fist/New()
	modules += new/obj/item/robot_parts/integrated/simple_integrated/fist/r(src)
	..()

//=======heads=======

/obj/item/robot_parts/head/radio

/obj/item/robot_parts/head/radio/New()
	modules += new/obj/item/robot_parts/integrated/simple_integrated/radio()
	..()
