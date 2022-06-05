/datum/antagonist

//! ## Text shown when becoming this antagonist.
	// Jobs that cannot be this antagonist (depending on config)
	var/list/restricted_jobs = list()
	// Jobs that cannot be this antagonist (depending on config)
	var/list/protected_jobs = list()
	///Jobs that can be this antag, but not at roundstart
	var/list/roundstart_restricted = list()

//! ## Strings.
	var/welcome_text = "Cry havoc and let slip the dogs of war!"
	/// The sound file to play when someone gets this role. Only they can hear it.
	var/antag_sound = 'sound/effects/antag_notice/general_baddie_alert.ogg'
	/// Text shown to the leader, if any.
	var/leader_welcome_text
		/// World output at roundend for victory.
	var/victory_text
		/// As above for loss.
	var/loss_text
		/// Used by the database for end of round loss.
	var/victory_feedback_tag
		/// Used by the database for end of round loss.
	var/loss_feedback_tag

//! ## Role data.
	/// Unique datum identifier.
	var/id = "traitor"
	/// Preferences option for this role.
	var/role_type = BE_TRAITOR
	/// special_role text.
	var/role_text = "Traitor"
	/// As above but plural.
	var/role_text_plural = "Traitors"

//! ## Visual references.
	/// Used by the ghost antagHUD.
	var/antaghud_indicator = "unknown"
	/// icon_state for icons/mob/mob.dm visual indicator.
	var/antag_indicator
	/// See antag_indicator, but for factionalized people only.
	var/faction_indicator
	/// Can members of the faction identify other antagonists?
	var/faction_invisible

//! ## Faction data.
	/// Role for sub-antags. Mandatory for faction role.
	var/faction_role_text
	/// Description of the cause. Mandatory for faction role.
	var/faction_descriptor
	/// Verb added when becoming a member of the faction, if any.
	var/faction_verb
	/// Message shown to faction members.
	var/faction_welcome

//! ## Spawn values (autotraitor and game mode)

	/// Autotraitor var. Won't spawn more than this many antags.
	var/hard_cap = 3
	/// As above but 'core' round antags ie. roundstart.
	var/hard_cap_round = 5
	/// Gamemode using this template won't start without this # candidates.
	var/initial_spawn_req = 1
	/// Gamemode will attempt to spawn this many antags.
	var/initial_spawn_target = 3
	/// Has an announcement been sent?
	var/announced
	/// When the datum spawn proc is called, does it announce to the world? (ie. xenos)
	var/spawn_announcement
	/// Report title.
	var/spawn_announcement_title
	/// Report sound clip.
	var/spawn_announcement_sound
	/// Time between initial spawn and round announcement.
	var/spawn_announcement_delay

//! ## Misc.
	/// Spawn point identifier.
	var/landmark_id
	/// Mobtype this antag will use if none is provided.
	var/mob_path = /mob/living/carbon/human
	/// End of round
	var/feedback_tag = "traitor_objective"
	/// Ban to check when spawning this antag.
	var/bantype = "Syndicate"
	/// Players need to be at least minimum_player_age days old before they are eligable for auto-spawning
	var/minimum_player_age = 7
	/// Prob of being on the initial Command report
	var/suspicion_chance = 50
	/// Various runtime options.
	var/flags = NONE

	/// Used for setting appearance.
	var/list/valid_species =       list(SPECIES_UNATHI,SPECIES_TAJ,SPECIES_SKRELL,SPECIES_HUMAN,SPECIES_DIONA,SPECIES_TESHARI)

//! ## Runtime vars.
	/// Current leader, if any.
	var/datum/mind/leader
	/// Autotraitor current effective maximum.
	var/cur_max = 0
	/// Has a bomb been spawned?
	var/spawned_nuke
	/// If so, where should it be placed?
	var/nuke_spawn_loc
	/// All marked antagonists for this type.
	var/list/current_antagonists = list()
	/// Candidates that are awaiting finalized antag status.
	var/list/pending_antagonists = list()
	/// Spawn points.
	var/list/starting_locations =  list()
	/// Universal objectives if any.
	var/list/global_objectives = list()
	/// Potential candidates.
	var/list/candidates = list()
	/// Semi-antags (in-round revs, borer thralls)
	var/list/faction_members = list()

	/// Determines whether or not the game mode will allow for the template to spawn try_latespawn.
	var/allow_latejoin = 0

//! ## ID card stuff.
	var/default_access = list()
	var/id_type = /obj/item/card/id

	var/antag_text = "You are an antagonist! Within the rules, \
		try to act as an opposing force to the crew. Further RP and try to make sure \
		other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

	/// If true, will be given the AOOC verb, along with the ability to use it.
	var/can_use_aooc = TRUE
	/// If FALSE, the antag can neither speak nor hear AOOC. If TRUE, they can at least hear it.
	var/can_hear_aooc = TRUE
	/// If TRUE, the antag can freely spean in AOOC.
	var/can_speak_aooc = TRUE

