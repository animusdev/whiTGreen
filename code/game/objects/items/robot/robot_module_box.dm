//happy prigraming word

/obj/item/robot_parts/equippable/module_box
   name = "cyborg modular printer"
   desc = "Prints chosen equipmen from itself"
   icon_state = "module_box"
   item_state = "syringe_kit"
   origin_tech = "materials=1;programming=1;powerstorage=1"
   force = 3
   throwforce = 5
   var/obj/control_panell = null
   var/list/avalable_equipment_sets = list("Standard", "Engineering", "Medical", "Miner", "Janitor", "Service", "Security")
   // for save list("Standard", "Engineering", "Medical", "Miner", "Janitor","Service", "Security")

   /obj/item/robot_parts/equippable/module_box/proc/Print_module(var/mob/living/silicon/robot/M)
      if (!istype(loc, /obj/item/robot_parts/chest))
         return
         // cat print equipmen only in borg chests
      var/obj/item/robot_parts/chest/CH = loc
      var/chosen_set = input("Please, select a equipment set!", "Robot", null, null) in avalable_equipment_sets
      if(!src.check_enough_plase(chosen_set, CH))
         M << "<span class='warning'>There are not enogh plase for [chosen_set] equipment set.</span>"
         return

      src.detach_from_robot(M)
      CH.modules -= src
      CH.free_module_slots += 1

      print_equipment(chosen_set, CH, M)

      for (var/obj/item/robot_parts/T in modules)
         CH.modules += T
         CH.free_module_slots -= 1
         T.attach_to_robot(M)
         modules -= T
      M.hud_used.update_robot_modules_display()
      qdel(src)

   /obj/item/robot_parts/equippable/module_box/proc/check_enough_plase(var/chosen_set, var/obj/item/robot_parts/chest/CH, var/mob/living/silicon/robot/M)
      switch(chosen_set)
         if("Standard")
            return (CH.free_module_slots >= 4)

         if("Engineering")
            return (CH.free_module_slots >= 7)

         if("Medical")
            return (CH.free_module_slots >= 8)

         if("Miner")
            return (CH.free_module_slots >= 6)

         if("Janitor")
            return (CH.free_module_slots >= 5)

         if("Service")
            return (CH.free_module_slots >= 8)

         if("Security")
            return (CH.free_module_slots >= 3)

         if("Sindicate")
            return (CH.free_module_slots >= 5)

      M << "<span class='warning'>something vent wrong</span>"
      return 0

   /obj/item/robot_parts/equippable/module_box/proc/print_equipment(var/chosen_set, var/obj/item/robot_parts/chest/CH, var/mob/living/silicon/robot/M)
      var/animation_length=0
      switch(chosen_set)
         if("Standard")
            M.hands.icon_state = "standard"
            M.icon_state = "robot"
            M.modtype = "Stand"
            modules += new/obj/item/robot_parts/equippable/energy/stanbaton(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/extinguisher(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/wrench(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/healthanalyzer(CH)

         if("Engineering")
            M.hands.icon_state = "engineer"
            M.icon_state = "engiborg"
            animation_length = 45
            M.modtype = "Eng"
            modules += new/obj/item/robot_parts/equippable/sight/meson(CH)
            modules += new/obj/item/robot_parts/equippable/energy/RCD(CH)
            modules += new/obj/item/robot_parts/equippable/energy/RPD(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/extinguisher(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/weldingtool/largetank(CH)
            modules += new/obj/item/robot_parts/equippable/cyborg_toolbox/engineering(CH)
            modules += new/obj/item/robot_parts/equippable/energy/storage_user/engineering(CH)
            modules += new/obj/item/robot_parts/equippable/energy/storage_user/wire(CH)

         if("Medical")
            M.hands.icon_state = "medical"
            M.icon_state = "mediborg"
            animation_length = 35
            M.modtype = "Med"
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/healthanalyzer(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/borghypo(CH)
            modules += new/obj/item/robot_parts/equippable/plaseble/beaker/large(CH)
            modules += new/obj/item/robot_parts/equippable/plaseble/dropper(CH)
            modules += new/obj/item/robot_parts/equippable/plaseble/syringe(CH)
            modules += new/obj/item/robot_parts/equippable/cyborg_toolbox/medical(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/extinguisher/mini(CH)
            modules += new/obj/item/robot_parts/equippable/storage/roller_dock(CH)
            modules += new/obj/item/robot_parts/equippable/energy/storage_user/gauze(CH)

         if("Miner")
            M.hands.icon_state = "miner"
            M.icon_state = "minerborg"
            animation_length = 30
            M.modtype = "Miner"
            modules += new/obj/item/robot_parts/equippable/sight/meson(CH)
            modules += new/obj/item/robot_parts/equippable/storage/ore_bag(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/drill(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/shovel(CH)
            modules += new/obj/item/robot_parts/equippable/storage/sheetsnatcher(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/mining_scanner/advanced(CH)
            modules += new/obj/item/robot_parts/equippable/energy/gun_holder/kinetic_accelerator(CH)

         if("Janitor")
            M.hands.icon_state = "janitor"
            M.icon_state = "janiborg"
            animation_length = 22
            M.modtype = "Jan"
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/soap/nanotrasen(CH)
            modules += new/obj/item/robot_parts/equippable/storage/trash(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/mop(CH)
            modules += new/obj/item/robot_parts/equippable/energy/lightreplacer(CH)            //!!!
            modules += new/obj/item/robot_parts/equippable/plaseble/bucket(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/holosign_creator(CH)

         if("Service")
            M.hands.icon_state = "service"
            var/icontype = input("Select an icon!", "Robot", null, null) in list("Waitress", "Bro", "Butler", "Kent", "Rich")
            switch(icontype)
               if("Waitress")
                  M.icon_state = "service_female"
                  animation_length=45
               if("Kent")
                  M.icon_state = "toiletbot"
               if("Bro")
                  M.icon_state = "brobot"
                  animation_length=54
               if("Rich")
                  M.icon_state = "maximillion"
                  animation_length=60
               else
                  M.icon_state = "service_male"
                  animation_length=43
            M.modtype = "Butler"
            modules += new/obj/item/robot_parts/equippable/plaseble/drinkingglass(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/enzyme(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/pen(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/razor(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/violin(CH)
            modules += new/obj/item/robot_parts/equippable/energy/RSF(CH)
            modules += new/obj/item/robot_parts/equippable/plaseble/dropper(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/zippo(CH)
            modules += new/obj/item/robot_parts/equippable/storage/tray(CH)
            modules += new/obj/item/robot_parts/equippable/energy/fabricator/shaker(CH)

         if("Security")
            M.hands.icon_state = "security"
            M.icon_state = "secborg"
            animation_length = 28
            M.modtype = "Sec"
            modules += new/obj/item/robot_parts/equippable/simple_tool/handcuffs(CH)
            modules += new/obj/item/robot_parts/equippable/energy/stanbaton(CH)
            modules += new/obj/item/robot_parts/equippable/energy/gun_holder/advtaser(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/sechailer(CH)

         if("Sindicate")
            modules += new/obj/item/robot_parts/equippable/simple_tool/e_sword(CH)
            modules += new/obj/item/robot_parts/equippable/energy/gun_holder/printer(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/emag(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/jetpack(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/small/crowbar/red(CH)
            modules += new/obj/item/robot_parts/equippable/simple_tool/pinpointer/operative(CH)

      M.transform_animation(animation_length)
      M.notify_ai(2)
      M.update_icons()
      M.update_headlamp()

/mob/living/silicon/robot/proc/transform_animation(animation_length)
   if(!animation_length)
      return
   icon = 'icons/mob/robot_transformations.dmi'
   src.dir = SOUTH
   notransform = 1
   flick(icon_state, src)
   sleep(animation_length+1)
   notransform = 0
   icon = 'icons/mob/robots.dmi'

/obj/item/robot_parts/equippable/module_box/New()
   ..()
   control_panell = new/obj/item/borg/controle/module_box(src)


/obj/item/robot_parts/equippable/module_box/attach_to_robot(var/mob/living/silicon/robot/M)
   holding_robot = M
   if(M.module)
      if(control_panell)
         M.module.modules += control_panell
         control_panell.loc = M.module
         M.module.rebuild()        //No need to fix modules, as it's done in rebild()

/obj/item/robot_parts/equippable/module_box/detach_from_robot(var/mob/living/silicon/robot/M)
   if(control_panell)
      M.uneq_module(control_panell)
      if(M.module)
         M.module.modules.Remove(control_panell)
      control_panell.loc = src
      if(M.module)
         M.module.rebuild()
   holding_robot = null


/obj/item/robot_parts/equippable/module_box/sindicate
   icon_state = "sindi_module_box"
   origin_tech = "materials=4;programming=3;powerstorage=4;magnets=3;syndicate=5"
   avalable_equipment_sets = list("Sindicate")

/obj/item/robot_parts/equippable/module_box/sindicate/New()
   ..()
   if(control_panell)
      qdel(control_panell)
   control_panell = new/obj/item/borg/controle/module_box/sindicate(src)
