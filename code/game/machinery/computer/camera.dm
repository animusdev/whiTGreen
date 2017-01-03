/obj/machinery/computer/security
	name = "security camera console"
	desc = "Used to access the various cameras on the station."
	icon_state = "cameras"
	circuit = /obj/item/weapon/circuitboard/security
	var/obj/machinery/camera/current = null
	var/last_pic = 1.0
	var/list/network = list("SS13")
	var/mapping = 0//For the overview file, interesting bit of code.
	var/selected_area

/obj/machinery/computer/security/check_eye(var/mob/user as mob)
	if ((get_dist(user, src) > 1 || user.eye_blind || !( current ) || !( current.status )) && (!istype(user, /mob/living/silicon)))
		return null
	var/list/viewing = viewers(src)
	if((istype(user,/mob/living/silicon/robot)) && (!(viewing.Find(user))))
		return null
	user.reset_view(current)
	return 1


/obj/machinery/computer/security/attack_hand(var/mob/user as mob)
	if(!stat)

		if (!network)
			ERROR("A computer lacks a network at [x],[y],[z].")
			return
		if (!(istype(network,/list)))
			ERROR("The computer at [x],[y],[z] has a network that is not a list!")
			return

		if(..())
			return

		var/list/L = list()
		for (var/obj/machinery/camera/C in cameranet.cameras)
			if((z > ZLEVEL_SPACEMAX || C.z > ZLEVEL_SPACEMAX) && (C.z != z))//if on away mission, can only recieve feed from same z_level cameras
				continue
			L.Add(C)

		camera_sort(L)


		var/list/areas= list()
		var/list/cameras = list()

		for(var/obj/machinery/camera/C in L)
			if(!C.network)
				ERROR("[C.c_tag] has no camera network.")
				continue
			if(!(istype(C.network,/list)))
				ERROR("[C.c_tag]'s camera network is not a list!")
				continue
			var/list/tempnetwork = C.network&network
			if(tempnetwork.len)
				var/turf/T=get_turf(C)
				var/area/area=T.loc
				if( !areas.Find(area) )
					areas.Add(area)
					cameras[area.name]= new/list()
				var/list/A=cameras[area.name]
				A.Add(C)


		var/dat=""

		if(current)
			dat+="<A href='?src=\ref[src];cancel'>Cancel camera view</A> "

		if(selected_area)
			dat+="  <A href='?src=\ref[src];area'>Back</A><br>"

			if(selected_area=="All")
				dat+="<hr>"
				for(var/area/A in areas)
					dat+="<B>[A]</B><br>"
					for(var/obj/machinery/camera/cam in cameras[A.name])
						dat += "<A href='?src=\ref[src];view=\ref[cam]'>[cam.c_tag][cam.status ? null : " (Deactivated)"]</A><br>"

			else
				dat+="<A href='?src=\ref[src];area=All'>Collapse all</A><br><hr>"
				var/area/A= selected_area as area
				if(A)
					dat+="<B>[A.name] cameras:</B><br>"
					for(var/obj/machinery/camera/cam in cameras[A.name])
						dat += "<A href='?src=\ref[src];view=\ref[cam]'>[cam.c_tag][cam.status ? null : " (Deactivated)"]</A><br>"

		else
			dat+="<A href='?src=\ref[src];area=All'>Collapse all</A><br><hr>"
			dat+="<B>Areas:</B><br>"
			for(var/area/A in areas)
				dat+="<A href='?src=\ref[src];area=\ref[A]'>[A.name]</A><br>"


		var/datum/browser/popup = new(user, "computer", "Cameras", 350, 480)
		popup.set_content(dat)
		popup.open()


/obj/machinery/computer/security/Topic(var/href,var/list/href_list)

	if("cancel" in href_list)
		current=null
		usr.reset_view(null)
		return updateUsrDialog()


	if("close" in href_list)
		usr.reset_view(null)
		usr.unset_machine()
		current = null
		return


	if("area" in href_list)
		if(href_list["area"]=="All")
			selected_area="All"
		else
			selected_area=locate(href_list["area"])

		return updateUsrDialog()

	if("view" in href_list)
		var/obj/machinery/camera/C = locate(href_list["view"])
		if(C)
			src.current = C
			if ((get_dist(usr, src) > 1 || usr.machine != src || usr.eye_blind || !( C.can_use() )) && (!istype(usr, /mob/living/silicon/ai)))
				if(!C.can_use() && !isAI(usr))
					src.current = null
				return 0
			else
				if(isAI(usr))
					var/mob/living/silicon/ai/A = usr
					A.eyeobj.setLoc(get_turf(C))
					A.client.eye = A.eyeobj
				else
					src.current = C
					use_power(50)
		return updateUsrDialog()










/obj/machinery/computer/security/telescreen
	name = "\improper Telescreen"
	desc = "Used for watching an empty arena."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	network = list("thunder")
	density = 0
	circuit = null
	brightness_on = 0

/obj/machinery/computer/security/telescreen/update_icon()
	icon_state = initial(icon_state)
	SetLuminosity(brightness_on)
	if(stat & BROKEN)
		icon_state += "b"
	return

/obj/machinery/computer/security/telescreen/entertainment
	name = "entertainment monitor"
	desc = "Damn, they better have the /tg/ channel on these things."
	icon = 'icons/obj/status_display.dmi'
	icon_state = "entertainment"
	network = list("thunder")
	density = 0
	circuit = null

/obj/machinery/computer/security/telescreen/entertainment/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/wrench))
		if(!src) return
		user << "<span class='notice'>¤ Вы разбираете монитор...</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 30))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			qdel(src)
			new /obj/item/stack/sheet/glass(user.loc)
			return


/obj/machinery/computer/security/wooden_tv
	name = "security camera monitor"
	desc = "An old TV hooked into the stations camera network."
	icon_state = "security_det"


/obj/machinery/computer/security/mining
	name = "outpost camera console"
	desc = "Used to access the various cameras on the outpost."
	icon_state = "miningcameras"
	network = list("MINE")
	circuit = "/obj/item/weapon/circuitboard/mining"
