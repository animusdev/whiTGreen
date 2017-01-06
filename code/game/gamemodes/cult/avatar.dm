var/avatarcreated=0		//Был ли уже создан Аватар?
var/mob/living/simple_animal/avatar/demon		//Главная переменная, на которой основан аватар, его абилки, и всё-всё-всё.

/proc/messagevictimcheck(mob/living/P as mob)		//Проверка на цель с сообщением
	if(iscultist(P) || ("cult" in P.faction) || ("faithless" in P.faction))
		demon << "\red My followers do not deserve this!"
		return 0
	if(demon==P)
		demon << "\red What the hell am I doing?"
		return 0
	if(P.check_contents_for(/obj/item/weapon/nullrod))
		demon << "\red Something prevents my power to work!"
		return 0
	return 1

/proc/victimcheck(mob/living/M as mob)		//Проверка на цель без сообщений
	return !((M.check_contents_for(/obj/item/weapon/nullrod)) || (iscultist(M)) || (demon==M) || ("cult" in M.faction) || ("faithless" in M.faction))

/mob/living/simple_animal/avatar
	name = "Avatar of the Nar-Sie"
	desc = "Human, which Nar-Sie uses as vessel, to contain Her great power..."
	icon = 'icons/mob/demon.dmi'
	icon_state = "daemon"
	verb_say = "рычит"
	verb_engsay = "snarls"
	verb_ask = "рычит"
	verb_exclaim = "ревёт"
	verb_yell = "ревёт"
	wander = 0
	see_in_dark = 8
	environment_smash = 3
	mob_size = MOB_SIZE_LARGE		//Чтобы в шкафчике не заварили
	a_intent = "harm"
	response_help = "touches"
	response_disarm = "tries to push"
	response_harm = "hits"
	maxHealth = 400
	health = 400
	speed=5
	status_flags = 0		//Нельзя толкнуть
	harm_intent_damage = 5
	force_threshold = 10
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "smashes"
	attack_sound = 'sound/effects/heavyhit.ogg'
	minbodytemp = 0
	maxbodytemp = INFINITY		//Пофиг на атмос. Возможно стоит убрать, ибо почему бы не дать возможность его зажарить/космировать?
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("faithless","cult")		//Чтобы его ногами не запинали его же собственные демоны
	var/stepsound=0		//Сколько шагов до звука?
	var/enraged=0		//В ярости?
	var/victim=null		//Жертва под воздействием Doom. Нужна для того чтобы проклятье можно было скинуть ударив библией, а так же определить есть ли она вообще в мире
	var/hunger=200		//Need...moar...souls
	var/summoned_during_cult=0		//Его призвали во время культа?
	var/attack_cooldown=2		//Кулдаун атаки



