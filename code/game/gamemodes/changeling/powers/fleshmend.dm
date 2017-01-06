/obj/effect/proc_holder/changeling/fleshmend
	name = "Fleshmend"
	desc = "Our flesh rapidly regenerates, healing our wounds."
	helptext = "Heals a moderate amount of damage over a short period of time. Can be used while unconscious."
	chemical_cost = 25
	dna_cost = 2
	req_stat = UNCONSCIOUS

//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/obj/effect/proc_holder/changeling/fleshmend/sting_action(var/mob/living/user)
	user << "<span class='notice'>We begin to heal rapidly.</span>"
	spawn(0)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.eye_stat = 0
			H.eye_blind = 0
			H.eye_blurry = 0
			H.disabilities &= ~NEARSIGHT
			H.disabilities &= ~BLIND
			H.restore_blood()
			H.remove_all_embedded_objects()

		for(var/i = 0, i<10,i++)
			user.adjustBruteLoss(-10)
			user.adjustOxyLoss(-10)
			user.adjustFireLoss(-10)
			sleep(10)
	return 1