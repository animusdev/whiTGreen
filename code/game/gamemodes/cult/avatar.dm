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
	verb_say = "snarls"
	verb_ask = "growls"
	verb_exclaim = "roars"
	verb_yell = "roars"
	wander = 0
	see_in_dark = 8
	environment_smash = 3
	mob_size = MOB_SIZE_LARGE		//Чтобы в шкафчике не заварили
	a_intent = "harm"
	response_help = "touches"
	response_disarm = "tries to push"
	response_harm = "hits"
	maxHealth = 500
	health = 500
	status_flags = 0		//Нельзя толкнуть
	harm_intent_damage = 5
	force_threshold = 10
	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "smashes"
	attack_sound = 'sound/effects/heavyhit.ogg'
	minbodytemp = 0
	maxbodytemp = INFINITY		//Пофиг на атмос. Возможно стоит убрать, ибо почему бы не дать возможность его зажарить/космировать?
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("faithless","cult")		//Чтобы его ногами не запинали его же собственные демоны
	var/enraged=0		//В ярости?
	var/victim=null		//Жертва под воздействием Doom. Нужна для того чтобы проклятье можно было скинуть ударив библией, а так же определить есть ли она вообще в мире
	var/hunger=200		//Need...moar...souls
	var/summoned_during_cult=0		//Его призвали во время культа?



//////////////////////// ГЛАВНЫЕ ПРОКИ ////////////////////////



	New()
		..()
		if (avatarcreated || demon)		//Есть только один Аватар.
			message_admins("There can be only one Avatar in the world")
			qdel(src)
		avatarcreated = 1		//Переменную нельзя установить на 0 без педальвмешательства. Если аватар соснул, то нового не сделать.
		demon=src
		if(ticker.mode.name == "cult")
			summoned_during_cult=1
			for(var/datum/game_mode/cult/satan)
				satan.summoning_in_progress = 1		//Если Аватар был призван во время культа - начать обратный отсчёт
		world << "\bold <font color=\"purple\"><FONT size=3>The ground shakes and rumbles, as you can feel great evil power being summoned in this plane, with all your body...and soul</FONT></font>"
		world << 'sound/effects/avatarsummon.ogg'

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

		spawn(1)		//Нагло украдено у ревенанта
			if(!src.giveSpells())
				message_admins("Avatar was created but has no mind. Trying again in ten seconds.")
				spawn(100)
					if(!src.giveSpells())
						message_admins("Avatar still has no mind. Deleting...")
						qdel(src)

		spawn(50)
			for(var/mob/living/I in world)
				if(I!=demon)		//Сообщения с инструкциями чё надо делать.
					if(!iscultist(I) && !("cult" in I.faction))		I << "\red \bold Stop the Avatar and it's servants, to prevent Nar-Sie herself break into this world. Remember: each fallen living being only helps Nar-Sie to break the interdimensional barrier and invade this world"
					else if(iscultist(I))		I << "\red \bold There comes the Chosen One...obey all orders of the Avatar and assist it in summoning your Master..."
					else if(istype(I, /mob/living/simple_animal/construct))		I << "\red \bold Your only lord and commander is Avatar now...obey all it's orders and help it succeed in summoning your true Master and creator on this plane..."
				else		I << "\bold Rejoice, you are now playing as the Avatar of the Nar-Sie...your goal is to survive until your She finally breaks through interdimensional barrier and unleashes Her wrath on this plane. Absorb souls of the mere mortals to damage the barrier and heal yourself, make them suffer for their detestable sins, annihilate any attempt to resist you, chase the fleeing with your faithlesses, grapple them with your harpoon and condemn their souls to the Final Judgement, and unleash the Pandemonium upon this place. For now, it's time for this world to finally end..."


	Stat()		//Cтат-панелька с временем и голодом
		..()
		stat(null, "Hunger: [src.hunger]/200")
		if(ticker.mode.name == "cult")
			var/datum/game_mode/cult/cult = ticker.mode
			if(cult.summoning_in_progress == 1)		stat(null, "Time: [cult.reality_integrity]/800")


	death()
		..()
		visible_message("<span class='danger'>[src] let's out a terrible shriek, terrible amount of dark essense flies out of it, as it vanishes from our world... </span>")
		if(summoned_during_cult)
			for(var/datum/game_mode/cult/satan)
				if(satan.summoning_in_progress ==1 && satan)
					for(var/mob/living/M in world)
						if(iscultist(M))		ticker.mode.remove_cultist(M.mind)		//Культистов нет
						if(istype(M,/mob/living/simple_animal/construct) || istype(M,/mob/living/simple_animal/hostile/faithless))		//Конструктов нет
							M << "\blue \italic Your master was banished from this world, his grip on you...no more. You are free..."
							M.death(1)
					for(var/obj/effect/rune/ru in world)		//Рун нет
						qdel(ru)
					for(var/turf/corrupted in world)		//Культоговна нет
						if(istype(corrupted,/turf/simulated/floor/engine/cult))		corrupted.ChangeTurf(/turf/simulated/floor/plating)
						else if(istype(corrupted,/turf/simulated/wall/cult))		corrupted.ChangeTurf(/turf/simulated/wall/r_wall)
					world << "\blue \bold<FONT size=4>You hear tormented scream of pain...then suddenly everything calms down...like terrible disease was ripped off this world</FONT>"
				satan.summoning_in_progress = 0		//Отсчёта нет
		ghostize()
		qdel(src)		//Аватара нет

	Life()
		..()
		for(var/mob/living/M in view(src.loc,3))		//Его аура
			if(victimcheck(M))
				if(!istype(M,/mob/living/silicon))
					if(enraged==0)
						if(get_dist(M,src)<=1)
							M.adjustCloneLoss(10)
						else
							M.adjustCloneLoss(5)
					else
						if(get_dist(M,src)<=1)
							M.adjustCloneLoss(10)
							M.adjustFireLoss(10)
						else
							M.adjustCloneLoss(5)
							M.adjustFireLoss(5)
				else
					if(enraged==0)		//Боргота тоже отхватывает
						if(get_dist(M,src)<=1)
							if(prob(50))
								M.emp_act(1)
						else
							if(prob(25))
								M.emp_act(2)
					else
						if(get_dist(M,src)<=1)
							if(prob(75))
								M.emp_act(1)
						else
							if(prob(25))
								M.emp_act(2)


		if(health <=250 && enraged==0)		//Ярость
			visible_message("<span class='danger'><FONT size=2>[src] eyes starts glowing with the piercing red light...</span></FONT>")
			icon_state = "enrage"
			force_threshold = 0
			enraged=1
			speed=0

		if(hunger>1)		--hunger
		else if(hunger==1)		//Дай пожрать
			src << "\red Uuugh...I am losing power...I need...souls"
			--hunger
		else
			if(health >10)		demon.adjustBruteLoss(2)



