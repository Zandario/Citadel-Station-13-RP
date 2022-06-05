/proc/load_configuration()
	config_legacy = new /datum/configuration_legacy()
	config_legacy.load("config/legacy/config.txt")
	// config_legacy.load("config/legacy/game_options.txt","game_options")
	config_legacy.loadsql("config/legacy/dbconfig.txt")
	config_legacy.loadforumsql("config/legacy/forumdbconfig.txt")

/datum/configuration_legacy




	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(EVENT_LEVEL_MUNDANE = null, 	EVENT_LEVEL_MODERATE = null,	EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 6000,	EVENT_LEVEL_MODERATE = 18000,	EVENT_LEVEL_MAJOR = 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 9000,	EVENT_LEVEL_MODERATE = 27000,	EVENT_LEVEL_MAJOR = 42000)

	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dsay_allowed = 1

	var/static/starlight = 0	// Whether space turfs have ambient light or not

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/aggressive_changelog = 0

	var/list/language_prefixes = list(",","#")//Default language prefixes


	var/radiation_decay_rate = 1 //How much radiation is reduced by each tick
	var/radiation_resistance_multiplier = 8.5
	var/radiation_lower_limit = 0.35 //If the radiation level for a turf would be below this, ignore it.

	var/comms_key = "default_password"

	var/minute_click_limit = 500		//default: 7+ clicks per second
	var/second_click_limit = 15
	var/minute_topic_limit = 500
	var/second_topic_limit = 10
	var/random_submap_orientation = FALSE // If true, submaps loaded automatically can be rotated.
	var/autostart_solars = FALSE // If true, specifically mapped in solar control computers will set themselves up when the round starts.

	var/list/gamemode_cache = list()



/datum/configuration_legacy/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = world.file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)

				if("comms_key")
					config_legacy.comms_key = value

				if ("disable_ooc")
					config_legacy.ooc_allowed = 0
					config_legacy.looc_allowed = 0

				if ("disable_dead_ooc")
					config_legacy.dooc_allowed = 0

				if ("disable_dsay")
					config_legacy.dsay_allowed = 0

				if ("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if (prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if (prob_name in config_legacy.modes)
							config_legacy.probabilities[prob_name] = text2num(prob_value)
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if ("required_players", "required_players_secret")
					var/req_pos = findtext(value, " ")
					var/req_name = null
					var/req_value = null
					var/is_secret_override = findtext(name, "required_players_secret") // Being extra sure we're not picking up an override for Secret by accident.

					if(req_pos)
						req_name = lowertext(copytext(value, 1, req_pos))
						req_value = copytext(value, req_pos + 1)
						if(req_name in config_legacy.modes)
							if(is_secret_override)
								config_legacy.player_requirements_secret[req_name] = text2num(req_value)
							else
								config_legacy.player_requirements[req_name] = text2num(req_value)
						else
							log_misc("Unknown game mode player requirement configuration definition: [req_name].")
					else
						log_misc("Incorrect player requirement configuration definition: [req_name]  [req_value].")

				if("allow_holidays")
					Holiday = 1
/*
				if("station_levels")
					GLOB.using_map.station_levels = text2numlist(value, ";")

				if("admin_levels")
					GLOB.using_map.admin_levels = text2numlist(value, ";")

				if("contact_levels")
					GLOB.using_map.contact_levels = text2numlist(value, ";")

				if("player_levels")
					GLOB.using_map.player_levels = text2numlist(value, ";")
*/
				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					config_legacy.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					config_legacy.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					config_legacy.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					config_legacy.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config_legacy.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config_legacy.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					config_legacy.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config_legacy.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config_legacy.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					config_legacy.aggressive_changelog = 1

				if("default_language_prefixes")
					var/list/values = splittext(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("radiation_lower_limit")
					radiation_lower_limit = text2num(value)

				if("minute_click_limit")
					config_legacy.minute_click_limit = text2num(value)

				if("second_click_limit")
					config_legacy.second_click_limit = text2num(value)

				if("minute_topic_limit")
					config_legacy.minute_topic_limit = text2num(value)
				if("random_submap_orientation")
					config_legacy.random_submap_orientation = 1

				if("second_topic_limit")
					config_legacy.second_topic_limit = text2num(value)
				if("autostart_solars")
					config_legacy.autostart_solars = TRUE

				if("second_topic_limit")
					config_legacy.second_topic_limit = text2num(value)

				else
					log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration_legacy/proc/loadsql(filename)  // -- TLE
	var/list/Lines = world.file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			if ("feedback_database")
				sqlfdbkdb = value
			if ("feedback_login")
				sqlfdbklogin = value
			if ("feedback_password")
				sqlfdbkpass = value
			if ("enable_stat_tracking")
				sqllogging = 1
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration_legacy/proc/loadforumsql(filename)  // -- TLE
	var/list/Lines = world.file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				forumsqladdress = value
			if ("port")
				forumsqlport = value
			if ("database")
				forumsqldb = value
			if ("login")
				forumsqllogin = value
			if ("password")
				forumsqlpass = value
			if ("activatedgroup")
				forum_activated_group = value
			if ("authenticatedgroup")
				forum_authenticated_group = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration_legacy/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M
	return gamemode_cache["extended"]

/datum/configuration_legacy/proc/get_runnable_modes()
	var/list/runnable_modes = list()
	for(var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if(M && M.can_start() && !isnull(config_legacy.probabilities[M.config_tag]) && config_legacy.probabilities[M.config_tag] > 0)
			runnable_modes |= M
	return runnable_modes

/datum/configuration_legacy/proc/post_load()
	//apply a default value to CONFIG_GET(string/python_path), if needed
	if(!CONFIG_GET(string/python_path))
		if(world.system_type == UNIX)
			CONFIG_SET(CONFIG_GET(string/python_path), "/usr/bin/env python2")
		else //probably windows, if not this should work anyway
			CONFIG_SET(CONFIG_GET(string/python_path), "python")
	world.update_hub_visibility(hub_visibility)
