/obj/item/stack/tile/mineral/plasma
	name = "plasma tile"
	singular_name = "plasma floor tile"
	desc = "A tile made out of highly flammable plasma. This can only end well."
	icon_state = "tile_plasma"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "plasma=1"
	turf_type = /turf/simulated/floor/mineral/plasma
	mineralType = "plasma"

/obj/item/stack/tile/mineral/uranium
	name = "uranium tile"
	singular_name = "uranium floor tile"
	desc = "A tile made out of uranium. You feel a bit woozy."
	icon_state = "tile_uranium"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "material=1"
	turf_type = /turf/simulated/floor/mineral/uranium
	mineralType = "uranium"
	var/rad_buildup = 0
	var/rad_pwr = 0

/obj/item/stack/tile/mineral/uranium/enr
	turf_type = /turf/simulated/floor/mineral/uranium/enr
	weldCallback = "enrich"
	rad_pwr = 0.25

/obj/item/stack/tile/mineral/uranium/New(var/loc, var/amount=null)
	SSobj.processing.Add(src)
	..()

/obj/item/stack/tile/mineral/uranium/Destroy()
	SSobj.processing.Remove(src)
	..()

/obj/item/stack/tile/mineral/uranium/process()
	radiate()
	if(!rad_pwr && prob((rad_buildup/rad_pwr)*IRRADIATION_RADIOACTIVITY_MODIFIER*33))
		enrich()

/obj/item/stack/tile/mineral/uranium/irradiate(rad)
	..()
	if(!rad)
		return
	rad_buildup += rad

/obj/item/stack/tile/mineral/uranium/proc/radiate()
	if(amount != amount)
		return //sanity
	for(var/atom/A in orange(1,src))
		A.irradiate((amount/max_amount)*(rad_pwr+rad_buildup*IRRADIATION_RADIOACTIVITY_MODIFIER))
	IRRADIATION_RETARDATION(rad_buildup)

/obj/item/stack/tile/mineral/uranium/proc/enrich()
	turf_type = /turf/simulated/floor/mineral/uranium/enr
	weldCallback = "enrich"
	rad_pwr = 0.25

/obj/item/stack/tile/mineral/gold
	name = "gold tile"
	singular_name = "gold floor tile"
	desc = "A tile made out of gold, the swag seems strong here."
	icon_state = "tile_gold"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "material=1"
	turf_type = /turf/simulated/floor/mineral/gold
	mineralType = "gold"

/obj/item/stack/tile/mineral/silver
	name = "silver tile"
	singular_name = "silver floor tile"
	desc = "A tile made out of silver, the light shining from it is blinding."
	icon_state = "tile_silver"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "material=1"
	turf_type = /turf/simulated/floor/mineral/silver
	mineralType = "silver"

/obj/item/stack/tile/mineral/diamond
	name = "diamond tile"
	singular_name = "diamond floor tile"
	desc = "A tile made out of diamond. Wow, just, wow."
	icon_state = "tile_diamond"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "material=2"
	turf_type = /turf/simulated/floor/mineral/diamond
	mineralType = "diamond"

/obj/item/stack/tile/mineral/bananium
	name = "bananium tile"
	singular_name = "bananium floor tile"
	desc = "A tile made out of bananium, HOOOOOOOOONK!"
	icon_state = "tile_bananium"
	w_class = 3.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	origin_tech = "material=1"
	turf_type = /turf/simulated/floor/mineral/bananium
	mineralType = "bananium"

