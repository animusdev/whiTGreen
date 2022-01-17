//Foxxy
/mob/living/simple_animal/pet/fox
	name = "fox"
	desc = "It's a fox. I wonder what it says?"
	icon = 'icons/mob/pets.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Geckers","Awoo","Tchoff")
	speak_emote = list("тявкает", "лает")
	emote_hear = list("воет.","лает.")
	emote_see = list("трясёт головой.", "дрожит.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab = 3)
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"

//Captain fox
/mob/living/simple_animal/pet/fox/Renault
	name = "Renault"
	desc = "Renault, the Captain's trustworthy fox. I wonder what it says?"