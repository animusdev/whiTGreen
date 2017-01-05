#define LING_ABSORB_RECENT_SPEECH         8   //The amount of recent spoken lines to gain on absorbing a mob


var/list/possible_changeling_IDs = list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")

/datum/game_mode
   var/list/datum/mind/changelings = list()


/datum/game_mode/changeling
   name = "changeling"
   config_tag = "changeling"
   antag_flag = BE_CHANGELING
   restricted_jobs = list("AI", "Cyborg")
   protected_jobs = list("Security Officer", "Warden", "Head of Security", "Captain", "Cyborg", "AI", "Detective")
   required_players = 15
   required_enemies = 1
   recommended_enemies = 4
   reroll_friendly = 1


   var/const/prob_int_murder_target = 50 // intercept names the assassination target half the time
   var/const/prob_right_murder_target_l = 25 // lower bound on probability of naming right assassination target
   var/const/prob_right_murder_target_h = 50 // upper bound on probability of naimg the right assassination target

   var/const/prob_int_item = 50 // intercept names the theft target half the time
   var/const/prob_right_item_l = 25 // lower bound on probability of naming right theft target
   var/const/prob_right_item_h = 50 // upper bound on probability of naming the right theft target

   var/const/prob_int_sab_target = 50 // intercept names the sabotage target half the time
   var/const/prob_right_sab_target_l = 25 // lower bound on probability of naming right sabotage target
   var/const/prob_right_sab_target_h = 50 // upper bound on probability of naming right sabotage target

   var/const/prob_right_killer_l = 25 //lower bound on probability of naming the right operative
   var/const/prob_right_killer_h = 50 //upper bound on probability of naming the right operative
   var/const/prob_right_objective_l = 25 //lower bound on probability of determining the objective correctly
   var/const/prob_right_objective_h = 50 //upper bound on probability of determining the objective correctly

   var/const/changeling_amount = 4 //hard limit on changelings if scaling is turned off

/datum/game_mode/changeling/announce()
   world << "<b>ƒекущий и ровой режим - changelling!</b>"
   world << "<b>»ноЅланеƒные ор анизмы,  енокрады, Ѕроникли на «ƒанцию. Ќе дайƒе им выЅолниƒь и  ми««ию!</b>"

/datum/game_mode/changeling/pre_setup()

   if(config.protect_roles_from_antagonist)
      restricted_jobs += protected_jobs

   var/num_changelings = 1

   if(config.changeling_scaling_coeff)
      num_changelings = max(1, min( round(num_players()/(config.changeling_scaling_coeff*2))+2, round(num_players()/config.changeling_scaling_coeff) ))
   else
      num_changelings = max(1, min(num_players(), changeling_amount))

   if(antag_candidates.len>0)
      for(var/i = 0, i < num_changelings, i++)
         if(!antag_candidates.len) break
         var/datum/mind/changeling = pick(antag_candidates)
         antag_candidates -= changeling
         changelings += changeling
         changeling.restricted_roles = restricted_jobs
         modePlayer += changelings
      return 1
   else
      return 0

/datum/game_mode/changeling/post_setup()
   for(var/datum/mind/changeling in changelings)
      log_game("[changeling.key] (ckey) был выбран в каче«ƒве  енокрада")
      changeling.current.make_changeling()
      changeling.special_role = "Changeling"
      forge_changeling_objectives(changeling)
      greet_changeling(changeling)
   ..()
   return

/datum/game_mode/changeling/make_antag_chance(var/mob/living/carbon/human/character) //Assigns changeling to latejoiners
   var/changelingcap = min( round(joined_player_list.len/(config.changeling_scaling_coeff*2))+2, round(joined_player_list.len/config.changeling_scaling_coeff) )
   if(ticker.mode.changelings.len >= changelingcap) //Caps number of latejoin antagonists
      return
   if(ticker.mode.changelings.len <= (changelingcap - 2) || prob(100 - (config.changeling_scaling_coeff*2)))
      if(character.client.prefs.be_special & BE_CHANGELING)
         if(!jobban_isbanned(character.client, "changeling") && !jobban_isbanned(character.client, "Syndicate"))
            if(!(character.job in restricted_jobs))
               character.mind.make_Changling()

