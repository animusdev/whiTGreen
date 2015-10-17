
/obj/item/weapon/twohanded/mob_holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/mob/animal.dmi'
	dir = EAST
	var/mob/living/occupant

/obj/item/weapon/twohanded/mob_holder/New()
	item_state = icon_state
	..()
	SSobj.processing.Add(src)

/obj/item/weapon/twohanded/mob_holder/Del()
	SSobj.processing.Remove(src)
	..()

/obj/item/weapon/twohanded/mob_holder/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		del(src)


/obj/item/weapon/twohanded/mob_holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/weapon/twohanded/mob_holder/proc/show_message(message, m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and vars for scooping up
/mob/living/var/holder_type


/mob/living/proc/get_scooped(mob/living/carbon/grabber)
	if(!holder_type || buckled)
		return

	var/obj/item/weapon/twohanded/mob_holder/H = new holder_type(loc)
	H.name = src.name
	src.loc = H
	H.attack_hand(grabber)
	H.occupant = src
	grabber << "You scoop up [src]."
	src << "[grabber] scoops you up."
	H.icon = src.icon
	H.icon_state = src.icon_state
	H.name = src.name
	H.desc = src.desc
	return H


/obj/item/weapon/twohanded/mob_holder/attack_self(mob/user)
	return

/obj/item/weapon/twohanded/mob_holder/required/dropped(mob/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield(user)
	return	..()




/obj/item/weapon/twohanded/mob_holder/required/attack_hand(mob/living/carbon/user)
	if(user.l_hand || user.r_hand)
		user<<"You need your other hand to be empty!"
		return 0
	var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on the [name]"
	user.put_in_inactive_hand(O)
	wielded = 1
	..()
	return 1



//Mob specific holders.

/obj/item/weapon/twohanded/mob_holder/required/dog/corgi
	name = "dog"
	desc = "It's a dog. Woof."
	icon_state = "corgi"
	w_class = 5.0


/obj/item/weapon/twohanded/mob_holder/cat
	name = "cat"
	desc = "It's a cat. Meow."
	icon_state = "cat"

/obj/item/weapon/twohanded/mob_holder/mouse
	name = "mouse"
	desc = "It's a nasty, ugly, evil, disease-ridden rodent."
	icon_state = "mouse_gray"
	w_class = 2.0

/obj/item/weapon/twohanded/mob_holder/lizard
	name = "lizard"
	desc = "It's a Lizard."
	icon_state = "lizard"
	w_class = 2.0

/obj/item/weapon/twohanded/mob_holder/chicken
	name = "chicken"
	desc = "It's a chicken."
	icon_state = "chicken"

/obj/item/weapon/twohanded/mob_holder/chick
	name = "chick"
	desc = "It's a chick."
	icon_state = "chick"
