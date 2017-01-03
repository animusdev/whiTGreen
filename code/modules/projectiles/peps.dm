/obj/item/weapon/stock_parts/cell/peps
	name = "PEPS cell"
	desc = "A rechargeable cell suited for using in Pulsed Energy Projection System."
	icon = 'icons/obj/PEPS/peps-misc-dmi.dmi'
	icon_state = "cell_loaded"
	maxcharge = 20000
	chargerate = 200
	var/can_charge = 1

/obj/item/weapon/stock_parts/cell/peps/updateicon()
	if(charge < 0.01)
		return
	else if(charge > 19000)
		icon_state = "cell_loaded"
	else
		icon_state = "cell_unloaded"

/obj/item/projectile/energy/electrode/peps
	name = "pressure wave"
	icon_state = "pulse1_bl"
	color = null
	range = 7

/obj/item/projectile/energy/electrode/peps/Range()
	range--
	if(range <= 0)
		on_range()

/obj/item/projectile/energy/electrode/peps/on_hit(atom/target, blocked = 0)
	..()
	if(iscarbon(target) && range>=4)
		var/mob/living/carbon/C = target
		C << "<span class='warning'>You feel a pressure wave knocking you down!</span>"
		C.sleeping = 60
		C.Paralyse(70)

/obj/item/ammo_casing/energy/electrode/peps
	projectile_type = /obj/item/projectile/energy/electrode/peps
	fire_sound = 'sound/effects/sparks4.ogg'
	e_cost = 19000
	delay = 6
	pellets = 6
	variance = 0.65

/obj/item/weapon/gun/peps
	name = "PEPS"
	desc = "The Pulsed Energy Projection System, a modern non-lethal weapon using concentrated blasts to create pressure wave that knocks down opponents."
	icon = 'icons/obj/PEPS/PEPS-dmi.dmi'
	icon_state = "peps_loaded"
	item_state = "peps"
	lefthand_file = 'icons/mob/inhands/peps_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/peps_righthand.dmi'

	var/obj/item/weapon/stock_parts/cell/peps/power_supply //What type of power cell this uses
	var/cell_type = /obj/item/weapon/stock_parts/cell/peps
	var/list/ammo_type = list(/obj/item/ammo_casing/energy/electrode/peps)
	var/select = 1
	var/obj/item/ammo_casing/energy/shot

/obj/item/weapon/gun/peps/emp_act(severity)
	if(power_supply)
		power_supply.use(round(power_supply.charge / severity))
		power_supply.updateicon()
		update_icon()

/obj/item/weapon/gun/peps/New()
	..()
	power_supply = new cell_type(src)
	power_supply.give(power_supply.maxcharge)
	var/obj/item/ammo_casing/energy/shot
	for (var/i = 1, i <= ammo_type.len, i++)
		var/shottype = ammo_type[i]
		shot = new shottype(src)
		ammo_type[i] = shot
	shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	update_icon()
	return

/obj/item/weapon/gun/peps/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, params)
	newshot() //prepare a new shot
	..()

/obj/item/weapon/gun/peps/can_shoot()
	if (!power_supply)
		return 0
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	return power_supply.charge >= shot.e_cost

/obj/item/weapon/gun/peps/newshot()
	if (!ammo_type || !power_supply)
		return
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(power_supply.charge >= shot.e_cost) //if there's enough power in the power_supply cell...
		chambered = shot //...prepare a new shot based on the current ammo type selected
		chambered.newshot()
	return

/obj/item/weapon/gun/peps/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/energy/shot = chambered
		power_supply.use(shot.e_cost)//... drain the power_supply cell
	chambered = null //either way, released the prepared shot
	return

/obj/item/weapon/gun/peps/proc/select_fire(mob/living/user)
	select++
	if (select > ammo_type.len)
		select = 1
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	if (shot.select_name)
		user << "<span class='notice'>[src] is now set to [shot.select_name].</span>"
	update_icon()
	return

/obj/item/weapon/gun/peps/update_icon()
	if (!power_supply)
		icon_state = "peps_empty"
		return
	if(power_supply.charge < 19000)
		icon_state = "peps_unloaded"
	else if(power_supply.charge > 19000)
		icon_state = "peps_loaded"
	return

/obj/item/weapon/gun/peps/ui_action_click()
	toggle_gunlight()

