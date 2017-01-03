/proc/playsound(var/atom/source,  soundin,  vol  as  num,  vary,  extrarange  as  num,  falloff,  surround  =  1)

	soundin  =  get_sfx(soundin)  //  same  sound  for  everyone

	if(isarea(source))
		ERROR("[source]  is  an  area  and  is  trying  to  make  the  sound:  [soundin]")
		return

	var/frequency  =  get_rand_frequency()  //  Same  frequency  for  everybody
	var/turf/turf_source  =  get_turf(source)

  	//  Looping  through  the  player  list  has  the  added  bonus  of  working  for  mobs  inside  containers
	for  (var/P  in  player_list)
		var/mob/M  =  P
		if(!M  ||  !M.client)
			continue
		if(get_dist(M,  turf_source)  <=  world.view  +  extrarange)
			var/turf/T  =  get_turf(M)
			if(T  &&  T.z  ==  turf_source.z)
				M.playsound_local(turf_source,  soundin,  vol,  vary,  frequency,  falloff,  surround)


/atom/proc/playsound_local(var/turf/turf_source,  soundin,  vol  as  num,  vary,  frequency,  falloff,  surround  =  1)
	soundin  =  get_sfx(soundin)

	var/sound/S  =  sound(soundin)
	S.wait  =  0  //No  queue
	S.channel  =  0  //Any  channel
	S.volume  =  vol

	if  (vary)
		if(frequency)
			S.frequency  =  frequency
		else
			S.frequency  =  get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T  =  get_turf(src)

		//Atmosphere  affects  sound
		var/pressure_factor  =  1
		var/datum/gas_mixture/hearer_env  =  T.return_air()
		var/datum/gas_mixture/source_env  =  turf_source.return_air()

		if(hearer_env  &&  source_env)
			var/pressure  =  min(hearer_env.return_pressure(),  source_env.return_pressure())
			if(pressure  <  ONE_ATMOSPHERE)
				pressure_factor  =  max((pressure  -  SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE  -  SOUND_MINIMUM_PRESSURE),  0)
		else  //space
			pressure_factor  =  0

		var/distance  =  get_dist(T,  turf_source)
		if(distance  <=  1)
			pressure_factor  =  max(pressure_factor,  0.15)  //touching  the  source  of  the  sound

		S.volume  *=  pressure_factor
		//End  Atmosphere  affecting  sound

		if(S.volume  <=  0)
			return  //No  sound

		//  3D  sounds,  the  technology  is  here!
		if  (surround)
			var/dx  =  turf_source.x  -  T.x  //  Hearing  from  the  right/left
			S.x  =  round(max(-SURROUND_CAP,  min(SURROUND_CAP,  dx)),  1)

			var/dz  =  turf_source.y  -  T.y  //  Hearing  from  infront/behind
			S.z  =  round(max(-SURROUND_CAP,  min(SURROUND_CAP,  dz)),  1)

		//  The  y  value  is  for  above  your  head,  but  there  is  no  ceiling  in  2d  spessmens.
		S.y  =  1
		S.falloff  =  (falloff  ?  falloff  :  FALLOFF_SOUNDS)

	src  <<  S

/mob/playsound_local(var/turf/turf_source,  soundin,  vol  as  num,  vary,  frequency,  falloff,  surround  =  1)
	if(!client  ||  ear_deaf  >  0)
		return
	..()

/client/proc/playtitlemusic()
	if(!ticker  ||  !ticker.login_music)	return
	if(prefs  &&  (prefs.toggles  &  SOUND_LOBBY))
		src  <<  sound(ticker.login_music,  repeat  =  0,  wait  =  0,  volume  =  85,  channel  =  1)  //  MAD  JAMS

/proc/get_rand_frequency()
	return  rand(32000,  55000)  //Frequency  stuff  only  works  with  45kbps  oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if  ("shatter")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("explosion")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("rustle")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("bodyfall")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("punch")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("clownstep")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("swing_hit")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("hiss")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("pageturn")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("gunshot")  soundin  =  pick('sound/effects/pewpew.ogg')
			if  ("erikafootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("grassfootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("dirtfootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("waterfootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("sandfootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("woodfootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("carpetfootsteps")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
			if  ("avatarstep")  soundin  =  pick('sound/effects/footsteps/footsteps.ogg')
	return  soundin
