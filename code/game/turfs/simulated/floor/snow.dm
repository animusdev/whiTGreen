/turf/simulated/floor/plating/snow //cold and snowy
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	icon_plating = "snow"
	temperature = 70 // Enough for wintercoats to protect from cold

/turf/simulated/floor/plating/snow/New()
	..()
	if(prob(20))
		icon_state = "snow[rand(0,12)]"

/turf/simulated/floor/plating/snowplating
	name = "snowy plating"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snowplating"
	icon_plating = "snowplating"
	temperature = 70