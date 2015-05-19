/client/proc/reestablish_db_connection()
	set category = "Special Verbs"
	set name = "Reestablish DB Connection"
	if (!config.sql_enabled)
		usr << "<span class='adminnotice'>The Database is not enabled!</span>"
		return

	if (dbcon && dbcon.IsConnected())
		if (!check_rights(R_DEBUG,0))
			alert("Don't mess with it, pubby.", "If there is a real necessity in reconnecting a database, then you should call a coder.")
			return

		var/reconnect = alert("The database is already connected! If you *KNOW* that this is incorrect, you can force a reconnection", "The database is already connected!", "Force Reconnect", "Cancel")
		if (reconnect != "Force Reconnect")
			return

		dbcon.Disconnect()
		failed_db_connections = 0
		log_admin("[key_name(usr)] has forced the database to disconnect")
		message_admins("[key_name_admin(usr)] has <b>forced</b> the database to disconnect!")

	log_admin("[key_name(usr)] is attempting to re-established the DB Connection")
	message_admins("[key_name_admin(usr)] is attempting to re-established the DB Connection")

	failed_db_connections = 0
	if (!establish_db_connection())
		message_admins("Database connection failed: " + dbcon.ErrorMsg())
	else
		message_admins("Database connection re-established")