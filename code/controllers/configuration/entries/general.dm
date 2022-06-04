/datum/config_entry/flag/minimaps_enabled
	default = TRUE

/// Prevents people the server hasn't seen before from connecting.
/datum/config_entry/flag/panic_bunker

/datum/config_entry/string/panic_bunker_message
	default = "Sorry but the server is currently not accepting connections from never before seen players."

/datum/config_entry/number/max_bunker_days
	default = 7
	min_val = 1

/datum/config_entry/string/invoke_youtubedl
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN

/datum/config_entry/number/client_warn_version
	default = null
	min_val = 500

/datum/config_entry/number/client_warn_version
	default = null
	min_val = 500

/datum/config_entry/string/client_warn_message
	default = "Your version of byond may have issues or be blocked from accessing this server in the future."

/datum/config_entry/flag/client_warn_popup

/datum/config_entry/number/client_error_version
	default = null
	min_val = 500

/datum/config_entry/string/client_error_message
	default = "Your version of byond is too old, may have issues, and is blocked from accessing this server."

/datum/config_entry/number/client_error_build
	default = null
	min_val = 0

/datum/config_entry/string/community_shortname

/datum/config_entry/string/community_link

/datum/config_entry/string/tagline
	default = "<br><small><a href='https://discord.gg/citadelstation'>Roleplay focused 18+ server with extensive species choices.</a></small></br>"

/datum/config_entry/flag/usetaglinestrings

/datum/config_entry/flag/cache_assets
	default = TRUE

/datum/config_entry/flag/show_irc_name

/// allows admins with relevant permissions to have their own ooc colour
/datum/config_entry/flag/allow_admin_ooccolor
	default = TRUE

/// allow votes to restart
/datum/config_entry/flag/allow_vote_restart
	default = TRUE

/// ERT can only be called by admins
/datum/config_entry/flag/ert_admin_call_only
	default = TRUE


/// Allow votes to change mode
/datum/config_entry/flag/allow_vote_mode
	default = FALSE

/// minimum time between voting sessions (deciseconds, 10 minute default)
/datum/config_entry/number/vote_delay
	default = 10 MINUTES
	integer = FALSE
	min_val = 0

/// length of voting period (deciseconds, default 1 minute)
/datum/config_entry/number/vote_period
	default = 1 MINUTE
	integer = FALSE
	min_val = 0

/// Autovote initial delay (deciseconds) before first automatic transfer vote call (default 180 minutes)
/datum/config_entry/number/vote_autotransfer_initial
	default = 3 HOURS
	integer = FALSE
	min_val = 0

/// Autovote delay (deciseconds) before sequential automatic transfer votes are called (default 60 minutes)
/datum/config_entry/number/vote_autotransfer_interval
	default = 1 HOUR
	integer = FALSE
	min_val = 0

/datum/config_entry/number/vote_autogamemode_timeleft
	default = 100 SECONDS
	integer = FALSE
	min_val = 0

/// Vote does not default to nochange/norestart (tbi)
/datum/config_entry/flag/vote_no_default
	default = FALSE

/// Dead people can't vote (tbi)
/datum/config_entry/flag/vote_no_dead
	default = TRUE //Fuck you ghosters.

/// If the amount of traitors scales based on amount of players.
/datum/config_entry/flag/traitor_scaling
	default = TRUE

/// If objectives are DISABLED
/datum/config_entry/flag/objectives_disabled
	default = FALSE

/// Enables random events mid-round.
/datum/config_entry/flag/allow_random_events
	default = TRUE

/// Metadata is supported. Used for OOC Notes.
/datum/config_entry/flag/allow_metadata
	default = TRUE

/// Time until a player is considered inactive.
/datum/config_entry/number/inactivity_period
	default = 5 MINUTES
	integer = FALSE
	min_val = 0

/// Time in ds until a player is considered afk.
/datum/config_entry/number/afk_period
	default = 10 MINUTES
	integer = FALSE
	min_val = 0

/// Force disconnect for inactive players.
/datum/config_entry/flag/kick_inactive
	default = FALSE

/datum/config_entry/string/hostedby

/datum/config_entry/flag/norespawn
	default = FALSE

/datum/config_entry/flag/guest_ban
	default = TRUE

/// Time until a dead player is allowed to respawn .
/datum/config_entry/number/respawn_time
	default = 5 MINUTES
	integer = FALSE
	min_val = 0

/// Enables automuting/spam prevention.
/datum/config_entry/flag/automute_on
	default = FALSE