//////////////////////// ГЛАВНЫЕ ПРОКИ ////////////////////////



	New()
		..()
		if (avatarcreated || demon)		//Есть только один Аватар.
			spawn(1)		message_admins("There can be only one Avatar in the world")
			qdel(src)

		demon=src
		avatarcreated = 1		//Переменную нельзя установить на 0 без педальвмешательства. Если аватар соснул, то нового не сделать.
		if(ticker.mode.name == "cult")		summoned_during_cult=1

		var/matrix/M = matrix()		//Увеличить спрайт Аватара. Это делает его мыльным, но тут уже выбор - либо карликовый но нормальный, либо нормальный, но мыльный.
		M.Scale(1.25)
		M.Translate(0,5)
		src.transform = M

		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS		//X-RAY
		src.sight |= SEE_OBJS

		if(!iscultist(src) && summoned_during_cult && mind)
			ticker.mode.add_cultist(src.mind)
			src.mind.special_role = "Cultist"
			src.mind.current.verbs -= /mob/living/proc/cult_innate_comm		//Ему это не нужно

		spawn(1)
			if(!src.giveSpells())		//Нагло украдено у ревенанта
				message_admins("Avatar was created but has no mind. Trying again in ten seconds.")
				spawn(100)
					if(!src.giveSpells())
						message_admins("Avatar still has no mind. Deleting...")
						qdel(src)


	Stat()		//Cтат-панелька с временем и голодом
		..()
		stat(null, "Hunger: [src.hunger]/200")
		if(ticker.mode.name == "cult")
			var/datum/game_mode/cult/cult = ticker.mode
			if(cult.summoning_in_progress == 1)		stat(null, "Time: [cult.reality_integrity]/600")


	death()
		..()
		visible_message("<span class='danger'>[src] roars and shrieks, dark essense flies out of it's body...</span>")
		world << 'sound/hallucinations/far_noise.ogg'
		var/datum/effect/effect/system/bad_smoke_spread/smoke = new /datum/effect/effect/system/sleep_smoke_spread()
		smoke.set_up(10, 0, src.loc)
		smoke.start()
		var/mob/living/carbon/human/P = new /mob/living/carbon/human(src.loc)
		P.name = "Unknown"
		P.mutations |= HUSK
		P.adjustCloneLoss(rand(300,600))
		P.adjustFireLoss(rand(300,600))
		P.key=src.key
		ghostize()
		qdel(src)		//Аватара нет

	Life()
		..()
		for(var/obj/mecha/machine in view(src.loc,3))
			if(machine && machine.occupant)		machine.occupant.adjustCloneLoss(5)

		for(var/mob/living/M in view(src.loc,3))		//Его аура
			if(M)
				if(victimcheck(M))
					var/rast = get_dist(M,src)
					if(!istype(M,/mob/living/silicon))
						M.adjustCloneLoss(14-3*rast)
						if(enraged)		M.adjustFireLoss(14-4*rast)
					else
						if(prob(40-10*rast)+10*enraged)
							if(rast!=0)
								M.emp_act(get_dist(M,src))
							else
								M.emp_act(1)


		if(health <=200 && enraged==0)		//Ярость
			visible_message("<span class='danger'><FONT size=2>[src] body starts glowing with the piercing red light...</span></FONT>")
			icon_state = "enrage"
			force_threshold = 0
			enraged=1
			speed=1

		if(attack_cooldown>0)		--attack_cooldown

		if(hunger>1)		--hunger
		else if(hunger==1)		//Дай пожрать
			src << "\red Uuugh...I am losing power...I need...souls"
			--hunger
		else		demon.adjustBruteLoss(2)



//////////////////////// АБИЛКИ ////////////////////////



/mob/living/simple_animal/avatar/proc/giveSpells()		//Прок, который выдаёт ему абилки. Нагло украдено у Ревенанта.
	if(src.mind)
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/soul_absorb
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/evilwhisper
		src.mind.spell_list += new /obj/effect/proc_holder/spell/dumbfire/harpoon
		src.mind.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/destruction
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/area_teleport/dark_transfering
		src.mind.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/summon_daemons
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/suffer
		src.mind.spell_list += new /obj/effect/proc_holder/spell/aoe_turf/inferno
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/condemn

		return 1
	return 0


/obj/effect/proc_holder/spell/targeted/soul_absorb
	name = "Absorb soul"
	panel = "Powers"
	desc = "Absorb the soul of living being, to shorten the timer and heal yourself"
	charge_max = 200
	clothes_req = 0
	range = 1

/obj/effect/proc_holder/spell/aoe_turf/summon_daemons
	name = "Summon Daemons"
	invocation_type = "shout"
	invocation = "SATELLITES ILLAM UNAM PATERE"
	panel = "Powers"
	desc = "Summon faithlesses to aid you in battle"
	charge_max = 600
	clothes_req = 0
	range = 1

/obj/effect/proc_holder/spell/targeted/suffer
	name = "Suffering of Geometer"
	panel = "Powers"
	desc = "Paralyse the target with unbearable pain"
	max_targets = 1
	charge_max = 100
	clothes_req = 0
	range = 5

/obj/effect/proc_holder/spell/aoe_turf/inferno
	name = "Pandemonium"
	panel = "Powers"
	desc = "Unleash the Pandemonium"
	invocation_type = "shout"
	invocation = "CHORO MORTIS"
	charge_max = 1200
	clothes_req = 0
	range = 6

/obj/effect/proc_holder/spell/targeted/condemn
	name = "Doom"
	panel = "Powers"
	desc = "Curse your target to make it inevitably die after 60 seconds. Curse chain-jumps, and each death shortens the cooldown"
	charge_max = 600
	clothes_req = 0
	range = 7

/obj/effect/proc_holder/spell/aoe_turf/destruction
	name = "Annihilation"
	panel = "Powers"
	desc = "Annihilate everything around you"
	charge_max = 1200
	clothes_req = 0
	range = 7

