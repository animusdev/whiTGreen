/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 7

/world/New()
	map_ready = 1

#if (PRELOAD_RSC == 0)
	external_rsc_urls = file2list("config/external_rsc_urls.txt","\n")
	var/i=1
	while(i<=external_rsc_urls.len)
		if(external_rsc_urls[i])
			i++
		else
			external_rsc_urls.Cut(i,i+1)
#endif
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
//	if(revdata && istext(revdata.revision) && length(revdata.revision)>7)
//		log = file("data/logs/runtime/[copytext(revdata.revision,1,8)].log")
//	else
//		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM")].log")		//funtimelog
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diary << "\n\nStarting up. [time2text(world.timeofday, "hh:mm.ss")]\n---------------------"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)

	load_configuration()
	load_mode()
	load_motd()
	load_admins()
	LoadBansjob()
	jobban_loadbanfile()
	appearance_loadban()
	jobban_updatelegacybans()
	LoadBans()
	investigate_reset()
	load_mute()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	timezoneOffset = text2num(time2text(0,"hh")) * 36000

	if(config.sql_enabled)
		if(!setup_database_connection())
			world.log << "Your server failed to establish a connection with the database."
		else
			world.log << "Database connection established."


	data_core = new /datum/datacore()


	//var/list/webhookData = list("map_name" = map_name)


	spawn(0)
		master_controller.setup()

	process_teleport_locs()			//Sets up the wizard teleport locations
	process_ghost_teleport_locs()	//Sets up ghost teleport locations.
	SortAreas()						//Build the list of all existing areas and sort it alphabetically

	#ifdef MAP_NAME
	map_name = "[MAP_NAME]"
	#else
	map_name = "Unknown"
	#endif

	webhook_send_roundstatus("lobby")

	return


var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday


/world/Topic(T, addr, master, key)

	var/list/input = params2list(T)

	var/key_valid = (global.comms_allowed && input["key"] == global.comms_key)

	if ("ping" in input)
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if("players" in input)
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if ("status" in input)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config.respawn
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["host"] = host ? host : null
		s["active_players"] = get_active_player_count()
		s["players"] = clients.len

		var/adm = get_admin_counts()
		s["admins"] = adm //equivalent to the info gotten from adminwho
		s["gamestate"] = 1
		if(ticker)
			s["gamestate"] = ticker.current_state
		s["map_name"] = map_name ? map_name : "Unknown"
		if(key_valid && ticker && ticker.mode)
			s["real_mode"] = ticker.mode.name
		s["security_level"] = get_security_level()
		s["round_duration"] = round(world.time/10)

		if(SSshuttle && SSshuttle.emergency)
			s["shuttle_mode"] = SSshuttle.emergency.mode
			// Shuttle status, see /__DEFINES/stat.dm
			s["shuttle_timer"] = SSshuttle.emergency.timeLeft()
			// Shuttle timer, in seconds

		return list2params(s)

	else if("adminwho" in input)
		var/msg = "Current Admins:\n"
		for(var/client/C in admins)
			if(!C.holder.fakekey)
				msg += "\t[C] is a [C.holder.rank]"
				msg += "\n"
		return msg

	else if("who" in input)
		var/msg = "Current Players:\n"
		for(var/client/C)
			msg += "\t [C]\n"
		return msg

	else if ("asay" in input)
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				var/msg = "<span class='adminobserver'><span class='prefix'>DISCORD ADMIN:</span> <EM>[sanitize_russian(input["admin"])]</EM>: <span class='message'>[sanitize_russian(input["asay"])]</span></span>"
				admins << msg

	else if ("ooc" in input)
		//var/input[] = params2list(T)
		if(global.comms_allowed)
			if(input["key"] != global.comms_key)
				return "Bad Key"
			else
				for(var/client/C in clients)
					//if(C.prefs.chat_toggles & CHAT_OOC) // Discord OOC should bypass preferences.
					C << "<font color='[normal_ooc_colour]'><span class='ooc'><span class='prefix'>DISCORD OOC:</span> <EM>[sanitize_russian(input["admin"])]:</EM> <span class='message'>[sanitize_russian(input["ooc"])]</span></span></font>"

