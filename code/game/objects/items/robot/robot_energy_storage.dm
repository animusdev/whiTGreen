/datum/robot_energy_storage
   var/name = "Generic energy storage"
   var/max_energy = 30000
   var/recharge_rate = 1000
   var/recharge_cost = 500 //rapig draining borg energy
   var/energy

/datum/robot_energy_storage/New()
   energy = max_energy
   return

/datum/robot_energy_storage/proc/use_charge(var/amount)
   if (energy >= amount)
      energy -= amount
      if (energy == 0)
         return 1
      return 2
   else
      return 0

/datum/robot_energy_storage/proc/add_charge(var/amount)
   energy = min(energy + amount, max_energy)

/datum/robot_energy_storage/metal
   name = "Metal Synthesizer"

/datum/robot_energy_storage/glass
   name = "Glass Synthesizer"

/datum/robot_energy_storage/wire
   max_energy = 50
   recharge_rate = 2
   recharge_cost = 100
   name = "Wire Synthesizer"

/datum/robot_energy_storage/gauze
   max_energy = 2500
   recharge_rate = 250
   recharge_cost = 200
   name = "Gauze Synthesizer"


//================================================================================

/obj/item/robot_parts/equippable/energy/storage_user
   direct_draw = 0
   allow_draw = 0
   var/list/storages = list()
   var/list/materials = list()

/obj/item/robot_parts/equippable/energy/storage_user/attach_to_robot(var/mob/living/silicon/robot/M)
   holding_robot = M
   if(modules && M.module)
      M.module.energy_consumers += src
      for(var/obj/O in materials)
         M.module.modules += O
         O.loc = M.module
   if(storages && M.module)
      for(var/datum/robot_energy_storage/O in storages)
         M.module.storages += O
   M.module.rebuild()        //No need to fix modules, as it's done in rebild()
   allow_draw = 0

/obj/item/robot_parts/equippable/energy/storage_user/detach_from_robot(var/mob/living/silicon/robot/M)
   if(modules && M.module)
      M.module.energy_consumers.Remove(src)
      for(var/obj/O in materials)
         M.uneq_module(O)
         M.module.modules.Remove(O)
         O.loc = src
   if(storages && M.module)
      for(var/datum/robot_energy_storage/O in storages)
         M.module.storages.Remove(O)
   M.module.rebuild()        //No need to fix modules, as it's done in rebild()
   holding_robot = null
   allow_draw = 0

/obj/item/robot_parts/equippable/energy/storage_user/process()
   if(!holding_robot)
      return 0

   if(!allow_draw)
      return 0

   if (storages)
      for(var/datum/robot_energy_storage/S in storages)
         if(holding_robot.cell.use(S.recharge_cost))                //Take power from the borg...
            S.energy = min(S.max_energy, S.energy + S.recharge_rate)   //... to restock the storage

   return 1


/obj/item/robot_parts/equippable/energy/storage_user/engineering
   name = "cyborg engineering fabricator"
   desc = "Cyborg module which allows metal and glass using."
   icon_state = "eng_fabricator"

/obj/item/robot_parts/equippable/energy/storage_user/engineering/New()
   ..()
   var/datum/robot_energy_storage/metal/metstore = new /datum/robot_energy_storage/metal(src)
   var/datum/robot_energy_storage/glass/glastore = new /datum/robot_energy_storage/glass(src)

   var/obj/item/stack/sheet/metal/cyborg/M = new /obj/item/stack/sheet/metal/cyborg(src)
   M.source = metstore
   materials += M

   var/obj/item/stack/sheet/glass/cyborg/Q = new /obj/item/stack/sheet/glass/cyborg(src)
   Q.source = glastore
   materials += Q

   var/obj/item/stack/sheet/rglass/cyborg/G = new /obj/item/stack/sheet/rglass/cyborg(src)
   G.metsource = metstore
   G.glasource = glastore
   materials += G

   var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
   R.source = metstore
   materials += R

   var/obj/item/stack/tile/plasteel/cyborg/F = new /obj/item/stack/tile/plasteel/cyborg(src) //"Plasteel" is the normal metal floor tile, Don't be confused - RR
   F.source = metstore
   materials += F //'F' for floor tile - RR(src)

   storages += metstore
   storages += glastore


/obj/item/robot_parts/equippable/energy/storage_user/wire
   name = "cyborg wire fabricator"
   desc = "Cyborg module which allows wire using."
   icon_state = "wire_fabricator"

/obj/item/robot_parts/equippable/energy/storage_user/wire/New()
   ..()
   var/datum/robot_energy_storage/wire/wirestore = new /datum/robot_energy_storage/wire(src)

   var/obj/item/stack/cable_coil/cyborg/W = new /obj/item/stack/cable_coil/cyborg(src,MAXCOIL,pick("red","yellow","green","blue","pink","orange","cyan","white"))
   W.source = wirestore
   materials += W

   storages += wirestore


/obj/item/robot_parts/equippable/energy/storage_user/gauze
   name = "cyborg gauze fabricator"
   desc = "Cyborg module which allows gauze using."
   icon_state = "gauze"
   icon = 'icons/obj/items.dmi'

/obj/item/robot_parts/equippable/energy/storage_user/gauze/New()
   ..()
   var/datum/robot_energy_storage/gauze/gauzestore = new /datum/robot_energy_storage/gauze(src)

   var/obj/item/stack/medical/gauze/cyborg/G = new /obj/item/stack/medical/gauze/cyborg(src)
   G.source = gauzestore
   materials += G

   storages += gauzestore
