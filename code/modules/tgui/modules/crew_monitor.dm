/datum/tgui_module_old/crew_monitor
	name = "Crew monitor"
	tgui_id = "CrewMonitor"

/datum/tgui_module_old/crew_monitor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/nanomaps),
	)

/datum/tgui_module_old/crew_monitor/ui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	if(action && !issilicon(usr))
		playsound(ui_host(), SFX_ALIAS_TERMINAL, 50, 1)

	var/turf/T = get_turf(usr)
	if(!T || !(T.z in GLOB.using_map.player_levels))
		to_chat(usr, SPAN_WARNING("<b>Unable to establish a connection</b>: You're too far away from the station!"))
		return FALSE

	switch(action)
		if("track")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/mob/living/complex/human/H = locate(params["track"]) in GLOB.mob_list
				if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
					AI.ai_actual_track(H)
			return TRUE

/datum/tgui_module_old/crew_monitor/ui_interact(mob/user, datum/tgui/ui = null)
	var/z = get_z(user)
	var/list/map_levels = GLOB.using_map.get_map_levels(z, TRUE, om_range = DEFAULT_OVERMAP_RANGE)

	if(!map_levels.len)
		to_chat(user, SPAN_WARNING("The crew monitor doesn't seem like it'll work here."))
		if(ui)
			ui.close()
		return null

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, name)
		ui.autoupdate = TRUE
		ui.open()


/datum/tgui_module_old/crew_monitor/ui_data(mob/user)
	var/data[0]

	data["isAI"] = isAI(user)

	var/z = get_z(user)
	var/list/map_levels = uniqueList(GLOB.using_map.get_map_levels(z, TRUE, om_range = DEFAULT_OVERMAP_RANGE))
	data["map_levels"] = map_levels

	var/list/crewmembers = list()
	for(var/zlevel in map_levels)
		crewmembers += crew_repository.health_data(zlevel)

	// This is apparently necessary, because the above loop produces an emergent behavior
	// of telling you what coordinates someone is at even without sensors on,
	// because it strictly sorts by zlevel from bottom to top, and by coordinates from top left to bottom right.
	shuffle_inplace(crewmembers)
	data["crewmembers"] = crewmembers

	return data

/datum/tgui_module_old/crew_monitor/ntos
	ntos = TRUE

// Subtype for glasses_state
/datum/tgui_module_old/crew_monitor/glasses
/datum/tgui_module_old/crew_monitor/glasses/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.glasses_state

// Subtype for self_state
/datum/tgui_module_old/crew_monitor/robot
/datum/tgui_module_old/crew_monitor/robot/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.self_state

// Subtype for nif_state
/datum/tgui_module_old/crew_monitor/nif
/datum/tgui_module_old/crew_monitor/nif/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.nif_state
