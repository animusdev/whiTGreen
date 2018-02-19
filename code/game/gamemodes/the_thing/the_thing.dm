/datum/game_mode
	var/list/datum/mind/things = list()

/datum/game_mode/the_thing
	name = "the thing"
	config_tag = "the thing"
	antag_flag = BE_THING
	restricted_jobs = list("AI", "Cyborg")
	required_players = 5
	required_enemies = 1
	recommended_enemies = 1

	var/list/possible_things = list()
	var/const/thing_amount = 1 //hard limit on things if scaling is turned off


/datum/game_mode/the_thing/announce()
	world << "<b>Текущий игровой режим - The Thing!</b>"
	world << "<b>Нечто проникло на станцию. Уничтожте его как можно скорее!</b>"

/datum/game_mode/the_thing/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_things = get_players_for_role(BE_THING)
	var/num_things = 1

//	if(config.thing_scaling_coeff)
//		num_things = max(1, min( round(num_players()/(config.thing_scaling_coeff*2))+2, round(num_players()/config.thing_scaling_coeff) ))
//	else
//		num_things = max(1, min(num_players(), thing_amount))

	for(var/datum/mind/player in possible_things)
		for(var/job in restricted_jobs)//Removing robots from the list
			if(player.assigned_role == job)
				possible_things -= player

	if(antag_candidates.len>0)
		for(var/i = 0, i < num_things, i++)
			if(!antag_candidates.len) break
			var/datum/mind/thing = pick(antag_candidates)
			antag_candidates -= thing
			things += thing
			thing.restricted_roles = restricted_jobs
			modePlayer += things
		return 1
	else
		return 0

/datum/game_mode/the_thing/post_setup()
	for(var/datum/mind/thing in things)
		log_game("[thing.key] (ckey) был выбран в качестве нечто")
		thing.current.make_the_thing()
		thing.special_role = "The Thing"
		forge_thing_objectives(thing)
		greet_thing(thing)
	..()
	return

/////////////////

/datum/game_mode/the_thing/make_antag_chance(var/mob/living/carbon/human/character) //Assigns things to latejoiners
	var/thingcap = min( round(joined_player_list.len/(config.thing_scaling_coeff*2))+2, round(joined_player_list.len/config.thing_scaling_coeff) )
	if(ticker.mode.things.len >= thingcap) //Caps number of latejoin antagonists
		return
	if(ticker.mode.things.len <= (thingcap - 2) || prob(100 - (config.thing_scaling_coeff*2)))
		if(character.client.prefs.be_special & BE_THING)
			if(!jobban_isbanned(character.client, "the thing") && !jobban_isbanned(character.client, "Syndicate"))
				if(!(character.job in restricted_jobs))
					character.mind.make_Thing()

/datum/game_mode/proc/forge_thing_objectives(var/datum/mind/thing)
	var/datum/objective/devour/devour = new
	devour.owner = thing
	thing.objectives += devour


/datum/game_mode/proc/greet_thing(var/datum/mind/thing, var/you_are=1)
	if (you_are)
		thing.current << "<span class='boldannounce'>¤ Вы - Нечто! Поглотив одного из членов экипажа и прин&#255;в его форму вы проникли на станцию.</span>"
	thing.current << "¤ Вы должны уничтожить весь экипаж станции!</b>"

	if (thing.current.mind)
		var/mob/living/carbon/human/H = thing.current
		if(H.mind.assigned_role == "Clown")
			H << "¤ Вы смогли обуздать свою клоунскую натуру и теперь можете использовать оружие без вреда дл&#255; себ&#255;."
			H.dna.remove_mutation(CLOWNMUT)

	return

/datum/game_mode/the_thing/check_finished()
	var/thing_alive = 0
	for(var/datum/mind/thing in things)
		if(thing.current.stat==2 || !thing.current)
			continue

		thing_alive++
	if(thing_alive)
		return 0

	return ..()


/datum/game_mode/proc/auto_declare_completion_thing()
	if(things.len)
		var/text = "<br><font size=3><b>Нечтом были:</b></font>"
		for(var/datum/mind/thing in things)
			var/thingwin = 1
			if(!thing.current)
				thingwin = 0

			text += printplayer(thing)
			text += "<br><b>Людей поглощено:</b> [thing.the_thing.absorbedcount]"

			if(thingwin)
				text += "<br><font color='green'><b>Нечто успешно пожрал экипаж!</b></font>"
			else
				text += "<br><font color='red'><b>Нечто уничтожен.</b></font>"
			text += "<br>"
		world << text
	return 1

/datum/the_thing
	var/list/absorbed_dna = list()
	var/list/protected_dna = list()
	var/dna_max = 4
	var/absorbedcount = 1
	var/devouring = 0
	var/purchasedpowers = list()
	var/datum/dna/chosen_dna
	var/horror_form = 0
	var/obj/effect/proc_holder/the_thing/devour/devour = new()
	var/obj/effect/proc_holder/the_thing/separation/separation = new()
	var/list/mob/living/thing_list = list()

/datum/the_thing/New()
	..()
	absorbed_dna.len = dna_max

/datum/the_thing/proc/get_dna(var/dna_owner)
	for(var/datum/dna/DNA in (absorbed_dna+protected_dna))
		if(dna_owner == DNA.real_name)
			return DNA

/datum/the_thing/proc/has_dna(var/datum/dna/tDNA)
	for(var/datum/dna/D in (absorbed_dna+protected_dna))
		if(tDNA.is_same_as(D))
			return 1
	return 0


/datum/the_thing/proc/can_devour_dna(var/mob/living/carbon/user, var/mob/living/carbon/target)
	if(!ishuman(target))
		return
	if(!istype(user, /mob/living/carbon))
		return
	if(absorbed_dna[1] == user.dna)//If our current DNA is the stalest, we gotta ditch it.
		user << "<span class='warning'>¤ Вы достигли лимита вашего хранилища генетической информации. Вы должны трансформироватьс&#255;, чтобы поглотить больше геномов.</span>"
		return
	if(!target)
		return
	if((target.disabilities & NOCLONE) || (target.disabilities & HUSK))
		return
	if(has_dna(target.dna))
		user << "<span class='warning'>У вас уже есть эта ДНК в хранилище.</span>"
		return
	if(!check_dna_integrity(target))
		return
	return 1