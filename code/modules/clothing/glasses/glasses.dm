/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	r_name = "мезонный сканер"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting condition."
	icon_state = "meson"
	item_state = "meson"
	origin_tech = "magnets=2;engineering=2"
	darkness_view = 2
	vision_flags = SEE_TURFS
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/meson/night
	name = "Night Vision Optical Meson Scanner"
	r_name = "мезонный сканер с прибором ночного видени&#255;"
	desc = "An Optical Meson Scanner fitted with an amplified visible light spectrum overlay, providing greater visual clarity in darkness."
	icon_state = "nvgmeson"
	item_state = "nvgmeson"
	darkness_view = 8

/obj/item/clothing/glasses/sunglasses/aviator
	desc = "Just an aviator glasses? Duh."
	name = "aviator glasses"
	icon_state = "aviator"
	item_state = "aviator"

/obj/item/clothing/glasses/meson/gar
	name = "gar mesons"
	r_name = "пафосный мезонный сканер"
	icon_state = "garm"
	item_state = "garm"
	desc = "Do the impossible, see the invisible!"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	r_name = "исследовательские очки"
	desc = "A pair of snazzy goggles used to protect against chemical spills."
	icon_state = "purple"
	item_state = "glasses"

/obj/item/clothing/glasses/night
	name = "Night Vision Goggles"
	r_name = "прибор ночного видени&#255;"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = "magnets=4"
	darkness_view = 8
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	r_name = "пиратска&#255; пов&#255;зка"
	accusative_case = "пиратскую пов&#255;зку"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/monocle
	name = "monocle"
	r_name = "монокль"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol

/obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	r_name = "сканер материи"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	origin_tech = "magnets=3;engineering=3"
	vision_flags = SEE_OBJS
	invis_view = SEE_INVISIBLE_MINIMUM

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	r_name = "очки"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"

/obj/item/clothing/glasses/regular/hipster
	name = "Prescription Glasses"
	r_name = "очки без диоптрий"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	r_name = "зеленые очки"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	r_name = "солнцезащитные очки"
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = 1
	flash_protect = 1
	tint = 1

/obj/item/clothing/glasses/sunglasses/garb
	desc = "Go beyond impossible and kick reason to the curb!"
	name = "black gar glasses"
	r_name = "пафосные очки"
	icon_state = "garb"
	item_state = "garb"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/clothing/glasses/sunglasses/garb/supergarb
	desc = "Believe in us humans."
	name = "black giga gar glasses"
	icon_state = "supergarb"
	item_state = "garb"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/sunglasses/gar
	desc = "Just who the hell do you think I am?!"
	name = "gar glasses"
	r_name = "пафосные очки"
	icon_state = "gar"
	item_state = "gar"
	force = 10
	throwforce = 10
	throw_speed = 4
	attack_verb = list("sliced")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/clothing/glasses/sunglasses/gar/supergar
	desc = "We evolve past the person we were a minute before. Little by little we advance with each turn. That's how a drill works!"
	name = "giga gar glasses"
	icon_state = "supergar"
	item_state = "gar"
	force = 12
	throwforce = 12

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	r_name = "сварочные очки"
	desc = "Protects the eyes from welders; approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Toggle Welding Goggles"
	flash_protect = 2
	tint = 2
	visor_flags = GLASSESCOVERSEYES
	visor_flags_inv = HIDEEYES


/obj/item/clothing/glasses/welding/attack_self()
	toggle()


/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	weldingvisortoggle()


/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	r_name = "пов&#255;зка на глаза"
	accusative_case = "пов&#255;зку на глаза"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
//	vision_flags = BLIND	//handled in life.dm/handle_regular_hud_updates()
	flash_protect = 2
	tint = 3			// to make them blind

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	r_name = "термальный сканер"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	origin_tech = "magnets=3"
	vision_flags = SEE_MOBS
	invis_view = 2
	flash_protect = 0

	emp_act(severity)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			if(M.glasses == src)
				M << "<span class='danger'>The Optical Thermal Scanner overloads and blinds you!</span>"
				M.eye_blind = 3
				M.eye_blurry = 5
				M.disabilities |= NEARSIGHT
				spawn(100)
					M.disabilities &= ~NEARSIGHT
		..()

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	r_name = "мезонный сканер"
	desc = "Used by engineering and mining staff to see basic structural and terrain layouts through walls, regardless of lighting condition."
	icon_state = "meson"
	origin_tech = "magnets=3;syndicate=4"
	flash_protect = -1

/obj/item/clothing/glasses/thermal/monocle
	name = "Thermoncle"
	r_name = "термальный монокль"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/thermal/eyepatch
	name = "Optical Thermal Eyepatch"
	r_name = "пиратска&#255; пов&#255;зка"
	accusative_case = "пиратскую пов&#255;зку"
	desc = "An eyepatch with built-in thermal optics."
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/cold
	name = "cold goggles"
	r_name = "морозные очки"
	desc = "A pair of goggles meant for low temperatures."
	icon_state = "cold"
	item_state = "cold"

obj/item/clothing/glasses/heat
	name = "heat goggles"
	r_name = "гор&#255;чие очки"
	desc = "A pair of goggles meant for high temperatures."
	icon_state = "heat"
	item_state = "heat"

obj/item/clothing/glasses/orange
	name = "orange glasses"
	r_name = "оранжевые очки"
	desc = "A sweet pair of orange shades."
	icon_state = "orangeglasses"
	item_state = "orangeglasses"

obj/item/clothing/glasses/red
	name = "red glasses"
	r_name = "красные очки"
	desc = "A sweet pair of red shades."
	icon_state = "redglasses"
	item_state = "redglasses"

