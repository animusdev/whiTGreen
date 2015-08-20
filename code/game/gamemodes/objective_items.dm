//Contains the target item datums for Steal objectives.

datum/objective_item
	var/name = "A silly bike horn! Honk!"
	var/targetitem = /obj/item/weapon/bikehorn		//typepath of the objective item
	var/difficulty = 9001							//vaguely how hard it is to do this objective
	var/list/excludefromjob = list()				//If you don't want a job to get a certain objective (no captain stealing his own medal, etcetc)
	var/list/altitems = list()				//Items which can serve as an alternative to the objective (darn you blueprints)

datum/proc/check_special_completion() //for objectives with special checks (is that slime extract unused? does that intellicard have an ai in it? etcetc)
	return 1


datum/objective_item/steal/caplaser
	name = "капитанский антикварный лазер"
	targetitem = /obj/item/weapon/gun/energy/laser/captain
	difficulty = 5
	excludefromjob = list("Captain")

datum/objective_item/steal/hoslaser
	name = "энергетический пистолет главы охраны"
	targetitem = /obj/item/weapon/gun/energy/gun/hos
	difficulty = 10
	excludefromjob = list("Head Of Security")

datum/objective_item/steal/handtele
	name = "ручной телепортер"
	targetitem = /obj/item/weapon/hand_tele
	difficulty = 5
	excludefromjob = list("Captain", "Research Director")

datum/objective_item/steal/rcd
	name = "устройство моментального строительства"
	targetitem = /obj/item/weapon/rcd
	difficulty = 3
	excludefromjob = list("Chief Engineer", "Quartermaster", "Cargo Technician")

datum/objective_item/steal/jetpack
	name = "реактивный ранец"
	targetitem = /obj/item/weapon/tank/jetpack
	difficulty = 3
	excludefromjob = list("Chief Engineer")

datum/objective_item/steal/magboots
	name = "магнитные ботинки главы инженеров"
	targetitem =  /obj/item/clothing/shoes/magboots/advance
	difficulty = 5
	excludefromjob = list("Chief Engineer")

datum/objective_item/steal/corgimeat
	name = "ломтик м&#255;са корги"
	targetitem = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/corgi
	difficulty = 5
	excludefromjob = list("Head of Personnel", "Quartermaster", "Cargo Technician") //>hurting your little buddy ever

datum/objective_item/steal/capmedal
	name = "золотую медаль капитана"
	targetitem = /obj/item/clothing/tie/medal/gold/captain
	difficulty = 5
	excludefromjob = list("Captain")

datum/objective_item/steal/hypo
	name = "гипоспрей"
	targetitem = /obj/item/weapon/reagent_containers/hypospray/CMO
	difficulty = 5
	excludefromjob = list("Chief Medical Officer")

datum/objective_item/steal/nukedisc
	name = "диск &#255;дерной аутентификации"
	targetitem = /obj/item/weapon/disk/nuclear
	difficulty = 5
	excludefromjob = list("Captain")

datum/objective_item/steal/ablative
	name = "комплект отражающей брони"
	targetitem = /obj/item/clothing/suit/armor/laserproof
	difficulty = 3
	excludefromjob = list("Head of Security", "Warden")

datum/objective_item/steal/reactive
	name = "комплект реактивной брони"
	targetitem = /obj/item/clothing/suit/armor/reactive
	difficulty = 5
	excludefromjob = list("Research Director")

datum/objective_item/steal/documents
	name = "пачку секретных документов"
	targetitem = /obj/item/documents //Any set of secret documents. Doesn't have to be NT's
	difficulty = 5

//Items with special checks!
datum/objective_item/steal/plasma
	name = "28 моль плазмы (полна&#255; канистра)"
	targetitem = /obj/item/weapon/tank
	difficulty = 3
	excludefromjob = list("Chief Engineer","Research Director","Station Engineer","Scientist","Atmospheric Technician")