/datum/antagonist/New()
	..()
	cur_max = hard_cap
	get_starting_locations()
	if(!role_text_plural)
		role_text_plural = role_text
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs |= protected_jobs
	if(antaghud_indicator)
		if(!hud_icon_reference)
			hud_icon_reference = list()
		if(role_text) hud_icon_reference[role_text] = antaghud_indicator
		if(faction_role_text) hud_icon_reference[faction_role_text] = antaghud_indicator

/datum/antagonist/proc/tick()
	return TRUE

/datum/antagonist/proc/get_candidates(ghosts_only)
	candidates = list() // Clear.

	// Prune restricted status. Broke it up for readability.
	// Note that this is done before jobs are handed out.
	candidates = SSticker.mode.get_players_for_role(role_type, id, ghosts_only)
	for(var/datum/mind/player in candidates)

		if(ghosts_only && !istype(player.current, /mob/observer/dead))
			candidates -= player
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role! They have been removed from the draft.")

		else if(CONFIG_GET(flag/use_age_restriction_for_antags) && player.current.client.player_age < minimum_player_age)
			candidates -= player
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Is only [player.current.client.player_age] day\s old, has to be [minimum_player_age] day\s!")

		else if(player.special_role)
			candidates -= player
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They already have a special role ([player.special_role])! They have been removed from the draft.")

		else if (player in pending_antagonists)
			candidates -= player
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They have already been selected for this role! They have been removed from the draft.")

		else if(!can_become_antag(player))
			candidates -= player
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are blacklisted for this role! They have been removed from the draft.")

		else if(player_is_antag(player))
			candidates -= player
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist! They have been removed from the draft.")

	return candidates

/datum/antagonist/proc/attempt_random_spawn()
	build_candidate_list(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
	attempt_spawn()
	finalize_spawn()

/datum/antagonist/proc/attempt_late_spawn(datum/mind/player)
	if(!can_late_spawn())
		return FALSE
	if(!istype(player))
		var/list/players = get_candidates(is_latejoin_template())
		if(players && players.len)
			player = pick(players)
	if(!istype(player))
		message_admins(SPAN_ADMINNOTICE("[uppertext(SSticker.mode.name)]: Failed to find a candidate for [role_text]."))
		return FALSE
	to_chat(player.current, SPAN_ADMIN("<i>You have been selected this round as an antagonist!</i>"))
	message_admins(SPAN_ADMINNOTICE("[uppertext(SSticker.mode.name)]: Selected [player] as a [role_text]."))
	if(istype(player.current, /mob/observer/dead))
		create_default(player.current)
	else
		add_antagonist(player,0,0,0,1,1)
	return TRUE

/datum/antagonist/proc/build_candidate_list(var/ghosts_only)
	// Get the raw list of potential players.
	update_current_antag_max()
	candidates = get_candidates(ghosts_only)

/**
 * Selects players that will be spawned in the antagonist role from the potential candidates
 * Selected players are added to the pending_antagonists lists.
 * Attempting to spawn an antag role with ANTAG_OVERRIDE_JOB should be done before jobs are assigned,
 * so that they do not occupy regular job slots. All other antag roles should be spawned after jobs are
 * assigned, so that job restrictions can be respected.
 */
/datum/antagonist/proc/attempt_spawn(rebuild_candidates = TRUE)

	// Update our boundaries.
	if(!candidates.len)
		return FALSE

	//Grab candidates randomly until we have enough.
	while(candidates.len && pending_antagonists.len < initial_spawn_target)
		var/datum/mind/player = pick(candidates)
		candidates -= player
		draft_antagonist(player)

	return TRUE

/datum/antagonist/proc/draft_antagonist(datum/mind/player)
	//Check if the player can join in this antag role, or if the player has already been given an antag role.
	if(!can_become_antag(player) || (player.assigned_role in roundstart_restricted))
		log_debug("[player.key] was selected for [role_text] by lottery, but is not allowed to be that role.")
		return FALSE
	if(player.special_role)
		log_debug("[player.key] was selected for [role_text] by lottery, but they already have a special role.")
		return FALSE
	if(!(flags & ANTAG_OVERRIDE_JOB) && (!player.current || istype(player.current, /mob/new_player)))
		log_debug("[player.key] was selected for [role_text] by lottery, but they have not joined the game.")
		return FALSE

	pending_antagonists |= player
	log_debug("[player.key] has been selected for [role_text] by lottery.")

	//Ensure that antags with ANTAG_OVERRIDE_JOB do not occupy job slots.
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text

	//Ensure that a player cannot be drafted for multiple antag roles, taking up slots for antag roles that they will not fill.
	player.special_role = role_text

	return TRUE

/// Spawns all pending_antagonists. This is done separately from attempt_spawn in case the game mode setup fails.
/datum/antagonist/proc/finalize_spawn()
	if(!pending_antagonists)
		return

	for(var/datum/mind/player in pending_antagonists)
		pending_antagonists -= player
		add_antagonist(player,0,0,1)

/// Resets all pending_antagonists, clearing their special_role (and assigned_role if ANTAG_OVERRIDE_JOB is set)
/datum/antagonist/proc/reset()
	for(var/datum/mind/player in pending_antagonists)
		if(flags & ANTAG_OVERRIDE_JOB)
			player.assigned_role = null
		player.special_role = null
	pending_antagonists.Cut()