//////////////////////// АБИЛКИ ////////////////////////



/mob/living/simple_animal/avatar/proc/giveSpells()		//Прок, который выдаёт ему абилки. Нагло украдено у Ревенанта.
	if(src.mind)
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/soul_absorb
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/evilwhisper
		src.mind.spell_list += new /obj/effect/proc_holder/spell/dumbfire/harpoon
		src.mind.spell_list += new /obj/effect/proc_holder/spell/targeted/destruction
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
	charge_max = 100
	clothes_req = 0
	range = 1

/obj/effect/proc_holder/spell/aoe_turf/summon_daemons
	name = "Summon Daemons"
	panel = "Powers"
	charge_max = 600
	clothes_req = 0
	range = 1

/obj/effect/proc_holder/spell/targeted/suffer
	name = "Suffering of Geometer"
	panel = "Powers"
	invocation_type = "shout"
	invocation = "COGNOSCE DOLOR"
	max_targets = 1
	charge_max = 100
	clothes_req = 0
	range = 5

/obj/effect/proc_holder/spell/aoe_turf/inferno
	name = "Pandemonium"
	panel = "Powers"
	invocation_type = "shout"
	invocation = "CHORO MORTIS"
	charge_max = 1200
	clothes_req = 0
	range = 6

/obj/effect/proc_holder/spell/targeted/condemn
	name = "Doom"
	panel = "Powers"
	invocation_type = "shout"
	invocation = "INFELIX TUA ANIMA!"
	charge_max = 600
	clothes_req = 0
	range = 7

/obj/effect/proc_holder/spell/targeted/destruction
	name = "Annihilation"
	panel = "Powers"
	max_targets = 0
	charge_max = 600
	clothes_req = 0
	range = 5

/obj/effect/proc_holder/spell/dumbfire/harpoon
	name = "Dark harpoon"
	panel = "Powers"
	charge_max = 100
	clothes_req = 0
	invocation_type = "emote"
	invocation = "\red \bold Avatar shoots a dark harpoon from it's hand!"
	message = "\red \bold Harpoon pierces your body!"
	proj_lifespan = 100
	proj_step_delay = 1
	proj_trigger_range = 1
	proj_icon = 'icons/mob/demon.dmi'
	proj_icon_state = "magspear"
	proj_name = "a harpoon"
	proj_type = "/obj/effect/proc_holder/spell/targeted/inflict_handler/harpoon"


