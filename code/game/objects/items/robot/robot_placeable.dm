//wrost shitcode, as i thought

/obj/item/robot_parts/equippable/plaseble
   var/obj/item/storage = null   //placeable

/obj/item/robot_parts/equippable/plaseble/attach_to_robot(var/mob/living/silicon/robot/M)
   holding_robot = M
   if(storage && M.module)
      M.module.placeable += storage
      M.module.modules += storage
      storage.loc = M.module

/obj/item/robot_parts/equippable/plaseble/detach_from_robot(var/mob/living/silicon/robot/M)
   if(storage)
      if(M.module)
         M.module.placeable.Remove(storage)
         M.uneq_module(storage)
         M.module.modules.Remove(storage)
      storage.loc = src
      if(M.module)
         M.module.rebuild()         //No need to fix modules, as it's done in rebild()
   holding_robot = null

/obj/item/robot_parts/equippable/plaseble/New()
   ..()
   if(storage.m_amt != 0 || storage.g_amt != 0)
      m_amt = storage.m_amt + 60
   if(storage.m_amt != 0 || storage.g_amt != 0)
      g_amt = storage.g_amt
   if(storage.origin_tech)
      origin_tech = storage.origin_tech

/obj/item/robot_parts/equippable/plaseble/Replace_workng_obj(var/obj/item/I, var/forsed = 0)
   if(!I)
      return

   if(forsed)
      qdel(storage)
   else
      storage.loc = get_turf(src)

   storage = I

//=========================================

/obj/item/robot_parts/equippable/plaseble/beaker
   icon_state = "beaker"
   item_state = "beaker"
   name = "cyborg beaker"
   desc = "A beaker. It attached to the holder."

/obj/item/robot_parts/equippable/plaseble/beaker/New()
   if(!storage)
      storage = new/obj/item/weapon/reagent_containers/glass/beaker(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/beaker/large
   icon_state = "beakerlarge"
   name = "cyborg large beaker"
   desc = "A large beaker. It attached to the holder."

/obj/item/robot_parts/equippable/plaseble/beaker/large/New()
   storage = new/obj/item/weapon/reagent_containers/glass/beaker/large(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/beaker/noreact
   icon_state = "beakernoreact"
   name = "cyborg cryostasis beaker"
   desc = "A cryostasis beaker. It attached to the holder."

/obj/item/robot_parts/equippable/plaseble/beaker/noreact/New()
   storage = new/obj/item/weapon/reagent_containers/glass/beaker/noreact(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/beaker/bluespace
   icon_state = "beakerbluespace"
   name = "cyborg bluespace beaker"
   desc = "A bluespace beaker. It attached to the holder."

/obj/item/robot_parts/equippable/plaseble/beaker/bluespace/New()
   storage = new/obj/item/weapon/reagent_containers/glass/beaker/bluespace(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/beaker/Replace_workng_obj(var/obj/item/I, var/forsed = 0)
   if(!I)
      return

   if(forsed)
      qdel(storage)
   else
      storage.loc = get_turf(src)

   storage = I
   if(istype(storage, /obj/item/weapon/reagent_containers/glass/beaker/bluespace))
      icon_state = "beakerbluespace"
      name = "cyborg bluespace beaker"
      desc = "A bluespace beaker. It attached to the holder."
   else if(istype(storage, /obj/item/weapon/reagent_containers/glass/beaker/noreact))
      icon_state = "beakernoreact"
      name = "cyborg cryostasis beaker"
      desc = "A cryostasis beaker. It attached to the holder."
   else if(istype(storage, /obj/item/weapon/reagent_containers/glass/beaker/large))
      icon_state = "beakerlarge"
      name = "cyborg large beaker"
      desc = "A large beaker. It attached to the holder."
   else if(istype(storage, /obj/item/weapon/reagent_containers/glass/beaker))
      icon_state = "beaker"
      name = "cyborg beaker"
      desc = "A beaker. It attached to the holder."


/obj/item/robot_parts/equippable/plaseble/drinkingglass
   icon_state = "drinkingglass"
   item_state = null
   name = "cyborg glass"
   desc = "A glass. It attached to the holder."

/obj/item/robot_parts/equippable/plaseble/drinkingglass/New()
   storage = new/obj/item/weapon/reagent_containers/food/drinks/drinkingglass(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/syringe
   icon_state = "syringe"
   item_state = null
   name = "modular syringe"
   desc = "Cyborg module which allows syringe using."

/obj/item/robot_parts/equippable/plaseble/syringe/New()
   storage = new/obj/item/weapon/reagent_containers/syringe(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/dropper
   icon_state = "dropper"
   item_state = null
   name = "modular dropper"
   desc = "Cyborg module which allows dropper using."

/obj/item/robot_parts/equippable/plaseble/dropper/New()
   storage = new/obj/item/weapon/reagent_containers/dropper(src)
   ..()

/obj/item/robot_parts/equippable/plaseble/bucket
   icon_state = "bucket"
   name = "modular bucket"
   desc = "Cyborg module which allows bucket using."

/obj/item/robot_parts/equippable/plaseble/bucket/New()
   storage = new/obj/item/weapon/reagent_containers/glass/bucket(src)

   var/obj/item/weapon/reagent_containers/glass/bucket/B = storage
   if(istype(B))
      B.cyborg = 1
   ..()

/obj/item/robot_parts/equippable/plaseble/bucket/Replace_workng_obj(var/obj/item/I, var/forsed = 0)
   if(!I)
      return

   if(forsed)
      qdel(storage)
   else
      storage.loc = get_turf(src)

   storage = I
   var/obj/item/weapon/reagent_containers/glass/bucket/B = storage
   if(istype(B))
      B.cyborg = 1