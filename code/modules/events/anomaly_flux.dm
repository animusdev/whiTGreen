/datum/round_event_control/anomaly/anomaly_flux
	name = "Anomaly: Hyper-Energetic Flux"
	typepath = /datum/round_event/anomaly/anomaly_flux
	max_occurrences = 5
	weight = 20
	minimal_players = 5

/datum/round_event/anomaly/anomaly_flux
	startWhen = 10
	announceWhen = 2
	endWhen = 110


/datum/round_event/anomaly/anomaly_flux/announce()
	priority_announce("«арегистрировано возникновение сверхактивной энерго-волновой аномалии. ѕриблизительное местонахождение: [impact_area.name].", "Anomaly Alert")


/datum/round_event/anomaly/anomaly_flux/start()
	var/turf/T = pick(get_area_turfs(impact_area))
	if(T)
		newAnomaly = new /obj/effect/anomaly/flux(T.loc)


/datum/round_event/anomaly/anomaly_flux/end()
	if(newAnomaly.loc)//If it hasn't been neutralized, it's time to blow up.
		explosion(newAnomaly, -1, 3, 5, 5)
		qdel(newAnomaly)