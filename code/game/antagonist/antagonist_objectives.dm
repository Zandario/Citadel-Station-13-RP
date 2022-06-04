/datum/antagonist/proc/create_global_objectives()
	if(CONFIG_GET(flag/objectives_disabled))
		return FALSE
	if(global_objectives && global_objectives.len)
		return FALSE
	return TRUE

/datum/antagonist/proc/create_objectives(datum/mind/player)
	if(CONFIG_GET(flag/objectives_disabled))
		return FALSE
	if(create_global_objectives() || global_objectives.len)
		player.objectives |= global_objectives
	return TRUE

/datum/antagonist/proc/get_special_objective_text()
	return ""

/datum/antagonist/proc/check_victory()
	var/result = TRUE
	if(CONFIG_GET(flag/objectives_disabled))
		return TRUE
	if(global_objectives && global_objectives.len)
		for(var/datum/objective/O in global_objectives)
			if(!O.completed && !O.check_completion())
				result = FALSE
		if(result && victory_text)
			to_chat(world, SPAN_BOLDANNOUNCE("[victory_text]"))
			if(victory_feedback_tag) feedback_set_details("round_end_result","[victory_feedback_tag]")
		else if(loss_text)
			to_chat(world, SPAN_BOLDANNOUNCE(">[loss_text]"))
			if(loss_feedback_tag) feedback_set_details("round_end_result","[loss_feedback_tag]")

/mob/living/proc/write_ambition()
	set name = "Set Ambition"
	set category = "IC"
	set src = usr

	if(!mind)
		return
	if(!is_special_character(mind))
		to_chat(src, SPAN_WARNING("While you may perhaps have goals, this verb's meant to only be visible \
		to antagonists.  Please make a bug report!"))
		return
	var/new_ambitions = input(src, "Write a short sentence of what your character hopes to accomplish \
	today as an antagonist.  Remember that this is purely optional.  It will be shown at the end of the \
	round for everybody else.", "Ambitions", mind.ambitions) as null|message
	if(isnull(new_ambitions))
		return
	new_ambitions = sanitize(new_ambitions)
	mind.ambitions = new_ambitions
	if(new_ambitions)
		to_chat(src, SPAN_NOTICE("You've set your goal to be '[new_ambitions]'."))
	else
		to_chat(src, SPAN_NOTICE("You leave your ambitions behind."))
	log_and_message_admins("has set their ambitions to now be: [new_ambitions].")
