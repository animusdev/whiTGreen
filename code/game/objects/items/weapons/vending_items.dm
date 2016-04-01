/obj/item/weapon/vending_refill
	name = "resupply canister"
	var/machine_name = "Generic"

	icon = 'icons/obj/vending_restock.dmi'
	icon_state = "refill_snack"
	item_state = "restock_unit"
	flags = CONDUCT
	force = 7.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 7
	w_class = 4.0
	var/deconstruct_state = 0
	var/met_amount = 2
	var/wire_amount = 5

	var/charges = 0		//how many restocking "charges" the refill has

/obj/item/weapon/vending_refill/New(amt = -1)
	..()
	name = "\improper [machine_name] restocking unit"
	if(isnum(amt) && amt > -1)
		charges = amt

/obj/item/weapon/vending_refill/examine(mob/user)
	..()
	if(charges)
		user << "It can restock [charges] item(s)."
	else
		user << "It's empty!"

/obj/item/weapon/vending_refill/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/crowbar))
		if(deconstruct_state==0)
			user << "<span class='notice'>You begin to pry off [src.name] cover..."
			if(do_after(user, 15))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user <<"<span class='notice'>You succesfully pried [src.name] cover!"
				deconstruct_state++
				return
		return
	if(istype(W, /obj/item/weapon/screwdriver))
		if(deconstruct_state)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			user << "<span class='notice'>You start unscrewing [src.name]'s container...</span>"
			if(do_after(user, 20))
				user << "<span class='notice'>You disassemble [src.name]!</span>"
				var/obj/item/stack/sheet/metal/M = new /obj/item/stack/sheet/metal(src.loc)
				new /obj/item/stack/cable_coil(src.loc, amount = wire_amount)
				M.amount = met_amount
				spawn_contents(user)
				qdel(src)



/obj/item/weapon/vending_refill/proc/spawn_contents(mob/living/user as)
	var/list/contents = new/list()
	if(istype(src, /obj/item/weapon/vending_refill/coffee))
		user << "<span class='notice'>Contents are spilled on the floor!</span>"
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		var/turf/simulated/T = get_turf(src.loc)
		T.MakeSlippery()
		return

	else if(istype(src, /obj/item/weapon/vending_refill/boozeomat))
		var/bottles_broken = 0
		contents = get_contents("booze")
		for(var/item in contents)
			if(prob(75))
				bottles_broken++
				continue
			new item(src.loc)
		if(bottles_broken)
			playsound(src.loc, 'sound/effects/Glassbr3.ogg', 50, 1)
			user << "<span class='notice'>You broke some bottles, you idiot!</span>"
			var/turf/simulated/T = get_turf(src.loc)
			T.MakeSlippery()
			if(prob(40))
				user.apply_damage(10, user.hand)
				user << "<span class='notice'>You cut your hand.</span>"
			for(var/i = 0, i < bottles_broken, i++)
				if(prob(30))
					new /obj/item/weapon/shard(src.loc)
		return
		//todo: add fuel spit on floor

	else if(istype(src, /obj/item/weapon/vending_refill/snack))
		contents = get_contents("snack")
	else if(istype(src, /obj/item/weapon/vending_refill/cola))
		contents = get_contents("cola")
	else if(istype(src, /obj/item/weapon/vending_refill/cigarette))
		contents = get_contents("cig")
	else if(istype(src, /obj/item/weapon/vending_refill/autodrobe))
		contents = get_contents("autodrobe")
	else if(istype(src, /obj/item/weapon/vending_refill/clothing))
		contents = get_contents("clothes")
	for(var/item in contents)
		new item(src.loc)
	user << "<span class='notice'>Everything falls down to the floor!</span>"
	return

//NOTE I decided to go for about 1/3 of a machine's capacity

/obj/item/weapon/vending_refill/boozeomat
	machine_name = "Booze-O-Mat"
	icon_state = "refill_booze"
	charges = 54//of 162

/obj/item/weapon/vending_refill/coffee
	machine_name = "Solar's Best Hot Drinks"
	icon_state = "refill_joe"
	charges = 28//of 85



/obj/item/weapon/vending_refill/snack
	machine_name = "Getmore Chocolate Corp"
	charges = 14//of 42


/obj/item/weapon/vending_refill/cola
	machine_name = "Robust Softdrinks"
	icon_state = "refill_cola"
	charges = 22//of 66

/obj/item/weapon/vending_refill/cigarette
	machine_name = "ShadyCigs Deluxe"
	icon_state = "refill_smoke"
	charges = 14// of 42

/obj/item/weapon/vending_refill/autodrobe
	machine_name = "AutoDrobe"
	icon_state = "refill_costume"
	charges = 35// of 87

