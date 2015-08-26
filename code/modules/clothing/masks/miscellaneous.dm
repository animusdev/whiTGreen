/obj/item/clothing/mask/muzzle
	name = "muzzle"
	r_name = "кл&#255;п"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "blindfold"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	put_on_delay = 20

/obj/item/clothing/mask/muzzle/attack_paw(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.wear_mask)
			user << "<span class='warning'>You need help taking this off!</span>"
			return
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	r_name = "стерильна&#255; маска"
	accusative_case = "стерильную маску"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = 1
	flags = MASKCOVERSMOUTH
	flags_inv = HIDEFACE
	visor_flags = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 25, rad = 0)
	action_button_name = "Adjust Sterile Mask"
	ignore_maskadjust = 0

/obj/item/clothing/mask/surgical/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	r_name = "усы"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE

/obj/item/clothing/mask/pig
	name = "pig mask"
	r_name = "маска свиньи"
	accusative_case = "маску свиньи"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags = BLOCKHAIR
	flags_inv = HIDEEYES|HIDEFACE
	w_class = 2
	action_button_name = "Toggle Voice Box"
	var/voicechange = 0

/obj/item/clothing/mask/pig/attack_self(mob/user)
	voicechange = !voicechange
	user << "<span class='notice'>You turn the voice box [voicechange ? "on" : "off"]!</span>"

/obj/item/clothing/mask/pig/speechModification(message)
	if(voicechange)
		message = pick("Хрю!","Вииииииииии!","Хрю-хрю!")
	return message

/obj/item/clothing/mask/spig //needs to be different otherwise you could turn the speedmodification off and on
	name = "Pig face"
	r_name = "маска свиньи"
	accusative_case = "маску свиньи"
	desc = "It looks like a mask, but closer inspection reveals it's melded onto this persons face!" //It's only ever going to be attached to your face.
	icon_state = "pig"
	item_state = "pig"
	flags = BLOCKHAIR
	flags_inv = HIDEEYES|HIDEFACE
	w_class = 2
	var/voicechange = 1

/obj/item/clothing/mask/spig/speechModification(message)
	if(voicechange)
		message = pick("Oink!","Squeeeeeeee!","Oink Oink!")
	return message

/obj/item/clothing/mask/cowmask
	name = "Cowface"
	r_name = "маска коровы"
	accusative_case = "маску коровы"
	desc = "It looks like a mask, but closer inspection reveals it's melded onto this persons face!"
	icon = 'icons/mob/mask.dmi'
	icon_state = "cowmask"
	item_state = "cowmask"
	flags = BLOCKHAIR
	flags_inv = HIDEEYES|HIDEFACE
	w_class = 2
	var/voicechange = 1

/obj/item/clothing/mask/cowmask/speechModification(message)
	if(voicechange)
		message = pick("Муууууууу!","Муу!","Муууу!")
	return message

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	r_name = "маска лошади"
	accusative_case = "маску лошади"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags = BLOCKHAIR
	flags_inv = HIDEEYES|HIDEFACE
	w_class = 2
	var/voicechange = 1

/obj/item/clothing/mask/horsehead/speechModification(message)
	if(voicechange)
		message = pick("Иииии-го-го!", "Пррр!", "Иииииаааа!")
	return message

/obj/item/clothing/mask/bandana
	name = "botany bandana"
	r_name = "бандана"
	accusative_case = "бандану"
	desc = "A fine bandana with nanotech lining and a hydroponics pattern."
	w_class = 1
	flags = MASKCOVERSMOUTH
	flags_inv = HIDEFACE
	visor_flags = MASKCOVERSMOUTH
	visor_flags_inv = HIDEFACE
	slot_flags = SLOT_MASK
	ignore_maskadjust = 0
	adjusted_flags = SLOT_HEAD
	icon_state = "bandbotany"

/obj/item/clothing/mask/bandana/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	desc = "A fine red bandana with nanotech lining."
	icon_state = "bandred"

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	desc = "A fine blue bandana with nanotech lining."
	icon_state = "bandblue"

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	desc = "A fine green bandana with nanotech lining."
	icon_state = "bandgreen"

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	desc = "A fine gold bandana with nanotech lining."
	icon_state = "bandgold"

/obj/item/clothing/mask/bandana/black
	name = "black bandana"
	desc = "A fine black bandana with nanotech lining."
	icon_state = "bandblack"

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem."
	icon_state = "bandskull"