/obj/item/weapon/storage/internal
	storage_slots = 2
	max_w_class = 2
	max_combined_w_class = 4
	w_class = 4
	var/silent = 0
	var/priority = 1

/obj/item/weapon/storage/internal/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	if(silent)
		return ..(W, 1, user) // no warning
	else
		return ..()


/obj/item/weapon/storage/internal/pocket/New()
	..()
	if(loc) name = loc.name

/obj/item/weapon/storage/internal/pocket/big
	max_w_class = 3
	max_combined_w_class = 6

/obj/item/weapon/storage/internal/pocket/small
	storage_slots = 1
	max_combined_w_class = 2
	priority = 0

/obj/item/weapon/storage/internal/pocket/tiny
	storage_slots = 1
	max_w_class = 1
	max_combined_w_class = 1
	priority = 0


/obj/item/weapon/storage/internal/pocket/small/detective
	priority = 1

/obj/item/weapon/storage/internal/pocket/small/detective/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/flask/det(src)