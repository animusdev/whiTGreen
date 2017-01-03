
/obj/item/clothing/gloves/fingerless
	name = "fingerless gloves"
	desc = "Plain black gloves without fingertips for the hard working."
	icon_state = "fingerless"
	item_state = "fingerless"
	item_color = null	//So they don't wash.
	transfer_prints = TRUE
	strip_delay = 40
	put_on_delay = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT

/obj/item/clothing/gloves/botanic_leather
	name = "botanist's leather gloves"
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin.  They're also quite warm."
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = -1

/obj/item/clothing/gloves/combat
	name = "combat gloves"
	desc = "These tactical gloves are fireproof and shock resistant."
	icon_state = "black"
	item_state = "bgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	strip_delay = 80
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	burn_state = -1

/obj/item/clothing/gloves/combat/khaki
	icon_state = "khaki"
	item_state = "khaki"


/obj/item/clothing/gloves/brassknuckles
	name = "brass knuckles"
	desc = "A pair of shiny, easily concealed brass knuckles. A miner's go-to bar fight weapon."
	icon_state = "brassknuckles"
	item_state = "brassknuckles"
	w_class = 1
	force = 10
	throw_speed = 3
	throw_range = 4
	throwforce = 7
	m_amt = 5000
	origin_tech = "combat=2;"
	attack_verb = list("beaten", "punched", "slammed", "smashed")
	hitsound = 'sound/weapons/punch3.ogg'

/obj/item/clothing/gloves/brassknuckles/Touch(A, proximity, var/mob/living/carbon/user)
	if(!user || !proximity)
		return 0
	if(istype(A,/mob/living) && user.a_intent == "harm")
		var/mob/living/M = A
		src.attack(M,user,user.zone_sel.selecting)
		return 1
	return 0
