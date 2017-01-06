//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!


#define TINT_IMPAIR 2			//Threshold of tint level to apply weld mask overlay
#define TINT_BLIND 3			//Threshold of tint level to obscure vision fully

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 460K point
#define HEAT_DAMAGE_LEVEL_4 12 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

/mob/living/carbon/human
	var/tinttotal = 0				// Total level of visualy impairing items



/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (notransform)
		return

	tinttotal = tintcheck() //here as both hud updates and status updates call it

	if(..())
		if(dna)
			for(var/datum/mutation/human/HM in dna.mutations)
				HM.on_life(src)

		//Stuff jammed in your limbs hurts
		handle_embedded_objects()
	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	if(dna)
		dna.species.spec_life(src) // for mutantraces


/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	if((wear_suit && (wear_suit.flags & STOPSPRESSUREDMAGE)) && (head && (head.flags & STOPSPRESSUREDMAGE)))
		return ONE_ATMOSPHERE
	else
		return pressure


/mob/living/carbon/human/handle_disabilities()
	..()
	//Eyes
	if(!(disabilities & BLIND))
		if(tinttotal >= TINT_BLIND)		//covering your eyes heals blurry eyes faster
			eye_blurry = max(eye_blurry-2, 0)

	//Ears
	if(!(disabilities & DEAF))
		if(istype(ears, /obj/item/clothing/ears/earmuffs)) // earmuffs rest your ears, healing ear_deaf faster and ear_damage, but keeping you deaf.
			setEarDamage(max(ear_damage-0.10, 0), max(ear_deaf - 1, 1))


	if (getBrainLoss() >= 60 && stat != DEAD)
		if (prob(3))
			switch(pick(1,2,3))
				if(1)
					say(pick("Îíè ïîâñþäó! Íåñèòå îãíåìåòû!", "Îñòàâü ýòè ñëîæíîñòè, äåòêà, ïðîñòî âîçüìè ìîé ÷ëåí", "ÊÎÍÅÖ ÑÂÅÒÀ ÁËÈÇÎÊ" ,"ß âèæó äóõîâ óìåðøèõ, îíè ãîâîð&#255;ò ñî ìíîé!", "ÊÀÏÈÒÀÍ ÃÀÍÄÎÍ!", "ÐÀÑÑËÀÁËßÉÒÅ ÁÓËÊÈ, ÃÎÒÎÂÜÒÅ ÇÀÄÍÈÖÛ, ÈÁÎ ÃÐßÄÅÒ!!!", "ÕÎÑ ÕÓÅÑÎÑ!", "ËÞÄÈ Â ÁÀËÀÕÎÍÀÕ Â ÒÅÕÒÎÍÅËßÕ", "Ìåí&#255; îêðóæàþò ñóìàñøåäøèå!", "ÑÈÍÃÓËßÐÍÎÑÒÜ ÍÀ ÑÂÎÁÎÄÅ!!!" , "Îíî â ìîåé ãîëîâå, îíî â âàøèõ ãîëîâàõ òîæå!", "Óáåðèòå, óáåðèòå åãî îò ìåí&#255;!", "ÍÀ×ÀËÜÍÈÊ!!!!", "ÝÒÎÒ ÏÈÄÎÐÀÑ ÎÁÎÑÐÀËÑß!!", "Îíè èäóò çà ìíîé!", "[pick("×ÅÐÍÛÅ ÌÛØÈ", "ÇÅËÅÍÛÅ ÃÅÍÅÒÈÊÈ", "ÎÕÓÅÂØÈÅ ÊÐÀÑÍÎÇÀÄÛÅ", "ËÞÄÈ Â ÁÀËÀÕÎÍÀÕ", "ÅÁÓ×ÈÅ ÀÑÑÈÑÒÅÍÒÛ", "ÁËßÄÑÊÈÅ ÊÈÁÎÐÃÈ", "ÊÐÈÂÎÆÎÏÛÅ ÌÅÄÈÊÈ", "ÑÈÍÄÈÊÀÒÎÂÖÛ Â ÊÐÀÑÍÛÕ ÑÊÀÔÀÍÄÐÀÕ")] [pick("ÎÕÓÅËÈ", "ÓÁÈÂÀÞÒ", "ÍÀÑÈËÓÞÒ", "ÐÀÇÌÍÎÆÀÞÒÑß", "ÑÎÑÓÒ ÕÓÈ")]!!!"))
				if(2)
					say(pick("ÊÐÎÂÀÂÛÅ ÐÓÊÈ ËÅÇÓÒ ÈÇ ÑÒÅÍ", "ß âèæó ÅÃÎ âîëþ!", "ß ÓÁÜÞ ÒÅÁß, ß ÓÍÈ×ÒÎÆÓ ÒÅÁß!!!", "Êòî íèáóäü, ïîæàëóéñòà, ÓÁÅÉÒÅ ÌÅÍß ÍÀÊÎÍÅÖ!!!", "ÎÍÈ ÑËÅÄßÒ ÇÀ ÍÀÌÈ ×ÅÐÅÇ ÌÈÊÐÎ×ÈÏÛ Â ÏÎÍ×ÈÊÀÕ!!!", "ÊÀÏÈÒÀÍ ÍÅ ×ÅËÎÂÅÊ!", "ÎÍÎ ÏÎÆÐÅÒ ÒÂÎÞ ÄÓØÓ, ÊÀÊ ÏÎÆÐÀËÎ ÌÎÞ!", "ÍÈ×ÒÎ ÍÅ ÓÊÐÎÅÒÑß ÎÒ ÈÕ ÂÇÎÐÀ!", "ß ÊÎÍÄÓÊÒÎÐ ÝÒÎÃÎ ÑÈÑÊÎÂÎÇÀ", "ÁÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀÕÀ!!!", "ÌÛ ÎÒÄÀÄÈÌ ÍÀØÈ ÒÅËÀ ÑÈÍÃÓËßÐÍÎÑÒÈ!", "ß ÂÈÆÓ ËÈØÜ ÃÍÎÉ, ÍÅÒ ËÞÄÅÉ. ÒÎËÜÊÎ ÃÍÎÉ", "ÁËÅßÍÜÅ ÑÂßÙÅÍÍÎÃÎ ÒÓËÁÎÊÑÀ ÑÎÒÐßÑÀÅÒ ÍÀØÈ ÀÃÎÍÈÇÈÐÓÞÙÈÅ ×ÐÅÑËÀ", "ÌÛ ÎÒÏÐÀÂËßÅÌÑß ÏÐßÌÎ ÍÀÕÓÉ Â ÀÄ!", "ÑÌÅÐÒÜ ÅÑÒÜ ÎÑÂÎÁÎÆÄÅÍÈÅ, ÑÌÅÐÒÜ ÅÑÒÜ ÎÑÂÎÁÎÆÄÅÍÈÅ!!!", "ÒÛ ÍÅ ÁÛË ÐÎÆÄÅÍ ÈÇ ÓÒÐÎÁÛ ÌÀÒÅÐÈ, ÒÛ ÔÀËÜØÈÂÛÉ!", "ÃÎÐÈ ÑÎ ÌÍÎÉ!!!", "ÏËÀ×ÜÒÅ ÏÎÊÀ ÅÑÒÜ ÑËÅÇÛ, ÈÁÎ ÊÎÍÅÖ ÁËÈÇÎÊ", "ß ÂÛÐÂÓ ÒÂÎÈ ÃËÀÇÀ È ÁÓÄÓ ÑÌÎÒÐÅÒÜ Â ÍÈÕ, ÏÎÊÀ ÍÅ ÍÀÉÄÓ ×ÈÏÛ Â Â ÐÎÃÎÂÈÖÅ", "ß Ñ×ÀÑÒËÈÂ, ÒÛ ÍÅ ÂÈÄÈØÜ, ß Ñ×ÀÑÒËÈÂ", "ÒÐÅÏÀÍÀÖÈß, ÂÀÌ ÂÑÅÌ ÏÎÌÎÆÅÒ ÒÎËÜÊÎ ÒÐÅÏÀÍÀÖÈß", "ß ÑÎÒÐÓ ÝÒÎÒ ÌÈÐ ÑÂÎÈÌ ÎÃÍÅÒÓØÈÒÅËÅÌ", "ÒÊÀÍÜ ÐÅÀËÜÍÎÑÒÈ ÐÂÅÒÑß, ÍÅÄÎÂÎËÜÑÒÂÎ ÏÐÈÇÐÀÊÎÂ ÏÐÎÐÛÂÀÅÒÑß!"))
				if(3)
					emote("drool")


