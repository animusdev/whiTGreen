/obj/effect/decal
	name = "decal"
	icon = 'icons/effects/effects.dmi'

/obj/effect/decal/ex_act(severity, target)
	qdel(src)

/obj/effect/decal/barsign
	name = "Bar sign"
	icon = 'icons/misc/barsigns.dmi'
	layer = OBJ_LAYER + 0.5
	icon_state = "empty"
	New()
		ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum"))
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//ul_SetLuminosity(4)
		return