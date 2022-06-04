/// AdminPMs to non-admins show in a pop-up 'reply' window when set to 1.
/datum/config_entry/flag/popup_admin_pm
	default = TRUE

/datum/config_entry/flag/show_mods
	default = TRUE

/datum/config_entry/flag/show_devs
	default = TRUE

/datum/config_entry/flag/show_event_managers
	default = TRUE

/datum/config_entry/flag/mods_can_tempban
	default = TRUE

/datum/config_entry/flag/mods_can_job_tempban
	default = TRUE

/// Maximum mod tempban duration.
/datum/config_entry/number/mod_tempban_max
	default = 1440 MINUTES
	integer = TRUE
	min_val = 0

/// Maximum mod job tempban duration.
/datum/config_entry/number/mod_job_tempban_max
	default = 1440 MINUTES
	integer = TRUE
	min_val = 0
