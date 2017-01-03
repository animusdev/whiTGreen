
/obj/item/weapon/proc/trydismember(atom/M, mob/living/carbon/human/user, var/removal_type = MELEE_DISMEMBERMENT)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/attacked = M
	var/obj/item/organ/limb/affecting = attacked.get_organ(check_zone(user.zone_sel.selecting))
	affecting.dismember(src, removal_type, 0)




/obj/item/weapon/banhammer
	desc = "A banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 1.0
	throw_speed = 3
	throw_range = 7
	attack_verb = list("banned")

/obj/item/weapon/banhammer/suicide_act(mob/user)
		user.visible_message("<span class='suicide'>[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life.</span>")
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)

/obj/item/weapon/banhammer/attack(mob/M, mob/user)
	M << "<font color='red'><b> You have been banned FOR NO REISIN by [user]<b></font>"
	user << "<font color='red'> You have <b>BANNED</b> [M]</font>"
	playsound(loc, 'sound/effects/adminhelp.ogg', 15) //keep it at 15% volume so people don't jump out of their skin too much


/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of Nar-Sie's followers."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 3
	throw_range = 4
	throwforce = 10
	w_class = 1

/obj/item/weapon/nullrod/attack(mob/living/M as mob, mob/living/carbon/human/user as mob)
	..()
	if(iscultist(M) && prob(35))
		M << "\red Incredible power clears your mind of heresy!"
		user << "\red You see how [M]'s eyes become clear, the cult no longer holds control over him!"
		ticker.mode.remove_cultist(M.mind)


/obj/item/weapon/nullrod/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/sord
	name = "SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	flags = SHARP
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	w_class = 3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/weapon/sord/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(BRUTELOSS)

/obj/item/weapon/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	hitsound = 'sound/weapons/bladeslice.ogg'
	flags = CONDUCT | SHARP
	slot_flags = SLOT_BACK
	force = 40
	throwforce = 10
	w_class = 4
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	embed_chance = 5
	embedded_fall_chance = 95

/obj/item/weapon/claymore/IsShield()
	return 1

/obj/item/weapon/claymore/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(BRUTELOSS)

/obj/item/weapon/katana
	name = "katana"
	desc = "Woefully underpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	flags = CONDUCT | SHARP
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throwforce = 10
	w_class = 4
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	embed_chance = 10
	embedded_fall_chance = 90

/obj/item/weapon/katana/cursed
	slot_flags = null

/obj/item/weapon/katana/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</span>")
	return(BRUTELOSS)

/obj/item/weapon/katana/IsShield()
		return 1

obj/item/weapon/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 9
	throwforce = 10
	w_class = 3
	m_amt = 1875
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

obj/item/weapon/wirerod/attackby(var/obj/item/I, mob/user as mob, params)
	..()
	if(istype(I, /obj/item/weapon/shard))
		var/obj/item/weapon/twohanded/spear/S = new /obj/item/weapon/twohanded/spear

		user.unEquip(I)
		user.unEquip(src)

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>"
		qdel(I)
		qdel(src)

	else if(istype(I, /obj/item/weapon/wirecutters))
		var/obj/item/weapon/melee/baton/cattleprod/P = new /obj/item/weapon/melee/baton/cattleprod

		user.unEquip(I)
		user.unEquip(src)

		user.put_in_hands(P)
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
		qdel(I)
		qdel(src)


/obj/item/weapon/throwing_star
	name = "throwing star"
	desc = "An ancient weapon still used to this day due to it's ease of lodging itself into victim's body parts"
	icon_state = "throwingstar"
	force = 2
	throwforce = 20 //This is never used on mobs since this has a 100% embed chance.
	throw_speed = 4
	embedded_pain_multiplier = 4
	w_class = 2
	embed_chance = 100
	embedded_fall_chance = 0 //Hahaha!
	flags = SHARP

//5*(2*4) = 5*8 = 45, 45 damage if you hit one person with all 5 stars.
//Not counting the damage it will do while embedded (2*4 = 8, at 15% chance)
/obj/item/weapon/storage/box/throwing_stars/New()
	..()
	contents = list()
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)
	new /obj/item/weapon/throwing_star(src)



