/obj/item/weapon/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	force = 3
	throwforce = 2
	throw_speed = 3
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'
	var/cooldown = 0


/obj/item/weapon/phone/attack_self(mob/user)
	if(cooldown == 1)
		return
	var/input = stripped_input(user, "What do you want to say?", "Use the hotline.", "")
	if(!input || !(user in view(1,src)))
		return
	user << "You hit the button and put the phone to your ear."
	sleep(20)
	user << "[src] rings..."
	playsound(src, 'sound/weapons/ring.ogg', 40, 1)
	sleep(20)
	user << "[src] rings..."
	playsound(src, 'sound/weapons/ring.ogg', 40, 1)
	sleep(20)
	user << "[src] rings..."
	playsound(src, 'sound/weapons/ring.ogg', 40, 1)
	sleep(20)
	say("Nanotrasen Emergency Hotline, what is the emergency?")
	sleep(20)
	user.say("This is [user.name], the [user.job] of [station_name()]. I have a maximum priority message for  NanoTrasen Central Command. Please reroute me to them as soon as possible.")
	sleep(20)
	say("Please hold while we transfer your call. Be patient.")
	sleep(20)
	user << "*click*"
	sleep(20)
	user << "[src] rings..."
	playsound(src, 'sound/weapons/ring.ogg', 40, 1)
	sleep(20)
	user << "[src] rings..."
	playsound(src, 'sound/weapons/ring.ogg', 40, 1)
	sleep(20)
	user << "[src] rings..."
	playsound(src, 'sound/weapons/ring.ogg', 40, 1)
	sleep(20)
	say("Central Command Headquarters, this is [pick("Captain", "Ensign", "Lieutenant", "Commander", "Rear Admiral", "Vice Admiral", "Colonel", "Special Operations Officer", "Admiral", "Fleet Admiral")] [pick("Bob","Jebediah", "Dallas", "Jackson", "Tagger", "Michael", "Bill")] speaking. What is the situation?")
	sleep(20)
	user.say("This is [user.name], the [user.job] of [station_name()]. I have the following maximum priority message for Central Command.")
	sleep(20)
	user.say(input)
	sleep(20)
	say("Thank you, I will forward this to the Chief Executive Officer immediately.")
	sleep(20)
	user << "*click*"
	playsound(src, 'sound/items/syringeproj.ogg', 40, 1) // needed a click sound
	sleep(20)
	user << "You hang up the phone."
	cooldown = 1
	Centcomm_announce(input, user)
	spawn(3000)//5 minute cooldown
		cooldown = 0

/obj/item/weapon/phone/suicide_act(mob/user)
	if(locate(/obj/structure/stool) in user.loc)
		user.visible_message("<span class='notice'>[user] begins to tie a noose with the [src.name]'s cord! It looks like \he's trying to commit suicide.</span>")
	else
		user.visible_message("<span class='notice'>[user] is strangling \himself with the [src.name]'s cord! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)
