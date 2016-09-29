/mob/living/carbon/human/examine(mob/user)

	var/list/obscured = check_obscured_slots()
	var/skipface = 0
	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE

	var/he  = "He"
	var/him = "him"
	var/his = "his"

	if(gender == FEMALE)
		he  = "She"
		him = "her"
		his = "her"

	var/msg = "<span class='info'>*---------*\n* This is "

	if(icon)
		msg += "\icon[src] " //note, should we ever go back to runtime-generated icons (please don't), you will need to change this to \icon[icon] to prevent crashes.

	msg += "<EM>[src.name]</EM>"

	if(wear_id)
		if(src.get_authentification_name("") == src.name && src.get_assignment("","") != "")
			msg += ", [src.get_assignment("", "")]"
	msg += "!\n"

	if(!(name == "Unknown"))
		if(age < 27)
			msg += "* [he] looks pretty young.\n"
		else if (age > 55)
			msg += "* [he] looks old.\n"

	//head
	if(head)
		if(!istype(head, /obj/item/clothing/head/HoS/dermal))
			msg += "* [he] is wearing \icon[head] \a [head] on [his] head.\n"

	//eyes
	if(glasses && !(slot_glasses in obscured))
		msg += "* [he] has \icon[glasses] \a [glasses] covering [his] eyes.\n"

	//ears
	if(ears && !(slot_ears in obscured))
		if(istype(ears, /obj/item/device/radio/headset))
			msg += "* [he] has \icon[ears] \a radio headset on [his] ears.\n"
		else
			msg += "* [he] has \icon[ears] \a [ears] on [his] ears.\n"

	//mask
	if(wear_mask && !(slot_wear_mask in obscured))
		if(istype(wear_mask, /obj/item/clothing/mask/cigarette))
			msg += "* [he] has \icon[wear_mask] \a [wear_mask] in [his] mouth.\n"
		else
			msg += "* [he] has \icon[wear_mask] \a [wear_mask] on [his] face.\n"

	//neck
	if(neck && !(slot_neck in obscured))
		msg += "* [he] is wearing \icon[neck] \a [neck].\n"

	//uniform
	if(w_uniform && !(slot_w_uniform in obscured))
		//Ties
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.hastie)
				msg += "* [he] has \icon[U.hastie] \a [U.hastie] on [his] uniform.\n"

	//suit/armor
	if(wear_suit)
		msg += "* [he] is wearing \icon[wear_suit] \a [wear_suit].\n"

	//back
	if(back)
		msg += "* [he] has \icon[back] \a [back] on [his] back.\n"

	//left hand
	if(l_hand && !(l_hand.flags&ABSTRACT))
		if(l_hand.blood_DNA)
			msg += "* <span class='warning'>[he] is holding \icon[l_hand] [l_hand.gender==PLURAL?"some":"a"] blood-stained [l_hand.name] in [his] left hand!</span>\n"
		else
			msg += "* [he] is holding \icon[l_hand] \a [l_hand] in [his] left hand.\n"


	//right hand
	if(r_hand && !(r_hand.flags&ABSTRACT))
		if(r_hand.blood_DNA)
			msg += "* <span class='warning'>[he] is holding \icon[r_hand] [r_hand.gender==PLURAL?"some":"a"] blood-stained [r_hand.name] in [his] right hand!</span>\n"
		else
			msg += "* [he] is holding \icon[r_hand] \a [r_hand] in [his] right hand.\n"

	//gloves
	if(gloves && !(slot_gloves in obscured))
		if(istype(gloves,/obj/item/clothing/gloves/boxing/green) || istype(gloves,/obj/item/clothing/gloves/brassknuckles))
			msg += "* [he] has \icon[gloves] \a [gloves] on [his] hands.\n"
	if(!gloves && blood_DNA && !(slot_gloves in obscured))
		msg += "<span class='warning'>* [he] has blood-stained hands!</span>\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/restraints/handcuffs/cable))
			msg += "* <span class='warning'>[he] is \icon[handcuffed] restrained with cable!</span>\n"
		else
			msg += "* <span class='warning'>[he] is \icon[handcuffed] handcuffed!</span>\n"

	//belt
	if(belt)
		if(!istype(belt, /obj/item/device/pda))
			msg += "* [he] has \icon[belt] \a [belt] about [his] waist.\n"

	//shoes
	if(!shoes)
		msg += "* [he] is barefoot.\n"

	if(shoes && !(slot_shoes in obscured))
		if(istype(shoes,/obj/item/clothing/shoes/galoshes) || istype(shoes,/obj/item/clothing/shoes/magboots))
			msg += "* [he] is wearing \icon[shoes] \a [shoes].\n"

	if(legcuffed)
		msg += "* <span class='warning'>[he] is in \icon[legcuffed] \a [legcuffed]!</span>\n"
	//ID

	if(wear_id)
		if(src.get_authentification_name("") != src.name)
			msg += "* [he] is wearing \icon[wear_id] \a [wear_id].\n"

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			msg += "* <span class='warning'><B>[he] is convulsing violently!</B></span>\n"
		if(200 to 300)
			msg += "* <span class='warning'>[he] is extremely jittery.</span>\n"
		if(100 to 200)
			msg += "* <span class='warning'>[he] is] twitching ever so slightly.</span>\n"

	if(gender_ambiguous) //someone fucked up a gender reassignment surgery
		if(gender == MALE)
			msg += "* [he] has a strange feminine quality to [him].\n"
		else
			msg += "* [he] has a strange masculine quality to [him].\n"

	for(var/obj/item/organ/limb/temp in organs)
		var/limb
		switch(temp.body_part)
			if(LEG_RIGHT)	limb = "right leg"
			if(LEG_LEFT) limb = "left leg"
			if(ARM_RIGHT) limb = "right arm"
			if(ARM_LEFT) limb = "left arm"
			if(HEAD) limb = "head"

		if(temp)
			if(temp.state & ORGAN_REMOVED)
