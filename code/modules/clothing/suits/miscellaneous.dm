/*
 * Contains:
 *		Lasertag
 *		Costume
 *		Misc
 */

/*
 * Lasertag
 */

/obj/item/clothing/suit/bluetag
	name = "blue laser tag armor"
	r_name = "áðîí&#255; äë&#255; ëàçåðòàãà"
	accusative_case = "áðîíþ äë&#255; ëàçåðòàãà"
	desc = "A piece of plastic armor. It has sensors that react to red light." //Lasers are concentrated light
	icon_state = "bluetag"
	item_state = "bluetag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/weapon/gun/energy/laser/bluetag)

/obj/item/clothing/suit/redtag
	name = "red laser tag armor"
	r_name = "áðîí&#255; äë&#255; ëàçåðòàãà"
	accusative_case = "áðîíþ äë&#255; ëàçåðòàãà"
	desc = "A piece of plastic armor. It has sensors that react to blue light."
	icon_state = "redtag"
	item_state = "redtag"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/weapon/gun/energy/laser/redtag)

/*
 * Costume
 */
/obj/item/clothing/suit/bear_pjs
	name = "bear pajamas"
	r_name = "ïèæàìà ìåäâåæîíêà"
	accusative_case = "ïèæàìó ìåäâåæîíêà"
	desc = "I am fallen. I am faded. I have lost it all."
	icon_state = "bear_pajamas"
	item_state = "bear_pajamas"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = BLOCKHAIR


/obj/item/clothing/suit/pirate
	name = "pirate coat"
	r_name = "ïèðàòñêèé ìóíäèð"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"


/obj/item/clothing/suit/hgpirate
	name = "pirate captain coat"
	r_name = "ïèðàòñêèé ìóíäèð"
	desc = "Yarr."
	icon_state = "hgpirate"
	item_state = "hgpirate"
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/cyborg_suit
	name = "cyborg suit"
	r_name = "êîñòþì êèáîðãà"
	desc = "Suit for a cyborg costume."
	icon_state = "death"
	item_state = "death"
	flags = CONDUCT
	fire_resist = T0C+5200
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/judgerobe
	name = "judge's robe"
	r_name = "ìàíòè&#255; ñóäüè"
	accusative_case = "ìàíòèþ ñóäüè"
	desc = "This robe commands authority."
	icon_state = "judge"
	item_state = "judge"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/weapon/storage/fancy/cigarettes,/obj/item/stack/spacecash)
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/apron/overalls
	name = "coveralls"
	r_name = "ôàðòóê"
	desc = "A set of denim overalls."
	icon_state = "overalls"
	item_state = "overalls"
	body_parts_covered = CHEST|GROIN|LEGS


/obj/item/clothing/suit/syndicatefake
	name = "black and red space suit replica"
	r_name = "èãðóøå÷íûé ñêàôàíäð"
	icon_state = "syndicate-black-red"
	item_state = "syndicate-black-red"
	desc = "A plastic replica of the Syndicate space suit. You'll look just like a real murderous Syndicate agent in this! This is a toy, it is not made for use in space!"
	w_class = 3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/hastur
	name = "\improper Hastur's robe"
	desc = "Robes not meant to be worn by man."
	icon_state = "hastur"
	item_state = "hastur"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "\improper Imperium monk suit"
	r_name = "êîñòþì Èìïåðñêîãî ìîíàõà"
	desc = "Have YOU killed a xeno today?"
	icon_state = "imperium_monk"
	item_state = "imperium_monk"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/internals/emergency_oxygen)
	pocket = /obj/item/weapon/storage/internal/pocket


/obj/item/clothing/suit/chickensuit
	name = "chicken suit"
	r_name = "êîñòþì ïåòóõà"
	desc = "A suit made long ago by the ancient empire KFC."
	icon_state = "chickensuit"
	item_state = "chickensuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET
	flags_inv = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/monkeysuit
	name = "monkey suit"
	r_name = "êîñòþì îáåçü&#255;íû"
	desc = "A suit that looks like a primate."
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS|FEET|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/toggle/owlwings
	name = "owl cloak"
	r_name = "êîñòþì ñîâû"
	desc = "A soft brown cloak made of synthetic feathers. Soft to the touch, stylish, and a 2 meter wing span that will drive the ladies mad."
	icon_state = "owl_wings"
	item_state = "owl_wings"
	togglename = "wings"
	body_parts_covered = ARMS|CHEST
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)
	action_button_name = "Toggle Owl Wings"

