/mob/living/simple_animal/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard_dead"
	speak_emote = list("шипит")
	health = 5
	maxHealth = 5
	attacktext = "bites"
	attacktext = "bites"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	ventcrawler = 2
	density = 0
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	holder_type = /obj/item/weapon/twohanded/mob_holder/lizard

