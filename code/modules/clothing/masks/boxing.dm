/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	visor_flags_inv = HIDEFACE
	w_class = 2
	action_button_name = "Adjust Balaclava"
	ignore_maskadjust = 0

/obj/item/clothing/mask/balaclava/attack_self(var/mob/user)
	adjustmask(user)

/obj/item/clothing/mask/balaclava/tactical
	name = "balaclava camo"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon_state = "swatclava"
	item_state = "salaclava"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/balaclava/zhan_scarf
	name = "scarf"
	desc = "Warm white scarf. Used by ISIS combatants to hide identity."
	icon_state = "zhan_scarf"


/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2

/obj/item/clothing/mask/luchador/speechModification(message)
	if(copytext(message, 1, 2) != "*")
		message = replacetext(message, "captain", "CAPITБN")
		message = replacetext(message, "station", "ESTACIУN")
		message = replacetext(message, "sir", "SEСOR")
		message = replacetext(message, "the ", "el ")
		message = replacetext(message, "my ", "mi ")
		message = replacetext(message, "is ", "es ")
		message = replacetext(message, "it's", "es")
		message = replacetext(message, "friend", "amigo")
		message = replacetext(message, "buddy", "amigo")
		message = replacetext(message, "hello", "hola")
		message = replacetext(message, " hot", " caliente")
		message = replacetext(message, " very ", " muy ")
		message = replacetext(message, "sword", "espada")
		message = replacetext(message, "library", "biblioteca")
		message = replacetext(message, "traitor", "traidor")
		message = replacetext(message, "wizard", "mago")
		message = uppertext(message)	//Things end up looking better this way (no mixed cases), and it fits the macho wrestler image.
		if(prob(25))
			message += " OLE!"
	return message

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchar"
	item_state = "luchar"