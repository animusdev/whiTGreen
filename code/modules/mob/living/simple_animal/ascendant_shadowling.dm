/mob/living/simple_animal/ascendant_shadowling
	name = "Ascendant Shadowling"
	desc = "A large, floating eldritch horror. It has pulsing markings all about its body and large horns. It seems to be floating without any form of support."
	icon = 'icons/mob/mob.dmi'
	icon_state = "shadowling_ascended"
	icon_living = "shadowling_ascended"
	speak_emote = list("телепатически рокочет", "телепатически гремит")
	force_threshold = INFINITY //Can't die by normal means
	health = 100000
	maxHealth = 100000
	speed = 0
	var/phasing = 0
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_MINIMUM

	response_help   = "stares at"
	response_disarm = "flails at"
	response_harm   = "flails at"

	harm_intent_damage = 0
	melee_damage_lower = 35
	melee_damage_upper = 35
	attacktext = "claws at"
	attack_sound = 'sound/weapons/slash.ogg'

	minbodytemp = 0
	maxbodytemp = INFINITY
	environment_smash = 2

	faction = list("faithless")

/mob/living/simple_animal/ascendant_shadowling/Process_Spacemove(var/movement_dir = 0)
	return 1 //copypasta from carp code

/mob/living/simple_animal/ascendant_shadowling/get_spans()
	return ..() | list(SPAN_REALLYBIG, SPAN_YELL) //MAKES THEM SHOUT WHEN THEY TALK

/mob/living/simple_animal/ascendant_shadowling/ex_act(severity)
	return 0 //You think an ascendant can be hurt by bombs? HA

/mob/living/simple_animal/ascendant_shadowling/singularity_act()
	return 0 //Well hi, fellow god! How are you today?