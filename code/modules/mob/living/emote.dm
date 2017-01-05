//This only assumes that the mob has a body and face with at least one mouth.
//Things like airguitar can be done without arms, and the flap thing makes so little sense it's a keeper.
//Intended to be called by a higher up emote proc if the requested emote isn't in the custom emotes.

/mob/living/emote(var/act, var/m_type=1, var/message = null)
   var/param = null

   if (findtext(act, "-", 1, null))
      var/t1 = findtext(act, "-", 1, null)
      param = copytext(act, t1 + 1, length(act) + 1)
      act = copytext(act, 1, t1)

   if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
      act = copytext(act,1,length(act))

   switch(act)//Hello, how would you like to order? Alphabetically!
      if ("aflap")
         if (!src.restrained())
            message = "<B>[src]</B> ма∆еƒ «воими крыль&#255;ми ¬ я–ќ«ƒ»!"
            m_type = 2

      if ("blush")
         message = "<B>[src]</B> кра«нееƒ."
         m_type = 1

      if ("bow")
         if (!src.buckled)
            var/M = null
            if (param)
               for (var/mob/A in view(1, src))
                  if (param == A.name)
                     M = A
                     break
            if (!M)
               param = null
            if (param)
               message = "<B>[src]</B> клан&#255;еƒ«&#255; [param]."
            else
               message = "<B>[src]</B> клан&#255;еƒ«&#255;."
         m_type = 1

      if ("burp")
         message = "<B>[src]</B> оƒры иваеƒ."
         m_type = 2

      if ("choke")
         message = "<B>[src]</B> зады аеƒ«&#255;."
         m_type = 2

      if ("chuckle")
         message = "<B>[src]</B> Ѕо«меиваеƒ«&#255;."
         m_type = 2

      if ("collapse")
         Paralyse(2)
         message = "<B>[src]</B> изнурЄнно Ѕадаеƒ!"
         m_type = 2

      if ("cough")
         message = "<B>[src]</B> ка∆л&#255;еƒ."
         m_type = 2

      if ("dance")
         if (!src.restrained())
            message = "<B>[src]</B> радо«ƒно Ѕриƒанцовываеƒ."
            m_type = 1

      if ("deathgasp")
         message = "<B>[src]</B> «одро аеƒ«&#255; в Ѕо«ледний раз, безжизненный вз л&#255;д за«ƒываеƒ..."
         m_type = 1

      if ("drool")
         message = "<B>[src]</B> Ѕу«каеƒ «люну."
         m_type = 1

      if ("faint")
         message = "<B>[src]</B> бледнееƒ."
         if(src.sleeping)
            return //Can't faint while asleep
         src.sleeping += 10 //Short-short nap
         m_type = 1

      if ("flap")
         if (!src.restrained())
            message = "<B>[src]</B> ма∆еƒ «воими крыль&#255;ми."
            m_type = 2

      if ("flip")
         if (!src.restrained() || !src.resting || !src.sleeping)
            src.SpinAnimation(7,1)
            m_type = 2

      if ("frown")
         message = "<B>[src]</B>  муриƒ«&#255;."
         m_type = 1

      if ("gasp")
         message = "<B>[src]</B> зады аеƒ«&#255;!"
         m_type = 2

      if ("giggle")
         message = "<B>[src]</B>  и икаеƒ."
         m_type = 2

      if ("glare")
         var/M = null
         if (param)
            for (var/mob/A in view(1, src))
               if (param == A.name)
                  M = A
                  break
         if (!M)
            param = null
         if (param)
            message = "<B>[src]</B> зыркаеƒ на [param]."
         else
            message = "<B>[src]</B> зыркаеƒ."

      if ("grin")
         message = "<B>[src]</B> у мыл&#255;еƒ«&#255;."
         m_type = 1

      if ("jump")
         message = "<B>[src]</B> Ѕры аеƒ!"
         m_type = 1

      if ("laugh")
         message = "<B>[src]</B> «меЄƒ«&#255;."
         m_type = 2

      if ("look")
         var/M = null
         if (param)
            for (var/mob/A in view(1, src))
               if (param == A.name)
                  M = A
                  break
         if (!M)
            param = null
         if (param)
            message = "<B>[src]</B> «моƒриƒ на [param]."
         else
            message = "<B>[src]</B> «моƒриƒ."
         m_type = 1

      if ("me")
         if (src.client)
            if(client.prefs.muted & MUTE_IC)
               src << "§ ¬ы не «ледили за «воим &#255;зыком. ƒеЅерь е о неƒ (muted)."
               return
            if (src.client.handle_spam_prevention(message,MUTE_IC))
               return
         if (stat)
            return
         if(!(message))
            return
         else
            message = "<B>[src]</B> [message]"

      if ("nod")
         message = "<B>[src]</B> киваеƒ."
         m_type = 1

      if ("point")
         if (!src.restrained())
            var/atom/M = null
            if (param)
               for (var/atom/A as mob|obj|turf in view())
                  if (param == A.name)
                     M = A
                     break
            if (!M)
               message = "<B>[src]</B> points."
            else
               pointed(M)
         m_type = 1

      if ("scream")
         message = "<B>[src]</B> кричиƒ!"
         m_type = 2

      if ("shake")
         message = "<B>[src]</B> ƒр&#255;«Єƒ  оловой."
         m_type = 1

      if ("sigh")
         message = "<B>[src]</B> взды аеƒ."
         m_type = 2

      if ("sit")
         message = "<B>[src]</B> «адиƒ«&#255;."
         m_type = 1

      if ("smile")
         message = "<B>[src]</B> улыбаеƒ«&#255;."
         m_type = 1

      if ("sneeze")
         message = "<B>[src]</B> чи аеƒ."
         m_type = 2

      if ("sniff")
         message = "<B>[src]</B> ∆мы аеƒ но«ом."
         m_type = 2

      if ("snore")
         message = "<B>[src]</B> "
         message += pick(" раЅиƒ.", "«оЅиƒ.", "Ѕо раЅываеƒ.", "ворочаеƒ«&#255; во «не.")
         m_type = 2

      if ("stare")
         var/M = null
         if (param)
            for (var/mob/A in view(1, src))
               if (param == A.name)
                  M = A
                  break
         if (!M)
            param = null
         if (param)
            message = "<B>[src]</B>  лазееƒ на [param]."
         else
            message = "<B>[src]</B>  лазееƒ Ѕо «ƒоронам."

      if ("sulk")
         message = "<B>[src]</B> кук«иƒ«&#255;."
         m_type = 1

      if ("sway")
         message = "<B>[src]</B> одурманенно ∆аƒаеƒ«&#255;."
         m_type = 1

      if ("tremble")
         message = "<B>[src]</B> дрожиƒ в «ƒра е!"
         m_type = 1

      if ("twitch")
         message = "<B>[src]</B> «удорожно дЄр аеƒ«&#255;."
         m_type = 1

      if ("twitch_s")
         message = "<B>[src]</B> дЄр аеƒ«&#255;."
         m_type = 1

      if ("wave")
         message = "<B>[src]</B> ма∆еƒ рукой."
         m_type = 1

      if ("whimper")
         message = "<B>[src]</B>  нычеƒ."
         m_type = 2

      if ("yawn")
         message = "<B>[src]</B> зеваеƒ."
         m_type = 2

      if ("help")
         src << "«Ѕи«ок эмоций. ¬ы можеƒе и«Ѕользоваƒь и , набрав \"*emote\" в \"say\":\naflap, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, dance, deathgasp, drool, flap, frown, gasp, giggle, glare-(none)/mob, grin, jump, laugh, look, me, nod, point-atom, scream, shake, sigh, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tremble, twitch, twitch_s, wave, whimper, yawn"

      else
         if (src.client)
            if(client.prefs.muted & MUTE_IC)
               src << "§ „ƒо-ƒо ме∆аеƒ вам  овориƒь."
               return
            if (src.client.handle_spam_prevention(act,MUTE_IC))
               return
         if (stat)
            return
         if(!(act))
            return
         else
            message = "<B>[src]</B> [act]"

   if (message)
      log_emote("[ckey]/[name] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

      for(var/mob/M in dead_mob_list)
         if(!M.client || istype(M, /mob/new_player))
            continue //skip monkeys, leavers and new players
         var/T = get_turf(src)
         if(M.stat == DEAD && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(T,null)))
            M.show_message(message)


      if (m_type & 1)
         visible_message(message)
      else if (m_type & 2)
         audible_message(message)