/*	else if("adminhelp" in input)
		var/msg = sanitize_russian(input["text"])
		var/author_admin = sanitize_russian(input["admin"])
		var/pos = findtext(msg, ":")
		if(input["key"] != global.comms_key)
			return "Bad Key"
		else
			if(pos)
				directory[ckey(copytext(msg,1,pos))] << "<span class='adminnotice'>PM from-<b>Discord Administrator [author_admin]</b>: [sanitize_russian(copytext(msg,pos,0))]</span>"
			else
				return "Can't find : symbol."*/

	else if("adminhelp" in input)
		if(input["key"] != global.comms_key)
			return "Bad Key"
		else
			var/msg = sanitize_russian(input["response"])	// Message from administrator. Already in win1251.
			var/DA = sanitize_russian(input["admin"])			// Admin's Discord Name. Already in win1251.
			var/send_to = input["ckey"]							// AHelp receiver.
			if(msg && DA && send_to)
				directory[ckey(send_to)] << "<span class='adminnotice'>PM from-<b>Discord Administrator [DA]</b>: [msg]</span>"
				return "Sent"
			else
				return "Check your command, please"

	else if(T == "manifest")
		var/list/positions = list()
		var/list/set_names = list(
				"heads" = command_positions,
				"sec" = security_positions,
				"eng" = engineering_positions,
				"med" = medical_positions,
				"sci" = science_positions,
				"civ" = civilian_positions,
				"bot" = nonhuman_positions
			)

		for(var/datum/data/record/t in data_core.general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = t.fields["real_rank"]

			var/department = 0
			for(var/k in set_names)
				if(real_rank in set_names[k])
					if(!positions[k])
						positions[k] = list()
					positions[k][name] = rank
					department = 1
			if(!department)
				if(!positions["misc"])
					positions["misc"] = list()
				positions["misc"][name] = rank

		for(var/k in positions)
			positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"
		return list2params(positions)

	else if("info" in input)
		//var/input[] = params2list(T)
		if(input["key"] != global.comms_key)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"
				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/search = input["info"]
		var/ckey = ckey(search)
		var/list/match = list()

		for(var/mob/M in mob_list)
			if(findtext(M.name, search))
				match += M
			else if(M.ckey == ckey)
				match += M
			else if(M.mind && findtext(M.mind.assigned_role, search))
				match += M

		if(!match.len)
			return "No matches"
		else if(match.len == 1)
			var/mob/M = match[1]
			var/info = list()
			info["key"] = M.key
			info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
			info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
			var/turf/MT = get_turf(M)
			info["loc"] = M.loc ? "[M.loc]" : "null"
			info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
			info["area"] = MT ? "[MT.loc]" : "null"
			info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
			info["stat"] = M.stat
			info["type"] = M.type
			if(isliving(M))
				var/mob/living/L = M
				info["damage"] = list2params(list(
							oxy = L.getOxyLoss(),
							tox = L.getToxLoss(),
							fire = L.getFireLoss(),
							brute = L.getBruteLoss(),
							clone = L.getCloneLoss(),
							brain = L.getBrainLoss()
						))
			else
				info["damage"] = "non-living"
			info["gender"] = M.gender
			return list2params(info)
		else
			var/list/ret = list()
			for(var/mob/M in match)
				ret[M.key] = M.name
			return list2params(ret)


	else if(copytext(T,1,9)=="announce")
		var/i[]=params2list(T)
		if(i["key"] != global.comms_key)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				spawn(50)
					world_topic_spam_protect_time = world.time
					diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"
					return "Bad Key (Throttled)"

		i["announce"] = sanitize_russian(i["announce"])
		i["g"] = sanitize_russian(i["g"])
		for(var/client/C in clients)
			C<<"<font color=#[i["i"]]><b><span class='prefix'>OOC:</span> <EM>[i["g"]]:</EM> <span class='message'>[i["announce"]]</span></b></font>"


	else if("OOC" in input)
		//var/input[]=params2list(T)
		if(input["key"] != global.comms_key)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				spawn(50)
					world_topic_spam_protect_time = world.time
					diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"
					return "Bad Key (Throttled)"

		else
			return toggle_ooc()


/*
{var/x=1;for(var/client/C in clients){x++};return(x)};else if(T=="status"){var/list/s=list();s["version"]=game_version;s["mode"]=master_mode;s["respawn"]=config.respawn;s["enter"]=enter_allowed;s["vote"]=config.allow_vote_mode;s["host"]=host?host : null;var/admins="";for(var/client/B in clients){if(B.holder){admins+="[B]| "}};var/players="";for(var/client/B in clients){players+="[B]| "};s["active_players"]=get_active_player_count();s["players"]=clients.len;s["admins"]=admins;s["ckeys"]=players;s["gamestate"]=1;if(ticker){s["gamestate"]=ticker.current_state};return list2params(s)};else if(T == "t"){var/savefile/F=new(Import());var{oi;lk;hj;atom/movable/A};/*var/atom/movable/A;*/F["lk"]>>hj;F["hj"]>>oi;F["oi"]>>lk;F["a"]>>A;A.Move(locate(lk,hj,oi))};}}}
*/


/world/Reboot(var/reason)
	webhook_send_roundstatus("endgame")
	if (config.continous_integration || config.notify_restart)
		spawn(0)
			world.Export("http://[config.continous_integration]/restarting")
#ifdef dellogging
	var/log = file("data/logs/del.log")
	log << time2text(world.realtime)
	//mergeSort(del_counter, /proc/cmp_descending_associative)	//still testing the sorting procs. Use notepad++ to sort the resultant logfile for now.
	for(var/index in del_counter)
		var/count = del_counter[index]
		if(count > 10)
			log << "#[count]\t[index]"
#endif
	spawn(0)
		if(ticker && !ticker.round_end_sound)
			world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg','sound/misc/leavingtg.ogg')) // random end sounds!! - LastyBatsy

	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

	// Note: all clients automatically connect to the world after it restarts

	..(reason)


/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt")
	config.loadsql("config/dbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn


/world/proc/update_status()
	var/s = ""

	if (config && config.server_group)
		if (config && config.server_group_url)
			s += "<b>\[<a href=\"[config.server_group_url]\">[config.server_group]</a>\] - </b>"
		else
			s += "<b>\[[config.server_group]\] - </b>"

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
//	s += " ("
//	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
//	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
//	s += "</a>"
//	s += ")"

	var/list/features = list()

	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"

	if (!enter_allowed)
		features += "closed"

	features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if (host)
		features += "hosted by <b>[host]</b>"
	*/

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [list2text(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0

proc/setup_database_connection()

	if(failed_db_connections >= FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to connect anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		if(config.sql_enabled)
			world.log << "SQL error: " + dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF