/turf/simulated/wall/mineral
	name = "mineral wall"
	icon_state = ""
	var/last_event = 0
	var/active = null

/turf/simulated/wall/mineral/New()
	sheet_type = text2path("/obj/item/stack/sheet/mineral/[mineral]")
	..()

/turf/simulated/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	icon_state = "gold0"
	walltype = "gold"
	mineral = "gold"
	//var/electro = 1
	//var/shocked = null

/turf/simulated/wall/mineral/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	icon_state = "silver0"
	walltype = "silver"
	mineral = "silver"
	//var/electro = 0.75
	//var/shocked = null

/turf/simulated/wall/mineral/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	icon_state = "diamond0"
	walltype = "diamond"
	mineral = "diamond"
	slicing_duration = 200   //diamond wall takes twice as much time to slice

/turf/simulated/wall/mineral/diamond/thermitemelt(mob/user as mob)
	return

/turf/simulated/wall/mineral/clown
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	icon_state = "bananium0"
	walltype = "bananium"
	mineral = "bananium"

/turf/simulated/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating."
	icon_state = "sandstone0"
	walltype = "sandstone"
	mineral = "sandstone"

/turf/simulated/wall/mineral/uranium
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon_state = "uranium0"
	walltype = "uranium"
	mineral = "uranium"
	var/rad_buildup = 0
	var/rad_pwr = 0

/turf/simulated/wall/mineral/uranium/enr
	sheet_breakCallback = "enrich"
	rad_pwr = 0.6

/turf/simulated/wall/mineral/uranium/New()
	SSobj.processing.Add(src)
	..()

/turf/simulated/wall/mineral/uranium/Destroy()
	SSobj.processing.Remove(src)
	..()

/turf/simulated/wall/mineral/uranium/process()
	radiate()
	if(!rad_pwr && prob((rad_buildup/rad_pwr)*IRRADIATION_RADIOACTIVITY_MODIFIER*33))
		enrich()

/turf/simulated/wall/mineral/uranium/irradiate(rad)
	..()
	if(!rad)
		return
	rad_buildup += rad

/turf/simulated/wall/mineral/uranium/proc/radiate(rad)
	for(var/atom/A in orange(1,src))
		A.irradiate(rad_pwr+rad_buildup*IRRADIATION_RADIOACTIVITY_MODIFIER)
	IRRADIATION_RETARDATION(rad_buildup)

/turf/simulated/wall/mineral/uranium/proc/enrich()
	sheet_breakCallback = "enrich"
	rad_pwr = 0.6

/turf/simulated/wall/mineral/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definately a bad idea."
	icon_state = "plasma0"
	walltype = "plasma"
	mineral = "plasma"
	thermal_conductivity = 0.04

/turf/simulated/wall/mineral/plasma/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(is_hot(W) > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma wall ignited by [key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Plasma wall ignited by [user.ckey]([user]) in ([x],[y],[z])")
		ignite(is_hot(W))
		return
	..()

/turf/simulated/wall/mineral/plasma/proc/PlasmaBurn(temperature)
	new /obj/structure/girder(src)
	src.ChangeTurf(/turf/simulated/floor/plasteel)
	atmos_spawn_air(SPAWN_HEAT | SPAWN_TOXINS, 400)

/turf/simulated/wall/mineral/plasma/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/simulated/wall/mineral/plasma/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PlasmaBurn(exposed_temperature)

/turf/simulated/wall/mineral/plasma/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		PlasmaBurn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		PlasmaBurn(500)
	..()

/*
/turf/simulated/wall/mineral/proc/shock()
	if (electrocute_mob(user, C, src))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		return 1
	else
		return 0

/turf/simulated/wall/mineral/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if((mineral == "gold") || (mineral == "silver"))
		if(shocked)
			shock()
*/

/turf/simulated/wall/mineral/wood
	name = "wooden wall"
	desc = "A wall with wooden plating."
	icon_state = "wood0"
	walltype = "wood"
	mineral = "wood"
	hardness = 70