/obj/effect/proc_holder/spell/dumbfire/harpoon
	name = "Dark harpoon"
	panel = "Powers"
	desc = "Throw forward your harpoon, to drag creatures to you"
	charge_max = 100
	clothes_req = 0
	invocation_type = "emote"
	invocation = "\red \bold Avatar shoots a dark harpoon from it's hand!"
	message = "\red \bold Harpoon pierces your body!"
	proj_trigger_range = 1
	proj_icon = 'icons/mob/demon.dmi'
	proj_icon_state = "magspear"
	proj_name = "a harpoon"
	proj_type = "/obj/effect/proc_holder/spell/targeted/inflict_handler/harpoon"


/obj/effect/proc_holder/spell/targeted/area_teleport/dark_transfering
	name = "Transfering of Damnation"
	panel = "Powers"
	desc = "Teleport after 4 seconds delay"
	charge_max = 400
	clothes_req = 0
	invocation_area = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/targeted/evilwhisper
	name = "Evil whisper"
	panel = "Powers"
	desc = "Whisper your message either to one or all living beings, or your cultists"
	charge_max = 50
	clothes_req = 0
	range = -1
	include_user = 1



//////////////////////// КАСТ ////////////////////////


//// Soul Absorb


/obj/effect/proc_holder/spell/targeted/soul_absorb/cast(list/targets)
	for(var/mob/living/carbon/Q in targets)
		spawn(0)
			if(!Q)		return
			if(!Q.ckey && !Q.get_ghost())		//Ворваться в генетику, пережрать макак и победить? Неm.
				demon << "\red THERE IS NO SOUL IN THIS CREATURE! OR IT IS JUST TOO WEAK TO SATISFY MY MASTER!"
				return
			if(!messagevictimcheck(Q))		return
			if(!Q.stat)
				demon << "\red This creature is still alive...I need time to rip it's soul off!"
				Q << "\red \bold You feel your soul being ripped away from your body!"
				demon.visible_message("<span class='danger'>[demon] starts siphoning essence out of [Q]!</span>")
				Q.Beam(demon,icon_state="drain_life",icon='icons/effects/effects.dmi',time=50,maxdistance=2)
				if(get_dist(demon,Q)>1)
					demon << "\red The spiritual bond were broken!"
					Q << "\blue You feel like your spirit has been broken free from terrible grip..."
					return

			demon << "\blue I absorbed spirit of this creature, empowering my Master with it's energy"
			demon.visible_message("<span class='danger'>[demon] saps the last of essence out of [Q]'s body, turning it into a pile of bones!</span>")
			Q.dust()
			if(demon.summoned_during_cult)		for(var/datum/game_mode/cult/satan)		satan.reality_integrity-=30
			demon.adjustBruteLoss(-50)		//Отнять время от отсчёта, похилить аватара и сделать его менее голодным.
			demon.hunger=200


//// Summon Daemons


/obj/effect/proc_holder/spell/aoe_turf/summon_daemons/cast(list/targets)		//Conjure - дерьмо.
	var/list/faithlesses= list()
	var/time=300		//Время сколько они существуют
	if(demon.enraged)		time=150

	for(var/turf/target_tile in targets)
		if(!target_tile)		return
		for(var/mob/living/M in target_tile.contents)		//Пихнуть назад тех, кто рядом
			if(M!=demon)
				M << "\red You was pushed away by appearing figures!"
				step_away(M,demon)
				M.Weaken(2)
		if(!istype(target_tile,/turf/space) && !(is_blocked_turf(target_tile)))		//Если в ярости, то восемь демонов появятся вокруг. Если нет, то четыре, слева,справа, спереди и сзади.
			if((!demon.enraged && (target_tile.x==demon.x || target_tile.y==demon.y)) || (demon.enraged))
				faithlesses += new /mob/living/simple_animal/hostile/faithless(target_tile)

	demon.visible_message("\red \italic \bold Several dark figures appears out of nowhere!")
	for(var/mob/living/simple_animal/hostile/faithless/F in faithlesses)
		if(!F)		return
		F.dir=demon.dir
		F.faction |= "cult"
		F.speed=-2
		spawn(time)
			qdel(F)
			faithlesses.Cut()


//// Suffering of Geometer


/obj/effect/proc_holder/spell/targeted/suffer/cast(list/targets)
	for(var/mob/living/T in targets)
		if(!T)
			revert_cast(usr)
			return

		demon.say("COGNOSCE DOLOR")		//Если ебанёт не того - всё равно на кулдаун
		if(messagevictimcheck(T))
			T << "\red <FONT size=5>AAAAAAAAGGHHH!!!!</FONT>"
			T.AdjustParalysis(10)
			T.emote("scream")
			T.eye_blurry+=30
			T.adjustBrainLoss(5)
			T.drowsyness += 30
			T.dizziness += 15


