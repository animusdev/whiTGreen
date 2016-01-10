/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'icons/obj/cult.dmi'

/obj/structure/cult/talisman
	name = "altar"
	desc = "A bloodstained altar dedicated to Nar-Sie"
	icon_state = "talismanaltar"


/obj/structure/cult/forge
	name = "daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie"
	icon_state = "forge"

/obj/structure/cult/pylon
	name = "pylon"
	desc = "A floating crystal that hums with an unearthly energy"
	icon_state = "pylon"
	luminosity = 5
	var/isbroken=0

/obj/structure/cult/pylon/attack_hand(mob/M as mob)
	attackpylon(M, 5)

/obj/structure/cult/pylon/attack_animal(mob/living/simple_animal/user as mob)
	attackpylon(user, user.melee_damage_upper)

/obj/structure/cult/pylon/attackby(obj/item/W as obj, mob/user as mob)
	attackpylon(user, W.force)

/obj/structure/cult/pylon/bullet_act(var/obj/item/projectile/P)
	if(prob(P.damage))
		playsound(get_turf(src), 'sound/effects/Glassbr3.ogg', 75, 1)
		isbroken = 1
		density = 0
		icon_state = "pylon-broken"
		luminosity=0

/obj/structure/cult/pylon/proc/attackpylon(mob/user as mob, var/damage)		//cпижжено с вг
	if(!isbroken)
		if(prob(1+ damage * 5))
			for(var/mob/M in viewers(src))
				if(M == user)
					M << "\red You break the crystal!"
				M.show_message("[user.name] smashed the pylon!", 3, "You hear a tinkle of crystal shards", 2)
			playsound(get_turf(src), 'sound/effects/Glassbr3.ogg', 75, 1)
			isbroken = 1
			density = 0
			icon_state = "pylon-broken"
			luminosity=0
		else
			playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 75, 1)
	else
		if(prob(damage * 2))
			qdel(src)
		playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 75, 1)

/obj/structure/cult/tome
	name = "desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl"
	icon_state = "tomealtar"
//	luminosity = 5

//sprites for this no longer exist	-Pete
//(they were stolen from another game anyway)
/*
/obj/structure/cult/pillar
	name = "Pillar"
	desc = "This should not exist"
	icon_state = "pillar"
	icon = 'magic_pillar.dmi'
*/

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back"
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = 1
	unacidable = 1
	anchored = 1.0

/obj/effect/gateway/Bumped(mob/M as mob|obj)
	spawn(0)
		return
	return

/obj/effect/gateway/Crossed(AM as mob|obj)
	spawn(0)
		return
	return