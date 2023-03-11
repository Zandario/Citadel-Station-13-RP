/*
	This state checks that the user is an admin, end of story
*/
GLOBAL_DATUM_INIT(admin_nano_state, /datum/topic_state/admin_nano_state, new)

/datum/topic_state/admin_nano_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_ADMIN))
		return UI_INTERACTIVE
	return UI_CLOSE
