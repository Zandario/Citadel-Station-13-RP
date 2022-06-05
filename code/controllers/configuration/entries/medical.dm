/// How long until someone can't be defibbed anymore, in minutes.
/datum/config_entry/number/defib_timer
	default = 10

/// How long until someone will get brain damage when defibbed, in minutes. The closer to the end of the above timer, the more brain damage they get.
/datum/config_entry/number/defib_braindamage_timer
	default = 2


//! ## Health

/datum/config_entry/number/health_threshold_softcrit
	default = 0
	integer = TRUE

/datum/config_entry/number/health_threshold_crit
	default = -50
	integer = TRUE

/datum/config_entry/number/health_threshold_dead
	default = -100
	integer = TRUE

//! ## Organs

/// Determines whether bones can be broken through excessive damage to the organ.
/datum/config_entry/flag/bones_can_break
	default = TRUE

/// Determines whether limbs can be amputated through excessive damage to the organ.
/datum/config_entry/flag/limbs_can_break
	default = TRUE

/**
 *! Multiplier which enables organs to take more damage before bones breaking or limbs being destroyed.
 *? 100 means normal, 50 means half.
 */
/datum/config_entry/number/organ_health_multiplier
	default = 100
	integer = TRUE

/**
 *! Multiplier which influences how fast organs regenerate naturally.
 *? 100 means normal, 50 means half.
 */
/datum/config_entry/number/organ_regeneration_multiplier
	default = 75
	integer = TRUE

/// Enables organ decay outside of a body or storage item.
/datum/config_entry/flag/organs_can_decay
	default = TRUE

/datum/config_entry/number/default_brain_health
	default = 400
	integer = TRUE

/datum/config_entry/flag/allow_headgibs
	default = TRUE

/**
 * Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
 * so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
 */
/datum/config_entry/number/organ_damage_spillover_multiplier
	default = 0.5 / 100
	integer = FALSE


//! ## REVIVAL

/// Whether pod plants work or not.
/datum/config_entry/flag/revival_pod_plants
	default = TRUE

/// whether cloning tubes work or not.
/datum/config_entry/flag/revival_cloning
	default = TRUE

/// Amount of time (in hundredths of seconds) for which a brain retains the "spark of life" after the person's death. (set to -1 for infinite)
/datum/config_entry/number/revival_brain_life
	default = -1
	integer = FALSE

/**
 *! ## Miscellaneous
 *? Config options which, of course, don't fit into previous categories.
 */

/// Do loyalty implants spawn by default on your server.
/datum/config_entry/flag/use_loyalty_implants
	default = TRUE

/// Whether or not humans show an area message when they die.
/datum/config_entry/flag/show_human_death_message
	default = TRUE
