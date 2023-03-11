/*
	This state checks if src_object is contained anywhere in the user's inventory, including bags, etc.
*/
var/global/datum/topic_state/deep_inventory_nano_state/deep_inventory_nano_state = new()

/datum/topic_state/deep_inventory_nano_state/can_use_topic(src_object, mob/user)
	if(!user.contains(src_object))
		return UI_CLOSE

	return user.shared_nano_interaction()
