//Configuraton defines //TODO: Move all yes/no switches into bitflags
/datum/configuration
	var/server_name = null				// server name (the name of the game window)
	var/server_group = null				// server group (for world name / status)
	var/server_group_url = null			// server group site (for status)
	var/station_name = null				// station name (the name of the station in-game)
	var/server_suffix = 0				// generate numeric suffix based on server port
	var/lobby_countdown = 120			// In between round countdown.

	var/sql_enabled = 0					// for sql switching
	var/allow_admin_ooccolor = 0		// Allows admins with relevant permissions to have their own ooc colour
	var/allow_vote_restart = 0 			// allow votes to restart
	var/allow_vote_mode = 0				// allow votes to change mode
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/fps = 10
	var/Tickcomp = 0
	var/allow_holidays = 0				//toggles whether holiday-specific content should be used

	var/hostedby = null
	var/respawn = 1
	var/kick_inactive = 0				//force disconnect for inactive players
	var/load_jobs_from_txt = 0
	var/automute_on = 0					//enables automuting/spam prevention
	var/minimal_access_threshold = 0	//If the number of players is larger than this threshold, minimal access will be turned on.
	var/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.
	var/sec_start_brig = 0				//makes sec start in brig or dept sec posts

	var/server
	var/banappeals
	var/wikiurl = "http://www.tgstation13.org/wiki" // Default wiki link.
	var/forumurl = "http://tgstation13.org/phpBB/index.php" //default forums
	var/rulesurl = "http://www.tgstation13.org/wiki/Rules" // default rules
	var/githuburl = "https://www.github.com/tgstation/-tg-station" //default github

	var/forbid_singulo_possession = 0

	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/see_own_notes = 0 //Can players see their own admin notes (read-only)? Config option in config.txt

	//Population cap vars
	var/soft_popcap				= 0
	var/hard_popcap				= 0
	var/extreme_popcap			= 0
	var/soft_popcap_message		= "Be warned that the server is currently serving a high number of users, consider using alternative game servers."
	var/hard_popcap_message		= "The server is currently serving a high number of users, You cannot currently join. You may wait for the number of living crew to decline, observe, or find alternative servers."
	var/extreme_popcap_message	= "The server is currently serving a high number of users, find alternative servers."

	//game_options.txt configs
	var/force_random_names = 0
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode

	var/allow_random_events = 0			// enables random events mid-round when set to 1
	var/panic_bunker = 0				// prevents new people it hasn't seen before from connecting
	var/notify_new_player_age = 0		// how long do we notify admins of a new player

	var/traitor_scaling_coeff = 6		//how much does the amount of players get divided by to determine traitors
	var/changeling_scaling_coeff = 6	//how much does the amount of players get divided by to determine changelings
	var/security_scaling_coeff = 8		//how much does the amount of players get divided by to determine open security officer positions
	var/abductor_scaling_coeff = 15 	//how many players per abductor team

	var/traitor_objectives_amount = 2
	var/meme_objectives_amount = 2
	var/protect_roles_from_antagonist = 0 //If security and such can be traitor/cult/other
	var/list/continuous = list()		// which roundtypes continue if all antagonists die
	var/list/midround_antag = list() 	// which roundtypes use the midround antagonist system
	var/midround_antag_time_check = 60  // How late (in minutes) you want the midround antag system to stay on, setting this to 0 will disable the system
	var/midround_antag_life_check = 0.7 // A ratio of how many people need to be alive in order for the round not to immediately end in midround antagonist
	var/shuttle_refuel_delay = 12000
	var/show_game_type_odds = 0			//if set this allows players to see the odds of each roundtype on the get revision screen

	var/no_summon_guns		//No
	var/no_summon_magic		//Fun
	var/no_summon_events	//Allowed

	var/alert_desc_green = "Все угрозы дл&#255; жизни персонала ликвидированы. Сотрудникам службы безопасности нельз&#255; открыто носить оружие, права на неприкосновенность частной жизни действуют в полную силу."
	var/alert_desc_blue_upto = "Получена информаци&#255; о возможной вражеской активности на станции. Сотрудники службы безопасности имеют право открыто носить оружие и проводить произвольные обыски."
	var/alert_desc_blue_downto = "Пр&#255;ма&#255; угроза станции устранена. Сотрудникам службы безопасности не позволено ходить с оружием в руках, но открытое ношение разрешено. Произвольные обыски по-прежнему разрешены."
	var/alert_desc_red_upto = "Возникла серьезна&#255; угроза жизни персонала. Сотрудникам службы безопасности разрешено ходить с оружием наизготовку. Произвольные обыски персонала разрешены и насто&#255;тельно рекомендуютс&#255;."
	var/alert_desc_red_downto = "Механизм самоуничтожени&#255; станции деактивирован, но все еще существует серьезна&#255; угроза жизни персонала. Сотрудникам службы безопасности разрешено ходить с оружием наизготовку. Произвольные обыски персонала разрешены и насто&#255;тельно рекомендуютс&#255;."
	var/alert_desc_delta = "Запущен механизм самоуничтожени&#255; станции. Персонал об&#255;зан подчин&#255;тьс&#255; всем инструкци&#255;м и распор&#255;жени&#255;м со стороны руководительского состава. Любое нарушение подобного приказа может каратьс&#255; смертью. Это не учени&#255;."

	var/health_threshold_crit = 0
	var/health_threshold_dead = -100

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/rename_cyborg = 0
	var/ooc_during_round = 0
	var/emojis = 0

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/run_speed = 0
	var/walk_speed = 0

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = 0
	var/robot_delay = 0
	var/monkey_delay = 0
	var/alien_delay = 0
	var/slime_delay = 0
	var/animal_delay = 0

	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/silent_ai = 0
	var/silent_borg = 0

	var/sandbox_autoclose = 0 // close the sandbox panel after spawning an item, potentially reducing griff

	var/default_laws = 0 //Controls what laws the AI spawns with.
	var/silicon_max_law_amount = 12

	var/assistant_cap = -1

	var/starlight = 0
	var/grey_assistants = 0

	var/aggressive_changelog = 0

	var/super_conduct_delay = 30

	var/continous_integration = 0
	var/maprotation_allowed = 0
	var/notify_restart = 0

	var/list/potentialRandomZlevels = list()

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for(var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if(M.config_tag)
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				diary << "Adding game mode [M.name] ([M.config_tag]) to configuration."
				modes += M.config_tag
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				if(M.votable)
					votable_modes += M.config_tag
		qdel(M)
	votable_modes += "secret"

/datum/configuration/proc/load(filename) //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue
		switch(name)
			if("admin_legacy_system")
				config.admin_legacy_system = 1
			if("ban_legacy_system")
				config.ban_legacy_system = 1
			if("lobby_countdown")
				config.lobby_countdown = text2num(value)
			if("allow_admin_ooccolor")
				config.allow_admin_ooccolor = 1
			if("allow_vote_restart")
				config.allow_vote_restart = 1
			if("allow_vote_mode")
				config.allow_vote_mode = 1
			if("no_dead_vote")
				config.vote_no_dead = 1
			if("default_no_vote")
				config.vote_no_default = 1
			if("vote_delay")
				config.vote_delay = text2num(value)
			if("vote_period")
				config.vote_period = text2num(value)
			if("norespawn")
				config.respawn = 0
			if("servername")
				config.server_name = value
			if ("servergroup")
				config.server_group = value
			if ("servergroupurl")
				config.server_group_url = value
			if("stationname")
				config.station_name = value
			if("serversuffix")
				config.server_suffix = 1
			if("hostedby")
				config.hostedby = value
			if("server")
				config.server = value
			if("banappeals")
				config.banappeals = value
			if("wikiurl")
				config.wikiurl = value
			if("forumurl")
				config.forumurl = value
			if("rulesurl")
				config.rulesurl = value
			if("githuburl")
				config.githuburl = value
			if("kick_inactive")
				if(value < 1)
					value = INACTIVITY_KICK
				config.kick_inactive = value
			if("load_jobs_from_txt")
				load_jobs_from_txt = 1
			if("forbid_singulo_possession")
				forbid_singulo_possession = 1
			if("popup_admin_pm")
				config.popup_admin_pm = 1
			if("allow_holidays")
				config.allow_holidays = 1
			if("ticklag")
				var/ticklag = text2num(value)
				if(ticklag > 0)
					fps = 10 / ticklag
			if("fps")
				fps = text2num(value)
			if("tickcomp")
				Tickcomp = 1
			if("automute_on")
				automute_on = 1
			if("comms_key")
				global.comms_key = value
				if(value != "default_pwd" && length(value) > 6) //It's the default value or less than 6 characters long, warn badmins
					global.comms_allowed = 1
			if("see_own_notes")
				config.see_own_notes = 1
			if("soft_popcap")
				config.soft_popcap = text2num(value)
			if("hard_popcap")
				config.hard_popcap = text2num(value)
			if("extreme_popcap")
				config.extreme_popcap = text2num(value)
			if("soft_popcap_message")
				config.soft_popcap_message = value
			if("hard_popcap_message")
				config.hard_popcap_message = value
			if("extreme_popcap_message")
				config.extreme_popcap_message = value
			if("panic_bunker")
				config.panic_bunker = 1
			if("notify_new_player_age")
				config.notify_new_player_age = text2num(value)
			if("aggressive_changelog")
				config.aggressive_changelog = 1
			if("health_threshold_crit")
				config.health_threshold_crit	= text2num(value)
			if("health_threshold_dead")
				config.health_threshold_dead	= text2num(value)
			if("revival_pod_plants")
				config.revival_pod_plants		= text2num(value)
			if("revival_cloning")
				config.revival_cloning			= text2num(value)
			if("revival_brain_life")
				config.revival_brain_life		= text2num(value)
			if("rename_cyborg")
				config.rename_cyborg			= 1
			if("ooc_during_round")
				config.ooc_during_round			= 1
			if("emojis")
				config.emojis					= 1
			if("run_delay")
				config.run_speed				= text2num(value)
			if("walk_delay")
				config.walk_speed				= text2num(value)
			if("human_delay")
				config.human_delay				= text2num(value)
			if("robot_delay")
				config.robot_delay				= text2num(value)
			if("monkey_delay")
				config.monkey_delay				= text2num(value)
			if("alien_delay")
				config.alien_delay				= text2num(value)
			if("slime_delay")
				config.slime_delay				= text2num(value)
			if("animal_delay")
				config.animal_delay				= text2num(value)
			if("alert_red_upto")
				config.alert_desc_red_upto		= "Возникла серьезна&#255; угроза жизни персонала. Сотрудникам службы безопасности разрешено ходить с оружием наизготовку. Произвольные обыски персонала разрешены и насто&#255;тельно рекомендуютс&#255;."
			if("alert_red_downto")
				config.alert_desc_red_downto	= "Механизм самоуничтожени&#255; станции деактивирован, но все еще существует серьезна&#255; угроза жизни персонала. Сотрудникам службы безопасности разрешено ходить с оружием наизготовку. Произвольные обыски персонала разрешены и насто&#255;тельно рекомендуютс&#255;."
			if("alert_blue_downto")
				config.alert_desc_blue_downto	= "Пр&#255;ма&#255; угроза станции устранена. Сотрудникам службы безопасности не позволено ходить с оружием в руках, но открытое ношение разрешено. Произвольные обыски по-прежнему разрешены."
			if("alert_blue_upto")
				config.alert_desc_blue_upto		= "Получена информаци&#255; о возможной вражеской активности на станции. Сотрудники службы безопасности имеют право открыто носить оружие и проводить произвольные обыски."
			if("alert_green")
				config.alert_desc_green			= "Все угрозы дл&#255; жизни персонала ликвидированы. Сотрудникам службы безопасности нельз&#255; открыто носить оружие, права на неприкосновенность частной жизни действуют в полную силу."
			if("alert_delta")
				config.alert_desc_delta			= "Запущен механизм самоуничтожени&#255; станции. Персонал об&#255;зан подчин&#255;тьс&#255; всем инструкци&#255;м и распор&#255;жени&#255;м со стороны руководительского состава. Любое нарушение подобного приказа может каратьс&#255; смертью. Это не учебна&#255; тревога."
			if("sec_start_brig")
				config.sec_start_brig			= 1
			if("gateway_delay")
				config.gateway_delay			= text2num(value)
			if("continuous")
				var/mode_name = lowertext(value)
				if(mode_name in config.modes)
					config.continuous[mode_name] = 1
				else
					diary << "Unknown continuous configuration definition: [mode_name]."
			if("midround_antag")
				var/mode_name = lowertext(value)
				if(mode_name in config.modes)
					config.midround_antag[mode_name] = 1
				else
					diary << "Unknown midround antagonist configuration definition: [mode_name]."
			if("midround_antag_time_check")
				config.midround_antag_time_check = text2num(value)
			if("midround_antag_life_check")
				config.midround_antag_life_check = text2num(value)
			if("shuttle_refuel_delay")
				config.shuttle_refuel_delay     = text2num(value)
			if("show_game_type_odds")
				config.show_game_type_odds		= 1
			if("ghost_interaction")
				config.ghost_interaction		= 1
			if("traitor_scaling_coeff")
				config.traitor_scaling_coeff	= text2num(value)
			if("changeling_scaling_coeff")
				config.changeling_scaling_coeff	= text2num(value)
			if("security_scaling_coeff")
				config.security_scaling_coeff	= text2num(value)
			if("abductor_scaling_coeff")
				config.abductor_scaling_coeff	= text2num(value)
			if("traitor_objectives_amount")
				config.traitor_objectives_amount = text2num(value)
			if("probability")
				var/prob_pos = findtext(value, " ")
				var/prob_name = null
				var/prob_value = null
				if(prob_pos)
					prob_name = lowertext(copytext(value, 1, prob_pos))
					prob_value = copytext(value, prob_pos + 1)
					if(prob_name in config.modes)
						config.probabilities[prob_name] = text2num(prob_value)
					else
						diary << "Unknown game mode probability configuration definition: [prob_name]."
				else
					diary << "Incorrect probability configuration definition: [prob_name]  [prob_value]."
			if("protect_roles_from_antagonist")
				config.protect_roles_from_antagonist	= 1
			if("allow_random_events")
				config.allow_random_events		= 1
			if("minimal_access_threshold")
				config.minimal_access_threshold	= text2num(value)
			if("jobs_have_minimal_access")
				config.jobs_have_minimal_access	= 1
			if("force_random_names")
				config.force_random_names		= 1
			if("silent_ai")
				config.silent_ai 				= 1
			if("silent_borg")
				config.silent_borg				= 1
			if("sandbox_autoclose")
				config.sandbox_autoclose		= 1
			if("default_laws")
				config.default_laws				= 1
			if("silicon_max_law_amount")
				config.silicon_max_law_amount	= text2num(value)
			if("assistant_cap")
				config.assistant_cap			= text2num(value)
			if("starlight")
				config.starlight			= 1
			if("grey_assistants")
				config.grey_assistants			= 1
			if("no_summon_guns")
				config.no_summon_guns			= 1
			if("no_summon_magic")
				config.no_summon_magic			= 1
			if("no_summon_events")
				config.no_summon_events			= 1
			if("super_conduct_delay")
				config.super_conduct_delay		= text2num(value)
			if("awaymap")
				config.potentialRandomZlevels.Add("_maps/RandomZLevels/[value].dmm")
			if("ci")
				config.continous_integration 	= value
			if("maprotation")
				config.maprotation_allowed		= 1
			if("notify_restart")
				config.notify_restart = 1


			else
				diary << "Unknown setting in configuration: '[name]'"

	fps = round(fps)
	if(fps <= 0)
		fps = initial(fps)

/datum/configuration/proc/loadsql(filename)
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue

		switch(name)
			if("sql_enabled")
				config.sql_enabled = 1
			if("address")
				sqladdress = value
			if("port")
				sqlport = value
			if("database")
				sqlfdbkdb = value
			if("login")
				sqlfdbklogin = value
			if("password")
				sqlfdbkpass = value
			else
				diary << "Unknown setting in configuration: '[name]'"

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for(var/T in (typesof(/datum/game_mode) - /datum/game_mode))
		var/datum/game_mode/M = new T()
		if(M.config_tag && M.config_tag == mode_name)
			return M
		qdel(M)
	return new /datum/game_mode/extended()

/datum/configuration/proc/get_runnable_modes()
	var/list/datum/game_mode/runnable_modes = new
	for(var/T in (typesof(/datum/game_mode) - /datum/game_mode))
		var/datum/game_mode/M = new T()
		//world << "DEBUG: [T], tag=[M.config_tag], prob=[probabilities[M.config_tag]]"
		if(!(M.config_tag in modes))
			qdel(M)
			continue
		if(probabilities[M.config_tag]<=0)
			qdel(M)
			continue
		if(M.can_start())
			runnable_modes[M] = probabilities[M.config_tag]
			//world << "DEBUG: runnable_mode\[[runnable_modes.len]\] = [M.config_tag]"
	return runnable_modes

datum/configuration/proc/get_runnable_midround_modes(crew)
	var/list/datum/game_mode/runnable_modes = new
	for(var/T in (typesof(/datum/game_mode) - /datum/game_mode - ticker.mode.type))
		var/datum/game_mode/M = new T()
		if(!(M.config_tag in modes))
			qdel(M)
			continue
		if(probabilities[M.config_tag]<=0)
			qdel(M)
			continue
		if(M.required_players <= crew)
			runnable_modes[M] = probabilities[M.config_tag]
	return runnable_modes