/obj/item/weapon/vending_refill/clothing
	machine_name = "ClothesMate"
	icon_state = "refill_clothes"
	charges = 40// of 90
/obj/item/weapon/vending_refill/proc/get_contents(var/pack as text)
	var/list/possible_conts = new/list()
	var/list/conts = new/list()
	switch(pack)
		if("snack")
			possible_conts = list(
					/obj/item/weapon/reagent_containers/food/snacks/candy,
					/obj/item/weapon/reagent_containers/food/drinks/dry_ramen,
					/obj/item/weapon/reagent_containers/food/snacks/chips,
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky,
					/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
					/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers)
		if("cola")
			possible_conts = list(
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/cola,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_mountain_wind,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/dr_gibb,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/starkist,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/space_up,
					/obj/item/weapon/reagent_containers/food/drinks/soda_cans/lemon_lime)
		if("cig")
			possible_conts = list(
					/obj/item/weapon/storage/fancy/cigarettes,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_uplift,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_robust,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_carp,
					/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori,
					/obj/item/weapon/storage/box/matches,
					/obj/item/weapon/lighter/grayscale,
					/obj/item/weapon/storage/fancy/rollingpapers)
		if("autodrobe")
			possible_conts = list(/obj/item/clothing/suit/chickensuit,/obj/item/clothing/head/chicken,/obj/item/clothing/under/gladiator,
					/obj/item/clothing/head/helmet/gladiator,/obj/item/clothing/under/gimmick/rank/captain/suit,/obj/item/clothing/head/flatcap,
					/obj/item/clothing/suit/toggle/labcoat/mad,/obj/item/clothing/glasses/gglasses,/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/under/schoolgirl,/obj/item/clothing/under/schoolgirl/red,/obj/item/clothing/under/schoolgirl/green,/obj/item/clothing/under/schoolgirl/orange,/obj/item/clothing/head/kitty,/obj/item/clothing/under/blackskirt,/obj/item/clothing/head/beret,
					/obj/item/clothing/tie/waistcoat,/obj/item/clothing/under/suit_jacket,/obj/item/clothing/head/that ,/obj/item/clothing/under/kilt,/obj/item/clothing/head/beret,/obj/item/clothing/tie/waistcoat,
					/obj/item/clothing/glasses/monocle ,/obj/item/clothing/head/bowler,/obj/item/weapon/support/cane,/obj/item/clothing/under/sl_suit,
					/obj/item/clothing/mask/fakemoustache,/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,/obj/item/clothing/head/plaguedoctorhat,/obj/item/clothing/mask/gas/plaguedoctor,
					/obj/item/clothing/suit/toggle/owlwings, /obj/item/clothing/under/owl,/obj/item/clothing/mask/gas/owl_mask,
					/obj/item/clothing/suit/toggle/owlwings/griffinwings, /obj/item/clothing/under/griffin, /obj/item/clothing/shoes/griffin, /obj/item/clothing/head/griffin,
					/obj/item/clothing/suit/apron,/obj/item/clothing/under/waiter,
					/obj/item/clothing/under/pirate,/obj/item/clothing/suit/pirate,/obj/item/clothing/head/pirate,/obj/item/clothing/head/bandana,
					/obj/item/clothing/head/bandana,/obj/item/clothing/under/soviet,/obj/item/clothing/head/ushanka,/obj/item/clothing/suit/imperium_monk,
					/obj/item/clothing/mask/gas/cyborg,/obj/item/clothing/suit/holidaypriest,/obj/item/clothing/head/wizard/marisa/fake,
					/obj/item/clothing/suit/wizrobe/marisa/fake,/obj/item/clothing/under/sundress,/obj/item/clothing/head/witchwig,/obj/item/weapon/broom,
					/obj/item/clothing/suit/wizrobe/fake,/obj/item/clothing/head/wizard/fake,/obj/item/device/flashlight/staff,/obj/item/clothing/mask/gas/sexyclown,
					/obj/item/clothing/under/sexyclown,/obj/item/clothing/mask/gas/sexymime,/obj/item/clothing/under/sexymime,/obj/item/clothing/suit/apron/overalls,
					/obj/item/clothing/head/rabbitears , /obj/item/clothing/head/sombrero, /obj/item/clothing/head/sombrero/green, /obj/item/clothing/suit/poncho,
					/obj/item/clothing/suit/poncho/green, /obj/item/clothing/suit/poncho/red,
					/obj/item/clothing/under/maid, /obj/item/clothing/under/janimaid,/obj/item/clothing/glasses/cold,/obj/item/clothing/glasses/heat,
					/obj/item/clothing/suit/whitedress, /obj/item/clothing/suit/batman, /obj/item/clothing/under/king, /obj/item/clothing/head/crown, /obj/item/clothing/head/turban, /obj/item/clothing/head/batman,/obj/item/clothing/head/crown/dark, /obj/item/clothing/under/chaps, /obj/item/clothing/under/dolan, /obj/item/clothing/under/safari, /obj/item/clothing/shoes/king, /obj/item/clothing/cloak/king)

		if("clothes")
			possible_conts = list(/obj/item/clothing/head/that,/obj/item/clothing/head/fedora,/obj/item/clothing/glasses/monocle, /obj/item/clothing/under/training = 2, /obj/item/clothing/under/cosby = 1, /obj/item/clothing/under/cosby/cosby2 = 1, /obj/item/clothing/under/cosby/cosby3 = 1, /obj/item/clothing/under/rasta = 2, /obj/item/clothing/head/rasta = 2,/obj/item/clothing/under/rank/chaplain/buddhist = 3, /obj/item/clothing/suit/jacket,/obj/item/clothing/under/suit_jacket/navy,/obj/item/clothing/under/suit_jacket/really_black,/obj/item/clothing/under/kilt,/obj/item/clothing/under/overalls,
					/obj/item/clothing/under/sl_suit,/obj/item/clothing/under/pants/jeans,/obj/item/clothing/under/pants/classicjeans, /obj/item/clothing/suit/jacket/puffer = 1, /obj/item/clothing/suit/jacket/puffer/vest = 1, /obj/item/clothing/suit/jacket/puffer = 1, /obj/item/clothing/suit/jacket/puffer/vest = 1, /obj/item/clothing/suit/sweater = 1, /obj/item/clothing/suit/sweater/green = 1, /obj/item/clothing/suit/sweater/red = 1,
					/obj/item/clothing/under/pants/camo = 1,/obj/item/clothing/under/pants/blackjeans,/obj/item/clothing/under/pants/khaki,
					/obj/item/clothing/under/pants/white,/obj/item/clothing/under/pants/red,/obj/item/clothing/under/pants/black,
					/obj/item/clothing/under/pants/tan,/obj/item/clothing/under/pants/track,
					/obj/item/clothing/tie/blue, /obj/item/clothing/tie/red,/obj/item/clothing/tie/black, /obj/item/clothing/tie/horrible,
					/obj/item/clothing/scarf/red,/obj/item/clothing/scarf/green,/obj/item/clothing/scarf/darkblue,
					/obj/item/clothing/scarf/purple,/obj/item/clothing/scarf/yellow,/obj/item/clothing/scarf/orange,
					/obj/item/clothing/scarf/lightblue,/obj/item/clothing/scarf/white,/obj/item/clothing/scarf/black,
					/obj/item/clothing/scarf/zebra,/obj/item/clothing/scarf/christmas,/obj/item/clothing/scarf/stripedredscarf,
					/obj/item/clothing/scarf/stripedbluescarf,/obj/item/clothing/scarf/stripedgreenscarf,/obj/item/clothing/tie/waistcoat,
					/obj/item/clothing/under/blackskirt,/obj/item/clothing/under/sundress,/obj/item/clothing/under/stripeddress, /obj/item/clothing/under/sailordress, /obj/item/clothing/under/redeveninggown,/obj/item/clothing/under/blacktango,/obj/item/clothing/under/wedding,/obj/item/clothing/under/wedding/bride_red,/obj/item/clothing/suit/toggle/hoodie/black,/obj/item/clothing/suit/toggle/hoodie,/obj/item/clothing/suit/kimono,/obj/item/clothing/under/plaid_skirt,/obj/item/clothing/under/plaid_skirt/blue,/obj/item/clothing/under/plaid_skirt/purple,
					/obj/item/clothing/glasses/regular,/obj/item/clothing/head/sombrero,/obj/item/clothing/suit/poncho,
					/obj/item/clothing/suit/ianshirt,/obj/item/clothing/shoes/laceup,/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/shoes/sandal, /obj/item/clothing/gloves/fingerless,/obj/item/clothing/glasses/orange,/obj/item/clothing/glasses/red, /obj/item/clothing/glasses/sunglasses/aviator,
					/obj/item/weapon/storage/belt/fannypack, /obj/item/weapon/storage/belt/fannypack/blue, /obj/item/weapon/storage/belt/fannypack/red)
		if("booze")
			possible_conts = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/gin,/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequila,/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth,/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine,/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua,/obj/item/weapon/reagent_containers/food/drinks/beer,
					/obj/item/weapon/reagent_containers/food/drinks/ale,/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice,/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream)
		else
			return
	for(var/i = 0, i < round(charges/2), i++)
		conts.Add(pick(possible_conts))
	return conts