/datum/game_mode/proc/forge_changeling_objectives(var/datum/mind/changeling)
   //OBJECTIVES - random traitor objectives. Unique objectives "steal brain" and "identity theft".
   //No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
   //If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone


   var/datum/objective/absorb/absorb_objective = new
   absorb_objective.owner = changeling
   absorb_objective.gen_amount_goal(6, 8)
   changeling.objectives += absorb_objective

   if(prob(60))
      var/datum/objective/steal/steal_objective = new
      steal_objective.owner = changeling
      steal_objective.find_target()
      changeling.objectives += steal_objective
   else
      var/datum/objective/debrain/debrain_objective = new
      debrain_objective.owner = changeling
      debrain_objective.find_target()
      changeling.objectives += debrain_objective


   var/list/active_ais = active_ais()
   if(active_ais.len && prob(100/joined_player_list.len))
      var/datum/objective/destroy/destroy_objective = new
      destroy_objective.owner = changeling
      destroy_objective.find_target()
      changeling.objectives += destroy_objective
   else
      if(prob(70))
         var/datum/objective/assassinate/kill_objective = new
         kill_objective.owner = changeling
         kill_objective.find_target()
         changeling.objectives += kill_objective
      else
         var/datum/objective/maroon/maroon_objective = new
         maroon_objective.owner = changeling
         maroon_objective.find_target()
         changeling.objectives += maroon_objective

         if (!(locate(/datum/objective/escape) in changeling.objectives))
            var/datum/objective/escape/escape_with_identity/identity_theft = new
            identity_theft.owner = changeling
            identity_theft.target = maroon_objective.target
            identity_theft.update_explanation_text()
            changeling.objectives += identity_theft

   if (!(locate(/datum/objective/escape) in changeling.objectives))
      if(prob(50))
         var/datum/objective/escape/escape_objective = new
         escape_objective.owner = changeling
         changeling.objectives += escape_objective
      else
         var/datum/objective/escape/escape_with_identity/identity_theft = new
         identity_theft.owner = changeling
         identity_theft.find_target()
         changeling.objectives += identity_theft
   return

/datum/game_mode/proc/greet_changeling(var/datum/mind/changeling, var/you_are=1)
   if (you_are)
      changeling.current << "<span class='boldannounce'>§ ¬ы - [changeling.changeling.changelingID],  енокрад! Ѕо лоƒив одно о из членов экиЅажа и Ѕрин&#255;в е о форму вы Ѕроникли на «ƒанцию.</span>"
   changeling.current << "<span class='boldannounce'>»«Ѕользуйƒе \":g «ообщение\", чƒобы общаƒь«&#255; « дру ими  енокрадами.</span>"
   changeling.current << "§ ¬ы должны выЅолниƒь «ледующие задани&#255;:</b>"

   if (changeling.current.mind)
      var/mob/living/carbon/human/H = changeling.current
      if(H.mind.assigned_role == "Clown")
         H << "§ ¬ы «мо ли обуздаƒь «вою клоун«кую наƒуру и ƒеЅерь можеƒе и«Ѕользоваƒь оружие без вреда дл&#255; «еб&#255;."
         H.dna.remove_mutation(CLOWNMUT)

   var/obj_count = 1
   for(var/datum/objective/objective in changeling.objectives)
      changeling.current << "<b>«адание #[obj_count]</b>: [objective.explanation_text]"
      obj_count++
   return

/*/datum/game_mode/changeling/check_finished()
   var/changelings_alive = 0
   for(var/datum/mind/changeling in changelings)
      if(!istype(changeling.current,/mob/living/carbon))
         continue
      if(changeling.current.stat==2)
         continue
      changelings_alive++

   if (changelings_alive)
      changelingdeath = 0
      return ..()
   else
      if (!changelingdeath)
         changelingdeathtime = world.time
         changelingdeath = 1
      if(world.time-changelingdeathtime > TIME_TO_GET_REVIVED)
         return 1
      else
         return ..()
   return 0*/

