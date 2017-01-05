var/global/done_rotation = 0
var/global/picked_map = null

/proc/num_players()
	. = 0
	for(var/mob/P in player_list)
		if(P.client)
			. ++

/proc/maprotate(admintriggered = 0)
	if (!config.continous_integration)
		message_admins("FUCK: Can't rotate without active backend, please modify CI in config.txt")
		diary << "FUCK: Can't rotate without active backend, please modify CI in config.txt"
		return

	if (!done_rotation)
		if (!picked_map)
			picked_map = default_map

		var/datum/votablemap/M = new picked_map
		var/id = M.get_id()
		var/name = M.name
		var/r_players = M.required_players
		qdel(M)

		if (num_players() < r_players)
			if (!admintriggered)
				world << "<font color=red><b>Can't rotate to [name], need [r_players] players and got only [num_players()].</b></font>"
			else
				message_admins("Can't rotate to [name], need [r_players] players and got only [num_players()].")
			return

		var/returndata = world.Export("http://[config.continous_integration]/maprotate?map=[id]")

		var/content = file2text(returndata["CONTENT"])
		if (content == "Got it")
			message_admins("Map switched to [name] ([id]).")
			diary << "Map switched to [name] ([id])."
			done_rotation = 1

		else
			message_admins("Got error while switching to [name] ([id]): [content]")
			diary << "Got error while switching to [name] ([id]): [content]"

	else
		if(!admintriggered)
			world << "<font color=red><b>Map rotation error: map has already been rotated.</b></font>"
		else
			message_admins("Map rotation error: map has already been rotated.")