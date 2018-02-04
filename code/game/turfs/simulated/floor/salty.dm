/turf/simulated/floor/salty
	name = "salty floor"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow_dug"

/turf/simulated/floor/salty/Entered(atom/movable/M)
	spawn(0)
		if (istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			while(H && H.loc == src && !istype(H.back, /obj/item/clothing/suit/space) && !istype(H.back, /obj/item/clothing/suit/bio_suit))
				if(do_after(H, rand(90, 210), needhand = 0, progress = 0))
					H.heal_overall_damage(rand(0, 4), rand(0, 4))
					if (prob(10))
						H << "<span class='notice'>You breathe in salt vapours. Smells good.</span>"

	..(M)