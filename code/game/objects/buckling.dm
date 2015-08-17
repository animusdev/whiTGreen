

/obj
	var/can_buckle = 0
	var/buckle_lying = -1 //bed-like behaviour, forces mob.lying = buckle_lying if != -1
	var/buckle_requires_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null


//Interaction
/obj/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		user_unbuckle_mob(user)

/obj/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		user_buckle_mob(M, user)


//Cleanup
/obj/Destroy()
	. = ..()
	unbuckle_mob()

/obj/Del()
	. = ..()
	unbuckle_mob()


//procs that handle the actual buckling and unbuckling
/obj/proc/buckle_mob(mob/living/M)
	if(!can_buckle || !istype(M) || (M.loc != loc) || M.buckled || (buckle_requires_restraints && !M.restrained()))
		return 0

	if (isslime(M) || isAI(M))
		if(M == usr)
			M << "<span class='warning'>You are unable to buckle yourself to the [src]!</span>"
		else
			usr << "<span class='warning'>You are unable to buckle [M] to the [src]!</span>"
		return 0

	M.buckled = src
	M.dir = dir
	buckled_mob = M
	M.update_canmove()
	post_buckle_mob(M)
	M.throw_alert("buckled", new_master = src)
	return 1

/obj/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob.clear_alert("buckled")
		buckled_mob = null

		post_buckle_mob(.)


//Handle any extras after buckling/unbuckling
//Called on buckle_mob() and unbuckle_mob()
/obj/proc/post_buckle_mob(mob/living/M)
	return


//Wrapper procs that handle sanity and user feedback
/obj/proc/user_buckle_mob(mob/living/M, mob/user)
	if(!user.Adjacent(M) || user.restrained() || user.lying || user.stat)
		return

	add_fingerprint(user)
	unbuckle_mob()

	if(buckle_mob(M))
		if(M == user)

			if(istype(src, /obj/structure/stool/bed/chair))
				M.visible_message("[M.name] садитс&#255; на [src.accusative_case].",\
			 		 "<span class='notice'>¤ Вы садитесь на [src.accusative_case].</span>")
			else if(src.r_name == "кровать" || "каталка")
				M.visible_message("[M.name] ложитс&#255; на [src.accusative_case].",\
					 "<span class='notice'>¤ Вы ложитесь на [src.accusative_case].</span>")

		else
			if(src.r_name == "кровать" || src.r_name == "каталка")
				M.visible_message(
					"<span class='warning'>[user.name] кладёт [M.name] на [src.accusative_case]!</span>",\
					"<span class='danger'>[user.name] кладёт вас на [src.accusative_case]!</span>")
			else if(src.r_name == "кресло")
				M.visible_message(
					"<span class='warning'>[user.name] усаживает [M.name] в [src.accusative_case]!</span>",\
					"<span class='danger'>[user.name] усаживает вас в [src.accusative_case]!</span>")
			else
				M.visible_message(
					"<span class='warning'>[user.name] усаживает [M.name] на [src.accusative_case]!</span>",\
					"<span class='danger'>[user.name] усаживает вас на [src.accusative_case]!</span>")

/obj/proc/user_unbuckle_mob(mob/user)
	var/mob/living/M = unbuckle_mob()

	if(M)
		if(M == user)
			if(src.r_name == "стул")
				M.visible_message("[M.name] встаёт со [src.genitive_case].",\
					"<span class='notice'>¤ Вы встаёте со [src.genitive_case].</span>")
			else
				M.visible_message("[M.name] встаёт с [src.genitive_case].",\
					"<span class='notice'>¤ Вы встаёте с [src.genitive_case].</span>")
		else
			if(src.r_name == "кровать" || src.r_name == "каталка" || src.r_name == "диван")
				M.visible_message(
					"<span class='warning'>[user.name] поднимает [M.name] с [src.genitive_case]!</span>",\
					"<span class='danger'>[user.name] поднимает вас с [src.genitive_case]!</span>")

			else if(src.r_name == "кресло")
				M.visible_message(
					"<span class='warning'>[user.name] поднимает [M.name] из [src.genitive_case]!</span>",\
					"<span class='danger'>[user.name] поднимает вас из [src.genitive_case]!</span>")
			else
				M.visible_message(
					"<span class='warning'>[user.name] поднимает [M.name] со [src.genitive_case]!</span>",\
					"<span class='danger'>[user.name] поднимает вас со [src.genitive_case]!</span>")


		add_fingerprint(user)
	return M