datum/objective_item/plasma/check_special_completion(var/obj/item/weapon/tank/T)
	var/target_amount = text2num(name)
	var/found_amount = 0
	found_amount += T.air_contents.toxins
	return found_amount>=target_amount


datum/objective_item/steal/functionalai
	name = "функционирующий ИИ"
	targetitem = /obj/item/device/aicard
	difficulty = 20 //beyond the impossible

datum/objective_item/functionalai/check_special_completion(var/obj/item/device/aicard/C)
	for(var/mob/living/silicon/ai/A in C)
		if(istype(A, /mob/living/silicon/ai) && A.stat != 2) //See if any AI's are alive inside that card.
			return 1
	return 0

datum/objective_item/steal/blueprints
	name = "чертежи станции"
	targetitem = /obj/item/areaeditor/blueprints
	difficulty = 10
	excludefromjob = list("Chief Engineer")
	altitems = list(/obj/item/weapon/photo)

datum/objective_item/blueprints/check_special_completion(var/obj/item/I)
	if(istype(I, /obj/item/areaeditor/blueprints))
		return 1
	if(istype(I, /obj/item/weapon/photo))
		var/obj/item/weapon/photo/P = I
		if(P.blueprints)	//if the blueprints are in frame
			return 1
	return 0

datum/objective_item/steal/slime
	name = "неиспользованный экстракт слайма"
	targetitem = /obj/item/slime_extract
	difficulty = 3
	excludefromjob = list("Research Director","Scientist")

datum/objective_item/slime/check_special_completion(var/obj/item/slime_extract/E)
	if(E.Uses > 0)
		return 1
	return 0

//Unique Objectives
datum/objective_item/unique/docs_red
	name = "\"Красные\" секретные документы"
	targetitem = /obj/item/documents/syndicate/red
	difficulty = 10

datum/objective_item/unique/docs_blue
	name = "\"Синие\" секретные документы"
	targetitem = /obj/item/documents/syndicate/blue
	difficulty = 10

//Old ninja objectives.
datum/objective_item/special/pinpointer
	name = "капитанский целеуказатель"
	targetitem = /obj/item/weapon/pinpointer
	difficulty = 10
	excludefromjob = list("Captain")

datum/objective_item/special/aegun
	name = "улучшенное энергетическое оружие"
	targetitem = /obj/item/weapon/gun/energy/gun/nuclear
	difficulty = 10

datum/objective_item/special/ddrill
	name = "алмазную дрель"
	targetitem = /obj/item/weapon/pickaxe/drill/diamonddrill
	difficulty = 10

datum/objective_item/special/boh
	name = "подпространственную сумку"
	targetitem = /obj/item/weapon/storage/backpack/holding
	difficulty = 10

datum/objective_item/special/hypercell
	name = "гипер-вместительную батарею"
	targetitem = /obj/item/weapon/stock_parts/cell/hyper
	difficulty = 5

datum/objective_item/special/laserpointer
	name = "лазерную указку"
	targetitem = /obj/item/device/laser_pointer
	difficulty = 5

//Stack objectives get their own subtype
datum/objective_item/stack
	name = "5 листов картона"
	targetitem = /obj/item/stack/sheet/cardboard
	difficulty = 9001

datum/objective_item/stack/check_special_completion(var/obj/item/stack/S)
	var/target_amount = text2num(name)
	var/found_amount = 0

	if(istype(S, targetitem))
		found_amount = S.amount
	return found_amount>=target_amount

datum/objective_item/stack/diamond
	name = "10 алмазов"
	targetitem = /obj/item/stack/sheet/mineral/diamond
	difficulty = 10

datum/objective_item/stack/gold
	name = "50 золотых слитков"
	targetitem = /obj/item/stack/sheet/mineral/gold
	difficulty = 15

datum/objective_item/stack/uranium
	name = "25 обработанных урановых стержней"
	targetitem = /obj/item/stack/sheet/mineral/uranium
	difficulty = 10
