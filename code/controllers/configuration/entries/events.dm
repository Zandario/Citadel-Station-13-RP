/datum/config_entry/number/expected_round_length
	default = 3 HOURS
	integer = TRUE
	min_val = 0


// /// If the first delay has a custom start time
// /// No custom time, no custom time, between 80 to 100 minutes respectively.
// /datum/config_entry/keyed_list/event_first_run
// 	key_mode = KEY_MODE_TEXT
// 	value_mode = VALUE_MODE_NUM
// 	default = list( //DEFAULTS
// 		EVENT_LEVEL_MUNDANE = null,
// 		EVENT_LEVEL_MODERATE = null,
// 		EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000),
// 	)

// /// The lowest delay until next event
// /// 10, 30, 50 minutes respectively
// /datum/config_entry/keyed_list/event_delay_lower
// 	key_mode = KEY_MODE_TEXT
// 	value_mode = VALUE_MODE_NUM
// 	default = list( //DEFAULTS
// 		EVENT_LEVEL_MUNDANE = 6000,
// 		EVENT_LEVEL_MODERATE = 18000,
// 		EVENT_LEVEL_MAJOR = 30000,
// 	)

// /// The upper delay until next event
// /// 15, 45, 70 minutes respectively
// /datum/config_entry/keyed_list/event_delay_upper
// 	key_mode = KEY_MODE_TEXT
// 	value_mode = VALUE_MODE_NUM
// 	default = list( //DEFAULTS
// 		EVENT_LEVEL_MUNDANE = 9000,
// 		EVENT_LEVEL_MODERATE = 27000,
// 		EVENT_LEVEL_MAJOR = 42000,
// 	)

/// Uncomment to allow aliens to spawn.
/datum/config_entry/flag/aliens_allowed
	default = TRUE

/// Uncomment to allow xenos to spawn.
/datum/config_entry/flag/ninjas_allowed
	default = TRUE

/datum/config_entry/keyed_list/ert_species
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/ert_species/ValidateListEntry(key_name, key_value)
	if(key_name in GLOB.species_meta)
		return TRUE

	log_config("ERROR: [key_name] is not a valid race meta ID.")
	return FALSE
