//replaces the old Ticklag verb, fps is easier to understand
/client/proc/fps_old()
	set category = "Debug"
	set name = "Set fps"
	set desc = "Sets game speed in frames-per-second. Can potentially break the game"

	if(!check_rights(R_DEBUG))	return

	var/new_fps = round(input("Sets game frames-per-second. Can potentially break the game (default: [config.fps])","FPS", world.fps) as num|null)

	if(new_fps <= 0)
		src << "<span class='danger'>Error: set_server_fps(): Invalid world.fps value. No changes made.</span>"
		return
	if(new_fps > config.fps*1.5)
		if(alert(src, "You are setting fps to a high value:\n\t[new_fps] frames-per-second\n\tconfig.fps = [config.fps]","Warning!","Confirm","ABORT-ABORT-ABORT") != "Confirm")
			return

	switch(alert("Enable Tick Compensation?","Tick Comp is currently: [config.Tickcomp]","Enable","Disable"))
		if("Enable")	config.Tickcomp = 1
		else			config.Tickcomp = 0

	var/msg = "[key_name(src)] has modified world.fps to [new_fps] and config.Tickcomp to [config.Tickcomp]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	world.fps = new_fps