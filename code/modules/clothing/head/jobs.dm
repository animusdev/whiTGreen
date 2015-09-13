
//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	r_name = "поварский колпак"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chef"
	item_state = "chef"
	desc = "The commander in chef's head wear."
	strip_delay = 10
	put_on_delay = 10

//Captain
/obj/item/clothing/head/caphat
	name = "captain's hat"
	r_name = "капитанска&#255; шл&#255;па"
	accusative_case = "капитанскую шл&#255;пу"
	desc = "It's good being the king."
	icon_state = "captain"
	item_state = "that"
	flags_inv = 0
	armor = list(melee = 70, bullet = 50, laser = 70, energy = 15, bomb = 25, bio = 0, rad = 0)
	strip_delay = 60

//Captain: This is no longer space-worthy
/obj/item/clothing/head/caphat/parade
	name = "captain's parade cap"
	r_name = "капитанска&#255; парадна&#255; фуражка"
	accusative_case = "капитанскую парадную фуражку"
	desc = "Worn only by Captains with an abundance of class."
	icon_state = "capcap"


//Head of Personnel
/obj/item/clothing/head/hopcap
	name = "head of personnel's cap"
	r_name = "фуражка"
	accusative_case = "фуражку"
	icon_state = "hopcap"
	desc = "The symbol of true bureaucratic micromanagement."
	armor = list(melee = 50, bullet = 25, laser = 25, energy = 15, bomb = 25, bio = 0, rad = 0)

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	r_name = "клобук"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags = HEADCOVERSEYES|BLOCKHAIR

/obj/item/clothing/head/det_hat
	name = "detective's fedora"
	r_name = "федора"
	accusative_case = "федору"
	desc = "There's only one man who can sniff out the dirty stench of crime, and he's likely wearing this hat."
	icon_state = "detective"
	armor = list(melee = 50, bullet = 50, laser = 25, energy = 10, bomb = 25, bio = 0, rad = 0)
	pocket = /obj/item/weapon/storage/internal/pocket/small/detective

//Mime
/obj/item/clothing/head/beret
	r_name = "берет"
	name = "beret"
	desc = "A beret, a mime's favorite headwear."
	icon_state = "beret"

//Security

/obj/item/clothing/head/HoS
	name = "head of security cap"
	r_name = "фуражка лейтенанта"
	accusative_case = "фуражку лейтенанта"
	desc = "The robust standard-issue cap of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoscap"
	armor = list(melee = 70, bullet = 50, laser = 70,energy = 15, bomb = 25, bio = 0, rad = 0)
	strip_delay = 80

/obj/item/clothing/head/HoS/beret
	name = "head of security beret"
	r_name = "берет лейтенанта"
	desc = "A robust beret for the Head of Security, for looking stylish while not sacrificing protection."
	icon_state = "hosberetblack"

/obj/item/clothing/head/HoS/dermal
	name = "Dermal Armour Patch"
	r_name = "дермальный патч"
	desc = "You're not quite sure how you manage to take it on and off, but it implants nicely in your head."
	icon_state = "dermal"

/obj/item/clothing/head/warden
	name = "warden's police hat"
	r_name = "фуражка сержанта"
	accusative_case = "фуражку сержанта"
	desc = "It's a special armored hat issued to the Warden of a security force. Protects the head from impacts."
	icon_state = "policehelm"
	armor = list(melee = 60, bullet = 40, laser = 60, energy = 15, bomb = 25, bio = 0, rad = 0)
	strip_delay = 60

/obj/item/clothing/head/beret/sec
	name = "security beret"
	r_name = "офицерский берет"
	desc = "A robust beret with the security insignia emblazoned on it. Uses reinforced fabric to offer sufficent protection."
	icon_state = "beret_badge"
	armor = list(melee = 40, bullet = 25, laser = 40, energy = 15, bomb = 25, bio = 0, rad = 0)
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyhos
	name = "head of security's beret"
	r_name = "берет лейтенанта"
	desc = "A special beret with the Head of Security's insignia emblazoned on it. A symbol of excellence, a badge of courage, a mark of distinction."
	armor = list(melee = 70, bullet = 50, laser = 70,energy = 15, bomb = 25, bio = 0, rad = 0)
	strip_delay = 80
	icon_state = "hosberet"

/obj/item/clothing/head/beret/sec/navywarden
	name = "warden's beret"
	r_name = "берет сержанта"
	desc = "A special beret with the Warden's insignia emblazoned on it. For wardens with class."
	icon_state = "wardenberet"
	armor = list(melee = 60, bullet = 40, laser = 60, energy = 15, bomb = 25, bio = 0, rad = 0)
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "A special beret with the security insignia emblazoned on it. For officers with class."
	armor = list(melee = 40, bullet = 25, laser = 40, energy = 15, bomb = 25, bio = 0, rad = 0)
	icon_state = "officerberet"

/obj/item/clothing/head/beret/sec/greenberet
	icon_state = "greenberet"