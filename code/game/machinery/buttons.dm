/obj/machinery/driver_button
	name = "mass driver button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mass driver."
	var/id = null
	var/active = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/ignition_switch
	name = "ignition switch"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mounted igniter."
	var/id = null
	var/active = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/flasher_button
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	var/id = null
	var/active = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/crema_switch
	desc = "Burn baby burn!"
	name = "crematorium igniter"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	anchored = 1
	var/on = 0
	var/area/area = null
	var/otherarea = null
	var/id = 1

/obj/gibbutton
	name = "big red button"
	desc = "Button that will kill you if you press it."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bigred"
	anchored = 1

/obj/gibbutton/proc/lol(mob/living/retard as mob)
	retard.gib(1)
	message_admins("[(retard)] has self gibbed by pressing gibbutton.")

/obj/gibbutton/attack_hand(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_animal(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_paw(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_alien(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_larva(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_slime(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_robot(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attack_ai(mob/living/retard as mob)
	lol(retard)

/obj/gibbutton/attackby(obj/item/W, mob/retard, params)
	..()
	lol(retard)
