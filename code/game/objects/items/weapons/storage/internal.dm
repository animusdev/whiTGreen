/obj/item/weapon/storage/internal
	var/silent = 0

/obj/item/weapon/storage/internal/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	if(silent)
		return ..(W, 1, user) // no warning
	else
		return ..()