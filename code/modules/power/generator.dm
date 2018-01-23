// dummy generator object for testing

/*/obj/machinery/power/generator/verb/set_amount(var/g as num)
	set src in view(1)

	gen_amount = g

*/

/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = 1
	density = 1
	use_power = 0

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/lastgen = 0
	var/lastgenlev = -1
	var/lastcirc = "00"

/obj/machinery/power/generator/inbox
	anchored = 0

/obj/item/weapon/paper/teg
	name = "paper- 'Setup your own thermoelectric generator.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or plasma! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the sun's movements and to send commands to the solar panels to change direction with the sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"
	info = "<h1>How to setup thermoelecric generator in 6 simple steps</h1><p><b>Step 1: </b>unpack your generator box</p><p><b>Step 2: </b>place two circulators in the right and left of generator</p><p><b>Step 3: </b>wrench all things in place</p><p><b>Step 4: </b>initialize generator with screwdriver (sold separately)</p><p><b>Step 5: </b>connect your pipe network to the circulators, and cable to generator, <b>LEFT circulator is the COLD loop, RIGHT circulator is the HOT loop, all gases must flow form up to down and not vice versa</b></p><b>Step 6: </b>your are set the most safe, powerful and flexible generator in the world!</p>"


/obj/machinery/power/generator/initialize()

	circ1 = null
	circ2 = null

	circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
	circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)
	connect_to_network()

	if(circ1)
		circ1.side = 1
		circ1.teg = src
		circ1.update_icon()
	if(circ2)
		circ2.side = 2
		circ2.teg = src
		circ2.update_icon()

	if(!circ1 || !circ2)
		stat |= BROKEN

	update_icon()


/obj/machinery/power/generator/update_icon()

	if((stat & (NOPOWER|BROKEN)) || !anchored || !circ1 || !circ2)
		overlays.Cut()
	else
		overlays.Cut()

		if(lastgenlev != 0)
			overlays += image('icons/obj/power.dmi', "teg-op[lastgenlev]")

		overlays += image('icons/obj/power.dmi', "teg-oc[lastcirc]")


#define GENRATE 800		// generator output coefficient from Q

/obj/machinery/power/generator/process()

	if(!circ1 || !circ2)
		return

	lastgen = 0

	if(powernet)
		//world << "circ1 and circ2 pass"

		var/datum/gas_mixture/cold_air = circ1.return_transfer_air()
		var/datum/gas_mixture/hot_air = circ2.return_transfer_air()

		//world << "hot_air = [hot_air]; cold_air = [cold_air];"

		if(cold_air && hot_air)

			//world << "hot_air = [hot_air] temperature = [hot_air.temperature]; cold_air = [cold_air] temperature = [hot_air.temperature];"

			//world << "coldair and hotair pass"
			var/cold_air_heat_capacity = cold_air.heat_capacity()
			var/hot_air_heat_capacity = hot_air.heat_capacity()

			var/delta_temperature = hot_air.temperature - cold_air.temperature

			//world << "delta_temperature = [delta_temperature]; cold_air_heat_capacity = [cold_air_heat_capacity]; hot_air_heat_capacity = [hot_air_heat_capacity]"

			if(delta_temperature > 0 && cold_air_heat_capacity > 0 && hot_air_heat_capacity > 0)
				var/efficiency = 0.65

				var/energy_transfer = delta_temperature*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)

				var/heat = energy_transfer*(1-efficiency)
				lastgen = energy_transfer*efficiency

				//world << "lastgen = [lastgen]; heat = [heat]; delta_temperature = [delta_temperature]; hot_air_heat_capacity = [hot_air_heat_capacity]; cold_air_heat_capacity = [cold_air_heat_capacity];"

				hot_air.temperature = hot_air.temperature - energy_transfer/hot_air_heat_capacity
				cold_air.temperature = cold_air.temperature + heat/cold_air_heat_capacity

				//world << "POWER: [lastgen] W generated at [efficiency*100]% efficiency and sinks sizes [cold_air_heat_capacity], [hot_air_heat_capacity]"

				add_avail(lastgen)
		// update icon overlays only if displayed level has changed

		if(hot_air)
			circ2.air1.merge(hot_air)

		if(cold_air)
			circ1.air1.merge(cold_air)

	var/genlev = max(0, min( round(11*lastgen / 100000), 11))
	var/circ = "[circ1 && circ1.last_pressure_delta > 0 ? "1" : "0"][circ2 && circ2.last_pressure_delta > 0 ? "1" : "0"]"
	if((genlev != lastgenlev) || (circ != lastcirc))
		lastgenlev = genlev
		lastcirc = circ
		update_icon()

	src.updateDialog()

/obj/machinery/power/generator/attack_hand(mob/user)
	if(..())
		user << browse(null, "window=teg")
		return
	interact(user)

/obj/machinery/power/generator/proc/get_menu(var/include_link = 1)
	var/t = ""
	if(!powernet)
		t += "<span class='bad'>Unable to connect to the power network!</span>"
	else if(circ1 && circ2)

		t += "<div class='statusDisplay'>"

		t += "Output: [round(lastgen)] W"

		t += "<BR>"

		t += "<B><font color='blue'>Cold loop</font></B><BR>"
		t += "Temperature Inlet: [round(circ1.air2.temperature, 0.1)] K / Outlet: [round(circ1.air1.temperature, 0.1)] K<BR>"
		t += "Pressure Inlet: [round(circ1.air2.return_pressure(), 0.1)] kPa /  Outlet: [round(circ1.air1.return_pressure(), 0.1)] kPa<BR>"

		t += "<B><font color='red'>Hot loop</font></B><BR>"
		t += "Temperature Inlet: [round(circ2.air2.temperature, 0.1)] K / Outlet: [round(circ2.air1.temperature, 0.1)] K<BR>"
		t += "Pressure Inlet: [round(circ2.air2.return_pressure(), 0.1)] kPa / Outlet: [round(circ2.air1.return_pressure(), 0.1)] kPa<BR>"

		t += "</div>"
	else
		t += "<span class='bad'>Unable to locate all parts!</span>"
	if(include_link)
		t += "<BR><A href='?src=\ref[src];close=1'>Close</A>"

	return t

/obj/machinery/power/generator/interact(mob/user)

	user.set_machine(src)

	//user << browse(t, "window=teg;size=460x300")
	//onclose(user, "teg")

	var/datum/browser/popup = new(user, "teg", "Thermo-Electric Generator", 460, 300)
	popup.set_content(get_menu())
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return 1


/obj/machinery/power/generator/Topic(href, href_list)
	if(..())
		return
	if( href_list["close"] )
		usr << browse(null, "window=teg")
		usr.unset_machine()
		return 0
	return 1


/obj/machinery/power/generator/power_change()
	..()
	update_icon()


/obj/machinery/power/generator/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		if((circ1 || circ2) && anchored)
			user << "<span class='warning'>You cannot unwrench \the [src] while it connected to circulators!</span>"
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		update_icon()
		user << "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>"
		return
	if(istype(W, /obj/item/weapon/screwdriver))
		if(anchored)
			initialize()
			user << "<span class='notice'>You initialize \the [src].</span>"
			return
	..()


