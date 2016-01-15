/obj/item/weapon/service_bell
	name = "service bell"
	desc = "Waiter, where is my steak?"
	icon='icons/obj/objects.dmi'
	icon_state = "servicebell"
	hitsound = 'sound/items/service_bell_1.ogg'
	attack_verb = list("called", "rang")
	var/cooldowntime = 30
	var/spam_flag = 0
	force=1

/obj/item/weapon/service_bell/attack_paw(mob/user)
	return attack_hand(user)


/obj/item/weapon/service_bell/attack_hand(mob/user)
	if(!spam_flag)
		spam_flag=1
		var/bsound = pick('sound/items/service_bell_1.ogg','sound/items/service_bell_2.ogg')
		playsound(src.loc,bsound, 90, 1)
		user.visible_message("<span class='warning'>[user] has [pick("ringed","dinged")] [src].</span>", "You ring [src].")
		spawn(cooldowntime)
			spam_flag=0


/obj/item/weapon/service_bell/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(over_object == M)
		M.put_in_hands(src)

	else if(istype(over_object, /obj/screen))
		switch(over_object.name)
			if("r_hand")
				M.unEquip(src)
				M.put_in_r_hand(src)
			if("l_hand")
				M.unEquip(src)
				M.put_in_l_hand(src)
	add_fingerprint(M)