//// Dark Harpoon


/obj/effect/proc_holder/spell/targeted/inflict_handler/harpoon
	amt_weakened = 4
	amt_dam_brute = 25		//Попадание гарпуном валит с ног и наносит 25 брута

/obj/effect/proc_holder/spell/targeted/inflict_handler/harpoon/cast(list/targets)
	..()
	spawn(0)
		for(var/mob/living/jertva in targets)
			if(!jertva)		return
			var/i=0
			if(jertva.buckled)		jertva.buckled.unbuckle_mob()
			while(get_dist(demon,jertva)>1 && i<=10)
				++i
				jertva.loc=get_step_towards(jertva,demon)		//Чтобы через столы пролетала. Если между ними окажется стена, то это тип тёмная сила, мистика, короч не баг а фича
				sleep(2)


//// Annihilation


/obj/effect/proc_holder/spell/aoe_turf/destruction/cast(list/targets)
	var/z=demon.health
	demon.visible_message("\red \bold [demon] starts glowing with the crimson light!")
	demon.canmove=0
	demon.stunned += 4		//Обездвижить
	spawn(0)
		for(var/i=1+2*demon.enraged,i<=10,++i)
			if(demon.health<(z-40))
				demon.visible_message("\red \bold [demon] staggers, crimson aura around it dissipates")
				demon << "\red \bold <FONT size=3>UAGGHH!!!</FONT>"
				demon.adjustBruteLoss(30)
				return
			sleep(5)

		demon.visible_message("\red \bold [demon] releases a huge wave of destructive energy!")
		for(var/turf/T in targets)
			if(!T)		return
			if(istype(T,/turf/simulated/wall))
				var/turf/simulated/wall/llaw=T
				if(prob(70-10*get_dist(demon,llaw)))
					if(prob(50))		llaw.break_wall()
					else		llaw.dismantle_wall(1,1)

			for(var/mob/living/K in T.contents)
				if(!K)		return
				if(!victimcheck(K))		continue
				if(istype(K,/mob/living/silicon))		//Борготу туда же
					if(get_dist(demon,K) <= 3)		K.emp_act(1)
					else		K.emp_act(2)
					K.adjustBruteLoss(80-10*get_dist(demon,K))

				else if(istype(K,/mob/living/carbon)||istype(K,/mob/living/simple_animal))
					K << "\red \bold You feel your body disfiguring under tremendous amount of corruptive energy!"
					K.adjustFireLoss(80-10*get_dist(demon,K))
					K.adjustCloneLoss(80-10*get_dist(demon,K))

				if(demon.enraged && prob(100-10*get_dist(demon,K)))
					K << "\red \bold You was burned into nothingness!"
					K.dust()

			for(var/obj/mecha/meh in T.contents)
				var/distance=get_dist(demon,meh)
				if(distance<=2)
					meh.ex_act(1)
					meh.emp_act(1)
				else
					meh.ex_act(2)
					meh.emp_act(2)

			for(var/obj/structure/window/W in T.contents)		if(prob(33))		W.spawnfragments()		//Риск лагалища, поэтому тут шанс всегда 1/3


//// Doom