/obj/item/clothing/suit/toggle/owlwings/griffinwings
	name = "griffon cloak"
	r_name = "êîñòþì ãðèôîíà"
	desc = "A plush white cloak made of synthetic feathers. Soft to the touch, stylish, and a 2 meter wing span that will drive your captives mad."
	icon_state = "griffin_wings"
	item_state = "griffin_wings"


/obj/item/clothing/suit/holidaypriest
	name = "holiday priest"
	r_name = "ïðàçäíè÷íà&#255; ðîáà"
	accusative_case = "ïðàçäíè÷íóþ ðîáó"
	desc = "This is a nice holiday, my son."
	icon_state = "holidaypriest"
	item_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/storage/book/bible, /obj/item/weapon/nullrod, /obj/item/weapon/reagent_containers/food/drinks/bottle/holywater, /obj/item/weapon/storage/fancy/candle_box, /obj/item/candle, /obj/item/weapon/tank/internals/emergency_oxygen)
	pocket = /obj/item/weapon/storage/internal/pocket


/obj/item/clothing/suit/cardborg
	name = "cardborg suit"
	r_name = "êàðòîííà&#255; áðîí&#255;"
	accusative_case = "êàðòîííóþ áðîíþ"
	desc = "An ordinary cardboard box with holes cut in the sides."
	icon_state = "cardborg"
	item_state = "cardborg"
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/poncho
	name = "poncho"
	r_name = "ïîí÷î"
	desc = "Your classic, non-racist poncho."
	icon_state = "classicponcho"
	item_state = "classicponcho"

/obj/item/clothing/suit/poncho/green
	name = "green poncho"
	desc = "Your classic, non-racist poncho. This one is green."
	icon_state = "greenponcho"
	item_state = "greenponcho"

/obj/item/clothing/suit/poncho/red
	name = "red poncho"
	desc = "Your classic, non-racist poncho. This one is red."
	icon_state = "redponcho"
	item_state = "redponcho"

/obj/item/clothing/suit/poncho/rainbow
	name = "rainbow poncho"
	desc = "Your classic, non-racist poncho. This one is rainbow."
	icon_state = "poncho"
	item_state = "poncho"


/obj/item/clothing/suit/poncho/ponchoshame
	name = "poncho of shame"
	desc = "Forced to live on your shameful acting as a fake Mexican, you and your poncho have grown inseperable. Literally."
	icon_state = "ponchoshame"
	item_state = "ponchoshame"
	flags = NODROP

/obj/item/clothing/suit/whitedress
	name = "white dress"
	r_name = "áåëîå ïëàòüå"
	desc = "A fancy white dress."
	icon_state = "white_dress"
	item_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	flags_inv = HIDEJUMPSUIT|HIDESHOES


/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "straight jacket"
	r_name = "ñìèðèòåëüíà&#255; ðóáàøêà"
	accusative_case = "ñìèðèòåëüíóþ ðóáàøêó"
	desc = "A suit that completely restrains the wearer. Manufactured by Antyphun Corp." //Straight jacket is antifun
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	strip_delay = 60

/obj/item/clothing/suit/ianshirt
	name = "worn shirt"
	r_name = "ôóòáîëêà"
	accusative_case = "ôóòáîëêó"
	desc = "A worn out, curiously comfortable t-shirt with a picture of Ian. You wouldn't go so far as to say it feels like being hugged when you wear it, but it's pretty close. Good for sleeping in."
	icon_state = "ianshirt"
	item_state = "ianshirt"

/obj/item/clothing/suit/nerdshirt
	name = "gamer shirt"
	r_name = "ôóòáîëêà"
	accusative_case = "ôóòáîëêó"
	desc = "A baggy shirt with vintage game character Phanic the Weasel. Why would anyone wear this?"
	icon_state = "nerdshirt"
	item_state = "nerdshirt"

/obj/item/clothing/suit/jacket
	name = "bomber jacket"
	r_name = "áîìáåð"
	desc = "Aviators not included."
	icon_state = "bomberjacket"
	item_state = "brownjsuit"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/jacket/leather
	name = "leather jacket"
	r_name = "êîæàíûé ïèäæàê"
	desc = "Pompadour not included."
	icon_state = "leatherjacket"

/obj/item/clothing/suit/jacket/puffer
	name = "ïóõîâèê"
	name = "puffer jacket"
	desc = "A thick jacket with a rubbery, water-resistant shell."
	icon_state = "pufferjacket"
	item_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/jacket/puffer/vest
	name = "puffer vest"
	desc = "A thick vest with a rubbery, water-resistant shell."
	icon_state = "puffervest"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)

/obj/item/clothing/suit/vest/SOA
	name = "SOA vest"
	icon_state = "soa_vest"
	item_state = "soa_vest"


