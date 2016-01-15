/*Completely generic structures for use by mappers to create fake objects, i.e. display rooms*/
/obj/structure/showcase
	name = "showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1

/obj/structure/showcase/fakeid
	name = "\improper Centcom identification console"
	desc = "You can use this to change ID's."
	icon = 'icons/obj/computer.dmi'
	icon_state = "id"

/obj/structure/showcase/fakesec
	name = "\improper Centcom security records"
	desc = "Used to view and edit personnel's security records"
	icon = 'icons/obj/computer.dmi'
	icon_state = "security"

/obj/structure/showcase/oldclock
	name = "Grandfather clock"
	desc = "Antique clock from 18th century."
	icon_state = "clock"

/obj/structure/showcase/oldclock/examine(mob/user)
	..()
	user<<"<span class='notice'>The arrows point at [worldtime2text()].</span>"
	if(prob(20))
		user<<"<span class='notice'>It's [pick("nap","tea","beer","sandwich","disco","breakfast","rampage")] time.</span>"
