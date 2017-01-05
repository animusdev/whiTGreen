/datum/round_event_control/spider_infestation
   name = "Spider Infestation"
   typepath = /datum/round_event/spider_infestation
   weight = 5
   max_occurrences = 1
   minimal_players = 15

/datum/round_event/spider_infestation
   announceWhen   = 400

   var/spawncount = 1


/datum/round_event/spider_infestation/setup()
   announceWhen = rand(announceWhen, announceWhen + 50)
   spawncount = rand(5, 8)

/datum/round_event/spider_infestation/announce()
   priority_announce("Ќа борƒу обнаружены неоЅознанные формы жизни. Ќеоб одимо обе«Ѕечиƒь безоЅа«но«ƒь в«е  возможны  в одов на «ƒанцию, включа&#255; возду оводы и венƒил&#255;ционные ∆а ƒы.", "Lifesign Alert", 'sound/AI/aliens.ogg')


/datum/round_event/spider_infestation/start()
   var/list/vents = list()
   for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
      if(temp_vent.loc.z == ZLEVEL_STATION && !temp_vent.welded)
         if(temp_vent.parent.other_atmosmch.len > 20)
            vents += temp_vent

   while((spawncount >= 1) && vents.len)
      var/obj/vent = pick(vents)
      var/obj/effect/spider/spiderling/S = new(vent.loc)
      if(prob(66))
         S.grow_as = /mob/living/simple_animal/hostile/poison/giant_spider/nurse
      vents -= vent
      spawncount--