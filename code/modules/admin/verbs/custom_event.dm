// verb for admins to set custom event
var/custom_event_msg = null

/client/proc/cmd_admin_change_custom_event()
	set category = "Fun"
	set name = "Change Custom Event"

	if(!holder)
		src << "Only administrators may use this command."
		return

	var/input = input(usr, "Enter the description of the custom event. Be descriptive. To cancel the event, make this blank or hit cancel.", "Custom Event", custom_event_msg) as message|null
	if(!input || input == "")
		custom_event_msg = null
		log_admin("[usr.key] has cleared the custom event text.")
		message_admins("[key_name_admin(usr)] has cleared the custom event text.")
		return

	log_admin("[usr.key] has changed the custom event text.")
	message_admins("[key_name_admin(usr)] has changed the custom event text.")

	custom_event_msg = input

	world << "<h1 class='alert'>ИВОНТ, ПОСОНЫ!</h1>"
	world << "<h2 class='alert'>Суть токова:</h2>"
	world << "<span class='alert'>[rhtml_encode(custom_event_msg)]</span>"
	world << "<br>"

// normal verb for players to view info
mob/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"

	if(!custom_event_msg || custom_event_msg == "")
		src << "Сегодн&#255; ивонта нет."
		return

	src << "<h1 class='alert'>Ивонт!</h1>"
	src << "<h2 class='alert'>Суть токова:</h2>"
	src << "<span class='alert'>[rhtml_encode(custom_event_msg)]</span>"
	src << "<br>"
