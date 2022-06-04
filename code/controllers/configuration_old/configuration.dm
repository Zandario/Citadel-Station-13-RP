/proc/load_configuration()
	config_legacy = new /datum/configuration_legacy()
	config_legacy.load("config/legacy/config.txt")
	config_legacy.load("config/legacy/game_options.txt","game_options")
	config_legacy.loadsql("config/legacy/dbconfig.txt")
	config_legacy.loadforumsql("config/legacy/forumdbconfig.txt")

/datum/configuration_legacy
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/nudge_script_path = "nudge.py"  // where the nudge.py script is located

	var/hub_visibility = FALSE				//CITADEL CHANGE - HUB CONFIG

	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode
	var/list/player_requirements = list() // Overrides for how many players readied up a gamemode needs to start.
	var/list/player_requirements_secret = list() // Same as above, but for the secret gamemode.



	var/ip_reputation = FALSE		//Should we query IPs to get scores? Generates HTTP traffic to an API service.
	var/ipr_email					//Left null because you MUST specify one otherwise you're making the internet worse.
	var/ipr_block_bad_ips = FALSE	//Should we block anyone who meets the minimum score below? Otherwise we just log it (If paranoia logging is on, visibly in chat).
	var/ipr_bad_score = 1			//The API returns a value between 0 and 1 (inclusive), with 1 being 'definitely VPN/Tor/Proxy'. Values equal/above this var are considered bad.
	var/ipr_allow_existing = FALSE 	//Should we allow known players to use VPNs/Proxies? If the player is already banned then obviously they still can't connect.
	var/ipr_minimum_age = 5
	var/ipqualityscore_apikey //API key for ipqualityscore.com

	var/serverurl
	var/server
	var/banappeals
	var/wikiurl
	var/wikisearchurl
	var/forumurl
	var/rulesurl
	var/mapurl

	var/forbid_singulo_possession = 0

	//game_options.txt configs

	var/health_threshold_softcrit = 0
	var/health_threshold_crit = 0
	var/health_threshold_dead = -100

	var/organ_health_multiplier = 1
	var/organ_regeneration_multiplier = 1
	var/organs_decay
	var/default_brain_health = 400
	var/allow_headgibs = FALSE

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/organ_damage_spillover_multiplier = 0.5

	var/bones_can_break = 0
	var/limbs_can_break = 0

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/use_loyalty_implants = 0

	var/welder_vision = 1
	var/generate_map = 1
	var/no_click_cooldown = 0

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/run_speed = 0
	var/walk_speed = 0

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = 0
	var/robot_delay = 0
	var/monkey_delay = 0
	var/alien_delay = 0
	var/slime_delay = 0
	var/animal_delay = 0

	var/footstep_volume = 0

	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config_legacy.txt
	var/use_age_restriction_for_jobs = 0 //Do jobs use account age restrictions? --requires database
	var/use_age_restriction_for_antags = 0 //Do antags use account age restrictions? --requires database

	var/simultaneous_pm_warning_timeout = 100

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.
	var/multi_z_explosion_scalar = 0.5 //Multiplier for how much weaker explosions are on neighboring z levels.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/enter_allowed = 1

	var/use_irc_bot = 0
	var/use_node_bot = 0
	var/irc_bot_port = 0
	var/irc_bot_host = ""
	var/irc_bot_export = 0 // whether the IRC bot in use is a Bot32 (or similar) instance; Bot32 uses world.Export() instead of nudge.py/libnudge
	var/main_irc = ""
	var/admin_irc = ""
	var/python_path = "" //Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix
	var/use_lib_nudge = 0 //Use the C library nudge instead of the python nudge.
	var/use_overmap = 0

	// Event settings
	var/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(EVENT_LEVEL_MUNDANE = null, 	EVENT_LEVEL_MODERATE = null,	EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 6000,	EVENT_LEVEL_MODERATE = 18000,	EVENT_LEVEL_MAJOR = 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 9000,	EVENT_LEVEL_MODERATE = 27000,	EVENT_LEVEL_MAJOR = 42000)

	var/aliens_allowed = 0
	var/ninjas_allowed = 0
	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dsay_allowed = 1

	var/static/starlight = 0	// Whether space turfs have ambient light or not

	var/list/ert_species = list(SPECIES_HUMAN)

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/aggressive_changelog = 0

	var/list/language_prefixes = list(",","#")//Default language prefixes

	var/show_human_death_message = 1

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