///obj/item/weapon/gun/peps/suicide_act(mob/user)
//	if (src.can_shoot())
//		user.visible_message("<span class='suicide'>[user] is putting the barrel of the [src.name] in \his mouth.  It looks like \he's trying to commit suicide.</span>")
//		sleep(25)
//		if(user.l_hand == src || user.r_hand == src)
//			user.visible_message("<span class='suicide'>[user] melts \his face off with the [src.name]!</span>")
//			playsound(loc, fire_sound, 50, 1, -1)
//			var/obj/item/ammo_casing/energy/shot = ammo_type[select]
//			power_supply.use(shot.e_cost)
//			update_icon()
//			return(FIRELOSS)
//		else
//			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
//			return(OXYLOSS)
//	else
//		user.visible_message("<span class='suicide'>[user] is pretending to blow \his brains out with the [src.name]! It looks like \he's trying to commit suicide!</b></span>")
//		playsound(loc, 'sound/weapons/empty.ogg', 50, 1, -1)
//		return (OXYLOSS)

///obj/item/weapon/gun/peps/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
//	..()
//	if(pointblank and iscarbon(pbtarget))
//		pbtarget << "<span class='warning'>You feel a pressure wave knocking you down!</span>"
//		pbtarget.sleeping = 60
//		pbtarget.Paralyse(70)

/obj/item/weapon/gun/peps/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/weapon/stock_parts/cell/peps) && !power_supply)
		var/obj/item/weapon/stock_parts/cell/peps/battery = A
		user.remove_from_mob(battery)
		power_supply = battery
		power_supply.loc = src
		playsound(src, 'sound/items/rped.ogg', 40, 1)
		user << "<span class='notice'>You load a new cell into \the [src].</span>"
		battery.updateicon()
		update_icon()
		return 1
	else if (power_supply)
		user << "<span class='notice'>There's already a magazine in \the [src].</span>"

/obj/item/weapon/gun/peps/attack_self(mob/living/user)
	if(power_supply)
		power_supply.loc = get_turf(src.loc)
		user.put_in_hands(power_supply)
		power_supply.updateicon()
		power_supply = null
		playsound(src, 'sound/items/rped.ogg', 40, 1)
		user << "<span class='notice'>You eject the cell out of \the [src].</span>"
	else
		user << "<span class='notice'>There's no cell in \the [src].</span>"
	update_icon()

/obj/item/weapon/gun/peps/process_fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, message = 1, params, zone_override)
	add_fingerprint(user)

	if(burst_size > 1)
		for(var/i = 1 to burst_size)
			if(!issilicon(user))
				if( i>1 && !(src in get_both_hands(user))) //for burst firing
					break
			if(chambered)
				playsound(user, 'sound/weapons/pepsfire1.ogg', 80, 1)
				sleep(fire_delay)
				if(!chambered.fire(target, user, params, , suppressed, zone_override))
					shoot_with_empty_chamber(user)
					break
				else
					if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
						shoot_live_shot(user, 1, target, message)
					else
						shoot_live_shot(user, 0, target, message)
				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
				sparks.set_up(1, 1, src)
				sparks.start()
			else
				shoot_with_empty_chamber(user)
				break
			process_chamber()
			update_icon()
	else
		if(chambered)
			playsound(user, 'sound/weapons/pepsfire1.ogg', 100, 1)
			sleep(fire_delay)
			if(!chambered.fire(target, user, params, , suppressed, zone_override))
				shoot_with_empty_chamber(user)
				return
			else
				if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
					shoot_live_shot(user, 1, target, message)
				else
					shoot_live_shot(user, 0, target, message)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
			sparks.set_up(1, 1, src)
			sparks.start()
		else
			shoot_with_empty_chamber(user)
			return
		process_chamber()
		update_icon()

	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()
	//feedback_add_details("gun_fired","[src.type]")

// PEPS briefcase -----------------------------------------------
/obj/item/weapon/storage/secure/briefcase/peps
	name = "experimental weaponry briefcase"
	desc = "A large briefcase with a digital locking system. You see a label: \"HIGH-TECH EXPERIMENTAL WEAPONRY; DO NOT USE UNTIL CODE BLUE\"."

/obj/item/weapon/storage/secure/briefcase/peps/New()
	new /obj/item/weapon/gun/peps(src)
	new /obj/item/weapon/stock_parts/cell/peps(src)
	new /obj/item/weapon/stock_parts/cell/peps(src)
	return ..()

// PEPS locker --------------------------------------------------
/obj/structure/closet/secure_closet/peps
	name = "experimental weaponry locker"
	req_access = list(access_security)
	icon_state = "sec"

/obj/structure/closet/secure_closet/peps/New()
	..()
	new /obj/item/weapon/storage/secure/briefcase/peps(src)
	if (prob(20))
		new /obj/item/weapon/storage/secure/briefcase/peps(src)
