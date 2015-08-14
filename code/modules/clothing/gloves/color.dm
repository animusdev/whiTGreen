/obj/item/clothing/gloves/color/yellow
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	r_name = "изол&#255;ционные перчатки"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	item_color="yellow"

/obj/item/clothing/gloves/color/yellow/fake
	desc = "These gloves will protect the wearer from electric shock. They don't feel like rubber..."
	siemens_coefficient = 1

/obj/item/clothing/gloves/color/fyellow                             //Cheap Chinese Crap
	desc = "These gloves are cheap knockoffs of the coveted ones - no way this can end badly."
	name = "budget insulated gloves"
	r_name = "дешёвые изол&#255;ционные перчатки"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05
	item_color="yellow"

/obj/item/clothing/gloves/color/fyellow/New()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/black
	desc = "These gloves are fire-resistant."
	name = "black gloves"
	r_name = "чёрные перчатки"
	icon_state = "black"
	item_state = "bgloves"
	item_color="brown"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT


/obj/item/clothing/gloves/color/black/hos
	item_color = "hosred"		//Exists for washing machines. Is not different from black gloves in any way.

/obj/item/clothing/gloves/color/black/ce
	item_color = "chief"			//Exists for washing machines. Is not different from black gloves in any way.

/obj/item/clothing/gloves/color/black/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/wirecutters))
		if(icon_state == initial(icon_state)) //only if not dyed
			user << "<span class='notice'>You snip the fingertips off of [src].</span>"
			playsound(user.loc,'sound/items/Wirecutter.ogg', rand(10,50), 1)
			new /obj/item/clothing/gloves/fingerless(user.loc)
			qdel(src)
	..()

/obj/item/clothing/gloves/color/orange
	name = "orange gloves"
	r_name = "оранжевые перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"
	item_state = "orangegloves"
	item_color="orange"

/obj/item/clothing/gloves/color/red
	name = "red gloves"
	r_name = "красные перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"
	item_state = "redgloves"
	item_color = "red"

/obj/item/clothing/gloves/color/rainbow
	name = "rainbow gloves"
	r_name = "радужные перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	item_state = "rainbowgloves"
	item_color = "rainbow"

/obj/item/clothing/gloves/color/rainbow/clown
	item_color = "clown"

/obj/item/clothing/gloves/color/blue
	name = "blue gloves"
	r_name = "синие перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"
	item_state = "bluegloves"
	item_color="blue"

/obj/item/clothing/gloves/color/purple
	name = "purple gloves"
	r_name = "фиолетовые перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"
	item_state = "purplegloves"
	item_color="purple"

/obj/item/clothing/gloves/color/green
	name = "green gloves"
	r_name = "зеленые перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"
	item_state = "greengloves"
	item_color="green"

/obj/item/clothing/gloves/color/grey
	name = "grey gloves"
	r_name = "серые перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"
	item_state = "graygloves"
	item_color="grey"

/obj/item/clothing/gloves/color/grey/rd
	item_color = "director"			//Exists for washing machines. Is not different from gray gloves in any way.

/obj/item/clothing/gloves/color/grey/hop
	item_color = "hop"				//Exists for washing machines. Is not different from gray gloves in any way.

/obj/item/clothing/gloves/color/light_brown
	name = "light brown gloves"
	r_name = "светло-коричневые перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"
	item_state = "lightbrowngloves"
	item_color="light brown"

/obj/item/clothing/gloves/color/brown
	name = "brown gloves"
	r_name = "коричневые перчатки"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"
	item_state = "browngloves"
	item_color="brown"

/obj/item/clothing/gloves/color/brown/cargo
	item_color = "cargo"					//Exists for washing machines. Is not different from brown gloves in any way.

/obj/item/clothing/gloves/color/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	r_name = "капитанские перчатки"
	icon_state = "captain"
	item_state = "egloves"
	item_color = "captain"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 60

/obj/item/clothing/gloves/color/latex
	name = "latex gloves"
	r_name = "латексные перчатки"
	desc = "Cheap sterile gloves made from latex."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.01
	item_color="white"
	transfer_prints = TRUE

/obj/item/clothing/gloves/color/latex/nitrile
	name = "nitrile gloves"
	r_name = "нитриловые перчатки"
	desc = "Pricy sterile gloves that are stronger than latex."
	icon_state = "nitrile"
	item_state = "nitrilegloves"
	item_color = "cmo"
	transfer_prints = FALSE

/obj/item/clothing/gloves/color/white
	name = "white gloves"
	r_name = "белые перчатки"
	desc = "These look pretty fancy."
	icon_state = "white"
	item_state = "wgloves"
	item_color="mime"

/obj/item/clothing/gloves/color/white/redcoat
	item_color = "redcoat"		//Exists for washing machines. Is not different from white gloves in any way.