/obj/effect/proc_holder/spell/targeted/area_teleport/dark_transfering
	name = "Transfering of Damnation"
	panel = "Powers"
	charge_max = 400
	clothes_req = 0
	invocation_area = 0
	range = -1
	include_user = 1

/obj/effect/proc_holder/spell/targeted/evilwhisper
	name = "Evil whisper"
	panel = "Powers"
	charge_max = 50
	clothes_req = 0
	range = -1
	include_user = 1



//////////////////////// КАСТ ////////////////////////


//// Soul Absorb


/obj/effect/proc_holder/spell/targeted/soul_absorb/cast(list/targets)
	for(var/mob/living/carbon/Q in targets)
		spawn(0)
			if(!Q.ckey && !Q.get_ghost())		//Ворваться в генетику, пережрать макак и победить? Неm.
				demon << "\red THERE IS NO SOUL IN THIS CREATURE! OR IT IS JUST TOO WEAK TO SATISFY MY MASTER!"
				return
			if(!messagevictimcheck(Q))		return
			if(!Q.stat)
				demon << "\red This creature is still alive...I need time to rip it's soul off!"
				Q << "\red \bold You feel your soul being ripped away from your body!"
				demon.visible_message("<span class='danger'>[demon] starts siphoning essence out of [Q]!</span>")
				var/alpha=demon.loc
				var/omega=Q.loc
				for(var/i,i<=5,++i)
					if(demon.loc!=alpha || Q.loc!=omega)
						demon << "\red Arrgh! It moved away from me!"
						Q << "\blue You feel like your spirit has been broken free from terrible grip..."
						return
					sleep(10)

			demon << "\blue I absorbed spirit of this creature, empowering my Master with it's energy"
			demon.visible_message("<span class='danger'>[demon] saps the last of essence out of [Q]'s body, turning it into a pile of bones!</span>")
			Q.dust()
			if(demon.summoned_during_cult)
				for(var/datum/game_mode/cult/satan)
					satan.reality_integrity-=50
			demon.adjustBruteLoss(-50)		//Отнять время от отсчёта, похилить аватара и сделать его менее голодным.
			demon.hunger=200


//// Summon Daemons


/obj/effect/proc_holder/spell/aoe_turf/summon_daemons/cast(list/targets)		//Conjure - дерьмо.
	var/list/faithlesses= list()
	var/time=300		//Время сколько они существуют
	if(demon.enraged)		time=150

	for(var/turf/target_tile in targets)
		for(var/mob/living/M in target_tile.contents)		//Пихнуть назад тех, кто рядом
			if(M!=demon)
				M << "\red You was pushed away by appearing figures!"
				step_away(M,demon)
				M.Weaken(2)
		if(!istype(target_tile,/turf/space) && !(is_blocked_turf(target_tile)))		//Если в ярости, то восемь демонов появятся вокруг. Если нет, то четыре, слева,справа, спереди и сзади.
			if((!demon.enraged && (target_tile.x==demon.x || target_tile.y==demon.y)) || (demon.enraged))
				faithlesses += new /mob/living/simple_animal/hostile/faithless(target_tile)

	demon.visible_message("<span class='danger'>[demon] raises it's hands and roars...</span>")
	demon.visible_message("\red \italic \bold Several dark figures appears out of nowhere!")

	for(var/mob/living/simple_animal/hostile/faithless/F in faithlesses)
		F.dir=demon.dir
		F.faction |= "cult"
		F.speed=-2
		spawn(time)
			qdel(F)
			faithlesses.Cut()


//// Suffering of Geometer


/obj/effect/proc_holder/spell/targeted/suffer/cast(list/targets)
	for(var/mob/living/carbon/human/T in targets)
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
	amt_weakened = 3
	amt_dam_brute = 25		//Попадание гарпуном валит с ног и наносит 25 брута

/obj/effect/proc_holder/spell/targeted/inflict_handler/harpoon/cast(list/targets)
	..()
	spawn(0)
		for(var/mob/living/jertva in targets)
			var/i=0
			if(jertva.buckled)		jertva.buckled.unbuckle_mob()
			while(get_dist(demon,jertva)>1 && i<=10)
				++i
				jertva.loc=get_step_towards(jertva,demon)		//Чтобы через столы пролетала. Если между ними окажется стена, то это тип тёмная сила, мистика, короч не баг а фича
				sleep(2)


//// Annihilation