/obj/item/clothing/suit/xenos
	name = "xenos suit"
	r_name = "êîñòþì êñåíîìîðôà"
	desc = "A suit made out of chitinous alien hide."
	icon_state = "xenos"
	item_state = "xenos_helm"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

// WINTER COATS

/obj/item/clothing/suit/hooded/wintercoat
	name = "winter coat"
	r_name = "çèìí&#255;&#255; êóðòêà"
	accusative_case = "çèìíþþ êóðòêó"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	item_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter)
	hooded = 1
	action_button_name = "Toggle Winter Hood"

/obj/item/clothing/head/winterhood
	name = "winter hood"
	r_name = "ò¸ïëûé êàïþøîí"
	desc = "A hood attached to a heavy winter jacket."
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags = NODROP

/obj/item/clothing/suit/hooded/wintercoat/captain
	name = "captain's winter coat"
	icon_state = "coatcaptain"
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)

/obj/item/clothing/suit/hooded/wintercoat/security
	name = "security winter coat"
	icon_state = "coatsecurity"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)

/obj/item/clothing/suit/hooded/wintercoat/medical
	name = "medical winter coat"
	icon_state = "coatmedical"
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/melee/classic_baton/telescopic)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/hooded/wintercoat/science
	name = "science winter coat"
	icon_state = "coatscience"
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper,/obj/item/weapon/melee/classic_baton/telescopic)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/hooded/wintercoat/engineering
	name = "engineering winter coat"
	icon_state = "coatengineer"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/device/t_scanner, /obj/item/weapon/rcd)

/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	icon_state = "coatatmos"

/obj/item/clothing/suit/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	icon_state = "coathydro"
	allowed = list(/obj/item/weapon/reagent_containers/spray/plantbgone,/obj/item/device/analyzer/plant_analyzer,/obj/item/seeds,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/cultivator,/obj/item/weapon/reagent_containers/spray/pestspray,/obj/item/weapon/hatchet,/obj/item/weapon/storage/bag/plants)

/obj/item/clothing/suit/hooded/wintercoat/cargo
	name = "cargo winter coat"
	icon_state = "coatcargo"

/obj/item/clothing/suit/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	allowed = list(/obj/item/weapon/pickaxe,/obj/item/device/flashlight,/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/toy,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter)
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)


/obj/item/clothing/suit/leathercoat
	r_name = "êîæàííûé ïëàù"
	name = "leather coat"
	desc = "A long, thick black leather coat."
	icon_state = "leathercoat"
	item_state = "leathercoat"

/obj/item/clothing/suit/kimono
	r_name = "êèìîíî"
	name = "Sakura Kimono"
	desc = "A pale-pink, nearly white, kimono with a red and gold obi. There is a embroidered design of cherry blossom flowers covering the kimono."
	icon_state = "kimono"
	item_state = "kimono"

/obj/item/clothing/suit/toggle/hoodie
	r_name = "òîëñòîâêà"
	name = "grey hoodie"
	desc = "A warm, grey sweatshirt."
	icon_state = "grey_hoodie"
	item_state = "grey_hoodie"
	min_cold_protection_temperature = T0C - 20
	togglename = "zipper"
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/toggle/hoodie/black
	name = "black hoodie"
	desc = "A warm, black sweatshirt."
	icon_state = "black_hoodie"
	item_state = "black_hoodie"

/obj/item/clothing/suit/inflatable_duck
	r_name = "ñïàñàòåëüíûé êðóã"
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"

/obj/item/clothing/suit/sweater
	r_name = "ñâèòåð"
	name = "blue sweater"
	icon_state = "sweater_blue"
	item_state = "sweater_blue"
	min_cold_protection_temperature = T0C - 20
	body_parts_covered = CHEST|ARMS
	cold_protection = CHEST|ARMS

/obj/item/clothing/suit/sweater/green
	name = "green sweater"
	icon_state = "sweater_green"
	item_state = "sweater_green"

/obj/item/clothing/suit/sweater/red
	name = "red sweater"
	icon_state = "sweater_red"
	item_state = "sweater_red"


/obj/item/clothing/suit/adeptus
	name = "adeptus suit"
	icon_state = "adeptus"
	item_state = "adeptus"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = BLOCKHAIR

/obj/item/clothing/suit/batman
	r_name = "êîñòþì áåòìåíà"
	name = "bat-suit"
	icon_state = "batsuit"
	item_state = "batsuit"
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/robe
	name = "robe"
	flags_inv = HIDEJUMPSUIT
	flags = BLOCKHAIR