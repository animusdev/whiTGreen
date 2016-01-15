/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/implants.dmi'
	icon_state = "generic" //Shows up as the action button icon
	action_button_is_hands_free = 1
	origin_tech = "materials=2;biotech=3;programming=2"

	var/activated = 1 //1 for implant types that can be activated, 0 for ones that are "always on" like loyalty implants
	var/implanted = null
	var/mob/living/imp_in = null
	item_color = "b"
	var/allow_multiple = 0
	var/uses = -1


/obj/item/weapon/implant/proc/trigger(emote, mob/source)
	return


/obj/item/weapon/implant/proc/activate()
	return

/obj/item/weapon/implant/ui_action_click()
	activate("action_button")


//What does the implant do upon injection?
//return 1 if the implant injects
//return -1 if the implant fails to inject
//return 0 if there is no room for implant
/obj/item/weapon/implant/proc/implant(var/mob/source, var/mob/user)
	var/obj/item/weapon/implant/imp_e = locate(src.type) in source
	if(!allow_multiple && imp_e && imp_e != src)
		if(imp_e.uses < initial(imp_e.uses)*2)
			if(uses == -1)
				imp_e.uses = -1
			else
				imp_e.uses = min(imp_e.uses + uses, initial(imp_e.uses)*2)
			qdel(src)
			return 1
		else
			return 0


	if(activated)
		action_button_name = "Activate [src.name]"
	src.loc = source
	imp_in = source
	implanted = 1
	
	if(istype(source, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = source
		H.sec_hud_set_implants()

	if(user)
		add_logs(user, source, "implanted", object="[name]")

	return 1

/obj/item/weapon/implant/proc/removed(var/mob/source)
	src.loc = null
	imp_in = null
	implanted = 0

	if(istype(source, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = source
		H.sec_hud_set_implants()

	return 1

/obj/item/weapon/implant/proc/get_data()
	return "No information available"

/obj/item/weapon/implant/dropped(mob/user as mob)
	. = 1
	qdel(src)
	return .

/obj/item/weapon/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	activated = 0
	var/id = 1.0

/obj/item/weapon/implant/tracking/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Tracking Beacon<BR>
				<b>Life:</b> 10 minutes after death of host<BR>
				<b>Important Notes:</b> None<BR>
				<HR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
				<b>Special Features:</b><BR>
				<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
				a malfunction occurs thereby securing safety of subject. The implant will melt and
				disintegrate into bio-safe elements.<BR>
				<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
				circuitry. As a result neurotoxins can cause massive damage.<HR>
				Implant Specifics:<BR>"}
	return dat

/obj/item/weapon/implant/weapons_auth
	name = "firearms authentication implant"
	desc = "Lets you shoot your guns"
	icon_state = "auth"
	origin_tech = "materials=2;magnets=2;programming=2;biotech=5;syndicate=5"
	activated = 0

/obj/item/weapon/implant/weapons_auth/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Firearms Authentication Implant<BR>
				<b>Life:</b> 4 hours after death of host<BR>
				<b>Implant Details:</b> <BR>
				<b>Function:</b> Allows operation of implant-locked weaponry, preventing equipment from falling into enemy hands."}
	return dat

/obj/item/weapon/implant/explosive
	name = "explosive implant"
	desc = "And boom goes the weasel."
	icon_state = "explosive"
	item_color = "r"
	origin_tech = "materials=2;combat=3;biotech=4;syndicate=4"

/obj/item/weapon/implant/explosive/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Robust Corp RX-78 Employee Management Implant<BR>
				<b>Life:</b> Activates upon death.<BR>
				<b>Important Notes:</b> Explodes<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
				<b>Special Features:</b> Explodes<BR>
				<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return dat

/obj/item/weapon/implant/explosive/trigger(emote, mob/source)
	if(emote == "deathgasp")
		activate("death")

/obj/item/weapon/implant/explosive/activate(var/cause)
	if(!cause || !imp_in)	return 0
	if(cause == "action_button" && alert(imp_in, "Are you sure you want to activate your explosive implant? This will cause you to explode and gib!", "Explosive Implant Confirmation", "Yes", "No") != "Yes")
		return 0
	explosion(src,0,1,5,7,10, flame_range = 5)
	if(imp_in)
		imp_in.gib()


/obj/item/weapon/implant/chem
	name = "chem implant"
	desc = "Injects things."
	icon_state = "reagents"
	allow_multiple = 1
	origin_tech = "materials=3;biotech=4"
	flags = OPENCONTAINER

/obj/item/weapon/implant/chem/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Robust Corp MJ-300C Chemical Implant<BR>
				<b>Life:</b> Deactivates upon death but remains within the body.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small capsule that can contain various chemicals. The implant releases the chemicals directly into the blood stream.<BR>
				<b>Special Features:</b>
				<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
				<b>Integrity:</b> Implant will last so long as the subject is alive."}
	return dat

/obj/item/weapon/implant/chem/New()
	..()
	create_reagents(50)

/obj/item/weapon/implant/chem/trigger(emote, mob/source)
	if(emote == "deathgasp")
		activate(reagents.total_volume)

/obj/item/weapon/implant/chem/activate(var/cause)
	if(!cause || !imp_in)	return 0
	var/mob/living/carbon/R = imp_in
	var/injectamount = null
	if (cause == "action_button")
		injectamount = reagents.total_volume
	else
		injectamount = cause
	reagents.trans_to(R, injectamount)
	R << "<span class='italics'>You hear a faint beep.</span>"
	if(!reagents.total_volume)
		R << "<span class='italics'>You hear a faint click from your chest.</span>"
		qdel(src)

/obj/item/weapon/implant/chem/security/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Robust Corp MJ-420 Prisoner Management Implant<BR>
				<b>Life:</b> Deactivates upon death but remains within the body.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small capsule that can contain various chemicals. Upon receiving a specially encoded signal<BR>
				the implant releases the chemicals directly into the blood stream.<BR>
				<b>Special Features:</b>
				<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
				<b>Integrity:</b> Implant will last so long as the subject is alive."}
	return dat

/obj/item/weapon/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0


/obj/item/weapon/implant/loyalty/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Management Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
				<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
				<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat


/obj/item/weapon/implant/loyalty/implant(mob/target)
	if(..())
		if((target.mind in (ticker.mode.head_revolutionaries | ticker.mode.A_bosses | ticker.mode.B_bosses)) || is_shadow_or_thrall(target))
			target.visible_message("<span class='warning'>[target] seems to resist the implant!</span>",
				"<span class='warning'>You feel the corporate tendrils of Nanotrasen try to invade your mind!</span>")
			qdel(src)
			return -1
		if(target.mind in (ticker.mode.A_gang | ticker.mode.B_gang))
			ticker.mode.remove_gangster(target.mind, exclude_bosses=0)
			qdel(src)
			return -1
		if(target.mind in ticker.mode.revolutionaries)
			ticker.mode.remove_revolutionary(target.mind)
		target << "<span class='notice'>You feel a surge of loyalty towards Nanotrasen.</span>"
		return 1
	return 0

/obj/item/weapon/implant/loyalty/removed(mob/target)
	if(..())
		target << "<span class='notice'><b>You feel a sense of liberation as Nanotrasen's grip on your mind fades away.</b></span>"
		return 1
	return 0


/obj/item/weapon/implant/adrenalin
	name = "adrenal implant"
	desc = "Removes all stuns and knockdowns."
	icon_state = "adrenal"
	origin_tech = "materials=2;biotech=4;combat=3;syndicate=3"
	item_color = "r"
	uses = 3

/obj/item/weapon/implant/adrenalin/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Cybersun Industries Adrenaline Implant<BR>
				<b>Life:</b> Five days.<BR>
				<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
				<HR>
				<b>Implant Details:</b> Subjects injected with implant can activate an injection of medical cocktails.<BR>
				<b>Function:</b> Removes stuns, increases speed, and has a mild healing effect.<BR>
				<b>Integrity:</b> Implant can only be used three times before reserves are depleted."}
	return dat

/obj/item/weapon/implant/adrenalin/activate()
	if(uses == 0)	return 0
	if(uses != -1)	uses--

	imp_in << "<span class='notice'>You feel a sudden surge of energy!</span>"
	imp_in.SetStunned(0)
	imp_in.SetWeakened(0)
	imp_in.SetParalysis(0)
	imp_in.adjustStaminaLoss(-75)
	imp_in.lying = 0
	imp_in.update_canmove()

	imp_in.reagents.add_reagent("synaptizine", 10)
	imp_in.reagents.add_reagent("omnizine", 10)
	imp_in.reagents.add_reagent("stimulants", 10)


/obj/item/weapon/implant/emp
	name = "emp implant"
	desc = "Triggers an EMP."
	icon_state = "emp"
	origin_tech = "materials=2;biotech=3;magnets=4;syndicate=4"
	item_color = "r"

	uses = 2

/obj/item/weapon/implant/emp/activate()
	if(uses == 0)	return 0
	if(uses != -1)	uses--

	empulse(imp_in, 3, 5)
