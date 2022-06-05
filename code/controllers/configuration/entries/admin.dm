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

/// Defines whether the server uses the legacy admin system with admins.txt or the SQL system.
/datum/config_entry/flag/admin_legacy_system
	default = TRUE

/// Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config_legacy.txt
/datum/config_entry/flag/ban_legacy_system
	default = TRUE

/**
 * Set this entry to have certain jobs require your account to be at least a certain number of days old to select.
 * You can configure the exact age requirement for different jobs by editing
 * the minimal_player_age variable in the files in folder /code/game/jobs/job/.. for the job you want to edit.
 * Set minimal_player_age to 0 to disable age requirement for that job.
 *
 *! REQUIRES the database set up to work. Keep it hashed if you don't have a database set up.
 *
 *! NOTE: If you have just set-up the database keep this DISABLED, as player age is determined from the first time they connect to the server with the database up.
 *!       If you just set it up, it means you have noone older than 0 days, since noone has been logged yet. Only turn this on once you have had the database up
 *!       for 30 days.
 */
/datum/config_entry/flag/use_age_restriction_for_jobs
	default = TRUE

/**
 * Set this entry to have certain antag roles require your account to be at least a certain number of days old for round start and auto-spawn selection.
 * Non-automatic antagonist recruitment, such as being converted to cultism is not affected. Has the same database requirements and notes as USE_AGE_RESTRICTION_FOR_JOBS.
 */
/datum/config_entry/flag/use_age_restriction_for_antags
	default = TRUE
