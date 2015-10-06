//Cat
/mob/living/simple_animal/pet/cat
	name = "cat"
	desc = "Kitty!"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	languages = CAT
	speak = list("М&#255;у!", "Мур-м&#255;у!", "Мрррр!", "Шшшшш!")
	speak_emote = list("мурлычет", "м&#255;укает")
	emote_hear = list("м&#255;укает.", "мурчит.", "мурлычет.", "шипит.")
	emote_see = list("тр&#255;сёт головой.", "дрожит.", "играетс&#255; со своим хвостом.")
	speak_chance = 2
	turns_per_move = 5
	see_in_dark = 6
	species = /mob/living/simple_animal/pet/cat
	childtype = /mob/living/simple_animal/pet/cat/kitten
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 2)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	holder_type = /obj/item/weapon/twohanded/mob_holder/cat

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = "GCAT"
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target

/mob/living/simple_animal/pet/cat/Runtime/Life()
	//MICE!
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in view(1,src))
				if(!M.stat && Adjacent(M))
					emote("me", 1, "splats \the [M]!")
					M.splat()
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	make_babies()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/mob/living/simple_animal/mouse/snack in oview(src,3))
					if(isturf(snack.loc) && !snack.stat)
						movement_target = snack
						break
			if(movement_target)
				stop_automated_movement = 1
				walk_to(src,movement_target,0,3)

/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"

/mob/living/simple_animal/pet/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER
	density = 0
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL


