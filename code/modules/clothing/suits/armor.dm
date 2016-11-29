/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/device/flashlight/seclite,/obj/item/weapon/melee/classic_baton/telescopic)
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	put_on_delay = 40
	burn_state = -1

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "A slim armored vest that protects against most types of damage."
	icon_state = "secmediumvest"
	item_state = "secmediumvest"
	blood_overlay_type = "armor"
	armor = list(melee = 40, bullet = 25, laser = 50, energy = 15, bomb = 25, bio = 0, rad = 0)
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/swat
	name = "Special Weapons And Tactics sniper west"
	desc = "Used by snipers and saboteurs among the station. Has an additional pockets for great stuff like C-4 and another stuff"
	icon_state = "specnaz"
	item_state = "specnaz"
	armor = list(melee = 45, bullet = 45, laser = 50, energy = 25, bomb = 25, bio = 0, rad = 0)
	pocket = /obj/item/weapon/storage/internal/pocket/razgruzka

/obj/item/clothing/suit/armor/vest/loshok
	name = "Bartender armor"
	desc = "An armored vest without kevlar. Just for stylish, not for potection"
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"

/obj/item/clothing/suit/armor/deltaforce
	name = "Delta Force vest"
	desc = "Armor for graduated top in the Navy Seals"
	icon_state = "delta"
	item_state = "delta"
	blood_overlay_type = "armor"
	armor = list(melee = 75,bullet = 75, laser = 75, energy = 75, bomb = 75, bio = 100, rad = 100)
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/deltaforce/commander
	name = "Delta Force commander vest"
	desc = "Armor for graduated top in the Navy Seals"
	icon_state = "delta1"
	item_state = "delta1"

/obj/item/clothing/suit/armor/deltaforce/med
	name = "Delta Force medical vest"
	desc = "Armor for graduated top in the Navy Seals"
	icon_state = "delta2"
	item_state = "delta2"

/obj/item/clothing/suit/armor/vest/jacket
	name = "military jacket"
	desc = "An old military jacket, it has armoring."
	icon_state = "militaryjacket"
	item_state = "militaryjacket"
	body_parts_covered = CHEST|ARMS
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/hos
	name = "armored greatcoat"
	desc = "A greatcoat enchanced with a special alloy for some protection and style for those with a commanding presence."
	icon_state = "hos"
	item_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(melee = 60, bullet = 50, laser = 70, energy = 15, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	pocket = /obj/item/weapon/storage/internal/pocket
	strip_delay = 80

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "armored trenchoat"
	desc = "A trenchcoat enchanced with a special lightweight kevlar. The epitome of tactical plainclothes."
	icon_state = "hostrench"
	item_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "A red jacket with silver rank pips and body armor strapped on top."
	icon_state = "warden_jacket"
	item_state = "armor"
	armor = list(melee = 50, bullet = 40, laser = 60, energy = 15, bomb = 25, bio = 0, rad = 0)
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	pocket = /obj/item/weapon/storage/internal/pocket
	strip_delay = 70
	burn_state = 0

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "warden's armored jacket"
	desc = "A navy-blue armored jacket with blue shoulder designations and '/Warden/' stitched into one of the chest pockets."
	icon_state = "warden_alt"


/obj/item/clothing/suit/armor/vest/capcarapace
	name = "captain's carapace"
	desc = "An armored vest reinforced with ceramic plates and pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon_state = "capcarapace"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(melee = 70, bullet = 50, laser = 70, energy = 15, bomb = 25, bio = 0, rad = 0)


/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	slowdown = 1
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 85, bullet = 20, laser = 20, energy = 20, bomb = 40, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	strip_delay = 80
	put_on_delay = 60

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof armor"
	desc = "A bulletproof vest that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 20, bullet = 90, laser = 20, energy = 15, bomb = 40, bio = 0, rad = 0)
	strip_delay = 70
	put_on_delay = 50

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles, as well as occasionally reflecting them."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 20, bullet = 20, laser = 90, energy = 75, bomb = 0, bio = 0, rad = 0)
	var/hit_reflect_chance = 40

/obj/item/clothing/suit/armor/laserproof/IsReflect(var/def_zone)
	if(!(def_zone in list("chest", "groin"))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		hit_reflect_chance = 0
	if (prob(hit_reflect_chance))
		return 1

/obj/item/clothing/suit/armor/vest/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	armor = list(melee = 40, bullet = 60, laser = 20, energy = 10, bomb = 40, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/tank/internals/emergency_oxygen,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)
	pocket = /obj/item/weapon/storage/internal/pocket
	burn_state = 0


//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone seperated our Research Director from his own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	action_button_name = "Toggle Armor"
	unacidable = 1

/obj/item/clothing/suit/armor/reactive/IsShield()
	if(active)
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "<span class='notice'>[src] is now active.</span>"
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		user << "<span class='notice'>[src] is now inactive.</span>"
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()


//All of the armor below is mostly unused


/obj/item/clothing/suit/armor/centcom
	name = "\improper Centcom armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals/emergency_oxygen)
	flags = THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit"
	desc = "Pukish armor."	//classy.
	icon_state = "tdgreen"
	item_state = "tdgreen"


/obj/item/clothing/suit/armor/vest/secnew/heavy
	name = "heavy armor vest"
	desc = "A heavy kevlar plate carrier with webbing attached."
	icon_state = "webvest"
	item_state = "webvest"
	armor = list(melee = 65, bullet = 55, laser = 55, energy = 45, bomb = 35, bio = 0, rad = 0)
	pocket = /obj/item/weapon/storage/internal/pocket

/obj/item/clothing/suit/armor/vest/secnew/heavy/merc
	name = "heavy armor vest"
	desc = "A high-quality heavy kevlar plate carrier in a fetching tan. The vest is surprisingly flexible, and possibly made of an advanced material."
	icon_state = "mercwebvest"
	item_state = "mercwebvest"
	armor = list(melee = 70, bullet = 80, laser = 70, energy = 55, bomb = 60, bio = 0, rad = 0)
	slowdown = 0
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword/saber,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals)


/obj/item/clothing/suit/armor/leathercoatsec
	name = "leather coat"
	desc = "A long, thick black leather coat. That one has a security badge and somewhat armored."
	icon_state = "leathercoat-sec"
	item_state = "leathercoat-sec"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals/emergency_oxygen)