/obj/effect/proc_holder/spell/targeted/destruction/cast(list/targets)
	var/z=demon.health
	demon.visible_message("\red \bold [demon] starts glowing with the crimson light!")
	demon.canmove=0
	demon.stunned += 4		//Обездвижить
	spawn(0)
		for(var/i=1+2*demon.enraged,i<=8,++i)
			if(demon.health<(z-60))
				demon.visible_message("\red \bold [demon] staggers, crimson aura around it dissipates")
				demon << "\red \bold <FONT size=3>UAGGHH!!!</FONT>"
				demon.health=max(demon.health-50,1)
				return
			sleep(5)

		demon.visible_message("\red \bold [demon] releases a huge wave of destructive energy!")
		for(var/mob/living/K in targets)
			if(!victimcheck(K))
				continue
			if(demon.enraged==0)
				if(istype(K,/mob/living/silicon))		//У борготы рядом останется 1 хп.
					K.emp_act(1)
					K.adjustBruteLoss(79)
				if(istype(K,/mob/living/carbon)||istype(K,/mob/living/simple_animal))
					K << "\red \bold You feel your body disfiguring under tremendous amount of corruptive energy!"
					K.adjustFireLoss(55)
					K.adjustCloneLoss(55)
			else
				K << "\red \bold You was burned into nothingness!"
				K.dust()

		for(var/obj/structure/window/W in view(7,demon.loc))
			if(prob(33))		W.spawnfragments()


//// Doom


/mob/living/proc/Doom(var/countdown = 60)		//Через отдельный прок
	if(demon)		demon.victim=src
	if(!src.ckey || src.stat==2)	return
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
						if(!victimcheck(K) || istype(K,/mob/living/silicon))		continue
						var/list/jertvi=list()
						jertvi+=K
						if(jertvi.len)
							var/mob/living/N=pick(jertvi)
							N.Doom()
					visible_message("\red \bold [src] let's out a terrible scream of pain! It's eyes starts bleeding, and seconds after [src]'s body becomes engulfed with crimson aura and desintegrates...")
					dust()
					if(demon.summoned_during_cult)
						for(var/datum/game_mode/cult/satan)
							satan.reality_integrity-=50
			sleep(10)


/obj/effect/proc_holder/spell/targeted/condemn/cast(list/targets)
	for(var/mob/living/target in targets)
		if(target.ckey && target.stat !=2)
			if(messagevictimcheck(target))
				target.Doom()
		else
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
		if(get_dist(T,stone)==7)
			var/obj/effect/forcefield/flames = new /obj/effect/forcefield(T)		//Никто ничего не заподозрит...
			flames.name= "Fire"
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
		while(stone.isbroken==0)
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
					spawn(5)		burningturf.color="#383838"
			sleep(11-demon.enraged*10)

		qdel(stone)

		for(var/obj/effect/forcefield/faya in walls)
			var/turf/simulated/burnedturf=get_turf(faya)
			burnedturf.burn_tile()
			qdel(faya)
			walls.Cut()

		spawn(20)
			for(var/turf/truf in targets)
				truf.color=null


//// Evil Whisper


/obj/effect/proc_holder/spell/targeted/evilwhisper/cast(list/targets)
	for(var/mob/living/user in targets)
		var/text = sanitize_russian(stripped_input(user, "What do you want to say?.", "Dark Voice", ""))
		var/choice = alert(demon, "To whom you want to send your thoughts?",,"One creature","All creatures","Servants")
		switch(choice)
			if("One creature")
				var/mob/living/receiver = input(demon,"What do you want to say?") in mob_list
				if(!text)		return
				if(istype(receiver,/mob/living/silicon))
					usr << "\red Impossible...I cannot send my thoughts to that mind!"
					return
				receiver << "\bold <font color=\"purple\">You hear dark, sinister voice, whispering directly into your head... [text]</font>"
				usr << "\blue You project [text] into [receiver] mind"
			if("All creatures")
				if(!text)		return
				for(var/mob/U in mob_list)
					if(istype(U,/mob/living/silicon) || U==usr)		continue
					U << "\bold \italic <font color=\"purple\">You hear dark, sinister voice, whispering directly into your head... [text]</font>"
				usr << "\blue You project [text] into the mind of all living creatures"
			if("Servants")
				if(!text)		return
				for(var/mob/M in mob_list)
					if(iscultist(M) || (M in dead_mob_list) || istype(M,/mob/living/simple_animal/construct) || M==demon)		M << "\bold \italic <font color=\"purple\">MASTER: [text]</font>"


//////////////////////// БУЛЛЕТ АКТ ////////////////////////



/mob/living/simple_animal/avatar/bullet_act(var/obj/item/projectile/P)
	if((!src.enraged) && !(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)))
		visible_message("<span class='danger'>[P.name] got stopped by [src] armor!</span>", \
						"<span class='userdanger'>[P.name] got stopped by [src] armor!</span>")
		qdel(P)
		return -1
	return (..(P))





















