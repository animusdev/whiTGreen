//This  only  assumes  that  the  mob  has  a  body  and  face  with  at  least  one  mouth.
//Things  like  airguitar  can  be  done  without  arms,  and  the  flap  thing  makes  so  little  sense  it's  a  keeper.
//Intended  to  be  called  by  a  higher  up  emote  proc  if  the  requested  emote  isn't  in  the  custom  emotes.

/mob/living/emote(var/act,  var/m_type=1,  var/message  =  null)
	var/param  =  null

	if  (findtext(act,  "-",  1,  null))
		var/t1  =  findtext(act,  "-",  1,  null)
		param  =  copytext(act,  t1  +  1,  length(act)  +  1)
		act  =  copytext(act,  1,  t1)

	if(findtext(act,"s",-1)  &&  !findtext(act,"_",-2))//Removes  ending  s's  unless  they  are  prefixed  with  a  '_'
		act  =  copytext(act,1,length(act))

	switch(act)//Hello,  how  would  you  like  to  order?  Alphabetically!
		if  ("aflap")
			if  (!src.restrained())
				message  =  "<B>[src]</B>  машет  своими  крыль&#255;ми  В  ЯРОСТИ!"
				m_type  =  2

		if  ("blush")
			message  =  "<B>[src]</B>  краснеет."
			m_type  =  1

		if  ("bow")
			if  (!src.buckled)
				var/M  =  null
				if  (param)
					for  (var/mob/A  in  view(1,  src))
						if  (param  ==  A.name)
							M  =  A
							break
				if  (!M)
					param  =  null
				if  (param)
					message  =  "<B>[src]</B>  клан&#255;етс&#255;  [param]."
				else
					message  =  "<B>[src]</B>  клан&#255;етс&#255;."
			m_type  =  1

		if  ("burp")
			message  =  "<B>[src]</B>  отрыгивает."
			m_type  =  2

		if  ("choke")
			message  =  "<B>[src]</B>  задыхаетс&#255;."
			m_type  =  2

		if  ("chuckle")
			message  =  "<B>[src]</B>  посмеиваетс&#255;."
			m_type  =  2

		if  ("collapse")
			Paralyse(2)
			message  =  "<B>[src]</B>  изнурённо  падает!"
			m_type  =  2

		if  ("cough")
			message  =  "<B>[src]</B>  кашл&#255;ет."
			m_type  =  2

		if  ("dance")
			if  (!src.restrained())
				message  =  "<B>[src]</B>  радостно  пританцовывает."
				m_type  =  1

		if  ("deathgasp")
			message  =  "<B>[src]</B>  содрогаетс&#255;  в  последний  раз,  безжизненный  взгл&#255;д  застывает..."
			m_type  =  1

		if  ("drool")
			message  =  "<B>[src]</B>  пускает  слюну."
			m_type  =  1

		if  ("faint")
			message  =  "<B>[src]</B>  бледнеет."
			if(src.sleeping)
				return  //Can't  faint  while  asleep
			src.sleeping  +=  10  //Short-short  nap
			m_type  =  1

		if  ("flap")
			if  (!src.restrained())
				message  =  "<B>[src]</B>  машет  своими  крыль&#255;ми."
				m_type  =  2

		if  ("flip")
			if  (!src.restrained()  ||  !src.resting  ||  !src.sleeping)
				src.SpinAnimation(7,1)
				m_type  =  2

		if  ("frown")
			message  =  "<B>[src]</B>  хмуритс&#255;."
			m_type  =  1

		if  ("gasp")
			message  =  "<B>[src]</B>  задыхаетс&#255;!"
			m_type  =  2

		if  ("giggle")
			message  =  "<B>[src]</B>  хихикает."
			m_type  =  2

		if  ("glare")
			var/M  =  null
			if  (param)
				for  (var/mob/A  in  view(1,  src))
					if  (param  ==  A.name)
						M  =  A
						break
			if  (!M)
				param  =  null
			if  (param)
				message  =  "<B>[src]</B>  зыркает  на  [param]."
			else
				message  =  "<B>[src]</B>  зыркает."

		if  ("grin")
			message  =  "<B>[src]</B>  ухмыл&#255;етс&#255;."
			m_type  =  1

		if  ("jump")
			message  =  "<B>[src]</B>  прыгает!"
			m_type  =  1

		if  ("laugh")
			message  =  "<B>[src]</B>  смеётс&#255;."
			m_type  =  2

		if  ("look")
			var/M  =  null
			if  (param)
				for  (var/mob/A  in  view(1,  src))
					if  (param  ==  A.name)
						M  =  A
						break
			if  (!M)
				param  =  null
			if  (param)
				message  =  "<B>[src]</B>  смотрит  на  [param]."
			else
				message  =  "<B>[src]</B>  смотрит."
			m_type  =  1

		if  ("me")
			if  (src.client)
				if(client.prefs.muted  &  MUTE_IC)
					src  <<  "¤  Вы  не  следили  за  своим  &#255;зыком.  Теперь  его  нет  (muted)."
					return
				if  (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if  (stat)
				return
			if(!(message))
				return
			else
				message  =  "<B>[src]</B>  [message]"

		if  ("nod")
			message  =  "<B>[src]</B>  кивает."
			m_type  =  1

		if  ("point")
			if  (!src.restrained())
				var/atom/M  =  null
				if  (param)
					for  (var/atom/A  as  mob|obj|turf  in  view())
						if  (param  ==  A.name)
							M  =  A
							break
				if  (!M)
					message  =  "<B>[src]</B>  points."
				else
					pointed(M)
			m_type  =  1

		if  ("scream")
			message  =  "<B>[src]</B>  кричит!"
			m_type  =  2

		if  ("shake")
			message  =  "<B>[src]</B>  тр&#255;сёт  головой."
			m_type  =  1

		if  ("sigh")
			message  =  "<B>[src]</B>  вздыхает."
			m_type  =  2

		if  ("sit")
			message  =  "<B>[src]</B>  садитс&#255;."
			m_type  =  1

		if  ("smile")
			message  =  "<B>[src]</B>  улыбаетс&#255;."
			m_type  =  1

		if  ("sneeze")
			message  =  "<B>[src]</B>  чихает."
			m_type  =  2

		if  ("sniff")
			message  =  "<B>[src]</B>  шмыгает  носом."
			m_type  =  2

		if  ("snore")
			message  =  "<B>[src]</B>  "
			message  +=  pick("храпит.",  "сопит.",  "похрапывает.",  "ворочаетс&#255;  во  сне.")
			m_type  =  2

		if  ("stare")
			var/M  =  null
			if  (param)
				for  (var/mob/A  in  view(1,  src))
					if  (param  ==  A.name)
						M  =  A
						break
			if  (!M)
				param  =  null
			if  (param)
				message  =  "<B>[src]</B>  глазеет  на  [param]."
			else
				message  =  "<B>[src]</B>  глазеет  по  сторонам."

		if  ("sulk")
			message  =  "<B>[src]</B>  кукситс&#255;."
			m_type  =  1

		if  ("sway")
			message  =  "<B>[src]</B>  одурманенно  шатаетс&#255;."
			m_type  =  1

		if  ("tremble")
			message  =  "<B>[src]</B>  дрожит  в  страхе!"
			m_type  =  1

		if  ("twitch")
			message  =  "<B>[src]</B>  судорожно  дёргаетс&#255;."
			m_type  =  1

		if  ("twitch_s")
			message  =  "<B>[src]</B>  дёргаетс&#255;."
			m_type  =  1

		if  ("wave")
			message  =  "<B>[src]</B>  машет  рукой."
			m_type  =  1

		if  ("whimper")
			message  =  "<B>[src]</B>  хнычет."
			m_type  =  2

		if  ("yawn")
			message  =  "<B>[src]</B>  зевает."
			m_type  =  2

		if("superfart")
			playsound(src.loc, 'fart.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'fart.ogg', 80, 1)
			src << "\blue Your butt falls off!"
//			new /obj/item/clothing/head/butt(src.loc)
//			new /obj/decal/cleanable/poo(src.loc)
			playsound(src.loc, 'superfart.ogg', 80, 0)
			for(var/mob/living/carbon/M in ohearers(6, src))
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(istype(H.ears, /obj/item/clothing/ears/earmuffs))
						continue
				M.stuttering += 10
				M.ear_deaf += 3
				M.weakened = 1
				if(prob(30))
					M.stunned = 3
					M.paralysis += 4
//				else
//					M.make_jittery(10)

		if("superwank")
			playsound(src.loc, 'squishy.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 65, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 70, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 75, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			sleep(1)
			playsound(src.loc, 'squishy.ogg', 80, 1)
			src << "\blue Your penis falls off!"
//			new /obj/item/weapon/storage/cock(src.loc)
//			new /obj/decal/cleanable/cum(src.loc)
			playsound(src.loc, 'supersquishy.ogg', 80, 0)
			for(var/mob/living/carbon/M in ohearers(6, src))
				M.weakened = 4
				M.stunned = 2
//				new /obj/decal/cleanable/cum(M.loc)

		if("fart")
			if (src.nutrition == 250 || src.nutrition != 250)
				playsound(src.loc, 'fart.ogg', 65, 1)
				m_type = 2
				switch(rand(1, 48))
					if(1)
						message = "<B>[src]</B> lets out a girly little 'toot' from his butt."

					if(2)
						message = "<B>[src]</B> farts loudly!"

					if(3)
						message = "<B>[src]</B> lets one rip!"

					if(4)
						message = "<B>[src]</B> farts! It sounds wet and smells like rotten eggs."

					if(5)
						message = "<B>[src]</B> farts robustly!"

					if(6)
						message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."

					if(7)
						message = "<B>[src]</B> queefed out his ass!"

					if(8)
						message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."

					if(9)
						message = "<B>[src]</B> farts a ten second long fart."

					if(10)
						message = "<B>[src]</B> groans and moans, farting like the world depended on it."

					if(11)
						message = "<B>[src]</B> breaks wind!"

					if(12)
						message = "<B>[src]</B> expels intestinal gas through the anus."

					if(13)
						message = "<B>[src]</B> release an audible discharge of intestinal gas."

					if(14)
						message = "\red <B>[src]</B> is a farting motherfucker!!!"

					if(15)
						message = "\red <B>[src]</B> suffers from flatulence!"

					if(16)
						message = "<B>[src]</B> releases flatus."

					if(17)
						message = "<B>[src]</B> releases gas generated in his digestive tract, his stomach and his intestines. \red<B>It stinks way bad!</B>"

					if(18)
						message = "<B>[src]</B> farts like your mom used to!"

					if(19)
						message = "<B>[src]</B> farts. It smells like Soylent Surprise!"

					if(20)
						message = "<B>[src]</B> farts. It smells like pizza!"

					if(21)
						message = "<B>[src]</B> farts. It smells like George Melons' perfume!"

					if(22)
						message = "<B>[src]</B> farts. It smells like atmos in here now!"

					if(23)
						message = "<B>[src]</B> farts. It smells like medbay in here now!"

					if(24)
						message = "<B>[src]</B> farts. It smells like the bridge in here now!"

					if(25)
						message = "<B>[src]</B> farts like a pubby!"

					if(26)
						message = "<B>[src]</B> farts like a goone!"

					if(27)
						message = "<B>[src]</B> farts so hard he's certain poop came out with it, but dares not find out."

					if(28)
						message = "<B>[src]</B> farts delicately."

					if(29)
						message = "<B>[src]</B> farts timidly."

					if(30)
						message = "<B>[src]</B> farts very, very quietly. The stench is OVERPOWERING."

					if(31)
						message = "<B>[src]</B> farts and says, \"Mmm! Delightful aroma!\""

					if(32)
						message = "<B>[src]</B> farts and says, \"Mmm! Sexy!\""

					if(33)
						message = "<B>[src]</B> farts and fondles his own buttocks."

					if(34)
						message = "<B>[src]</B> farts and fondles YOUR buttocks."

					if(35)
						message = "<B>[src]</B> fart in he own mouth. A shameful [src]."

					if(36)
						message = "<B>[src]</B> farts out pure plasma! \red<B>FUCK!</B>"

					if(37)
						message = "<B>[src]</B> farts out pure oxygen. What the fuck did he eat?"

					if(38)
						message = "<B>[src]</B> breaks wind noisily!"

					if(39)
						message = "<B>[src]</B> releases gas with the power of the gods! The very station trembles!!"

					if(40)
						message = "<B>[src] \red f \blue a \black r \red t \blue s \black !</B>"

					if(41)
						message = "<B>[src] shat his pants!</B>"

					if(42)
						message = "<B>[src] shat his pants!</B> Oh, no, that was just a really nasty fart."

					if(43)
						message = "<B>[src]</B> is a flatulent whore."

					if(44)
						message = "<B>[src]</B> likes the smell of his own farts."

					if(45)
						message = "<B>[src]</B> doesnt wipe after he poops."

					if(46)
						message = "<B>[src]</B> farts! Now he smells like Tiny Turtle."

					if(47)
						message = "<B>[src]</B> burps! He farted out of his mouth!! That's Showtime's style, baby."

					if(48)
						message = "<B>[src]</B> laughs! His breath smells like a fart."


		if  ("help")
			src  <<  "Список  эмоций.  Вы  можете  использовать  их,  набрав  \"*emote\"  в  \"say\":\naflap,  blush,  bow-(none)/mob,  burp,  choke,  chuckle,  clap,  collapse,  cough,  dance,  deathgasp,  drool,  flap,  frown,  gasp,  giggle,  glare-(none)/mob,  grin,  jump,  laugh,  look,  me,  nod,  point-atom,  scream,  shake,  sigh,  sit,  smile,  sneeze,  sniff,  snore,  stare-(none)/mob,  sulk,  sway,  tremble,  twitch,  twitch_s,  wave,  whimper,  yawn"

		else
			if  (src.client)
				if(client.prefs.muted  &  MUTE_IC)
					src  <<  "¤  Что-то  мешает  вам  говорить."
					return
				if  (src.client.handle_spam_prevention(act,MUTE_IC))
					return
			if  (stat)
				return
			if(!(act))
				return
			else
				message  =  "<B>[src]</B>  [act]"

	if  (message)
		log_emote("[ckey]/[name]  :  [message]")

  //Hearing  gasp  and  such  every  five  seconds  is  not  good  emotes  were  not  global  for  a  reason.
  //  Maybe  some  people  are  okay  with  that.

		for(var/mob/M  in  dead_mob_list)
			if(!M.client  ||  istype(M,  /mob/new_player))
				continue  //skip  monkeys,  leavers  and  new  players
			var/T  =  get_turf(src)
			if(M.stat  ==  DEAD  &&  M.client  &&  (M.client.prefs.chat_toggles  &  CHAT_GHOSTSIGHT)  &&  !(M  in  viewers(T,null)))
				M.show_message(message)


		if  (m_type  &  1)
			visible_message(message)
		else  if  (m_type  &  2)
			audible_message(message)
