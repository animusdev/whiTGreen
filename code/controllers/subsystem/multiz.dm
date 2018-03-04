var/datum/subsystem/multiz/SSmultiz

/datum/subsystem/multiz
	name = "MultiZ"

/datum/subsystem/multiz/New()
	NEW_SS_GLOBAL(SSmultiz)

/datum/subsystem/multiz/Initialize(start_timeofday, zlevel)
	for(var/obj/effect/landmark/zcontroller/ZC)
		ZC.views_init()
	..()