/mob/living/proc/Doom(var/countdown = 60)		//Через отдельный прок
	if(demon)		demon.victim=src
	if(!src.ckey || src.stat==2)
		demon.victim=null
		return
	color = "#880000"

	spawn(1)
		src << "\italic \bold Terrible feeling covers whole your body, as you can sense your soul burning from it's very inside..."
		while(countdown>0)
			if(!demon || src != demon.victim || !src)
				color=null
				return

			--countdown
			switch(countdown)		//Библейский стишок. Возможно не самое эпичное или подходящее, но по мне норм.
				if(34)		src << "<font color=\"purple\"><i>Disaster after disaster</i></font>"
				if(32)		src << "<font color=\"purple\"><i>   is coming your way!</i></font>"
				if(30)		src << "<font color=\"purple\"><i>The end has come</i></font>"
				if(28)		src << "<font color=\"purple\"><i>   It has finally arrived.</i></font>"
				if(26)		src << "<font color=\"purple\"><i>   Your final doom is waiting!</i></font>"
				if(24)		src << "<font color=\"purple\"><i>The day of your destruction is dawning.</i></font>"
				if(22)		src << "<font color=\"purple\"><i>   The time has come; the moment of trouble is near.</i></font>"
				if(20)		src << "<font color=\"purple\"><i>Shouts of anguish will be heard</i></font>"
				if(18)		src << "<font color=\"purple\"><i>   not shouts of joy.</i></font>"
				if(16)		src << "<font color=\"purple\"><i>Soon I will pour out my fury on you</i></font>"
				if(14)		src << "<font color=\"purple\"><i>   and unleash my anger against you.</i></font>"
				if(12)		src << "<font color=\"purple\"><i>I will call you to account</i></font>"
				if(10)		src << "<font color=\"purple\"><i>   for all your detestable sins.</i></font>"
				if(8)		src << "<font color=\"purple\"><i>I will turn my eyes away and show no pity.</i></font>"
				if(6)		src << "<font color=\"purple\"><i>   I will repay you for all your detestable sins.</i></font>"
				if(4)		src << "<font color=\"purple\"><i>Then you will know that it is I...</i></font>"
				if(1)		src << "<font color=\"purple\"><i><b>  The Lord, who is striking the blow</b></i></font>"
				if(-INFINITY to 0)
					for(var/mob/living/K in oview(5, src))		//Прыжок на случайную цель рядом
						if(!victimcheck(K) || istype(K,/mob/living/silicon) || !K.ckey)		continue
						var/list/jertvi=list()
						jertvi+=K
						if(jertvi.len)
							var/mob/living/N=pick(jertvi)
							N.Doom()
					visible_message("\red \bold [src] let's out a terrible scream of pain! It's eyes starts bleeding, and seconds after [src]'s body becomes engulfed with crimson aura and desintegrates...")
					dust()
					if(demon.summoned_during_cult)
						for(var/datum/game_mode/cult/satan)
							satan.reality_integrity-=30
			sleep(10)


/obj/effect/proc_holder/spell/targeted/condemn/cast(list/targets)
	for(var/mob/living/target in targets)
		if(target.ckey && target.stat !=2 && target)
			demon.say("INFELIX TUA ANIMA!")
			if(messagevictimcheck(target))		target.Doom()
			return
		else		demon << "\red There is no soul in this creature to curse!"
	revert_cast(usr)


//// Transfering of Damnation


/obj/effect/proc_holder/spell/targeted/area_teleport/dark_transfering/cast(list/targets,area/thearea)
	spawn(0)
		demon.canmove=0
		demon.stunned += 4
		demon.visible_message("\red Avatar raises it's claws and starts sinking into ground!")
		var/z=demon.health
		for(var/i=1,i<=8,++i)
			if(demon.health<(z-10))
				demon.visible_message("\red \bold [demon] staggers back, dark portal under it dissapears")
				demon << "\red \bold <FONT size=3>UGHH!</FONT>"
				demon.canmove=1
				return
			sleep(5)
		demon.canmove=1
		..()

		spawn(1)		demon.visible_message("\red \bold [demon] jumps out of the ground!")


//// Pandemonium


/obj/effect/proc_holder/spell/aoe_turf/inferno/cast(list/targets)
	var/obj/structure/cult/pylon/stone = new /obj/structure/cult/pylon(demon.loc)
	spawn(200)		stone.isbroken=1

	var/list/walls=list()
	for(var/turf/simulated/T in range(demon,7))
		if(!T)		return
		if(get_dist(T,stone)==7)
			var/obj/effect/forcefield/flames = new /obj/effect/forcefield(T)		//Никто ничего не заподозрит...
			flames.name= "hotspot"
			flames.icon= 'icons/effects/fire.dmi'
			flames.icon_state="3"
			flames.opacity=1
			flames.luminosity = 5
			walls+=flames
		else		T.color="#383838"		//Всё что внутри станет чёрным

		for(var/mob/living/M in T.contents)
			if(get_dist(T,stone)==7)
				M << "\red You was pushed inside!"
				step_towards(M,stone)
				M.Weaken(2)
			M << sound('sound/effects/pandemonium.ogg',0,0,0)
			M << sound('sound/effects/drownindarkness.ogg',0,0,0)
	spawn(1)
		while(!stone.isbroken && stone)
			for(var/i=15-demon.enraged*15,i>=0,--i)
				var/turf/simulated/burningturf = pick(targets)
				var/turftype=burningturf.type
				if(!(turftype in typesof(/turf/simulated/floor)))		continue
				var/atom/movable/overlay/animation = new /atom/movable/overlay(burningturf)
				animation.icon_state = "cultfloor"
				animation.density = 0
				animation.anchored = 1
				animation.icon = 'icons/effects/effects.dmi'
				animation.layer = 3
				animation.master = burningturf
				flick("cultfloor",animation)
				spawn(10)
					animation.master = null
					qdel(animation)
					burningturf.color = "#FF0000"
					for(var/mob/living/M in burningturf.contents)
						if(M)
							if(!victimcheck(M))		continue
							M.Weaken(3)
							M.adjustCloneLoss(30)
							M << "\red You was stricken by the dark energy!"
					for(var/obj/mecha/mech in burningturf.contents)
						if(mech)
							mech.ex_act(3)
							mech.emp_act(3)
							if(mech.occupant)
								mech.occupant.adjustCloneLoss(30)
								if(prob(25))		mech.go_out()
					spawn(5)		burningturf.color="#383838"
			sleep(11-demon.enraged*10)

		qdel(stone)

		for(var/obj/effect/forcefield/faya in walls)
			var/turf/simulated/burnedturf=get_turf(faya)
			burnedturf.burn_tile()
			qdel(faya)
			walls.Cut()

		spawn(20)		for(var/turf/truf in targets)		truf.color=null


