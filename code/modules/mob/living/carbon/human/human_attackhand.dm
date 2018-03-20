/mob/living/carbon/human/attack_hulk(mob/living/carbon/human/user)
	if(user.a_intent == "harm")
		..(user, 1)
		adjustBruteLoss(5)
		Weaken(4)

/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	if(..())	//to allow surgery to return properly.
		return

	if(dna)
		dna.species.spec_attack_hand(M, src)
	if(M.a_intent == "harm")
		lose_hat(0.1) //kinda small chance to knock knockable hat off

	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return