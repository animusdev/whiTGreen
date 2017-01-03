/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/attackby(var/obj/item/weapon/W, mob/living/user, params)
	if(istype(W, /obj/item/weapon/wrench))
		user << "<span class='notice'>You start disassembling [src]...</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 10))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			qdel(src)
			return

/obj/structure/sign/ex_act(severity, target)
	qdel(src)

/obj/structure/sign/blob_act()
	qdel(src)
	return

/obj/structure/sign/portrait
	name = "portrait"
	desc = "A portrait of the glorious assistant."
	icon_state = "portrait"
	var/blesses = 1

/obj/structure/sign/portrait/rodger
	desc = "Красивое мужественное лицо сурово взирает на вас с картины. Этот человек внушает страх, уважение и необъ&#255;снимо сильную симпатию."
	icon_state = "portrait-rodger"

/obj/structure/sign/portrait/rodger/attackby(var/obj/item/weapon/W, mob/living/user, params)
	if(istype(W,/obj/item/weapon/extinguisher))
		if(blesses > 0)
			user << "<span class='userdanger'>¤ Боги благовол&#255;т вам!</span>"
			new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass/milky(user.loc)
			blesses--
		else
			user.visible_message("<span class='warning'>¤ Вам на миг почудилось, будто [user] ударило молнией. Боги не люб&#255;т жадин.</span>", \
								 "<span class='userdanger'>¤ Боги не оценили вашу жадность!</span>")
			playsound(loc, 'sound/effects/sparks1.ogg', 50, 1)
			user.adjustBrainLoss(5)
			user.Weaken(3)

/obj/structure/sign/portrait/ruben
	desc = "Какой н&#255;шечка! Томный образ этого оба&#255;тельного джентльмена делает ваши трусики насквозь мокрыми."
	icon_state = "portrait-ruben1"

/obj/structure/sign/portrait/ruben/attackby(var/obj/item/weapon/W, mob/living/user, params)
	if(istype(W,/obj/item/weapon/extinguisher))
		if(blesses > 0)
			user << "<span class='userdanger'>¤ Боги благовол&#255;т вам!</span>"
			new /obj/item/clothing/head/collectable/kitty(user.loc)
			blesses--
		else
			user.visible_message("<span class='warning'>¤ Вам на миг почудилось, будто [user] ударило молнией. Боги не люб&#255;т жадин.</span>", \
								 "<span class='userdanger'>¤ Боги не оценили вашу жадность!</span>")
			playsound(loc, 'sound/effects/sparks1.ogg', 50, 1)
			user.adjustBrainLoss(5)
			user.Weaken(3)

/obj/structure/sign/portrait/bisher
	desc = "Гордый взгл&#255;д бывалого солдата, армейска&#255; выправка, мускулиста&#255; ше&#255;. Вы почти ощущаете запах напалма, источаемый портретом."
	icon_state = "portrait-bishehlop"

/obj/structure/sign/portrait/bisher/attackby(var/obj/item/weapon/W, mob/living/user, params)
	if(istype(W,/obj/item/weapon/extinguisher))
		if(blesses > 0)
			user << "<span class='userdanger'>¤ Боги благовол&#255;т вам!</span>"
			new /obj/item/clothing/glasses/eyepatch(user.loc)
			blesses--
		else
			user.visible_message("<span class='warning'>¤ Вам на миг почудилось, будто [user] ударило молнией. Боги не люб&#255;т жадин.</span>", \
								 "<span class='userdanger'>¤ Боги не оценили вашу жадность!</span>")
			playsound(loc, 'sound/effects/sparks1.ogg', 50, 1)
			user.adjustBrainLoss(5)
			user.Weaken(3)

/obj/structure/sign/portrait/bisher/examine(mob/user)
	..()
	user.emote("salute")


/obj/structure/sign/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/map/left
	icon_state = "map-left"

/obj/structure/sign/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'"
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'"
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM ROOM"
	desc = "A guidance sign which reads 'EXAM ROOM'"
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL: LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL: LEADS TO SPACE'"
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'"
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'"
	icon_state = "fire"


/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking"


/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking2"

/obj/structure/sign/bluecross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "bluecross"

/obj/structure/sign/bluecross_2
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'"
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'"
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'"
	icon_state = "hydro1"

/obj/structure/sign/directions/science
	name = "science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "medical bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "escape arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"