/datum/configuration_legacy/New()
	var/list/L = subtypesof(/datum/game_mode)
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				modes += M.config_tag
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				player_requirements[M.config_tag] = M.required_players
				player_requirements_secret[M.config_tag] = M.required_players_secret
				if (M.votable)
					src.votable_modes += M.config_tag
	src.votable_modes += "secret"

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
				if ("admin_legacy_system")
					config_legacy.admin_legacy_system = 1

				if ("ban_legacy_system")
					config_legacy.ban_legacy_system = 1

				if ("hub_visibility")					//CITADEL CHANGE - ADDS HUB CONFIG
					config_legacy.hub_visibility = 1

				if ("use_age_restriction_for_jobs")
					config_legacy.use_age_restriction_for_jobs = 1

				if ("use_age_restriction_for_antags")
					config_legacy.use_age_restriction_for_antags = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("multi_z_explosion_scalar")
					multi_z_explosion_scalar = text2num(value)

				if ("generate_map")
					config_legacy.generate_map = 1

				if ("no_click_cooldown")
					config_legacy.no_click_cooldown = 1

				if("comms_key")
					config_legacy.comms_key = value

				if ("servername")
					config_legacy.server_name = value

				if ("serversuffix")
					config_legacy.server_suffix = 1

				if ("nudge_script_path")
					config_legacy.nudge_script_path = value

				if ("serverurl")
					config_legacy.serverurl = value

				if ("server")
					config_legacy.server = value

				if ("banappeals")
					config_legacy.banappeals = value

				if ("wikiurl")
					config_legacy.wikiurl = value

				if ("wikisearchurl")
					config_legacy.wikisearchurl = value

				if ("forumurl")
					config_legacy.forumurl = value

				if ("rulesurl")
					config_legacy.rulesurl = value

				if ("mapurl")
					config_legacy.mapurl = value

				if ("disable_ooc")
					config_legacy.ooc_allowed = 0
					config_legacy.looc_allowed = 0

				if ("disable_entry")
					config_legacy.enter_allowed = 0

				if ("disable_dead_ooc")
					config_legacy.dooc_allowed = 0

				if ("disable_dsay")
					config_legacy.dsay_allowed = 0

				if ("disable_respawn")
					config_legacy.abandon_allowed = 0

				if ("aliens_allowed")
					config_legacy.aliens_allowed = 1

				if ("ninjas_allowed")
					config_legacy.ninjas_allowed = 1

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

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("allow_holidays")
					Holiday = 1

				if("use_irc_bot")
					use_irc_bot = 1

				if("use_node_bot")
					use_node_bot = 1

				if("irc_bot_port")
					config_legacy.irc_bot_port = value

				if("irc_bot_export")
					irc_bot_export = 1

				if("assistant_maint")
					config_legacy.assistant_maint = 1

				if("gateway_delay")
					config_legacy.gateway_delay = text2num(value)

				if("ghost_interaction")
					config_legacy.ghost_interaction = 1

				if("irc_bot_host")
					config_legacy.irc_bot_host = value

				if("main_irc")
					config_legacy.main_irc = value

				if("admin_irc")
					config_legacy.admin_irc = value

				if("python_path")
					if(value)
						config_legacy.python_path = value

				if("use_lib_nudge")
					config_legacy.use_lib_nudge = 1

				if("use_overmap")
					config_legacy.use_overmap = 1
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
				if("expected_round_length")
					config_legacy.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					config_legacy.welder_vision = 0

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

				if("ert_species")
					config_legacy.ert_species = splittext(value, ";")
					if(!config_legacy.ert_species.len)
						config_legacy.ert_species += SPECIES_HUMAN

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

				if("ip_reputation")
					config_legacy.ip_reputation = 1

				if("ipr_email")
					config_legacy.ipr_email = value

				if("ipr_block_bad_ips")
					config_legacy.ipr_block_bad_ips = 1

				if("ipr_bad_score")
					config_legacy.ipr_bad_score = text2num(value)

				if("ipr_allow_existing")
					config_legacy.ipr_allow_existing = 1

				if("ipr_minimum_age")
					config_legacy.ipr_minimum_age = text2num(value)

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

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_crit")
					config_legacy.health_threshold_crit = value
				if("health_threshold_softcrit")
					config_legacy.health_threshold_softcrit = value
				if("health_threshold_dead")
					config_legacy.health_threshold_dead = value
				if("show_human_death_message")
					config_legacy.show_human_death_message = 1
				if("revival_pod_plants")
					config_legacy.revival_pod_plants = value
				if("revival_cloning")
					config_legacy.revival_cloning = value
				if("revival_brain_life")
					config_legacy.revival_brain_life = value
				if("organ_health_multiplier")
					config_legacy.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					config_legacy.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					config_legacy.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					config_legacy.organs_decay = 1
				if("default_brain_health")
					config_legacy.default_brain_health = text2num(value)
					if(!config_legacy.default_brain_health || config_legacy.default_brain_health < 1)
						config_legacy.default_brain_health = initial(config_legacy.default_brain_health)
				if("bones_can_break")
					config_legacy.bones_can_break = value
				if("limbs_can_break")
					config_legacy.limbs_can_break = value
				if("allow_headgibs")
					config_legacy.allow_headgibs = TRUE

				if("run_speed")
					config_legacy.run_speed = value
				if("walk_speed")
					config_legacy.walk_speed = value

				if("human_delay")
					config_legacy.human_delay = value
				if("robot_delay")
					config_legacy.robot_delay = value
				if("monkey_delay")
					config_legacy.monkey_delay = value
				if("alien_delay")
					config_legacy.alien_delay = value
				if("slime_delay")
					config_legacy.slime_delay = value
				if("animal_delay")
					config_legacy.animal_delay = value

				if("footstep_volume")
					config_legacy.footstep_volume = text2num(value)

				if("use_loyalty_implants")
					config_legacy.use_loyalty_implants = 1

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
	//apply a default value to config_legacy.python_path, if needed
	if (!config_legacy.python_path)
		if(world.system_type == UNIX)
			config_legacy.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			config_legacy.python_path = "python"
	world.update_hub_visibility(hub_visibility)			//CITADEL CHANGE - HUB CONFIG
