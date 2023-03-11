/var/global/datum/topic_state/default_nano_state/outside/outside_state = new()

/datum/topic_state/default_nano_state/outside/can_use_topic(var/src_object, var/mob/user)
	if(user in src_object)
		return UI_CLOSE
	return ..()
