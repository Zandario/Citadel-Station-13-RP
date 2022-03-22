// Relays don't handle any actual communication. Global NTNet datum does that, relays only tell the datum if it should or shouldn't work.
/obj/machinery/ntnet_relay
	name = "NTNet Quantum Relay"
	desc = "A very complex router and transmitter capable of connecting electronic devices together. Looks fragile."
	use_power = USE_POWER_ACTIVE
	active_power_usage = 20000 //20kW, apropriate for machine that keeps massive cross-Zlevel wireless network operational.
	idle_power_usage = 100
	icon_state = "bus"
	anchored = TRUE
	density = TRUE
	var/datum/ntnet/NTNet = null // This is mostly for backwards reference and to allow varedit modifications from ingame.
	var/enabled = TRUE			// Set to FALSE if the relay was turned off
	var/dos_failure = FALSE		// Set to TRUE if the relay failed due to (D)DoS attack
	var/list/dos_sources = list()	// Backwards reference for qdel() stuff

	// Denial of Service attack variables
	var/dos_overload = 0		// Amount of DoS "packets" in this relay's buffer
	var/dos_capacity = 500		// Amount of DoS "packets" in buffer required to crash the relay
	var/dos_dissipate = 1		// Amount of DoS "packets" dissipated over time.


// TODO: Implement more logic here. For now it's only a placeholder.
/obj/machinery/ntnet_relay/operable()
	if(!..(EMPED))
		return FALSE
	if(dos_failure)
		return FALSE
	if(!enabled)
		return FALSE
	return TRUE

/obj/machinery/ntnet_relay/update_icon()
	if(operable())
		icon_state = "bus"
	else
		icon_state = "bus_off"

/obj/machinery/ntnet_relay/process(delta_time)
	if(operable())
		update_use_power(USE_POWER_ACTIVE)
	else
		update_use_power(USE_POWER_IDLE)

	if(dos_overload)
		dos_overload = max(0, dos_overload - dos_dissipate)

	// If DoS traffic exceeded capacity, crash.
	if((dos_overload > dos_capacity) && !dos_failure)
		dos_failure = TRUE
		update_icon()
		ntnet_global.add_log("Quantum relay switched from normal operation mode to overload recovery mode.")
	// If the DoS buffer reaches 0 again, restart.
	if((dos_overload == 0) && dos_failure)
		dos_failure = FALSE
		update_icon()
		ntnet_global.add_log("Quantum relay switched from overload recovery mode to normal operation mode.")
	..()

/obj/machinery/ntnet_relay/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NTNetRelay", src)
		ui.open()

/obj/machinery/ntnet_relay/ui_data(mob/user)
	var/list/data = list()
	data["enabled"] = enabled
	data["dos_capacity"] = dos_capacity
	data["dos_overload"] = dos_overload
	data["dos_crashed"] = dos_failure

	return data

/obj/machinery/ntnet_relay/attack_hand(var/mob/living/user)
	ui_interact(user)

/obj/machinery/ntnet_relay/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("restart")
			dos_overload = 0
			dos_failure = 0
			update_icon()
			ntnet_global.add_log("Quantum relay manually restarted from overload recovery mode to normal operation mode.")
			. = TRUE
		if("toggle")
			enabled = !enabled
			ntnet_global.add_log("Quantum relay manually [enabled ? "enabled" : "disabled"].")
			update_icon()
			. = TRUE
		if("purge")
			ntnet_global.banned_nids.Cut()
			ntnet_global.add_log("Manual override: Network blacklist cleared.")
			. = TRUE

/obj/machinery/ntnet_relay/Initialize(mapload)
	uid = gl_uid
	gl_uid++
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src,15)
	component_parts += new /obj/item/circuitboard/ntnet_relay(src)

	if(ntnet_global)
		ntnet_global.relays.Add(src)
		NTNet = ntnet_global
		ntnet_global.add_log("New quantum relay activated. Current amount of linked relays: [NTNet.relays.len]")
	return ..()

/obj/machinery/ntnet_relay/Destroy()
	if(ntnet_global)
		ntnet_global.relays.Remove(src)
		ntnet_global.add_log("Quantum relay connection severed. Current amount of linked relays: [NTNet.relays.len]")
		NTNet = null
	for(var/datum/computer_file/program/ntnet_dos/D in dos_sources)
		D.target = null
		D.error = "Connection to quantum relay severed"
	..()

/obj/machinery/ntnet_relay/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.is_screwdriver())
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance hatch")
		return
	if(W.is_crowbar())
		if(!panel_open)
			to_chat(user, "Open the maintenance panel first.")
			return
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, "You disassemble \the [src]!")

		for(var/atom/movable/A in component_parts)
			A.forceMove(src.loc)
		new /obj/structure/frame(src.loc)
		qdel(src)
		return
	..()