/obj/item/clothing/suit/armor/military
	name = "military armor"
	desc = "heavy military armor"
	icon_state = "m3_ppa"
	item_state = "m3_ppa"
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/melee/baton,/obj/item/weapon/restraints/handcuffs,/obj/item/weapon/tank/internals/emergency_oxygen)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/military/nco
	icon_state = "m3_ppa-nco"
	item_state = "m3_ppa-nco"

/obj/item/clothing/suit/armor/military/eng
	icon_state = "m3_ppa-eng"
	item_state = "m3_ppa-eng"

/obj/item/clothing/suit/armor/military/medic
	icon_state = "m3_ppa-medic"
	item_state = "m3_ppa-medic"


/obj/item/clothing/suit/armor/knight
	name = "knight armor"
	desc = "Heavy mid-ages knight armour"
	armor = list(melee = 70, bullet = 80, laser = 70, energy = 55, bomb = 60, bio = 0, rad = 0)
	icon_state = "knight_grey"
	item_state = "knight_grey"
	slowdown = 3
	w_class = 4
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/knight/green
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/suit/armor/knight/yellow
	icon_state = "knight_yellow"
	item_state = "knight_yellow"

/obj/item/clothing/suit/armor/knight/red
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/suit/armor/knight/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/suit/armor/knight/black
	icon_state = "knight_black"
	item_state = "knight_black"

/obj/item/clothing/suit/armor/knight/english
	icon_state = "knight_english"
	item_state = "knight_english"

/obj/item/clothing/suit/armor/knight/templar
	icon_state = "knight_templar"
	item_color = "knight_templar"

/obj/item/clothing/suit/armor/viking
	name = "viking chainmail"
	desc = "Rusty nordic chainmail."
	icon_state = "viking"
	item_state = "viking"
	body_parts_covered = CHEST|GROIN|ARMS
	armor = list(melee = 15, bullet = 5, laser = 0,energy = 0, bomb = 5, bio = 0, rad = 0)