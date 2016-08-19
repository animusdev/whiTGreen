var/list/click_amt_list = list()
var/list/delay_click_list = list()
var/list/associated_ckey_list = list()

var/list/tagged_ckeys = list() // Suspects
var/list/list/click_speed_data = list() // Avg click speed of suspects
var/list/list/click_speed_avg_data = list()
var/list/list/delta_data = list() // Mean deviation data of suspects


var/anticheat_status = 0 // Not active by default

var/const/restrict_to_tournament = 1
var/maximum_delay_between_battles = 0
var/normal_human_speed = 0
var/rapid_succession_cutoff = 0
var/unique_ticks_min = 0
var/uniform_clicking_deviation = 0
var/uniform_clicking_exclusion_derivative = 0
var/rush_limit = 0

var/datum/anticheat/MC = new

/client/Click(object, location, control, params)
	if (anticheat_status && (!restrict_to_tournament || (istype(mob, /mob/living) && istype(get_area(mob), /area/tdome))))
	/*
	LISP style

	BYOND will not execute further statements if any of them give 0 in AND block
	BYOND will not execute further statements if any of them give 1 in OR block
	(and
		anticheat_status -- No point in going further if this is 0
		(or -- Must return 1 to complete
			(not restrict_to_tournament) -- No point in going further if this is 0
			(and -- The two conditions must be correct
				(istype mob /mob/living)
				(istype (get_area mob) /area/tdome)
			)
		)
	)
	*/
		var/ckey_index = associated_ckey_list.Find(ckey)
		if (!ckey_index) // Is there such player in the list?
			associated_ckey_list += ckey // Add this ckey to the base
			click_amt_list += 0 // Define AMT for this player
			ckey_index = length(associated_ckey_list) // Guaranteed to be found
			delay_click_list += list(list()) // Add new list for this player
		click_amt_list[ckey_index]++ // Add new click
		delay_click_list[ckey_index] += world.timeofday // Add current tick time

		var/first_delay = delay_click_list[ckey_index][1]
		var/tagged_indx = tagged_ckeys.Find(ckey)

		if (click_amt_list[ckey_index] > rapid_succession_cutoff)
			var/last_elm_in_the_second = length(delay_click_list[ckey_index])
			var/delta = delay_click_list[ckey_index][last_elm_in_the_second]-first_delay
			delta /= 10
			if (delta)
				var/avg_clks = click_amt_list[ckey_index] / delta
				if (avg_clks > normal_human_speed)
					if (!tagged_indx)
						tagged_ckeys += ckey // This player might be a cheater
						tagged_indx = tagged_ckeys.Find(ckey)

						click_speed_data += list(list()) // Define new list for this player
						click_speed_avg_data += list(list(first_delay, 0, 0)) // Add non-specialized data
						delta_data += list(list()) // And delta data

				if (tagged_indx) // Add data
					click_speed_data[tagged_indx] += avg_clks
					click_speed_avg_data[tagged_indx][2] = click_amt_list[ckey_index]
					click_speed_avg_data[tagged_indx][3] = delay_click_list[ckey_index][last_elm_in_the_second] // Set last point
				//del(src)
		// Create a list of deltas

		var/list/deltas = list()
		if(length(delay_click_list[ckey_index]) > unique_ticks_min)
			for(var/delta_indx=1, delta_indx < length(delay_click_list[ckey_index]), delta_indx++)
				deltas += delay_click_list[ckey_index][delta_indx+1]-delay_click_list[ckey_index][delta_indx]

			var/mean = 0
			for(var/counter in deltas)
				mean += counter
			mean /= length(deltas)

			var/variance = 0
			for(var/counter in deltas)
				variance += (mean - counter)**2
			variance /= length(deltas)

			if (tagged_indx)
				delta_data[tagged_indx] += variance
	..()

/client/proc/toggle_anticheat()
	set name = "Toggle Anticheat"
	set category = "Tournaments"

	anticheat_status = !anticheat_status
	if(anticheat_status)
		MC.activate()
		usr << "The anticheat is activated"
	else
		usr << "The anticheat is deactivated"
		click_amt_list = list() // Purge data
		delay_click_list = list() // Purge data
		associated_ckey_list = list() // Purge data
		tagged_ckeys = list()
		click_speed_data = list()
		click_speed_avg_data = list()
		delta_data = list()

/client/proc/show_MC()
	set name = "Configure Anticheat"
	set category = "Tournaments"

	MC.show_for(usr)

/client/add_admin_verbs()
	..()
	if(holder)
		verbs += /client/proc/toggle_anticheat
		verbs += /client/proc/show_MC

