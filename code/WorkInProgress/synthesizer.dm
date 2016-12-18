/datum/song/synthesized
	var/current_instrument = "piano"
	var/current_octave_offset = 0
	var/volume = 100
	var/sustain_timer = 5
	var/volume_soft = 0
	var/soft_coeff = 1.5
	var/octave_range_min = 1
	var/octave_range_max = 9
	var/three_dimensional_sound = 0


/datum/song/synthesized/proc/playsound_synthesized(var/soundin, var/frequency, var/free_channel, var/mob/play_for, var/play_time)
	var/sound/sound_copy = sound(soundin)

	sound_copy.frequency = frequency
	sound_copy.channel = free_channel
	sound_copy.volume = volume
	sound_copy.wait = 0
	if (three_dimensional_sound)
		sound_copy.falloff = 5
		var/dx = instrumentObj.x - play_for.x // Hearing from the right/left
		sound_copy.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

		var/dz = instrumentObj.y - play_for.y // Hearing from infront/behind
		sound_copy.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

	play_for << sound_copy
	sound_copy.frequency = 1
	spawn(play_time)
		while (sound_copy.volume > 0)
			sleep(1)
			if (volume_soft)
				sound_copy.volume = max(round(sound_copy.volume / soft_coeff), 0)
			else
				var/delta_volume = volume / sustain_timer
				sound_copy.volume = max(sound_copy.volume - delta_volume, 0)
			sound_copy.status |= SOUND_UPDATE
			play_for << sound_copy
		play_for << sound(channel = free_channel)


/datum/song/synthesized/proc/synthesize_note_and_play(var/note, var/acc as text, var/oct, var/free_channel, var/play_time)
	// handle accidental -> B<>C of E<>F
	if(acc == "b" && (note == 3 || note == 6)) // C or F
		if(note == 3)
			oct--
		note--
		acc = "n"
	else if(acc == "#" && (note == 2 || note == 5)) // B or E
		if(note == 2)
			oct++
		note++
		acc = "n"
	else if(acc == "#" && (note == 7)) //G#
		note = 1
		acc = "b"
	else if(acc == "#") // mass convert all sharps to flats, octave jump already handled
		acc = "b"
		note++

	/*
		Each instrument has 5 anchor notes defined: A1, A2, A3, A4, A5
		The closest one by frequency and num is chosen for modulation
		A1 :  55 hz
		A2 : 110 hz
		A3 : 220 hz
		A4 : 440 hz
		A5 : 880 hz

		Distortions shouldn't be too harsh for about +- 0.5 freq

		Piano
		Music box [represents sine wave]
		Guitar
		Strings
		Accordian
		Saw wave

		Each sample should have at least 5 seconds of sound
	*/

	if (oct < octave_range_min || oct > octave_range_max) return // Outside of allowed octaves

	var/list/list/instrument_files = list(list("piano", sound('sound/synthesizer/a1_pn.ogg'), sound('sound/synthesizer/a2_pn.ogg'), sound('sound/synthesizer/a3_pn.ogg'), sound('sound/synthesizer/a4_pn.ogg'), sound('sound/synthesizer/a5_pn.ogg')),
										  list("musicbox", sound('sound/synthesizer/a1_mb.ogg'), sound('sound/synthesizer/a2_mb.ogg'), sound('sound/synthesizer/a3_mb.ogg'), sound('sound/synthesizer/a4_mb.ogg'), sound('sound/synthesizer/a5_mb.ogg')),
										  list("guitar", sound('sound/synthesizer/a1_gt.ogg'), sound('sound/synthesizer/a2_gt.ogg'), sound('sound/synthesizer/a3_gt.ogg'), sound('sound/synthesizer/a4_gt.ogg'), sound('sound/synthesizer/a5_gt.ogg')),
										  list("accordian", sound('sound/synthesizer/a1_ac.ogg'), sound('sound/synthesizer/a2_ac.ogg'), sound('sound/synthesizer/a3_ac.ogg'), sound('sound/synthesizer/a4_ac.ogg'), sound('sound/synthesizer/a5_ac.ogg')),
										  list("strings", sound('sound/synthesizer/a1_vl.ogg'), sound('sound/synthesizer/a2_vl.ogg'), sound('sound/synthesizer/a3_vl.ogg'), sound('sound/synthesizer/a4_vl.ogg'), sound('sound/synthesizer/a5_vl.ogg')),
										  list("sawwave", sound('sound/synthesizer/a1_sw.ogg'), sound('sound/synthesizer/a2_sw.ogg'), sound('sound/synthesizer/a3_sw.ogg'), sound('sound/synthesizer/a4_sw.ogg'), sound('sound/synthesizer/a5_sw.ogg')))
	var/note2num = list()
	note2num["3n"] =  0 // C
	note2num["4b"] =  1 // Db or C#
	note2num["4n"] =  2 // D
	note2num["5b"] =  3 // Eb or D#
	note2num["5n"] =  4 // Fb or E
	note2num["6n"] =  5 // F
	note2num["7b"] =  6 // Gb or F#
	note2num["7n"] =  7 // G
	note2num["1b"] =  8 // Ab or G#
	note2num["1n"] =  9 // A
	note2num["2b"] = 10 // Bb or A#
	note2num["2n"] = 11 // Cb or B

	var/note_num = 12*oct + note2num["[note][acc]"]
	var/list/sample_numbers = list(12*1 + note2num["1n"], 12*2 + note2num["1n"], 12*3 + note2num["1n"], 12*4 + note2num["1n"], 12*5 + note2num["1n"]) // A1, A2, A3, A4, A5
	var/list/subset

	for (var/list/some_set in instrument_files)
		if (some_set[1] == current_instrument)
			subset = some_set

	#define DN(num1, num2) (abs(note_num-sample_numbers[num1])) <= (abs(note_num-sample_numbers[num2]))
	var/sound/closest_sample = (
	(DN(1, 2) && DN(1, 3) && DN(1, 4) && DN(1, 5)) ? subset[2] :
	(DN(2, 1) && DN(2, 3) && DN(2, 4) && DN(2, 5)) ? subset[3] :
	(DN(3, 1) && DN(3, 2) && DN(3, 4) && DN(3, 5)) ? subset[4] :
	(DN(4, 1) && DN(4, 2) && DN(4, 3) && DN(4, 5)) ? subset[5] :
	(DN(5, 1) && DN(5, 2) && DN(5, 3) && DN(5, 4)) ? subset[6] : null)
	#undef DN
	var/closest_delta = (
	(closest_sample == subset[2]) ? sample_numbers[1] :
	(closest_sample == subset[3]) ? sample_numbers[2] :
	(closest_sample == subset[4]) ? sample_numbers[3] :
	(closest_sample == subset[5]) ? sample_numbers[4] :
	(closest_sample == subset[6]) ? sample_numbers[5] : null)

	var/actual_deviation = note_num-closest_delta
	var/new_freq = 2**(actual_deviation/12)

	for (var/mob/hearer in get_hearers_in_view(15, instrumentObj))
		if (hearer.client && hearer.mind) // Don't waste any time with
			playsound_synthesized(closest_sample, new_freq, free_channel, hearer, play_time)

