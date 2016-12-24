#define TURNTABLE_CHANNEL 10
#define TURNTABLE_OLD_CHANNEL 11
/*
/sound/turntable/test
	file = 'TestLoop1.ogg'
	falloff = 2
	repeat = 1*/

/mob/var/sound/music

/obj/machinery/party/oldturntable
	name = "turntable"
	desc = "A turntable used for parties and shit."
	icon = 'icons/misc/sprites.dmi'
	icon_state = "turntable"
	var/playing = 0
	anchored = 1
	use_power = 0


/*
/obj/machinery/party/oldturntable/New()
	..()
	sleep(2)
	new /sound/turntable/test(src)
	return
*/
/obj/machinery/party/oldturntable/attack_hand(mob/user as mob)

	var/t = "<B>Turntable Interface</B><br><br>"
	t += "<A href='?src=\ref[src];off=1'>Off</A><br><br>"
	t += "<A href='?src=\ref[src];on1=Testloop1'>On</A><br>"
	user << browse(t, "window=turntable;size=300x200")


/obj/machinery/party/oldturntable/Topic(href, href_list)
	..()
	if( href_list["on1"] )
		if(src.playing == 0)
			var/sound/S = sound('sound/turntable/TestLoop1.ogg')
			S.repeat = 1
			S.channel = TURNTABLE_OLD_CHANNEL
			S.falloff = 2
			S.wait = 1
			S.environment = 0
			var/area/A = src.loc.loc
			playing = 1
			while(playing == 1)
				for(var/mob/M in world)
					if((M.loc.loc in A.related) && M.music == null)
						M << S
						M.music = S
					else if(!(M.loc.loc in A.related) && M.music != null && M.music.channel == TURNTABLE_OLD_CHANNEL)
						var/sound/Soff = sound(null)
						Soff.channel = TURNTABLE_OLD_CHANNEL
						M << Soff
						M.music = null
				sleep(10)
			return

	if( href_list["off"] )
		if(src.playing == 1)
			var/sound/S = sound(null)
			S.channel = TURNTABLE_OLD_CHANNEL
			S.wait = 1
			for(var/mob/M in world)
				if(M.music != null && M.music.channel == TURNTABLE_OLD_CHANNEL)
					M << S
					M.music = null
			playing = 0

//////////////////////////////////////////////////////////////

/datum/turntable_soundtrack
	var/f_name
	var/name
	var/path

/obj/machinery/party/turntable
	name = "Jukebox"
	desc = "A jukebox is a partially automated music-playing device, usually a coin-operated machine, that will play a patron's selection from self-contained media."
	icon = 'icons/obj/objects.dmi'
	icon_state = "jukebox"
	var/playing = 0
	var/datum/turntable_soundtrack/track = null
	var/volume = 100
	var/list/turntable_soundtracks = list()
	anchored = 1
	density = 1

/obj/machinery/party/turntable/New()
	..()
	for(var/obj/machinery/party/turntable/TT) // Rework it later
		if(TT != src)
			del(src)
	turntable_soundtracks = list()
	for(var/i in typesof(/datum/turntable_soundtrack) - /datum/turntable_soundtrack)
		var/datum/turntable_soundtrack/D = new i()
		if(D.path)
			turntable_soundtracks.Add(D)

/obj/machinery/party/turntable/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/party/turntable/attack_hand(mob/living/user as mob)
	if (..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/t = "<br><br><br><div align='center'><table border='0'><B><font color='maroon' size='6'>JukeBox Interface</font></B><br><br><br><br>"

	if(playing&&track)
		t+="<tr><td height='15' weight='450' align='center' colspan='3'><font color='maroon'><B>Playing: '[track.f_name][track.name]'</B></font></td></tr>"
		t+="<tr><td height='50' weight='50' align='center' colspan='3'><A href='?src=\ref[src];off=1'><B><font color='maroon'><B>Turn Off</B></font></B></A></td><td height='50' weight='50'></td></tr>"
	t += "<tr>"


	var/lastcolor = "LimeGreen"
	for(var/i = 10; i <= 100; i += 10)
		t += "<A href='?src=\ref[src];set_volume=[i]'><B><font color='[lastcolor]'>[i]</font></B></A> "
		if(lastcolor == "LimeGreen")
			lastcolor = "maroon"
		else
			lastcolor = "LimeGreen"

	var/i = 0
	lastcolor="maroon"
	for(var/datum/turntable_soundtrack/D in turntable_soundtracks)
		t += "<td height='50' weight='50'><A href='?src=\ref[src];on=\ref[D]'><B><font color='maroon'></font><font color='[lastcolor]'>[D.f_name][D.name]</font></B></A></td>"
		i++
		if(i == 1)
			lastcolor = pick("maroon","OliveDrab")
		else
			lastcolor = pick("olive", "maroon")
		if(i == 3)
			i = 0
			t += "</tr><tr>"

	t += "</table></div></body>"
	var/datum/browser/popup = new(user,"jukebox", name, 460, 550)
	popup.set_content(t)
	popup.open()
	return
	//user << browse(t, "window=turntable;size=450x700;can_resize=0")
	//onclose(user, "turntable")
	//return

/obj/machinery/party/turntable/power_change()
	turn_off()

/obj/machinery/party/turntable/Topic(href, href_list)
	if(..())
		return
	if(href_list["on"])
		turn_on(locate(href_list["on"]))

	else if(href_list["off"])
		turn_off()

	else if(href_list["set_volume"])
		set_volume(text2num(href_list["set_volume"]))
	updateUsrDialog()

/obj/machinery/party/turntable/process()
	if(playing)
		update_sound()

/obj/machinery/party/turntable/proc/turn_on(var/datum/turntable_soundtrack/selected)
	if(playing)
		turn_off()
	if(selected)
		track = selected
	if(!track)
		return

	for(var/mob/M)
		create_sound(M)
	update_sound()

	playing = 1
	process()

/obj/machinery/party/turntable/proc/turn_off()
	if(!playing)
		return
	for(var/mob/M)
		M.music = null
		M << sound(null, channel = TURNTABLE_CHANNEL, wait = 0)

	playing = 0

/obj/machinery/party/turntable/proc/set_volume(var/new_volume)
	volume = max(0, min(100, new_volume))
	if(playing)
		update_sound(1)

/obj/machinery/party/turntable/proc/update_sound(update = 0)
	var/area/A = get_area(src)
	for(var/mob/M)
		var/inRange = (get_area(M) in A.related)
		if(!M.music)
			create_sound(M)
			continue
		if(inRange && (M.music.volume != volume || update))
			M.music.status = SOUND_UPDATE//|SOUND_STREAM
			M.music.volume = volume
			M << M.music
		else if(!inRange && M.music.volume != 0)
			M.music.status = SOUND_UPDATE//|SOUND_STREAM
			M.music.volume = 0
			M << M.music

/obj/machinery/party/turntable/proc/create_sound(mob/M)
	var/sound/S = sound(track.path)
	S.repeat = 1
	S.channel = TURNTABLE_CHANNEL
	S.falloff = 2
	S.wait = 0
	S.volume = 0
	S.status = 0 //SOUND_STREAM
	M.music = S
	M << S