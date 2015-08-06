/datum/disease/brainrot
	name = "Brainrot"
	max_stages = 4
	spread_text = "On contact"
	spread_flags = CONTACT_GENERAL
	cure_text = "Mannitol"
	cures = list("mannitol")
	agent = "Cryptococcus Cosmosis"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST
	cure_chance = 15//higher chance to cure, since two reagents are required
	desc = "This disease destroys the braincells, causing brain fever, brain necrosis and general intoxication."
	required_organs = list(/obj/item/organ/limb/head)
	severity = DANGEROUS

/datum/disease/brainrot/stage_act() //Removed toxloss because damaging diseases are pretty horrible. Last round it killed the entire station because the cure didn't work -- Urist -ACTUALLY Removed rather than commented out, I don't see it returning - RR
	..()

	switch(stage)
		if(2)
			if(prob(2))
				affected_mob.emote("blink")
			if(prob(2))
				affected_mob.emote("yawn")
			if(prob(2))
				affected_mob << "<span class='danger'>Вам не по себе.</span>"
			if(prob(5))
				affected_mob.adjustBrainLoss(1)
				affected_mob.updatehealth()
		if(3)
			if(prob(2))
				affected_mob.emote("stare")
			if(prob(2))
				affected_mob.emote("drool")
			if(prob(10) && affected_mob.getBrainLoss()<=98)//shouldn't retard you to death now
				affected_mob.adjustBrainLoss(2)
				affected_mob.updatehealth()
				if(prob(2))
					affected_mob << "<span class='danger'>Вы пытаетесь вспомнить что-то очень важное...но не можете.</span>"

		if(4)
			if(prob(2))
				affected_mob.emote("stare")
			if(prob(2))
				affected_mob.emote("drool")
			if(prob(15) && affected_mob.getBrainLoss()<=98) //shouldn't retard you to death now
				affected_mob.adjustBrainLoss(3)
				affected_mob.updatehealth()
				if(prob(2))
					affected_mob << "<span class='danger'>Назойливый шум заполн&#255;ет всю вашу голову, не дава&#255; сосредоточитьс&#255;.</span>"
			if(prob(3))
				affected_mob << "<span class='danger'>Вы тер&#255;ете сознание...</span>"
				affected_mob.visible_message("<span class='warning'>[affected_mob] внезапно тер&#255;ет сознание.</span>")
				affected_mob.Paralyse(rand(5,10))
				if(prob(1))
					affected_mob.emote("snore")
			if(prob(15))
				affected_mob.stuttering += 3

	return