//				is_destroyed["[temp.display_name]"] = 1
				msg += "<span class='warning'>*<b><i> [he] is missing [his] [limb].</i></b></span>\n"
				continue
			if(temp.status & ORGAN_ROBOTIC)
				msg += "<span class='warning'>*<i> [he] has a robot [limb]!</i></span>\n"
				continue

	var/temp = getBruteLoss() //no need to calculate each of these twice

	msg += "<span class='warning'>"

	if(temp)
		if(temp < 30)
			msg += "* [he] has minor bruising.\n"
		else
			msg += "* <B>[he] has severe bruising!</B>\n"

	temp = getFireLoss()
	if(temp)
		if(temp < 30)
			msg += "* [he] has minor burns.\n"
		else
			msg += "* <B>[he] has severe burns!</B>\n"

	temp = getCloneLoss()
	if(temp)
		if(temp < 30)
			msg += "* [he] has minor cellular damage.\n"
		else
			msg += "* <B>[he] has severe cellular damage.</B>\n"


	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			msg += "<B>[he] has \a \icon[I] [I] embedded in [his] [L.getDisplayName()]!</B>\n"

	if(pale)
		msg += "* [he] has pale skin.\n"

	if(blood_max && !bleedsuppress)
		msg += "* <B>[he] is bleeding!</B>\n"

