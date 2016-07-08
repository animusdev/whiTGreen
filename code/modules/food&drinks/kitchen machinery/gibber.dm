
/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40// Time from starting until meat appears
	var/typeofmeat = /obj/item/weapon/reagent_containers/food/snacks/meat/
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500
	var/meat_produced = 0
	var/ignore_clothing = 0

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in cardinal)
			var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					qdel(input_obj)
					break

		if(!input_plate)
			diary << "a [src] didn't find an input plate."
			return

/obj/machinery/gibber/autogibber/Bumped(var/atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate)
			M.loc = src
			M.gib()


/obj/machinery/gibber/New()
	..()
	src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/gibber(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	RefreshParts()

/obj/machinery/gibber/RefreshParts()
	var/gib_time = 70
	for(var/obj/item/weapon/stock_parts/matter_bin/B in component_parts)
		meat_produced += 3 * B.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		gib_time = max(10, gib_time - 5 * M.rating) //sanyty check
		if(M.rating >= 2)
			ignore_clothing = 1
	gibtime = gib_time

/obj/machinery/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		src.overlays += image('icons/obj/kitchen.dmi', "grbloody")
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	else if (operating)
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")
	else
		src.overlays += image('icons/obj/kitchen.dmi', "gridle")

/obj/machinery/gibber/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/gibber/container_resist()
	src.go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << "<span class='danger'>It's locked and running.</span>"
		return
	else
		src.startgibbing(user)

/obj/machinery/gibber/attackby(obj/item/weapon/O as obj, mob/user as mob, params)
	if(src.occupant)
		user << "<span class='danger'>The gibber is full, empty it first!</span>"
		return
	if(default_unfasten_wrench(user, O))
		return

	if(default_deconstruction_screwdriver(user, "grinder_open", "grinder", O))
		return

	if(exchange_parts(user, O))
		return

	if(default_pry_open(O))
		return

	if(default_unfasten_wrench(user, O))
		return

	if(default_deconstruction_crowbar(O))
		return
	var/obj/item/weapon/grab/G = O
	if (!( istype(G, /obj/item/weapon/grab)) || !(istype(G.affecting, /mob/living/carbon/human)))
		user << "<span class='danger'>This item is not suitable for the gibber!</span>"
		return

	if(G.affecting.abiotic(1) && !ignore_clothing)
		user << "<span class='danger'>Subject may not have abiotic items on.</span>"
		return

	user.visible_message("<span class='danger'>[user] starts to put [G.affecting] into the gibber!</span>")
	src.add_fingerprint(user)
	if(do_after(user, 30) && G && G.affecting && !occupant)
		user.visible_message("<span class='danger'>[user] stuffs [G.affecting] into the gibber!</span>")
		var/mob/M = G.affecting
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		src.occupant = M
		qdel(G)
		update_icon()




/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "empty gibber"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	dropContents()
	update_icon()

/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("<span class='italics'>You hear a loud metallic grinding sound.</span>")
		return
	use_power(1000)
	if(src.occupant.health > 0)
		if(src.occupant.gender == MALE)
			playsound(src.loc, 'sound/voice/gib_scream_male.ogg', 400, 1)
		else
			playsound(src.loc, 'sound/voice/gib_scream_female.wav', 200, 1)
	visible_message("<span class='italics'>You hear a loud squelchy grinding sound.</span>")
	src.operating = 1
	update_icon()
	var/sourcenutriment = src.occupant.nutrition / 15
	var/sourcetotalreagents = src.occupant.reagents.total_volume
	var/totalslabs = 3

	var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/allmeat[meat_produced]

	if(ishuman(occupant))
		var/mob/living/carbon/human/gibee = occupant
		if(gibee.dna && gibee.dna.species)
			typeofmeat = gibee.dna.species.meat
		else
			typeofmeat = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human
	for (var/i=1 to totalslabs)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/newmeat = new typeofmeat
		newmeat.reagents.add_reagent ("nutriment", sourcenutriment / totalslabs) // Thehehe. Fat guys go first
		src.occupant.reagents.trans_to (newmeat, round (sourcetotalreagents / totalslabs, 1)) // Transfer all the reagents from the
		allmeat[i] = newmeat

	add_logs(user, occupant, "gibbed")
	src.occupant.death(1)
	src.occupant.ghostize()
	qdel(src.occupant)
	spawn(src.gibtime)
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = 0
		for (var/i=1 to totalslabs)
			var/obj/item/meatslab = allmeat[i]
			var/turf/Tx = locate(src.x - i, src.y, src.z)
			meatslab.loc = src.loc
			meatslab.throw_at(Tx,i,3)
			if (!Tx.density)
				new /obj/effect/decal/cleanable/blood/gibs(Tx,i)
		src.operating = 0
		update_icon()


