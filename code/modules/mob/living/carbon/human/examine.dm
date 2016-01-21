/mob/living/carbon/human/examine(mob/user)

	var/list/obscured = check_obscured_slots()
	var/skipface = 0
	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE

	var/he  = "Он"
	var/him = "нём"
	var/has = "него"
	var/his = "его"
	var/end = ""

	if(gender == FEMALE)
		he  = "Она"
		him = "ней"
		has = "неё"
		his = "её"
		end = "а"

	var/msg = "<span class='info'>*---------*\n* Это же "

	if(icon)
		msg += "\icon[src] " //note, should we ever go back to runtime-generated icons (please don't), you will need to change this to \icon[icon] to prevent crashes.

	msg += "<EM>[src.name]</EM>"

	if(wear_id)
		if(src.get_authentification_name("") == src.name && src.get_assignment("","") != "")
			msg += ", [src.get_assignment_russian(src.get_assignment("", ""))]"
	msg += "!\n"

	if(!(name == "Unknown"))
		if(age < 27)
			msg += "* [he] выгл&#255;дит весьма молодо."
		else
			if (age < 42)
				msg += "* [he] выгл&#255;дит достаточно зрело."
			else
				if (age < 75)
					msg += "* [he] выгл&#255;дит долгожителем."
				else
					msg += "* [he] буквально рассыпаетс&#255; на части от старости!"
		msg += "\n"

	//head
	if(head)
		if(!istype(head, /obj/item/clothing/head/HoS/dermal))
			if(istype(head, /obj/item/weapon/reagent_containers/food/snacks/grown))
				msg += "* У [has] за ухом \icon[head] цветок.\n"
			else
				if(istype(head,/obj/item/weapon/paper))
					msg += "* У [has] на голове \icon[head] бумажна&#255; шапка.\n"
				else
					msg += "* У [has] на голове \icon[head] [head.r_name].\n"

	//eyes
	if(glasses && !(slot_glasses in obscured))
		if(glasses.accusative_case)
			msg += "* [he] носит \icon[glasses] [glasses.accusative_case].\n"
		else
			msg += "* [he] носит \icon[glasses] [glasses.r_name].\n"

	//ears
	if(ears && !(slot_ears in obscured))
		if(istype(ears, /obj/item/device/radio/headset))
			msg += "* На [has] надета \icon[ears] [ears.r_name].\n"
		else
			msg += "* У [has] за ухом \icon[ears] [ears.r_name].\n"

	//mask
	if(wear_mask && !(slot_wear_mask in obscured))
		if(istype(wear_mask, /obj/item/clothing/mask/cigarette))
			msg += "* У [has] в зубах \icon[wear_mask] [wear_mask.r_name].\n"
		else
			msg += "* У [has] на лице \icon[wear_mask] [wear_mask.r_name].\n"

	//uniform
	if(w_uniform && !(slot_w_uniform in obscured))
		//Ties
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.hastie)
				if(istype(U.hastie,/obj/item/clothing/tie/medal))
					msg += "* У [has] на груди \icon[U.hastie] [U.hastie.r_name].\n"
				else if(istype(U.hastie,/obj/item/clothing/tie/armband))
					msg += "* У [has] на рукаве \icon[U.hastie] [U.hastie.r_name].\n"

	//suit/armor
	if(wear_suit)
		msg += "* На [him] \icon[wear_suit] [wear_suit.r_name].\n"

	//  suit/armor storage
	//	if(s_store)
	//		msg += "* [t_He] [t_is] carrying \icon[s_store] \a [s_store] on [t_his] [wear_suit.name].\n"

	//back
	if(back)
		if(back.r_name)
			msg += "* У [has] за спиной \icon[back] [back.r_name].\n"
		else
			msg += "* У [has] за спиной \icon[back] [back.name].\n"

	//left hand
	if(l_hand && !(l_hand.flags&ABSTRACT))
//		if(l_hand.blood_DNA)
//			msg += "* <span class='warning'>[he] держит \icon[l_hand] blood-stained [l_hand.name] в левой руке!</span>\n"
//		else
		if(l_hand.accusative_case)
			msg += "* [he] держит \icon[l_hand] [l_hand.accusative_case] в левой руке.\n"
		else if(l_hand.r_name)
			msg += "* [he] держит \icon[l_hand] [l_hand.r_name] в левой руке.\n"
		else
			msg += "* [he] держит \icon[l_hand] [l_hand] в левой руке.\n" // TODO: accusative_case needed

	//right hand
	if(r_hand && !(r_hand.flags&ABSTRACT))
//		if(r_hand.blood_DNA)
//			msg += "* <span class='warning'>[he] держит \icon[r_hand]  blood-stained [r_hand.name] в правой руке!</span>\n"
//		else
		if(r_hand.accusative_case)
			msg += "* [he] держит \icon[r_hand] [r_hand.accusative_case] в правой руке.\n"
		else if(r_hand.r_name)
			msg += "* [he] держит \icon[r_hand] [r_hand.r_name] в правой руке.\n"
		else
			msg += "* [he] держит \icon[r_hand] [r_hand] в правой руке.\n" // TODO: accusative_case needed

	//gloves
	if(gloves && !(slot_gloves in obscured))
		if(istype(gloves,/obj/item/clothing/gloves/brassknuckles))
			if(gloves.blood_DNA)
				msg += "* <span class='warning'>В руке у [has] \icon[gloves] окровавленный кастет!</span>\n"
			else
				msg += "* У [has] в руке \icon[gloves] кастет.\n"

		else
			if(gloves.blood_DNA)
				msg += "* <span class='warning'>На руках у [has] \icon[gloves] окровавленные [gloves.r_name]!</span>\n"
			else
				msg += "* На руках у [has] \icon[gloves] [gloves.r_name].\n"
	else if(blood_DNA)
		msg += "* <span class='warning'>У [has] окровавлены руки!</span>\n"


	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/restraints/handcuffs/cable))
			msg += "* <span class='warning'>[he] \icon[handcuffed] св&#255;зан[end] кабелем!</span>\n"
		else
			msg += "* <span class='warning'>[he] \icon[handcuffed] в наручниках!</span>\n"

	//belt
	if(belt)
		if(istype(belt, /obj/item/weapon/storage/belt))
			msg += "* [he] носит \icon[belt] [belt.r_name].\n"
		else
			if(!istype(belt, /obj/item/device/pda))
				if(belt.r_name)
					msg += "* У [has] на по&#255;се \icon[belt] [belt.r_name].\n"
				else
					msg += "* У [has] на по&#255;се \icon[belt] [belt].\n"

	//shoes
	if(!shoes)
		msg += "* У [has] босые ноги.\n"

	if(shoes && !(slot_shoes in obscured))
		if(istype(shoes,/obj/item/clothing/shoes/galoshes) || istype(shoes,/obj/item/clothing/shoes/magboots))
			msg += "* На [him] \icon[shoes] [shoes.r_name].\n"

	//ID

	if(wear_id)
		if(src.get_authentification_name("") != src.name)
			if(wear_id.accusative_case)
				msg += "* [he] носит \icon[wear_id] [wear_id.accusative_case].\n"
			else
				msg += "* [he] носит \icon[wear_id] [wear_id].\n"

		/*var/id
		if(istype(wear_id, /obj/item/device/pda))
			var/obj/item/device/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/weapon/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/weapon/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, user) <= 1) && prob(10))
			msg += "<span class='warning'>[t_He] [t_is] wearing \icon[wear_id] \a [wear_id] yet something doesn't seem right...</span>\n"
		else*/
	//	msg += "* На [him] \icon[wear_id] [wear_id].\n"

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			msg += "* <span class='warning'><B>[he] бьетс&#255; в припадке!</B></span>\n"
		if(100 to 300)
			msg += "* <span class='warning'>[he] конвульсивно подёргиваетс&#255;.</span>\n"

	if(gender_ambiguous) //someone fucked up a gender reassignment surgery
		if (gender == MALE)
			msg += "* [he] чем-то очень похож на женщину.\n"
		else
			msg += "* [he] чем-то очень похожа на мужчину.\n"

	var/temp = getBruteLoss() //no need to calculate each of these twice

	msg += "<span class='warning'>"

	if(temp)
		if(temp < 30)
			msg += "* У [has] незначительные ссадины.\n"
		else
			msg += "* <B>[he] [gender=="male"?"весь":"вс&#255;"] изранен[end]!</B>\n"

	temp = getFireLoss()
	if(temp)
		if(temp < 30)
			msg += "* У [has] незначительные ожоги.\n"
		else
			msg += "* <B>У [has] серьезные ожоги!</B>\n"

	temp = getCloneLoss()
	if(temp)
		if(temp < 30)
			msg += "* У [has] небольшие генетические дефекты.\n"
		else
			msg += "* <B>У [has] серьезные генетические дефекты.</B>\n"


	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			msg += "* <B>У [has] в [L.getNamePrepositional()] \icon[I] [I.r_name]!</B>\n"

	if(!stat == DEAD)
		if(nutrition < NUTRITION_LEVEL_HUNGRY)
			msg += "* [he] выгл&#255;дит голодн[gender=="male"?"ым":"ой"].\n"
		else if(nutrition < NUTRITION_LEVEL_STARVING)
			msg += "* [he] &#255;вно страдает от недоедани&#255;.\n"
		else if(nutrition >= NUTRITION_LEVEL_FAT)
			if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
				msg += "* [he] сочн[gender=="male"?"ый":"а&#255;"] и аппетитн[gender=="male"?"ый":"а&#255;"], как молодой поросёнок. О-о-очень вкусный поросёнок.\n"
			else
				msg += "* [he] довольно пухл[gender=="male"?"ый":"а&#255;"].\n"

	if(pale)
		msg += "* У [has] бледна&#255; кожа.\n"

	if(blood_max && !bleedsupress)
		msg += "* <B>[he] истекает кровью!</B>\n"

	if(getOxyLoss() > 30 && !(slot_wear_mask in obscured))
		msg += "* У [has] посиневшее лицо.\n"

	msg += "</span>"

	var/appears_dead = 0
	if(stat == DEAD || (status_flags & FAKEDEATH))
		appears_dead = 1
	if(!appears_dead)
		if(stat == UNCONSCIOUS && !sleeping)
			msg += "* [he] не реагирует на происход&#255;щее вокруг. Похоже, что [gender == "male" ? "он":"она"] без сознани&#255;.\n"
		else if(sleeping)
			msg += "* Похоже, что [gender == "male" ? "он":"она"] спит.\n"
		else if(getBrainLoss() >= 30)
			msg += "* У [has] глупое выражение лица.\n"

		if(getorgan(/obj/item/organ/brain))
			if(!key && !stat)
				msg += "* <span class='deadsay'>[he] полностью выгорел[end], не перенес&#255; невзгоды жизни в глубинах космоса. Нет никакой надежды, что [gender=="male"?"он":"она"] придёт в себ&#255;.</span>\n"
			else if(!client)
				msg += "* У [gender == "male" ? "него":"неё"] пустой, отсутствующий взгл&#255;д...\n"

		if(digitalcamo)
			msg += "* [he] выгл&#255;дит как психоделическое месиво из сотен красок!\n"

	else
		if(getorgan(/obj/item/organ/brain))//Only perform these checks if there is no brain
			msg += "* <span class='deadsay'>[he] безвольно поник[gender=="male"?"":"ла"], не про&#255;вл&#255;&#255; признаков жизни."
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
					msg += " [gender=="male"?"Его":"Её"] дух навеки успокоилс&#255;."
			msg += "..</span>\n"
		else //Brain is gone, doesn't matter if they are AFK or present
			msg += "* <span class='deadsay'>Похоже, что [his] мозг был извлечён...</span>\n"


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
