/datum/tgui_module_old/teleport_control
	name = "Teleporter Control"
	tgui_id = "Teleporter"
	var/locked_name = "Not Locked"
	var/obj/item/locked = null
	var/obj/machinery/tele_projector/station = null
	var/obj/machinery/tele_pad/hub = null

/datum/tgui_module_old/teleport_control/ui_data(mob/user, tgui/ui, datum/ui_state/state)
	var/list/data = ..()

	data["locked_name"] = locked_name || "No Target"
	data["station_connected"] = !!station
	data["hub_connected"] = !!hub
	data["calibrated"] = hub?.accurate
	data["teleporter_on"] = station?.engaged

	return data

/datum/tgui_module_old/teleport_control/ui_act(action, params, tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("select_target")
			var/list/L = list()
			var/list/areaindex = list()

			for(var/obj/item/radio/beacon/R in  GLOB.all_beacons)
				var/turf/T = get_turf(R)
				if(!T)
					continue
				if(!(T.z in GLOB.using_map.player_levels))
					continue
				var/tmpname = T.loc.name
				if(areaindex[tmpname])
					tmpname = "[tmpname] ([++areaindex[tmpname]])"
				else
					areaindex[tmpname] = 1
				L[tmpname] = R

			for(var/obj/item/implant/tracking/I in GLOB.all_tracking_implants)
				if(!I.implanted || !ismob(I.loc))
					continue
				else
					var/mob/M = I.loc
					if(M.stat == 2)
						if(M.timeofdeath + 6000 < world.time)
							continue
					var/turf/T = get_turf(M)
					if(T)
						continue
					if(!(T in GLOB.using_map.station_levels))
						continue
					var/tmpname = M.real_name
					if(areaindex[tmpname])
						tmpname = "[tmpname] ([++areaindex[tmpname]])"
					else
						areaindex[tmpname] = 1
					L[tmpname] = I

			var/desc = input("Please select a location to lock in.", "Locking Menu") in L|null
			if(!desc)
				return FALSE
			if(ui_status(usr, state) != UI_INTERACTIVE)
				return FALSE

			locked = L[desc]
			locked_name = desc
			return TRUE

		if("test_fire")
			station?.testfire()
			return TRUE

		if("toggle_on")
			if(!station)
				return FALSE

			if(station.engaged)
				station.disengage()
			else
				station.engage()

			return TRUE