//// Evil Whisper


/obj/effect/proc_holder/spell/targeted/evilwhisper/cast(list/targets)
	for(var/mob/living/user in targets)
		var/text = sanitize_russian(stripped_input(user, "What do you want to say?.", "Dark Voice", ""))
		var/choice = alert(demon, "To whom you want to send your thoughts?",,"One creature","All creatures","Servants")
		switch(choice)
			if("One creature")
				var/mob/living/receiver = input(demon,"What do you want to say?") in player_list
				if(!text)		return
				if(istype(receiver,/mob/living/silicon))
					usr << "\red Impossible...I cannot send my thoughts to that mind!"
					return
				receiver << "\bold <font color=\"purple\">You hear dark, sinister voice, whispering directly into your head... [text]</font>"
				usr << "\blue You project [text] into [receiver] mind"
			if("All creatures")
				if(!text)		return
				for(var/mob/U in player_list)
					if(istype(U,/mob/living/silicon) || U==usr || !U.ckey)		continue
					U << "\bold \italic <font color=\"purple\">You hear dark, sinister voice, whispering directly into your head... [text]</font>"
				usr << "\blue You project [text] into the mind of all living creatures"
			if("Servants")
				if(!text)		return
				for(var/mob/M in player_list)
					if(iscultist(M) || (M in dead_mob_list) || istype(M,/mob/living/simple_animal/construct) || M==demon)		M << "\bold \italic <font color=\"purple\">MASTER: [text]</font>"



//////////////////////// ЭКС И БУЛЛЕТ АКТ ////////////////////////



/mob/living/simple_animal/avatar/ex_act(severity)		//Ну ебануть одной лимиткой, ну весь фан же нахуй, ну.
	if(1)		adjustBruteLoss(200)
	else if(2)		adjustBruteLoss(100)
	else if(3)		visible_message("\red [src] shrugged off the explosion!")

/mob/living/simple_animal/avatar/bullet_act(var/obj/item/projectile/P)
	if(prob(70 - P.damage))
		adjustBruteLoss(P.damage * 0.5)
		visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")

		// Find a turf near or on the original location to bounce to
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			P.original = locate(new_x, new_y, P.z)
			P.starting = curloc
			P.current = curloc
			P.firer = src
			P.yo = new_y - curloc.y
			P.xo = new_x - curloc.x

		return -1 // complete projectile permutation
	return (..(P))



//////////////////////// УДАР С РУКИ ////////////////////////



/mob/living/simple_animal/avatar/UnarmedAttack(atom/A)
	if(attack_cooldown>0)		return
	if(A)
		attack_cooldown=2-src.enraged
		if(istype(A, /obj/structure/window))
			src.do_attack_animation(A)
			src.visible_message("\red [src] smashes the window!")
			var/obj/structure/window/windows10=A
			windows10.spawnfragments()
		else if(istype(A, /obj/machinery/door))
			var/obj/machinery/door/dura=A
			if(dura.density && dura.hasPower() && !dura.emagged)
				src.visible_message("\red [src] pries open [A]!")
				dura.emag_act()
			else
				src.do_attack_animation(A)
				src.visible_message("\red [src] smashes [A] apart!")
				dura.Destroy()
		else
			..()