/mob/living/carbon/human/handle_mutations_and_radiation()
	if(dna)
		if(dna.species.handle_mutations_and_radiation(src))
			..()

/mob/living/carbon/human/breathe()
	if(!isnull(src))
		if(dna)
			dna.species.breathe(src)
	return

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(dna)
		dna.species.handle_environment(environment, src)

	return

///FIRE CODE
/mob/living/carbon/human/handle_fire()
	if(dna)
		dna.species.handle_fire(src)
	if(..())
		return
	var/thermal_protection = 0 //Simple check to estimate how protected we are against multiple temperatures
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature >= FIRE_SUIT_MAX_TEMP_PROTECT)
			thermal_protection += (wear_suit.max_heat_protection_temperature*0.7)
	if(head)
		if(head.max_heat_protection_temperature >= FIRE_HELM_MAX_TEMP_PROTECT)
			thermal_protection += (head.max_heat_protection_temperature*THERMAL_PROTECTION_HEAD)
	thermal_protection = round(thermal_protection)
	if(thermal_protection >= FIRE_IMMUNITY_SUIT_MAX_TEMP_PROTECT)
		return
	if(thermal_protection >= FIRE_SUIT_MAX_TEMP_PROTECT)
		bodytemperature += 11
		return
	else
		bodytemperature += BODYTEMP_HEATING_MAX
	return

