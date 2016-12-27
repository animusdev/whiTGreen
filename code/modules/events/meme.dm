/datum/round_event_control/meme
	name = "Memetic Anomaly"
	typepath = /datum/round_event/meme
	weight = 15
	max_occurrences = 3
	minimal_players = 10

/datum/round_event/meme

	var/spawncount = 1
	var/successSpawn = 0    //So we don't make a command report if nothing gets spawned.
/*
/datum/round_event/meme/setup()
	spawncount = rand(1, 2)
*/

/datum/round_event/meme/kill()
	if(!successSpawn && control)
		control.occurrences--
	return ..()

/datum/round_event/meme/start()
	var/list/candidates = get_candidates(BE_MEME, MEME_AFK_BRACKET)
	var/list/host_candidates = list()
	var/list/living_crew = list() //actually it's living ACTIVE crew. We don't want our meme to be stuck in apatic bum somewhere in maintenance
	for(var/mob/Player in mob_list)
		if(Player.mind && Player.stat != DEAD && !isnewplayer(Player) &&!isbrain(Player)&&(Player in player_list))
			living_crew += Player
	for(var/mob/living/carbon/human/H in living_crew)
		if(H.client)
			host_candidates += H
	if(!candidates.len)
		message_admins("No candidates for [src] found")
		return
	if(!host_candidates.len)
		message_admins("No hosts for [src] found")
		return
	while(spawncount > 0 && candidates.len)
		var/mob/living/carbon/human/host = pick(host_candidates)
		var/client/C = pop(candidates)
		if(!C) return
		candidates -= C
		if(C.special_role_accept("meme"))
			var/datum/mind/meme
			var/is_hijacker = prob(10)
			var/objective_count = is_hijacker
			var/list/active_ais = active_ais()
			for(var/i = objective_count, i < config.meme_objectives_amount, i++)
				if(prob(50))
					if(active_ais.len && prob(100/joined_player_list.len))
						var/datum/objective/destroy/destroy_objective = new
						destroy_objective.owner = meme
						destroy_objective.find_target()
						meme.objectives += destroy_objective
					else if(prob(30))
						var/datum/objective/maroon/maroon_objective = new
						maroon_objective.owner = meme
						maroon_objective.find_target()
						meme.objectives += maroon_objective
					else
						var/datum/objective/assassinate/kill_objective = new
						kill_objective.owner = meme
						kill_objective.find_target()
						meme.objectives += kill_objective
				else
					var/datum/objective/steal/steal_objective = new
					steal_objective.owner = meme
					steal_objective.find_target()
					meme.objectives += steal_objective
			if(is_hijacker && objective_count <= config.meme_objectives_amount) //Don't assign hijack if it would exceed the number of objectives set in config.meme_objectives_amount
				if (!(locate(/datum/objective/meme_hijack) in meme.objectives))
					var/datum/objective/hijack/meme_hijack_objective = new
					meme_hijack_objective.owner = meme
					meme.objectives += meme_hijack_objective
					return
			if(!(locate(/datum/objective/escape) in meme.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = meme
				meme.objectives += escape_objective
				return
			var/datum/objective/attune/attune_objective = new
			attune_objective.owner = meme
			meme.objectives += attune_objective
			return
			var/mob/living/parasite/meme/new_meme = new(host)
			new_meme.key = C.key
			spawncount--
			successSpawn = 1