/datum/anticheat
	var/variance_supertable = list()
	proc
		show_for(who)
			var/dat = ""
			dat += "Anticheat controller<br>"
			dat += "<a href='?src=\ref[src];var=NHS'>Normal Human Speed: [normal_human_speed]</a><br>"
			dat += "<a href='?src=\ref[src];var=RSCO'>Ignore first [rapid_succession_cutoff] clicks</a><br>"
			dat += "<a href='?src=\ref[src];var=UTCO'>Check for abberation in delays after [unique_ticks_min] of clicks</a><br>"
			dat += "<a href='?src=\ref[src];var=UCDA'>Deviation boundaries for uniform clicking detection, [uniform_clicking_deviation]</a><br>"
			dat += "<a href='?src=\ref[src];var=TIME'>Max. delay between rushes: [maximum_delay_between_battles]</a><br>"
			dat += "<a href='?src=\ref[src];var=STOP'>Rushes can only last for [rush_limit/10] seconds</a>"

			who << browse(dat, "window=anticheat")
		activate()
			spawn while (anticheat_status)
				ticker()
				sleep(1)

		ticker()
			for (var/ckey_index=1, ckey_index<=length(associated_ckey_list), ckey_index++)
				if (length(delay_click_list[ckey_index])) // On watch
					var/last_elm_in_the_second = length(delay_click_list[ckey_index])
					var/delta = world.timeofday - delay_click_list[ckey_index][last_elm_in_the_second]
					var/rush_len = delay_click_list[ckey_index][last_elm_in_the_second] - delay_click_list[ckey_index][1]
					var/ckey = associated_ckey_list[ckey_index]
					if (delta > maximum_delay_between_battles || rush_len > rush_limit) // Enough time has passed since last clk
						if (tagged_ckeys.Find(ckey)) // We've got a suspect
							var/tagged_indx = tagged_ckeys.Find(ckey)
							// Gather data
							var/mean_avg = 0
							var/highest_speed = 0
							var/lowest_speed = INFINITY
							for (var/counter in click_speed_data[tagged_indx])
								mean_avg += counter
								highest_speed = max(highest_speed, counter)
								lowest_speed = min(lowest_speed, counter)
							mean_avg /= length(click_speed_data[tagged_indx])

							var/delta_local = (click_speed_avg_data[tagged_indx][3]-click_speed_avg_data[tagged_indx][1]) / 10
							var/clicks = click_speed_avg_data[tagged_indx][2]
							var/mean_uniform = clicks/delta_local

							var/last_taken_val = INFINITY

							for (var/uniform_index=1, uniform_index <= length(delta_data[tagged_indx]), uniform_index++)
								if (abs(last_taken_val - delta_data[tagged_indx][uniform_index]) <= uniform_clicking_exclusion_derivative)
									delta_data[tagged_indx][uniform_index] = last_taken_val // Make it equal to discretisize the curve
								else
									last_taken_val = delta_data[tagged_indx][uniform_index]

							var/list/unique_variance = list()
							var/list/unique_counter = list()
							for (var/uniform_index=1, uniform_index <= length(delta_data[tagged_indx]), uniform_index++)
								if (!unique_variance.Find(delta_data[tagged_indx][uniform_index]))
									unique_variance += delta_data[tagged_indx][uniform_index]
									unique_counter += 1
								else
									unique_counter[unique_variance.Find(delta_data[tagged_indx][uniform_index])]++

							var/list/list/zipped = list()
							for (var/unique_index=1, unique_index <= length(unique_variance), unique_index++)
								zipped += list(list(unique_variance[unique_index], unique_counter[unique_index]))

							variance_supertable += list(zipped)

							var/dat = "" // Time to compose the message
							dat += "<br>"
							dat += "\red \bold [ckey] is suspected of using an autoclicker<br>"
							dat += "Check the matter by examining the data below:<br>"
							dat += "COLLECTED CLICK DATA:<br>"
							dat += "	HIGHEST SPEED DETECTED: [highest_speed] clicks a second<br>"
							dat += "	LOWEST SPEED DETECTED: [lowest_speed] clicks a second<br>"
							dat += "	AVERAGE CLICK SPEED: [mean_avg]<br>"
							dat += "AVERAGE CLICK SPEED (UNIFORM): [mean_uniform]<br>"
							dat += "[clicks] CLICKS IN [delta_local] SECONDS<br>"
							dat += "<a href='?src=\ref[src];variance=1;indx=[length(variance_supertable)]'>Click here to view variance data</a>"
							message_admins(dat)

							click_speed_data.Cut(tagged_indx, tagged_indx+1)
							click_speed_avg_data.Cut(tagged_indx, tagged_indx+1)
							delta_data.Cut(tagged_indx, tagged_indx+1)
							tagged_ckeys.Cut(tagged_indx, tagged_indx+1)
						click_amt_list[ckey_index] = 0
						delay_click_list[ckey_index] = list()

	New()
		..()
		maximum_delay_between_battles = 25
		normal_human_speed = 8.5
		rapid_succession_cutoff = 5
		unique_ticks_min = 10
		uniform_clicking_deviation = 0.01
		uniform_clicking_exclusion_derivative = 0.02
		rush_limit = 150

	Topic(href, href_list)
		var/new_value = 0
		if(href_list["var"])
			new_value = input(usr) as num|null
		switch(href_list["var"])
			if ("NHS")
				normal_human_speed = new_value
			if ("RSCO")
				rapid_succession_cutoff = new_value
			if ("UTCO")
				unique_ticks_min = new_value
			if ("UCDA")
				uniform_clicking_deviation = new_value
			if ("TIME")
				maximum_delay_between_battles = new_value
			if ("STOP")
				rush_limit = new_value*10

		if (href_list["variance"])
			var/index = text2num(href_list["indx"])
			var/list/super_data = variance_supertable[index]
			var/dat = ""
			for (var/data in super_data)
				dat += "([data[1]] --- [data[2]])<br>"
			usr << browse(dat, "window=variance")
		else
			show_for(usr)


#undef RESTRICT_TO_TOURNAMENT