/proc/random_beast_name(attempts_to_find_unique_name=10) // Дварфийские имена. Охуеть.
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		. = capitalize(pick(beast_first_names)) + " " + capitalize(pick(beast_second_names))
		if(i != attempts_to_find_unique_name && !findname(.))
			break

/datum/forgotten_beast_limb // Используется для хранения материала и статуса конечности.
	material = MAT_SAND

/mob/living/forgotten_beast
	name = "the beast"
	icon = 'icons/mob/forgottenbeasts.dmi'

/mob/living/forgotten_beast/New()
	..()
	name = random_beast_name()
	verbs -= /mob/verb/observe
	if(!real_name)
		real_name = name
