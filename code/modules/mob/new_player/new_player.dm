//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.

	flags = NONE

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

/mob/new_player/New()
	tag = "mob_[next_mob_id++]"
	mob_list += src

/mob/new_player/proc/new_player_panel()

	var/output = "<center><p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <b>Ready</b> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <b>Not Ready</b> \]</p>"

	else
		output += "<p><a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A></p>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"
	output += "</center>"

	//src << browse(output,"window=playersetup;size=210x240;can_close=0")
	var/datum/browser/popup = new(src, "playersetup", "<div align='center'>New Player Options</div>", 220, 265)
	popup.set_window_options("can_close=0")
	popup.set_content(output)
	popup.open(0)
	return

/mob/new_player/Stat()
	..()

	if(statpanel("Lobby"))
		stat("Game Mode:", (ticker.hide_mode) ? "Secret" : "[master_mode]")

		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", (ticker.timeLeft >= 0) ? "[round(ticker.timeLeft / 10)]s" : "DELAYED")

			stat("Players: [ticker.totalPlayers]", "Players Ready: [ticker.totalPlayersReady]")
			for(var/mob/new_player/player in player_list)
				stat("[player.key]", "[player.ready ? "(Playing)" : ""]")



/mob/new_player/Topic(href, href_list[])
	if(src != usr)
		return 0

	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/dead/observer/observer = new()

			spawning = 1
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			src << "<span class='notice'>Now teleporting.</span>"
			observer.loc = O.loc
			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(gender)
			if(client.prefs.be_random_body)
				client.prefs.random_character(gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			observer.key = key
			qdel(mind)

			qdel(src)
			return 1

	if(href_list["late_join"])
		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			usr << "<span class='danger'>The round is either not ready, or has already finished...</span>"
			return
		var/relevant_cap
		if(config.hard_popcap && config.extreme_popcap)
			relevant_cap = min(config.hard_popcap, config.extreme_popcap)
		else
			relevant_cap = max(config.hard_popcap, config.extreme_popcap)
		if(relevant_cap && living_player_count() >= relevant_cap && !(ckey(key) in admin_datums))
			usr << "<span class='danger'>[config.hard_popcap_message]</span>"
			return
		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])

		if(!enter_allowed)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
			return

		AttemptLateSpawn(href_list["SelectedJob"])
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return 0
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		if(job.title == "Assistant")
			if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
				return 1
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return 0
		else
			return 0
	if(jobban_isbanned(src,rank))
		return 0
	return 1


/mob/new_player/proc/AttemptLateSpawn(rank)
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return 0

	SSjob.AssignRole(src, rank, 1)

	var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
	SSjob.EquipRank(character, rank, 1)					//equips the human
	character.loc = pick(latejoin)
	character.lastarea = get_area(loc)

	if(character.mind.assigned_role != "Cyborg")
		if(character.mind.assigned_role != "Bum")
			AnnounceArrival(character, rank)
		data_core.manifest_inject(character) //bums removal is in manifest_inject
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
	else
		character.Robotize()

	joined_player_list += character.ckey

	switch(SSshuttle.emergency.mode)
		if(SHUTTLE_RECALL, SHUTTLE_IDLE)
			ticker.mode.make_antag_chance(character)
		if(SHUTTLE_CALL)
			if(SSshuttle.emergency.timeLeft(1) > initial(SSshuttle.emergencyCallTime)*0.5)
				ticker.mode.make_antag_chance(character)
	qdel(src)

/mob/new_player/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank)
	if (ticker.current_state == GAME_STATE_PLAYING)
		var/ailist[] = list()
		for (var/mob/living/silicon/ai/A in living_mob_list)
			ailist += A
		if (ailist.len)
			var/mob/living/silicon/ai/announcer = pick(ailist)
			if(character.mind)
				if((character.mind.assigned_role != "Cyborg") && (character.mind.special_role != "MODE"))
					announcer.say("[announcer.radiomod] [character.real_name] has signed up as [rank].")

/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<div class='notice'>Round Duration: [round(hours)]h [round(mins)]m</div>"

	switch(SSshuttle.emergency.mode)
		if(SHUTTLE_ESCAPE)
			dat += "<div class='notice red'>The station has been evacuated.</div><br>"
		if(SHUTTLE_CALL)
			if(SSshuttle.emergency.timeLeft() < 0.5 * initial(SSshuttle.emergencyCallTime)) //Shuttle is past the point of no recall
				dat += "<div class='notice red'>The station is currently undergoing evacuation procedures.</div><br>"

	var/limit = 17
	var/list/splitJobs = list("Chief Engineer")
	var/widthPerColumn = 295
	var/width = widthPerColumn
	dat += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='50%'>" // Table within a table for alignment, also allows you to easily add more colomns.
	dat += "<table width='100%' cellpadding='1' cellspacing='0'>"
	var/index = -1

	//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.
	var/datum/job/lastJob

	for(var/datum/job/job in SSjob.occupations)
		if(job.title in nonhuman_positions)
			continue
		index += 1
		if((index >= limit) || (job.title in splitJobs))
			width += 295
			if((index < limit) && (lastJob != null))
				//If the cells were broken up by a job in the splitJob list then it will fill in the rest of the cells with
				//the last job's selection color. Creating a rather nice effect.
				for(var/i = 0, i < (limit - index), i += 1)
					dat += "<tr bgcolor='[lastJob.selection_color]'><td >&nbsp</td></tr>"
			dat += "</table></td><td width='50%'><table width='100%' cellpadding='1' cellspacing='0'>"
			index = 0
		dat += "<tr bgcolor='[job.selection_color]'><td align='center'>"
		var/rank = job.title
		lastJob = job
		var/rank_full_name = rank
		if(job.total_positions > 1)
			rank_full_name += " ([job.current_positions])"
		if(jobban_isbanned(src, rank))
			dat += "<a class='linkOff'><font color=red>[rank_full_name]</font></a><font color=red><b> \[BANNED\]</b></font></td></tr>"
			continue
		if(!IsJobAvailable(rank))
			dat += "<a class='linkOff'>[rank_full_name]</a></td></tr>"
			continue
		if((rank in command_positions) || (rank == "AI"))//Bold head jobs
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'><b>[rank_full_name]</b></a>"
		else
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[rank_full_name]</a>"
		dat += "</td></tr>"

	for(var/i = 1, i < (limit - index), i += 1) // Finish the column so it is even
		dat += "<tr bgcolor='[lastJob.selection_color]'><td>&nbsp</td></tr>"

	dat += "</td'></tr></table>"

	dat += "</center></table>"

	// Added the new browser window method
	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", width, 460)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(dat)
	popup.open(0) // 0 is passed to open so that it doesn't use the onclose() proc


/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character = new(loc)
	new_character.lastarea = get_area(loc)

	create_dna(new_character)

	if(config.force_random_names || appearance_isbanned(src))
		client.prefs.random_character()
		client.prefs.real_name = random_name(gender)
	client.prefs.copy_to(new_character)

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name

	ready_dna(new_character, client.prefs.blood_type)

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Crew Manifest</h4>"
	dat += data_core.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=387x420;can_close=1")

/mob/new_player/Move()
	return 0


/mob/new_player/proc/close_spawn_windows()

	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=latechoices") //closes late job selection
