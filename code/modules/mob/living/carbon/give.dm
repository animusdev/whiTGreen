/mob/living/carbon/verb/give()
	set category = "IC"
	set name = "Give"
	set src in view(1)
	if(!ismonkey(src)&&!ishuman(src)||isalien(src)||src.stat&(UNCONSCIOUS|DEAD)|| usr.stat&(UNCONSCIOUS|DEAD)|| src.client == null)
		usr << "<span class='warning'>[src.name] ничего не нужно.</span>"
		return
	if(src == usr)
//		usr << "<span class='warning'>I feel stupider, suddenly.</span>"
		return
	var/obj/item/I
	if(!usr.hand && usr.r_hand == null)
		usr << "<span class='warning'>¤ У вас в руке ничего нет!</span>"
		return
	if(usr.hand && usr.l_hand == null)
		usr << "<span class='warning'>¤ У вас в руке ничего нет!</span>"
		return
	if(usr.hand)
		I = usr.l_hand
	else if(!usr.hand)
		I = usr.r_hand
	if(!I || I.flags&(ABSTRACT|NODROP) || istype(I,/obj/item/tk_grab))
		return
	if(src.r_hand == null || src.l_hand == null)
		switch(alert(src,"[usr] даёт вам [(I.accusative_case ? I.accusative_case : I.name)]. Принять?",,"Да","Нет"))
			if("Да")
				if(!I)
					return
				if(!Adjacent(usr))
					usr << "<span class='warning'>¤ Вы должны сто&#255;ть р&#255;дом с человеком.</span>"
					src << "<span class='warning'>[usr.name] слишком далеко ушёл.</span>"
					return
				if((usr.hand && usr.l_hand != I) || (!usr.hand && usr.r_hand != I))
					usr << "<span class='warning'>¤ В вашей руке ничего нет.</span>"
					src << "<span class='warning'>[usr.name] больше не хочет отдать вам [(I.accusative_case ? I.accusative_case : I.name)].</span>"
					return
				if(src.lying||src.handcuffed)
					usr << "<span class='warning'>¤ [src.gender==MALE?"Он":"Она"] св&#255;зан[src.gender==MALE?"":"а"]!</span>"
					return
				if(src.r_hand != null && src.l_hand != null)
					src << "<span class='warning'>¤ Ваши руки зан&#255;ты.</span>"
					usr << "<span class='warning'>¤ [src.gender==MALE?"Его":"Её"] руки зан&#255;ты.</span>"
					return
				else
					if(src.r_hand == null)
						r_hand = I
						usr.drop_item()
					else if(src.l_hand==null)
						l_hand = I
						usr.drop_item()
					else
						src << "<span class='warning'>¤ Вы не можете это вз&#255;ть.</span>"
						usr << "<span class='warning'>[src.name] не может это вз&#255;ть!</span>"
						return
				I.loc = src
				I.layer = 20
				I.add_fingerprint(src)
				src.update_inv_r_hand()
				src.update_inv_l_hand()
				usr.update_inv_r_hand()
				usr.update_inv_l_hand()


				src.visible_message("<span class='notice'>[usr.name] передал[usr.gender==MALE?"":"а"] [(I.accusative_case ? I.accusative_case : I.name)] в руки [src.name].</span>")
			if("Нет")
				src.visible_message("<span class='warning'>[src.name] отказал[src.gender==MALE?"с&#255;":"ась"] от [(I.accusative_case ? I.accusative_case : I.name)].</span>")
	else
		usr << "<span class='warning'>¤ У [src.gender==MALE?"него":"неё"] зан&#255;ты руки.</span>"
