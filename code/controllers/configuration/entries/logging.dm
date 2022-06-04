/// Generic Logging.
/datum/config_entry/flag/log_debug
	default = TRUE

/// log all TGUI information for debugging.
/datum/config_entry/flag/emergency_tgui_logging
	default = FALSE

/// log messages sent in OOC
/datum/config_entry/flag/log_ooc
	default = TRUE

/// log messages sent in LOOC
/datum/config_entry/flag/log_looc
	default = TRUE

/// log messages sent in AOOC
/datum/config_entry/flag/log_aooc
	default = TRUE

/// log login/logout
/datum/config_entry/flag/log_access
	default = TRUE

/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login
	default = TRUE

/// log client say
/datum/config_entry/flag/log_say
	default = TRUE

/// log admin actions
/datum/config_entry/flag/log_admin
	default = TRUE
	protection = CONFIG_ENTRY_LOCKED

/// log debug information
/datum/config_entry/flag/log_admin
	default = TRUE
	protection = CONFIG_ENTRY_LOCKED


/// log prayers
/datum/config_entry/flag/log_prayer
	default = TRUE

/// log silicons
/datum/config_entry/flag/log_silicon
	default = TRUE

/datum/config_entry/flag/log_law
	deprecated_by = /datum/config_entry/flag/log_silicon

/datum/config_entry/flag/log_law/DeprecationUpdate(value)
	return value

/// log usage of tools
/datum/config_entry/flag/log_tools
	default = TRUE

/// log game events
/datum/config_entry/flag/log_game
	default = TRUE

/// log mech data
/datum/config_entry/flag/log_mecha
	default = TRUE

/// log virology data
/datum/config_entry/flag/log_virus
	default = TRUE

/// log assets
/datum/config_entry/flag/log_asset
	default = TRUE

/// log voting
/datum/config_entry/flag/log_vote
	default = TRUE

/// log client whisper
/datum/config_entry/flag/log_whisper
	default = TRUE

/// log attack messages
/datum/config_entry/flag/log_attack
	default = TRUE

/// log emotes
/datum/config_entry/flag/log_emote
	default = TRUE

/// log economy actions
/datum/config_entry/flag/log_econ
	default = TRUE

/// log traitor objectives
/datum/config_entry/flag/log_traitor
	default = TRUE

/// log admin chat messages
/datum/config_entry/flag/log_adminchat
	default = TRUE
	protection = CONFIG_ENTRY_LOCKED

/// log pda messages
/datum/config_entry/flag/log_pda
	default = TRUE

/// log uplink/spellbook/codex ciatrix purchases and refunds
/datum/config_entry/flag/log_uplink
	default = TRUE

/// log telecomms messages
/datum/config_entry/flag/log_telecomms
	default = TRUE

/// log certain expliotable parrots and other such fun things in a JSON file of twitter valid phrases.
/datum/config_entry/flag/log_twitter
	default = TRUE

/// log all world.Topic() calls
/datum/config_entry/flag/log_world_topic
	default = TRUE

/// log crew manifest to separate file
/datum/config_entry/flag/log_manifest
	default = TRUE

/// log roundstart divide occupations debug information to a file
/datum/config_entry/flag/log_job_debug
	default = TRUE

/// log shuttle related actions, ie shuttle computers, shuttle manipulator, emergency console
/datum/config_entry/flag/log_shuttle
	default = TRUE

/// logs all timers in buckets on automatic bucket reset (Useful for timer debugging)
/datum/config_entry/flag/log_timers_on_bucket_reset
	default = TRUE

/// This will notify admins and write to a file any time a new player (byond or your server) connects.
/datum/config_entry/flag/paranoia_logging
	default = TRUE
