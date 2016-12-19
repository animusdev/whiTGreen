/datum/admins/proc/call_maprotate(var/map in vm_names)
	set category = "Server"
	set name = "Map Rotate"
	set desc = "Rotating your maps."

	picked_map = votable_maps[map]
	spawn(0)
		maprotate(admintriggered=1)