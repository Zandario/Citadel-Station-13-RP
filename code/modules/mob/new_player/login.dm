/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	var/motd = config.motd
	if(motd)
		to_chat(src, "<blockquote class=\"motd\">[motd]</blockquote>", handle_whitespace=FALSE)
	if(client)
		to_chat(src, client.getAlertDesc())

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	GLOB.player_list |= src

	new_player_panel()

	sight |= SEE_TURFS

	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
	return ..()