/datum/song/synthesized/playsong(mob/user)
	while(repeat >= 0)
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = 3
			cur_acc[i] = "n"
		var/free_channel = 1 // Up to 256 channels are allowed
		for(var/line in lines)
			for(var/beat in text2list(lowertext(line), ","))
				// Stop all sounds
				var/list/notes = text2list(beat, "/")
				var/play_time = (notes.len >= 2 && text2num(notes[2])) ? sanitize_tempo(tempo / text2num(notes[2])) : tempo
				for(var/note in text2list(notes[1], "-"))
					//world << "note: [note]"
					if(!playing || shouldStopPlaying(user))
						playing = 0
						return
					if(lentext(note) == 0)
						continue
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to lentext(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#"
						else
							cur_oct[cur_note] = text2num(ni)

					synthesize_note_and_play(cur_note, cur_acc[cur_note], cur_oct[cur_note]+current_octave_offset-2, free_channel, play_time) // -2 octaves are required because this maps perfectly to the sounds
					free_channel = free_channel >= 256 ? 1 : free_channel+1
				sleep(play_time)
		repeat--
		if(repeat >= 0)
			updateDialog(user)
	playing = 0
	repeat = 0
	updateDialog(user)

/datum/song/synthesized/interact(mob/user)
	var/dat = ""

	if(lines.len > 0)
		dat += "<H3>Playback</H3>"
		if(!playing)
			dat += "<A href='?src=\ref[src];play=1'>Play</A> <SPAN CLASS='linkOn'>Stop</SPAN><BR><BR>"
			dat += "Repeat Song: "
			dat += repeat > 0 ? "<A href='?src=\ref[src];repeat=-10'>-</A><A href='?src=\ref[src];repeat=-1'>-</A>" : "<SPAN CLASS='linkOff'>-</SPAN><SPAN CLASS='linkOff'>-</SPAN>"
			dat += " [repeat] times "
			dat += repeat < max_repeats ? "<A href='?src=\ref[src];repeat=1'>+</A><A href='?src=\ref[src];repeat=10'>+</A>" : "<SPAN CLASS='linkOff'>+</SPAN><SPAN CLASS='linkOff'>+</SPAN>"
			dat += "<BR>"
		else
			dat += "<SPAN CLASS='linkOn'>Play</SPAN> <A href='?src=\ref[src];stop=1'>Stop</A><BR>"
			dat += "Repeats left: <B>[repeat]</B><BR>"

	dat += "Current instrument: [current_instrument] "
	dat += "<A href='?src=\ref[src];change_instrument=1'>Change instrument...</A><BR>"
	dat += "Volume: <A href='?src=\ref[src];change_volume=-10'>-10</A> <A href='?src=\ref[src];change_volume=-1'>-1</A> [volume] "
	dat += "<A href='?src=\ref[src];change_volume=1'>1</A> <A href='?src=\ref[src];change_volume=10'>10</A><BR>"
	dat += "Transposition by octave: <A href='?src=\ref[src];octave_dec=1'>-</A> [current_octave_offset] <A href='?src=\ref[src];octave_inc=1'>+</A><BR>"
	dat += "Octave range: <A href='?src=\ref[src];octave_range_min_dec=1'>-</A>[octave_range_min]<A href='?src=\ref[src];octave_range_min_inc=1'>+</A> to "
	dat += "<A href='?src=\ref[src];octave_range_max_dec=1'>-</A>[octave_range_max]<A href='?src=\ref[src];octave_range_max_inc=1'>+</A><BR>"
	dat += "<A href='?src=\ref[src];3d_sound=1'>[three_dimensional_sound ? "3D sound enabled" : "3D sound disabled"]</A><BR>"
	if (!volume_soft)
		dat += "Sustain pedal timer: <A href='?src=\ref[src];sustain_change=-10'>-10</A> <A href='?src=\ref[src];sustain_change=-1'>-1</A> [sustain_timer] <A href='?src=\ref[src];sustain_change=1'>1</A> <A href='?src=\ref[src];sustain_change=10'>10</A><BR>"
	else
		dat += "Soft coefficient: [soft_coeff] <A href='?src=\ref[src];soft_change=1'>Change coefficient</A><BR>"
	dat += "<A href='?src=\ref[src];toggle_volume=1'>[volume_soft ? "Soft" : "Sharp"] volume drop</A><BR>"
	if(!edit)
		dat += "<BR><B><A href='?src=\ref[src];edit=2'>Show Editor</A></B><BR>"
	else
		dat += "<H3>Editing</H3>"
		dat += "<B><A href='?src=\ref[src];edit=1'>Hide Editor</A></B>"
		dat += " <A href='?src=\ref[src];newsong=1'>Start a New Song</A>"
		dat += " <A href='?src=\ref[src];import=1'>Import a Song</A><BR><BR>"
		var/bpm = round(600 / tempo)
		dat += "Tempo: <A href='?src=\ref[src];tempo=[world.tick_lag]'>-</A> [bpm] BPM <A href='?src=\ref[src];tempo=-[world.tick_lag]'>+</A><BR><BR>"
		var/linecount = 0
		for(var/line in lines)
			linecount += 1
			dat += "Line [linecount]: <A href='?src=\ref[src];modifyline=[linecount]'>Edit</A> <A href='?src=\ref[src];deleteline=[linecount]'>X</A> [line]<BR>"
		dat += "<A href='?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += "<B><A href='?src=\ref[src];help=1'>Hide Help</A></B><BR>"
			dat += {"
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to 50 characters.<br>
					A song may only contain up to 200 lines.<br>
					<br>
					More info on the synthesizer here: http://pastebin.com/dxxTLVqy<br>
					"}
		else
			dat += "<B><A href='?src=\ref[src];help=2'>Show Help</A></B><BR>"

	var/datum/browser/popup = new(user, "instrument", instrumentObj.name, 700, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(instrumentObj.icon, instrumentObj.icon_state))
	popup.open()

/datum/song/synthesized/Topic(href, href_list)
	..(href, href_list)
	if (href_list["change_instrument"])
		var/new_instrument = input(usr, "Select new instrument") in list("piano", "musicbox", "guitar", "strings", "accordian", "sawwave")
		if (new_instrument)
			current_instrument = new_instrument
	if (href_list["change_volume"])
		var/amount = text2num(href_list["change_volume"])
		volume = min(max(volume + amount, 0), 100)

	if (href_list["octave_dec"])
		current_octave_offset = max(current_octave_offset-1,-4)
	if (href_list["octave_inc"])
		current_octave_offset = min(current_octave_offset+1, 4)
	if (href_list["octave_range_min_dec"])
		octave_range_min = max(octave_range_min-1, 0)
	if (href_list["octave_range_min_inc"])
		octave_range_min = min(max(octave_range_min+1, 0), 9)
		octave_range_max = max(octave_range_max, octave_range_min)
	if (href_list["octave_range_max_dec"])
		octave_range_max = max(octave_range_max-1, 0)
		octave_range_min = min(octave_range_max, octave_range_min)
	if (href_list["octave_range_max_inc"])
		octave_range_max = min(octave_range_max+1, 9)

	if (href_list["sustain_change"])
		var/change = text2num(href_list["sustain_change"])
		sustain_timer = min(max(sustain_timer+change, 1), 25)
	if (href_list["soft_change"])
		var/new_coeff = input(usr, "from 1.1 to 5.0") as num
		if (new_coeff < 1.1)
			return
		if (new_coeff > 5.0)
			return
		soft_coeff = new_coeff

	if (href_list["toggle_volume"])
		volume_soft = !volume_soft

	if (href_list["3d_sound"])
		three_dimensional_sound = !three_dimensional_sound

	updateDialog(usr)
	return

/obj/structure/piano/synthesizer
	name = "The Synthesizer"
	desc = "One of the rarest surviving models, state-of-the-art technology in entertainment and interrogation science"
	anchored = 1
	icon = 'synthesizer.dmi'
	icon_state = "synthesizer"

	New()
		src.song = new /datum/song/synthesized("synthesizer", src)

