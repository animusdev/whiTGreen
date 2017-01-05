/datum/round_event_control/anomaly/anomaly_vortex
   name = "Anomaly: Vortex"
   typepath = /datum/round_event/anomaly/anomaly_vortex
   max_occurrences = 1
   weight = 2
   minimal_players = 15

/datum/round_event/anomaly/anomaly_vortex
   startWhen = 30
   announceWhen = 3
   endWhen = 100


/datum/round_event/anomaly/anomaly_vortex/announce()
   priority_announce("«аре и«ƒрировано возникновение вы«окоинƒен«ивной ви ревой аномалии. Ѕриблизиƒельное ме«ƒона ождение: [impact_area.name]", "Anomaly Alert")

/datum/round_event/anomaly/anomaly_vortex/start()
   var/turf/T = pick(get_area_turfs(impact_area))
   if(T)
      newAnomaly = new /obj/effect/anomaly/bhole(T.loc)