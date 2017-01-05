/mob/living/simple_animal/slime/emote(var/act)


   if (findtext(act, "-", 1, null))
      var/t1 = findtext(act, "-", 1, null)
      //param = copytext(act, t1 + 1, length(act) + 1)
      act = copytext(act, 1, t1)

   if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
      act = copytext(act,1,length(act))

   var/m_type = 1
   var/regenerate_icons
   var/message

   switch(act) //Alphabetical please
      if("bounce")
         message = "<B>The [src.name]</B> ЅодЅры иваеƒ на ме«ƒе."
         m_type = 1

      if("jiggle")
         message = "<B>The [src.name]</B> Ѕокачиваеƒ«&#255;!"
         m_type = 1

      if("light")
         message = "<B>The [src.name]</B> за«веƒил«&#255; на м новение, но Ѕо а«."
         m_type = 1

      if("moan")
         message = "<B>The [src.name]</B> «ƒонеƒ."
         m_type = 2

      if("shiver")
         message = "<B>The [src.name]</B> дрожиƒ."
         m_type = 2

      if("sway")
         message = "<B>The [src.name]</B> ∆аƒаеƒ«&#255;."
         m_type = 1

      if("twitch")
         message = "<B>The [src.name]</B> дер аеƒ«&#255;."
         m_type = 1

      if("vibrate")
         message = "<B>The [src.name]</B> вибрируеƒ!"
         m_type = 1

      if("noface") //mfw I have no face
         mood = null
         regenerate_icons = 1

      if("smile")
         mood = "mischevous"
         regenerate_icons = 1

      if(":3")
         mood = ":33"
         regenerate_icons = 1

      if("pout")
         mood = "pout"
         regenerate_icons = 1

      if("frown")
         mood = "sad"
         regenerate_icons = 1

      if("scowl")
         mood = "angry"
         regenerate_icons = 1

      if ("help") //This is an exception
         src << "«Ѕи«ок эмоций дл&#255; «лизней. ¬ы можеƒе и«Ѕользоваƒь и , набрав \"*emote\" в \"say\":\nbounce, jiggle, light, moan, shiver, sway, twitch, vibrate. \n\n¬ы ƒакже можеƒе Ѕомен&#255;ƒь «воЄ \"на«ƒроение\": \n\nsmile, :3, pout, frown, scowl, noface"

      else
         src << "<span class='notice'>Ќеи«Ѕользуема&#255; эмоци&#255; '[act]'. Ќабериƒе \"*help\" в \"say\" дл&#255; Ѕолно о «Ѕи«ка.</span>"

   if ((message && stat == CONSCIOUS))
      if(client)
         log_emote("[ckey]/[name] : [message]")
      if (m_type & 1)
         visible_message(message)
      else
         audible_message(message)

   if (regenerate_icons)
      regenerate_icons()

   return