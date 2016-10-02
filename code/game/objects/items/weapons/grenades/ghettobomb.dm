//improvised explosives//

/obj/item/weapon/grenade/iedcasing
	name = "improvised firebomb"
	desc = "A weak, improvised incendiary device."
	w_class = 2.0
	icon = 'icons/obj/grenade.dmi'
	icon_state = "improvised_grenade"
	item_state = "flashbang"
	throw_speed = 3
	throw_range = 7
	flags = CONDUCT
	slot_flags = SLOT_BELT
	active = 0
	det_time = 50
	display_timer = 0
	var/range = 3
	var/times = list()

/obj/item/weapon/grenade/iedcasing/New(loc)
	..()
	overlays += image('icons/obj/grenade.dmi', icon_state = "improvised_grenade_filled")
	overlays += image('icons/obj/grenade.dmi', icon_state = "improvised_grenade_wired")
	times = list("5" = 10, "-1" = 20, "[rand(30,80)]" = 50, "[rand(65,180)]" = 20)// "Premature, Dud, Short Fuse, Long Fuse"=[weighting value]
	det_time = text2num(pickweight(times))
	if(det_time < 0) //checking for 'duds'
		range = 1
		det_time = rand(30,80)
	else
		range = pick(2,2,2,3,3,3,4)

/obj/item/weapon/grenade/iedcasing/CheckParts()
	var/obj/item/weapon/reagent_containers/food/drinks/soda_cans/can = locate() in contents
	if(can)
		var/muh_layer = can.layer
		can.layer = FLOAT_LAYER
		underlays += can
		can.layer = muh_layer


/obj/item/weapon/grenade/iedcasing/attack_self(mob/user as mob) //
	if(!active)
		if(clown_check(user))
			user << "<span class='warning'>You light the [name]!</span>"
			active = 1
			overlays -= image('icons/obj/grenade.dmi', icon_state = "improvised_grenade_filled")
			icon_state = initial(icon_state) + "_active"
			add_fingerprint(user)
			var/turf/bombturf = get_turf(src)
			var/area/A = get_area(bombturf)

			message_admins("[key_name(usr)]<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A> has primed a [name] for detonation at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
			log_game("[key_name(usr)] has primed a [name] for detonation at [A.name] ([bombturf.x],[bombturf.y],[bombturf.z]).")
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
			spawn(det_time)
				prime()

/obj/item/weapon/grenade/iedcasing/prime() //Blowing that can up
	update_mob()
	explosion(src.loc,-1,-1,-1, flame_range = range)	// no explosive damage, only a large fireball.
	qdel(src)

/obj/item/weapon/grenade/iedcasing/examine(mob/user)
	..()
	user << "You can't tell when it will explode!"



/obj/item/weapon/grenade/clustered_ied
	name = "clustered IED"
	desc = "A cluster of weak, improvised incendiary devices."
	w_class = 3.0
	icon = 'icons/obj/grenade.dmi'
	icon_state = "cluster_ied"
	item_state = "military"
	throw_speed = 3
	throw_range = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	active = 0
	det_time = 50
	display_timer = 0
	var/secured = 0
	var/obj/item/device/assembly/signaler/signaler

/obj/item/weapon/grenade/clustered_ied/New(loc)
	..()
	secured = pick(0, 0, 0, 1)

/obj/item/weapon/grenade/clustered_ied/CheckParts()
	signaler = locate() in contents
	if (!signaler)
		signaler = new/obj/item/device/assembly/signaler
	signaler.holder = src

/obj/item/weapon/grenade/clustered_ied/attack_self(mob/user)
	signaler.attack_self(user)

/obj/item/weapon/grenade/clustered_ied/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/weapon/screwdriver))
		if (secured == 0)
			secured = 1
			user << "<span class='notice'>You secure the [initial(name)] assembly.</span>"
		else
			secured = 0
			user << "<span class='notice'>You unsecure the [initial(name)] assembly.</span>"

/obj/item/weapon/grenade/clustered_ied/proc/process_activation(var/obj/item/device/D, var/normal = 1, var/special = 1, var/source = "*No Source*", var/usr_name = "*No mob*")
	if (secured == 1)
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)
		message_admins("[usr_name] has primed a [name] for detonation via <A HREF='?_src_=holder;secretsadmin=list_signalers'>signaler</A> at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
		log_game("[usr_name] has primed a [name] for detonation via <A HREF='?_src_=holder;secretsadmin=list_signalers'>signaler</A> at [A.name] ([bombturf.x],[bombturf.y],[bombturf.z]).")

		prime()

/obj/item/weapon/grenade/clustered_ied/prime() //Blowing that can up
	update_mob()
	explosion(src.loc, 1, 2, 4, flame_range = rand(3,5))	// BOOM BOOM SHAKE THE ROOM
	qdel(src)

/obj/item/weapon/grenade/clustered_ied/examine(mob/user)
	..()
	user << "It is [secured ? "secured" : "unsecured"]."