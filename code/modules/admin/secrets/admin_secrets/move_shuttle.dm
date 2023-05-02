datum/admin_secret_item/admin_secret/move_shuttle
	name = "Move a Shuttle"

datum/admin_secret_item/admin_secret/move_shuttle/can_execute(var/mob/user)
	if(!SSshuttle) return 0
	return ..()

datum/admin_secret_item/admin_secret/move_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/confirm = alert(user, "This command directly moves a shuttle from one area to another. DO NOT USE THIS UNLESS YOU ARE DEBUGGING A SHUTTLE AND YOU KNOW WHAT YOU ARE DOING.", "Are you sure?", "Ok", "Cancel")
	if (confirm == "Cancel")
		return

	var/shuttle_tag = input(user, "Which shuttle do you want to jump?") as null|anything in SSshuttle.shuttles
	if (!shuttle_tag) return

	var/datum/shuttle/S = SSshuttle.shuttles[shuttle_tag]

	var/destination_tag = input(user, "Which landmark do you want to jump to? (IF YOU GET THIS WRONG THINGS WILL BREAK)") as null|anything in SSshuttle.registered_shuttle_landmarks
	if (!destination_tag) return

	var/destination_location = SSshuttle.get_landmark(destination_tag)
	if (!destination_location) return

	S.attempt_move(destination_location)
	log_and_message_admins("moved the [shuttle_tag] shuttle", user)
