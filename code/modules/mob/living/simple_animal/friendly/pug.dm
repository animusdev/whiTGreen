/mob/living/simple_animal/pet/pug
   name = "\improper pug"
   real_name = "pug"
   desc = "It's a pug."
   icon = 'icons/mob/pets.dmi'
   icon_state = "pug"
   icon_living = "pug"
   icon_dead = "pug_dead"
   speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
   speak_emote = list("лаеД", "КавкаеД")
   emote_hear = list("лаеД!", "КавкаеД!", "Д&#255;вкаеД.","БыКДиД.")
   emote_see = list("Др&#255;ЗёД Коловой.", "Кон&#255;еДЗ&#255; за Звоим КвоЗДом.","дрожиД.")
   speak_chance = 1
   turns_per_move = 10
   butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/pug = 3)
   response_help  = "pets"
   response_disarm = "bops"
   response_harm   = "kicks"
   see_in_dark = 5

/mob/living/simple_animal/pet/pug/Life()
   ..()

   if(!stat && !resting && !buckled)
      if(prob(1))
         emote("me", 1, pick("Кон&#255;еДЗ&#255; за Звоим КвоЗДом."))
         spawn(0)
            for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
               dir = i
               sleep(1)
