/datum/config_entry/number/starlight
	default = 2

/datum/config_entry/keyed_list/engine_submap
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_NUM
	lowercase = TRUE

/// Set to FALSE to disable holidays (you monster)
/datum/config_entry/flag/allow_holidays
	default = TRUE

/datum/config_entry/flag/nightshifts_enabled
	default = TRUE

/datum/config_entry/string/alert_desc_green
	default = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."

/datum/config_entry/string/alert_desc_blue_upto
	default = "The station has received reliable information about possible hostile activity in the local area. Security staff may have weapons visible. Privacy laws are still in effect."

/datum/config_entry/string/alert_desc_blue_downto
	default = "Code Blue procedures are now in effect: The immediate threat has passed. Security staff may not have weapons drawn, but may still have weapons visible. Privacy laws are once again fully enforced."

/datum/config_entry/string/alert_desc_yellow_upto
	default = "The station has confirmed hostile activity in the local area. Security staff may have weapons visible. Random searches are permitted."

/datum/config_entry/string/alert_desc_yellow_downto
	default = "Code Yellow procedures are now in effect: The immediate security threat has been downgraded. Security staff may not have weapons drawn, but may still have weapons visible. Random searches are still permitted."

/datum/config_entry/string/alert_desc_violet_upto
	default = "A major medical emergency has been reported. Medical personnel are required to report to the Medbay immediately. Non-medical personnel are required to obey all relevant instructions from medical staff."

/datum/config_entry/string/alert_desc_violet_downto
	default = "Code Violet procedures are now in effect: Medical personnel are required to report to the Medbay immediately. Non-medical personnel are required to obey all relevant instructions from medical staff."

/datum/config_entry/string/alert_desc_orange_upto
	default = "A major engineering emergency has been reported. Engineering personnel are required to report to the affected area immediately. Non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/datum/config_entry/string/alert_desc_orange_downto
	default = "Code Orange procedures are now in effect: Engineering personnel are required to report to the affected area immediately. Non-engineering personnel are required to evacuate any affected areas and obey relevant instructions from engineering staff."

/datum/config_entry/string/alert_desc_red_upto
	default = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."

/datum/config_entry/string/alert_desc_red_downto
	default = "Code Red procedures are now in effect: The station is no longer under threat of imminent destruction, but there is still an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."

/datum/config_entry/string/alert_desc_delta
	default = "The station is under immediate threat of imminent destruction! All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

/datum/config_entry/flag/emojis
	default = TRUE

/// If security and such can be traitor/cult/other.
/datum/config_entry/flag/protect_roles_from_antagonist
	default = TRUE

/// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
/datum/config_entry/flag/continous_rounds
	// default = TRUE //! This is using TXT config so we don't need to suffer during development.

/// The sim framrate of BYOND.
/datum/config_entry/number/fps
	default = 20
	integer = FALSE
	min_val = 1
	max_val = 100 //byond will start crapping out at 50, so this is just ridic
	var/sync_validate = FALSE

/datum/config_entry/number/fps/ValidateAndSet(str_val)
	. = ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/ticklag/TL = config.entries_by_type[/datum/config_entry/number/ticklag]
		if(!TL.sync_validate)
			TL.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/ticklag
	integer = FALSE
	var/sync_validate = FALSE

/datum/config_entry/number/ticklag/New() //ticklag weirdly just mirrors fps
	var/datum/config_entry/CE = /datum/config_entry/number/fps
	default = 10 / initial(CE.default)
	..()

/datum/config_entry/number/ticklag/ValidateAndSet(str_val)
	. = text2num(str_val) > 0 && ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/fps/FPS = config.entries_by_type[/datum/config_entry/number/fps]
		if(!FPS.sync_validate)
			FPS.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/// SSinitialization throttling.
/datum/config_entry/number/tick_limit_mc_init
	default = TICK_LIMIT_MC_INIT_DEFAULT
	integer = TRUE
	min_val = 0

/// Do we enforce surnames?
/datum/config_entry/flag/humans_need_surnames
	default = FALSE

/// Enables the 'smart' event system. //Whatever that means.
/datum/config_entry/flag/enable_game_master
	default = FALSE

/// Enables the ai job.
/datum/config_entry/flag/allow_ai
	default = TRUE

/// Allow AIs to enter and leave special borg shells at will, and for those shells to be buildable.
/datum/config_entry/flag/allow_ai_shells
	default = TRUE

/**
 *! Allows a specific spawner object to instantiate a premade AI Shell.
 * This is intended for low-pop servers, where robotics might rarely be staffed.
 * Note that this will make it possible for the AI to 'bootstrap' more AI Shells on their own by using the science module. If this is not acceptable for your server, you should not uncomment this.
 * The landmark object that spawns the shell will also need to be mapped in for this to work.
 */
/datum/config_entry/flag/give_free_ai_shell
	default = FALSE

/// Toggle for having jobs load up from the .txt
/datum/config_entry/flag/load_jobs_from_txt
	default = FALSE

/// Use this to ban use of ToR.
/datum/config_entry/flag/tor_ban
	default = FALSE

/**
 *! Determines whether jobs use minimal access or expanded access.
 * This is intended for servers with low populations - where there are not enough players to fill all roles, so players need to do more than just one job.
 * Also for servers where they don't want people to hide in their own departments.
 */
/datum/config_entry/flag/jobs_have_minimal_access
	default = FALSE

/// Allow ghosts to write in blood during Cult rounds.
/datum/config_entry/flag/cult_ghostwriter
	default = TRUE

/// Sets the minimum number of cultists needed for ghosts to write in blood.
/datum/config_entry/number/cult_ghostwriter_req_cultists
	default = 6
	integer = TRUE
	min_val = 0

/// The number of available character slots.
/datum/config_entry/number/character_slots
	default = 10
	integer = TRUE
	min_val = 1

/// The number of loadout slots per character.
/datum/config_entry/number/loadout_slots
	default = 3
	integer = TRUE
	min_val = 1

/// Allow ghosts to become drones.
/datum/config_entry/flag/allow_drone_spawn
	default = TRUE

/// The number drones that can spawn.
/datum/config_entry/number/max_maint_drones
	default = 5
	integer = TRUE
	min_val = 1

/// A drone will become available every X minutes since last drone spawn. Default is 2 minutes.
/datum/config_entry/number/drone_build_time
	default = 2 MINUTES
	integer = TRUE
	min_val = 0

/// Disable mouse spawns for ghosts.
/datum/config_entry/flag/disable_player_mice
	default = FALSE

/// Prevent newly-spawned mice from understanding human speech.
/datum/config_entry/flag/disable_player_mice
	default = TRUE
