var/appearance_keylist[0]

/proc/appearance_isbanned(mob/M)
	if(M)
		if(appearance_keylist.Find("[M.ckey]"))
			return 1
	return 0

/proc/appearance_loadban()
	if(!establish_db_connection())
		world.log << "Database connection failed. Fuck you."
		diary << "Database connection failed. Fuck you."
		return

	//appearance bans
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey FROM erro_ban WHERE bantype = 'APPEARANCE_PERMABAN' AND isnull(unbanned)")
	query.Execute()
	while(query.NextRow())
		var/ckey = query.item[1]
		appearance_keylist.Add("[ckey]")