/datum/game_mode/proc/auto_declare_completion_changeling()
   if(changelings.len)
      var/text = "<br><font size=3><b> енокрадами были:</b></font>"
      for(var/datum/mind/changeling in changelings)
         var/changelingwin = 1
         if(!changeling.current)
            changelingwin = 0

         text += printplayer(changeling)

         //Removed sanity if(changeling) because we -want- a runtime to inform us that the changelings list is incorrect and needs to be fixed.
         text += "<br><b>ID  енокрада:</b> [changeling.changeling.changelingID]."
         text += "<br><b> еномов Ѕо лощено:</b> [changeling.changeling.absorbedcount]"

         if(changeling.objectives.len)
            var/count = 1
            for(var/datum/objective/objective in changeling.objectives)
               if(objective.check_completion())
                  text += "<br><b>«адание #[count]</b>: [objective.explanation_text] <font color='green'><b>”«Ѕе !</b></font>"
               else
                  text += "<br><b>«адание #[count]</b>: [objective.explanation_text] <span class='danger'>Ѕровал.</span>"
                  changelingwin = 0
               count++

         if(changelingwin)
            text += "<br><font color='green'><b> енокрад у«Ѕе∆но выЅолнил в«е «вои задани&#255;!</b></font>"
         else
            text += "<br><font color='red'><b> енокрад Ѕровалил «вою ми««ию.</b></font>"
         text += "<br>"
      world << text
   return 1

/datum/changeling //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
   var/list/absorbed_dna = list()
   var/list/protected_dna = list() //dna that is not lost when capacity is otherwise full
   var/dna_max = 4 //How many extra DNA strands the changeling can store for transformation.
   var/absorbedcount = 1 //We would require at least 1 sample of compatible DNA to have taken on the form of a human.
   var/chem_charges = 20
   var/chem_storage = 50
   var/chem_recharge_rate = 0.5
   var/chem_recharge_slowdown = 0
   var/sting_range = 2
   var/changelingID = "Changeling"
   var/geneticdamage = 0
   var/isabsorbing = 0
   var/geneticpoints = 10
   var/purchasedpowers = list()
   var/mimicing = ""
   var/canrespec = 0
   var/changeling_speak = 0
   var/datum/dna/chosen_dna
   var/obj/effect/proc_holder/changeling/sting/chosen_sting

/datum/changeling/New(var/gender=FEMALE)
   ..()
   var/honorific
   if(gender == FEMALE)   honorific = "Ms."
   else               honorific = "Mr."
   if(possible_changeling_IDs.len)
      changelingID = pick(possible_changeling_IDs)
      possible_changeling_IDs -= changelingID
      changelingID = "[honorific] [changelingID]"
   else
      changelingID = "[honorific] [rand(1,999)]"
   absorbed_dna.len = dna_max


/datum/changeling/proc/regenerate()
   chem_charges = min(max(0, chem_charges + chem_recharge_rate - chem_recharge_slowdown), chem_storage)
   geneticdamage = max(0, geneticdamage-1)


/datum/changeling/proc/get_dna(var/dna_owner)
   for(var/datum/dna/DNA in (absorbed_dna+protected_dna))
      if(dna_owner == DNA.real_name)
         return DNA

/datum/changeling/proc/has_dna(var/datum/dna/tDNA)
   for(var/datum/dna/D in (absorbed_dna+protected_dna))
      if(tDNA.is_same_as(D))
         return 1
   return 0

/datum/changeling/proc/can_absorb_dna(var/mob/living/carbon/user, var/mob/living/carbon/target)
   if(absorbed_dna[1] == user.dna)//If our current DNA is the stalest, we gotta ditch it.
      user << "<span class='warning'>§ ¬ы до«ƒи ли лимиƒа ва∆е о  ранилища  енеƒиче«кой информации. ¬ы должны ƒран«формироваƒь«&#255;, чƒобы Ѕо лоƒиƒь боль∆е  еномов.</span>"
      return
   if(!target)
      return
   if((target.disabilities & NOCLONE) || (target.disabilities & HUSK))
      user << "<span class='warning'>ƒЌ  [target] Ѕовреждена и не можеƒ быƒь и«Ѕользована!</span>"
      return
   if(!ishuman(target))//Absorbing monkeys is entirely possible, but it can cause issues with transforming. That's what lesser form is for anyway!
      user << "<span class='warning'>§ ¬ы не Ѕолучиƒе никакой Ѕользы, Ѕо лоƒив  еном нечеловече«кой о«оби.</span>"
      return
   if(has_dna(target.dna))
      user << "<span class='warning'>” ва« уже е«ƒь эƒа ƒЌ  в  ранилище.</span>"
   if(!check_dna_integrity(target))
      user << "<span class='warning'>[target] не «овме«ƒим « ва∆ей Ѕриродой.</span>"
      return
   return 1
