/client/proc/Jump(var/area/A in GLOB.sortedAreas)
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	usr.forceMove(pick(get_area_turfs(A)))

	log_admin("[key_name(usr)] jumped to [A]")
	message_admins("[key_name_admin(usr)] jumped to [A]", 1)
	feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(turf/T in world)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
	message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
	usr.forceMove(T)
	feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptomob(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Jump to Mob"
	set popup_menu = FALSE
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = get_turf(M)
		if(T && isturf(T))
			feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			A.forceMove(T)
		else
			to_chat(A, "This mob is not located in the game world.")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = locate(tx, ty, tz)
		if(!T)
			to_chat(src, SPAN_WARNING("[tx], [ty], [tz] does not exist!"))
			return
		A.forceMove(T)
		feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")


/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/list/keys = list()
	for(var/mob/M in player_list)
		keys += M.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection:mob
	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
	usr.forceMove(M.loc)
	feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getmob(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	var/msg = "[key_name_admin(usr)] jumped to [key_name_admin(M)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	M.forceMove(get_turf(usr))
	feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/list/keys = list()
	for(var/mob/M in player_list)
		keys += M.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection:mob

	if(!M)
		return
	log_admin("[key_name(usr)] teleported [key_name(M)]")
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	if(M)
		M.forceMove(get_turf(usr))
		feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/sendmob(mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	var/area/A = input(usr, "Pick an area.", "Pick an area") in GLOB.sortedAreas
	if(A)
		M.forceMove(pick(get_area_turfs(A)))
		feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		log_admin("[key_name(usr)] teleported [key_name(M)]")
		var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
		message_admins(msg)
		admin_ticket_log(M, msg)
