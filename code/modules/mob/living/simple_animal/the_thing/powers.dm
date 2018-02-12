/mob/living/simple_animal/hostile/the_thing/verb/Feed()
	set category = "The Thing"
	set desc = "This will let you feed on any valid creature in the surrounding area. This should also be used to halt the feeding process."

	if(stat)
		return 0

	var/list/choices = list()
	for(var/mob/living/C in view(1,src))
		if(C!=src && Adjacent(C))
			choices += C

	var/mob/living/M = input(src,"Who do you wish to feed on?") in null|choices
	if(!M) return 0
	if(CanFeedon(M))
		Feedon(M)
		return 1

/mob/living/simple_animal/hostile/the_thing/MouseDrop(var/mob/living/A)
	if(usr.mind != leader_mind)
		return 0
	if(isliving(A) && A != src)
		var/mob/living/Food = A
		if(CanFeedon(Food))
			Feedon(Food)
		else
			Feedstop()
	..()

/mob/living/simple_animal/hostile/the_thing/proc/CanFeedon(var/mob/living/M)
	if(!ismob(M))
		return 0

	if(issilicon(M))
		return 0

	if(!Adjacent(M))
		return 0

	if(Victim)
		return 0

	if(istype(M, /mob/living/simple_animal/hostile/the_thing))
		src << "<i>I can't latch onto another piece of you...</i>"
		return 0

	if(stat)
		src << "<i>I must be conscious to do this...</i>"
		return 0

	if(feedon||devouring)
		src << "<i>I already devour victim...</i>"
		return 0

	for(var/mob/living/simple_animal/hostile/the_thing/T in oviewers(7, src))
		if(T.Victim == M)
			src << "<i>The [T.name] is already feeding on this subject...</i>"
			return 0
	return 1

/mob/living/simple_animal/hostile/the_thing/proc/Feedon(var/mob/living/M)
	set background = 1
	Victim = M
	src.loc = M.loc
	canmove = 0
	anchored = 1
	feedon = 1
	src << "<span class='notice'><i>I have latched onto the subject and begun feeding...</i></span>"
	M << "<span class='userdanger'>The [name] has latched onto [M.name]!</span>"

	while(Victim && Victim == M && Victim.stat != DEAD && stat != DEAD)
		canmove = 0

		if(Adjacent(Victim))
			loc = M.loc
		else
			break
		sleep(5)

	anchored = 0

	if(M && M.stat == DEAD && !devouring)
		var/mob/living/simple_animal/hostile/the_thing/T = src
		M.grabbedby(T, 1)
		var/obj/item/weapon/grab/G = src.get_active_hand()
		if(G)
			G.state = GRAB_KILL
		AIStatus = AI_OFF
		T.devour.try_to_ability(T)

	AIStatus = AI_ON
	canmove = 1
	Feedstop()
	feedon = 0

/mob/living/simple_animal/hostile/the_thing/proc/Feedstop()
	if(Victim)
		if(Victim.client)
			Victim << "[src] has let go of your head!"//» получаетс€ бесокнечные залезание-слезани€
		Victim = null

/mob/living/simple_animal/hostile/the_thing/proc/UpdateFeed(var/mob/M)
	if(Victim)
		if(Victim == M)
			loc = M.loc // simple "attach to head" effect!