/obj/item/weapon/switchblade
	name = "switchblade"
	icon_state = "switchblade"
	desc = "A sharp, concealable, spring-loaded knife."
	flags = CONDUCT | SHARP
	force = 20
	w_class = 2
	throwforce = 15
	throw_speed = 3
	throw_range = 6
	m_amt = 12000
	origin_tech = "materials=1"
	hitsound = 'sound/weapons/Genhit.ogg'
	attack_verb = list("stubbed", "poked")
	var/extended
	var/ext_force = 20
	var/icon_base = "switchblade"
	embed_chance = 20
	embedded_fall_chance = 80

/obj/item/weapon/switchblade/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)
	if(extended)
		force = ext_force
		w_class = 3
		throwforce = 15
		icon_state = "[icon_base]_ext"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		hitsound = 'sound/weapons/bladeslice.ogg'
	else
		force = 1
		w_class = 2
		throwforce = 5
		icon_state = "[icon_base]"
		attack_verb = list("stubbed", "poked")
		hitsound = 'sound/weapons/Genhit.ogg'


/obj/item/weapon/switchblade/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is slitting \his own throat with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS)

/obj/item/weapon/switchblade/switchblade2
	icon_state = "switchblade2"
	icon_base = "switchblade2"

/obj/item/weapon/switchblade/pocket_knife
	name = "pocket knife"
	desc = "Small touristic knife. Can open your MRE."
	icon_state = "pocket_knife"
	icon_base = "pocket_knife"
	extended = 0
	embed_chance = 0
	ext_force = 10

/obj/item/weapon/switchblade/butterfly
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	icon_state = "butterfly_knife"
	icon_base = "butterfly_knife"
	item_state = null
	hitsound = null
	extended = 0
	w_class = 2
	throw_speed = 3
	throw_range = 4
	throwforce = 7
	ext_force = 15

/obj/item/weapon/kitchen/knife/combat
	icon = 'icons/obj/weapons.dmi'
	item_state = "knife"
	name = "combat knife"
	desc = "sharp and dangerous military knife."
	icon_state = "combat_knife"
	force = 18
	embed_chance = 80
	embedded_fall_chance = 20


/obj/item/weapon/kitchen/knife/combat/bayonet
	icon_state = "bayonet"

/obj/item/weapon/kitchen/knife/machete
	icon = 'icons/obj/weapons.dmi'
	item_state = "machete"
	name = "machete"
	desc = "Fight your way trouth bamboo."
	icon_state = "machete"
	force = 25
	w_class = 3
	embed_chance = 10
	embedded_fall_chance = 90





/obj/item/weapon/phone/suicide_act(mob/user)
	if(locate(/obj/structure/stool) in user.loc)
		user.visible_message("<span class='notice'>[user] begins to tie a noose with the [src.name]'s cord! It looks like \he's trying to commit suicide.</span>")
	else
		user.visible_message("<span class='notice'>[user] is strangling \himself with the [src.name]'s cord! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/weapon/support/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	force = 5
	throwforce = 5
	w_class = 2
	m_amt = 50
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")


/obj/item/weapon/support/crutch
	name = "crutch"
	desc = "Can help you, if you don't have one leg."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "crutch"
	item_state = "crutch"
	force = 5
	throwforce = 5
	w_class = 2
	attack_verb = list("bludgeonded", "whacked", "beated")



/obj/item/weapon/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = 2
	flags = NOSHIELD
	attack_verb = list("bludgeoned", "whacked", "disciplined")

/obj/item/weapon/broom/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	force = 3
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = 2
	flags = NOSHIELD

/obj/item/weapon/ectoplasm
	name = "ectoplasm"
	desc = "spooky"
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/obj/item/weapon/ectoplasm/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is inhaling the [src.name]! It looks like \he's trying to visit the astral plane.</span>")
	return (OXYLOSS)

/obj/item/weapon/short_spear
	icon_state = "shortspear"
	name = "short spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	force = 5
	w_class = 2.0
	slot_flags = SLOT_BELT
	throwforce = 10
	throw_speed = 6
	embedded_impact_pain_multiplier = 3
	embed_chance = 50
	flags = SHARP
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")