/mob/living/carbon/human/IgniteMob()
	if(dna)
		dna.species.IgniteMob(src)
	else
		..()

/mob/living/carbon/human/ExtinguishMob()
	if(dna)
		dna.species.ExtinguishMob(src)
	else
		..()
//END FIRE CODE


//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, CHEST, GROIN, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.heat_protection
	if(w_uniform)
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0.0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


	return min(1,thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(wear_suit)
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.cold_protection
	if(w_uniform)
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.cold_protection
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/proc/get_cold_protection(temperature)

	if(dna.check_mutation(COLDRES))
		return 1 //Fully protected from the cold.

	if(dna && COLDRES in dna.species.specflags)
		return 1

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0.0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1,thermal_protection)


/mob/living/carbon/human/handle_chemicals_in_body()
	..()
	if(dna)
		dna.species.handle_chemicals_in_body(src)

	return //TODO: DEFERRED

/mob/living/carbon/human/handle_vision()
	if(machine)
		if(!machine.check_eye(src))		reset_view(null)
	else
		if(!client.adminobs)			reset_view(null)

	if(dna)
		dna.species.handle_vision(src)

/mob/living/carbon/human/handle_hud_icons()
	if(dna)
		dna.species.handle_hud_icons(src)

/mob/living/carbon/human/handle_random_events()
	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 45 && nutrition > 20)
			lastpuke ++
			if(lastpuke >= 25) // about 25 second delay I guess
				Stun(5)

				visible_message("<span class='danger'>[src] throws up!</span>", \
						"<span class='userdanger'>[src] throws up!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

				var/turf/location = loc
				if (istype(location, /turf/simulated))
					location.add_vomit_floor(src, 1)

				nutrition -= 20
				adjustToxLoss(-3)

				// make it so you can only puke so fast
				lastpuke = 0


/mob/living/carbon/human/handle_changeling()
	if(mind && hud_used)
		if(mind.changeling)
			mind.changeling.regenerate()
			hud_used.lingchemdisplay.invisibility = 0
			hud_used.lingchemdisplay.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'> <font color='#dd66dd'>[mind.changeling.chem_charges]</font></div>"
		else
			hud_used.lingchemdisplay.invisibility = 101

/mob/living/carbon/human/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(glasses)
		if(glasses.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	if(head)
		if(head.flags & BLOCK_GAS_SMOKE_EFFECT)
			. = 1
	return .
/mob/living/carbon/human/proc/handle_embedded_objects()
	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			if(prob(I.embedded_pain_chance))
				L.take_damage(I.w_class*I.embedded_pain_multiplier)
				src << "<span class='userdanger'>[I] twists in your [L.getDisplayName()], causing great pain!</span>"

/mob/living/carbon/human/handle_heart()
	if(!heart_attack)
		return
	else
		losebreath += 5
		adjustOxyLoss(5)
		adjustBruteLoss(1)
	return

/mob/living/carbon/human/proc/handle_hud_list()

	if(hud_updateflag & 1 << HEALTH_HUD)
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == 2)
			holder.icon_state = "hudhealth-100"
		else
			holder.icon_state = "hud[RoundHealth(health)]"
		hud_list[HEALTH_HUD] = holder


	if(hud_updateflag & 1 << STATUS_HUD)
		var/image/holder = hud_list[STATUS_HUD]
		if(stat == 2)
			holder.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else if(check_virus())
			holder.icon_state = "hudill"
		else
			holder.icon_state = "hudhealthy"
		hud_list[STATUS_HUD] = holder
		med_hud_set_status()

	if(hud_updateflag & 1 << ID_HUD)
		var/image/holder = hud_list[ID_HUD]
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				holder.icon_state = "hud[ckey(I.GetJobName())]"
			else
				holder.icon_state = "hudunknown"
		else
			holder.icon_state = "hudunknown"


		hud_list[ID_HUD] = holder

	if(hud_updateflag & 1 << WANTED_HUD)
		var/image/holder = hud_list[WANTED_HUD]
		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						break
		hud_list[WANTED_HUD] = holder

	if(hud_updateflag & 1 << IMPLOYAL_HUD || hud_updateflag & 1 << IMPCHEM_HUD || hud_updateflag & 1 << IMPTRACK_HUD)
		var/image/holder1 = hud_list[IMPTRACK_HUD]
		var/image/holder2 = hud_list[IMPLOYAL_HUD]
		var/image/holder3 = hud_list[IMPCHEM_HUD]

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I,/obj/item/weapon/implant/loyalty))
					holder2.icon_state = "hud_imp_loyal"
				if(istype(I,/obj/item/weapon/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD] = holder3

#undef HUMAN_MAX_OXYLOSS
