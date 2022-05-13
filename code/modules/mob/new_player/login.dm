GLOBAL_DATUM_INIT(lobby_image, /obj/effect/lobby_image, new)

/obj/effect/lobby_image
	name = "Citadel Station 13"
	desc = "How are you reading this?"
	screen_loc = "1,1"

/obj/effect/lobby_image/Initialize(mapload)
	icon = GLOB.using_map.lobby_icon
	var/known_icon_states = icon_states(icon)
	for(var/lobby_screen in GLOB.using_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			log_world("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			GLOB.using_map.lobby_screens -= lobby_screen

	if(GLOB.using_map.lobby_screens.len)
		icon_state = pick(GLOB.using_map.lobby_screens)
	else
		icon_state = known_icon_states[1]
	. = ..()

//TODO: /mob/dead/new_player
/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled
	var/ready = FALSE

/mob/new_player/Login()
	if(!client)
		return
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.set_current(src)
	. = ..()
	if(!. || !client)
		return FALSE

	var/motd = config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)
	if(client)
		to_chat(src, client.getAlertDesc())

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	my_client = client
	GLOB.player_list |= src

	sight |= SEE_TURFS

	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()

	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		to_chat(src, "Please set up your character and select \"Ready\". The game will start [tl > 0 ? "in about [DisplayTimeText(tl)]" : "soon"].")

	return ..()
