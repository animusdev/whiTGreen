/mob/living/simple_animal/pet
	icon = 'icons/mob/pets.dmi'
	mob_size = MOB_SIZE_SMALL
	var/obj/item/collar/pet/pcollar = null
	var/image/collar = null
	var/image/pettag = null

/mob/living/simple_animal/pet/attackby(var/obj/item/O as obj, var/mob/user as mob, params)
	if(istype(O, /obj/item/collar/pet) && !pcollar)
		var/obj/item/collar/pet/P = O
		pcollar = P
		collar = image('icons/mob/pets.dmi', src, "[icon_state]collar")
		pettag = image('icons/mob/pets.dmi', src, "[icon_state]tag")
		regenerate_icons()
		user << "<span class='notice'>You put the [P] around [src]'s neck.</span>"
		if(P.tagname)
			name = P.tagname
		qdel(P)
		return
	if(istype(O, /obj/item/weapon/newspaper))
		if(!stat)
			user.visible_message("[user] baps [name] on the nose with the rolled up [O].")
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					dir = i
					sleep(1)
	else
		..()

/mob/living/simple_animal/pet/New()
	..()
	if(pcollar)
		pcollar = new(src)
		regenerate_icons()

/mob/living/simple_animal/pet/revive()
	..()
	regenerate_icons()

/mob/living/simple_animal/pet/death(gibbed)
	..(gibbed)
	regenerate_icons()

/mob/living/simple_animal/pet/regenerate_icons()
	overlays.Cut()
	overlays += collar
	overlays += pettag

/mob/living/simple_animal/pet/attack_ghost(mob/user)
	if (notes_search(user.ckey, "Memedick") == 1)
		var/be_pet = alert("Become a pet? (Warning, You can no longer be cloned!)",,"Yes","No")
		if(be_pet == "No" || gc_destroyed)
			return
		src.key = user.key
		src << "<span class='notice'>You are a pet now. Do it like a pet or you will find eventually your tail dismembered.</span>"
		return
	..()