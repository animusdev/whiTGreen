
/obj/item/weapon/mob_holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD

/obj/item/weapon/mob_holder/New()
	item_state = icon_state
	..()
	SSobj.processing.Add(src)

/obj/item/weapon/mob_holder/Del()
	SSobj.processing.Remove(src)
	..()

/obj/item/weapon/mob_holder/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		del(src)

/obj/item/weapon/mob_holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/weapon/mob_holder/proc/show_message(var/message, var/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber)
	if(!holder_type || buckled)
		return

	var/obj/item/weapon/mob_holder/H = new holder_type(loc)
	src.loc = H
	H.name = loc.name
	H.attack_hand(grabber)
	grabber << "You scoop up [src]."
	src << "[grabber] scoops you up."
	return

//Mob specific holders.

/obj/item/weapon/mob_holder/cat
	name = "cat"
	desc = "It's a cat. Meow."
	icon_state = "cat"
	origin_tech = null
