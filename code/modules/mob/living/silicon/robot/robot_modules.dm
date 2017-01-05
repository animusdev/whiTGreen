/obj/item/weapon/robot_module
   name = "robot module"
   icon = 'icons/obj/module.dmi'
   icon_state = "std_module"
   w_class = 100.0
   item_state = "electronic"
   flags = CONDUCT

   //all modules
   var/list/modules = list()
   //all placeable modules
   var/list/placeable = list()
   //all modules whitch use robot energy
   var/list/energy_consumers = list()
   //all raw resurse storages
   var/list/storages = list()


/obj/item/weapon/robot_module/Destroy()
   modules.Cut()
   placeable.Cut()
   energy_consumers.Cut()
   storages.Cut()
   return ..()

/obj/item/weapon/robot_module/emp_act(severity)
   if(modules)
      for(var/obj/O in modules)
         O.emp_act(severity)
   ..()
   return

/obj/item/weapon/robot_module/proc/get_usable_modules()
   . = modules.Copy()


/obj/item/weapon/robot_module/proc/get_inactive_modules()
   . = list()
   var/mob/living/silicon/robot/R = loc
   for(var/m in get_usable_modules())
      if((m != R.module_state_1) && (m != R.module_state_2) && (m != R.module_state_3))
         . += m


/obj/item/weapon/robot_module/New()
   ..()


/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R)
   return

/obj/item/weapon/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
   var/list/temp_list = modules
   modules = list()
   for(var/obj/O in temp_list)
      if(O)
         modules += O
   fix_modules()


/obj/item/weapon/robot_module/proc/fix_modules()
   for(var/obj/item/I in modules)
      I.flags |= NODROP


/obj/item/weapon/robot_module/proc/on_emag()
   return

