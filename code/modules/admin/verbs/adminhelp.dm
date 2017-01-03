/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>"
		return
	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(ahmuted(ckey))
		src << "<span class='danger'><big><b>No way for you, dick.</b></big></span>"
		return

	//clean the input msg
	if(!msg)	return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return
	var/original_msg = msg

/*	//explode the input msg into a list
	var/list/msglist = text2list(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = text2list(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							msg += "<b><font color='black'>[original_word] (<A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>?</A>)</font></b> "
							continue
			msg += "[original_word] "
*/

	if(!mob)	return						//this doesn't happen
	var/ref_mob = "\ref[mob]"
	msg = "<span class='adminnotice'><b><font color=red>HELP: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=[ref_mob]'>JMP</A>) (<A HREF='?_src_=holder;traitor=[ref_mob]'>TP</A>) :</b> [msg]</span>"

	//send this msg to all admins
	var/admin_number_present = 0

	for(var/client/X in admins)
		admin_number_present++
		if(X.prefs.toggles & SOUND_ADMINHELP)
			X << 'sound/effects/adminhelp.ogg'
		X << msg

	//show it to the person adminhelping too
	src << "<span class='adminnotice'>PM to-<b>Admins</b>: [original_msg]</span>"

	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] admins")
	return

/*
/client/verb/reportbug(msg as text)
	set category = "Admin"
	set name = "Report a bug"
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>"
		return
	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return
	if(ahmuted(ckey))
		src << "<span class='danger'><big><b>No way for you, dick.</b></big></span>"
		return
	if(!msg)	return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)	return
	var/original_msg = msg
*/