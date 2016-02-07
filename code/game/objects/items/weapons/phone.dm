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
	req_access = list(access_hos)
	var/spamcheck = 0
	var/codecheck = 18000
	var/told_code = 0 //anti-admin spam

/obj/item/weapon/phone/attack_self(mob/living/carbon/human/user)
	if(..())
		return
	if(!allowed(user))
		return
	if(!ishuman(user))
		usr << "<span class='warning'> You poke the [src.name]. </span>"
		return
	if(spamcheck > world.time)
		usr <<"<span class='notice'>Phone seems unresponsible...</span>"
		return
	var/msg
	add_fingerprint(usr)
	var/ref_user="\ref[user]"
	msg += "<a href='?src=\ref[src];choice=red;user=[ref_user]'>Request Red code?</a><BR>"
	if(get_security_level()== "red")
		msg += "<a href='?src=\ref[src];choice=bomb;user=[ref_user]'>Request code for self destruct?</a><BR>"
	var/datum/browser/popup = new(user, "phone", "Emergency Phone")
	popup.set_content(msg)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/phone/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)
	var/ref_src = "\ref[src]"
	var/mob/user = locate(href_list["user"])
	var/ref_usr = "\ref[user]"
	if(spamcheck > world.time)
		usr <<"<span class='notice'>Phone seems unresponsible...</span>"
		return
	switch(href_list["choice"])
		if("red")
			priority_announce("[usr.name] has requested Central Command to set Code Red.", null, 'sound/AI/commandreport.ogg')
			message_admins("<span class='adminnotice'>[key_name(user)] is requesting red code. <a href='?_src_=holder;user=[ref_usr];setredcode=[ref_src]'>Set?</a> </span>")
			spamcheck = world.time + 6000
		if("bomb")
			if(codecheck > world.time)
				usr << "<span class='notice'>Central Command refuses to give you codes to self-destruct terminal. Try again later.</span>"
				return
			told_code = 0
			priority_announce("[user.name] has requested code for station self-destruct.", null, 'sound/AI/commandreport.ogg')
			var/msg = text("<span class='adminnotice'>[key_name(user)] запрашивает коды для нюки. »спользуй View Variables на консоли самоуничтожения, найди там переменную r_code, и сообщи еЄ содержимое юзеру, нажав []</span>",
							"<a href='?_src_=holder;tellcodes=[ref_src];user=[ref_usr]'>сюда</a>")
			spamcheck = world.time + 6000
			message_admins(msg)

	updateUsrDialog()

/obj/item/weapon/phone/proc/tell_code(var/msg as text, mob/user)
	if(told_code)
		return
	priority_announce("Central Command approved [user.name]'s request. Sending code now.", null, 'sound/AI/commandreport.ogg')
	src.say("Your request has been approved by Central Command, here's your code: [msg]")
	message_admins("<span class='adminnotice'>[usr.key] told (possibly) code for self-destruction: [msg]</span>")
	log_admin("[usr.key] told (possibly) code for self-destruction:'[msg]'")
	told_code = 1