//	if(getOxyLoss() > 30 && !(slot_wear_mask in obscured))
//		msg += "* У [has] посиневшее лицо.\n"

	msg += "</span>"

	var/appears_dead = 0
	if(stat == DEAD || (status_flags & FAKEDEATH))
		appears_dead = 1
	if(!appears_dead)
		if(stat == UNCONSCIOUS && !sleeping)
			msg += "* [he] isn't responding to anything around [him].\n"
		else if(sleeping)
			msg += "* [he] seems to be asleep.\n"
		else if(getBrainLoss() >= 30)
			msg += "* [he] has a stupid expression on [his] face.\n"

		if(getorgan(/obj/item/organ/brain))
			if(!key && !stat)
				msg += "* <span class='deadsay'>[he] is totally catatonic. The stresses of life in deep-space must have been too much for [him]. Any recovery is unlikely.</span>\n"
			else if(!client)
				msg += "* [he] has a vacant, braindead stare...\n"

		if(digitalcamo)
			msg += "* [he] is moving [his] body in an unnatural and blatantly inhuman manner.\n"

	else
		if(getorgan(/obj/item/organ/brain))//Only perform these checks if there is no brain
			msg += "* <span class='deadsay'>[he] is limp and unresponsive; there are no signs of life"
			if(!key)
				var/foundghost = 0
				if(mind)
					for(var/mob/dead/observer/G in player_list)
						if(G.mind == mind)
							foundghost = 1
							if (G.can_reenter_corpse == 0)
								foundghost = 0
							break
				if(!foundghost)
					msg += " and [his] soul has departed"
			msg += "...</span>\n"
		else //Brain is gone, doesn't matter if they are AFK or present
			msg += "* <span class='deadsay'>It appears that [his] brain is missing...</span>\n"


	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/cybernetic_implant/eyes/hud/CIH = locate(/obj/item/cybernetic_implant/eyes/hud) in H.internal_organs
		if(istype(H.glasses, /obj/item/clothing/glasses/hud) || CIH)
			var/perpname = get_face_name(get_id_name(""))
			if(perpname)
				var/datum/data/record/R = find_record("name", perpname, data_core.general)
				if(R)
					msg += "<span class = 'deptradio'>Rank:</span> [R.fields["rank"]]<br>"
					msg += "<a href='?src=\ref[src];hud=1;photo_front=1'>\[Front photo\]</a> "
					msg += "<a href='?src=\ref[src];hud=1;photo_side=1'>\[Side photo\]</a><br>"
				if(istype(H.glasses, /obj/item/clothing/glasses/hud/health) || istype(CIH,/obj/item/cybernetic_implant/eyes/hud/medical))
					var/implant_detect
					for(var/obj/item/cybernetic_implant/CI in internal_organs)
						implant_detect += "[name] is modified with a [CI.name].<br>"
					if(implant_detect)
						msg += "Detected cybernetic modifications:<br>"
						msg += implant_detect
					if(R)
						var/health = R.fields["p_stat"]
						msg += "<a href='?src=\ref[src];hud=m;p_stat=1'>\[[health]\]</a>"
						health = R.fields["m_stat"]
						msg += "<a href='?src=\ref[src];hud=m;m_stat=1'>\[[health]\]</a><br>"
					R = find_record("name", perpname, data_core.medical)
					if(R)
						msg += "<a href='?src=\ref[src];hud=m;evaluation=1'>\[Medical evaluation\]</a><br>"


				if(istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(CIH,/obj/item/cybernetic_implant/eyes/hud/security))
					if(!user.stat && user != src) //|| !user.canmove || user.restrained()) Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
						var/criminal = "None"

						R = find_record("name", perpname, data_core.security)
						if(R)
							criminal = R.fields["criminal"]

						msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];hud=s;status=1'>\[[criminal]\]</a>\n"
						msg += "<span class = 'deptradio'>Security record:</span> <a href='?src=\ref[src];hud=s;view=1'>\[View\]</a> "
						msg += "<a href='?src=\ref[src];hud=s;add_crime=1'>\[Add crime\]</a> "
						msg += "<a href='?src=\ref[src];hud=s;view_comment=1'>\[View comment log\]</a> "
						msg += "<a href='?src=\ref[src];hud=s;add_comment=1'>\[Add comment\]</a>\n"

	msg += "*---------*</span>"

	user << msg

