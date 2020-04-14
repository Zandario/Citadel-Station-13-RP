SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	wait = 20
	init_order = INIT_ORDER_TICKER
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/const/restart_timeout = 3 MINUTES //One minute is 600.
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/post_game = 0
	var/event_time = null
	var/event = 0

	// var/login_music			// music played in pregame lobby // VOREStation Edit - We do music differently

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/Bible_icon_state	// icon_state the chaplain has chosen for his bible
	var/Bible_item_state	// item_state the chaplain has chosen for his bible
	var/Bible_name			// name of the bible
	var/Bible_deity_name

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 0

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0//Global holder for Triumvirate

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

/datum/controller/subsystem/ticker/proc/setup()
	//Create and announce mode
	if(master_mode=="secret")
		src.hide_mode = 1

	var/list/runnable_modes = config_legacy.get_runnable_modes()
	if((master_mode=="random") || (master_mode=="secret"))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			Master.SetRunLevel(RUNLEVEL_LOBBY)
			to_chat(world, "<B>Unable to choose playable game mode.</B> Reverting to pregame lobby.")
			return 0
		if(secret_force_mode != "secret")
			src.mode = config_legacy.pick_mode(secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = config_legacy.probabilities[GM.config_tag]
			src.mode = config_legacy.gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = config_legacy.pick_mode(master_mode)

	if(!src.mode)
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		to_chat(world, "<span class='danger'>Serious error in mode setup!</span> Reverting to pregame lobby.") //Uses setup instead of set up due to computational context.
		return 0

	SSjobs.ResetOccupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	SSjobs.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!src.mode.can_start())
		to_chat(world, "<B>Unable to start [mode.name].</B> Not enough players readied, [config_legacy.player_requirements[mode.config_tag]] players needed. Reverting to pregame lobby.")
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		mode.fail_setup()
		mode = null
		SSjobs.ResetOccupations()
		return 0

	if(hide_mode)
		to_chat(world, "<B>The current game mode is - Secret!</B>")
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				to_chat(world, "<B>Possibilities:</B> [english_list(tmpmodes, and_text= "; ", comma_text = "; ")]")
	else
		src.mode.announce()

	setup_economy()
	current_state = GAME_STATE_PLAYING
	create_characters() //Create player characters and transfer them.
	collect_minds()
	equip_characters()
	//data_core.manifest()	//VOREStation Removal

	callHook("roundstart")

	// TODO - Leshana - Dear God Fix This.  Fix all of this. Not just this line, this entire proc. This entire file!
	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)
		to_chat(world, "<FONT color='blue'><B>Enjoy the game!</B></FONT>")
		world << sound('sound/AI/welcome.ogg') // Skie
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2adminirc("A round has started with no admins online.")

/*	SSsupply.process() 		//Start the supply shuttle regenerating points -- TLE // handled in scheduler
	master_controller.process()		//Start master_controller.process()
	lighting_controller.process()	//Start processing DynamicAreaLighting updates
	*/

	Master.SetRunLevel(RUNLEVEL_GAME)

	if(config_legacy.sql_enabled)
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(var/station_missed=0, var/override = null)
	if( cinematic )	return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.layer = 100
	cinematic.plane = PLANE_PLAYER_HUD
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	var/obj/structure/bed/temp_buckle = new(src)
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle
			if(M.client)
				M.client.screen += cinematic

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && T.z in GLOB.using_map.station_levels)				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.stat = DEAD
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.stat = DEAD

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					//flick("end",cinematic)


		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			world << sound('sound/effects/explosionfar.ogg')


		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in living_mob_list)
				if(M.loc.z in GLOB.using_map.station_levels)
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)	qdel(cinematic)		//end the cinematic
	if(temp_buckle)	qdel(temp_buckle)	//release everybody
	return


/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/new_player/player in player_list)
		if(player && player.ready && player.mind)
			if(player.mind.assigned_role=="AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				//VOREStation Edit Start
				var/mob/living/carbon/human/new_char = player.create_character()
				if(new_char)
					qdel(player)
				if(istype(new_char) && !(new_char.mind.assigned_role=="Cyborg"))
					data_core.manifest_inject(new_char)
				//VOREStation Edit End


/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in player_list)
		if(player.mind)
			minds += player.mind


/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless=1
	for(var/mob/living/carbon/human/player in player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == "Colony Director")
				captainless=0
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				SSjobs.EquipRank(player, player.mind.assigned_role, 0)
				UpdateFactionList(player)
				//equip_custom_items(player)	//VOREStation Removal
				//player.apply_traits() //VOREStation Removal
	if(captainless)
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				to_chat(M, "Colony Directorship not forced on anyone.")

/datum/controller/subsystem/ticker/Initialize()
	if(!syndicate_code_phrase)
		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)
		syndicate_code_response = generate_code_phrase()

	// Set up antagonists.
	populate_antag_type_list()

	//Set up spawn points.
	populate_spawn_points()

	send2mainirc("Server lobby is loaded and open at byond://[config_legacy.serverurl ? config_legacy.serverurl : (config_legacy.server ? config_legacy.server : "[world.address]:[world.port]")]")
	pregame_timeleft = 180
	to_chat(world, "<B><FONT color='blue'>Welcome to the pregame lobby!</FONT></B>")
	to_chat(world, "Please set up your character and select ready. The round will start in [pregame_timeleft] seconds.")
	return ..()

/datum/controller/subsystem/ticker/fire()
	switch(current_state)
		if(GAME_STATE_PREGAME)
			pregame()
		if(GAME_STATE_SETTING_UP)
			setup()
		if(GAME_STATE_PLAYING)
			round_process()

/datum/controller/subsystem/ticker/proc/pregame()
	if(round_progressing)
		pregame_timeleft--
	if(pregame_timeleft == config_legacy.vote_autogamemode_timeleft)
		if(!SSvote.time_remaining)
			SSvote.autogamemode()	//Quit calling this over and over and over and over.
	if(pregame_timeleft <= 0)
		current_state = GAME_STATE_SETTING_UP
		Master.SetRunLevel(RUNLEVEL_SETUP)

/datum/controller/subsystem/ticker/proc/round_process()
	if(current_state != GAME_STATE_PLAYING)
		return 0

	mode.process()

//		SSemergencyshuttle.process() //handled in scheduler

	var/game_finished = 0
	var/mode_finished = 0
	if (config_legacy.continous_rounds)
		game_finished = (SSemergencyshuttle.returned() || mode.station_was_nuked)
		mode_finished = (!post_game && mode.check_finished())
	else
		game_finished = (mode.check_finished() || (SSemergencyshuttle.returned() && SSemergencyshuttle.evac == 1)) || universe_has_ended
		mode_finished = game_finished

	if(!mode.explosion_in_progress && game_finished && (mode_finished || post_game))
		current_state = GAME_STATE_FINISHED
		Master.SetRunLevel(RUNLEVEL_POSTGAME)

		spawn
			declare_completion()

		spawn(50)
			callHook("roundend")

			var/time_left

			if (mode.station_was_nuked)
				feedback_set_details("end_proper","nuke")
				time_left = 1 MINUTE //No point waiting five minutes if everyone's dead.
				if(!delay_end)
					to_chat(world, "<span class='notice'><b>Rebooting due to destruction of station in [round(time_left/600)] minutes.</b></span>")
			else
				feedback_set_details("end_proper","proper completion")
				time_left = round(restart_timeout)


			if(blackbox)
				blackbox.save_all_data_to_sql()

			if(!delay_end)
				while(time_left > 0)
					if(delay_end)
						break
					to_chat(world, "<span class='notice'><b>Restarting in [round(time_left/600)] minute\s.</b></span>")
					time_left -= 1 MINUTES
					sleep(600)
				if(!delay_end)
					world.Reboot()
				else
					to_chat(world, "<span class='notice'><b>An admin has delayed the round end.</b></span>")
			else
				to_chat(world, "<span class='notice'><b>An admin has delayed the round end.</b></span>")

	else if (mode_finished)
		post_game = 1

		mode.cleanup()

		//call a transfer shuttle vote
		spawn(50)
			if(!round_end_announced) // Spam Prevention. Now it should announce only once.
				to_chat(world, "<span class='danger'>The round has ended!</span>")
				round_end_announced = 1
			SSvote.autotransfer()

	return 1

/datum/controller/subsystem/ticker/proc/declare_completion()
	to_chat(world, "<br><br><br><H1>A round of [mode.name] has ended!</H1>")
	for(var/mob/Player in player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(SSemergencyshuttle.departed && SSemergencyshuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<font color='blue'><b>You survived the round, but remained on [station_name()] as [Player.real_name].</b></font>")
					else
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else
					to_chat(Player, "<font color='blue'><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>")
			else
				if(istype(Player,/mob/observer/dead))
					var/mob/observer/dead/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
	to_chat(world, "<br>")

	for (var/mob/living/silicon/ai/aiPlayer in mob_list)
		if (aiPlayer.stat != 2)
			to_chat(world, "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the round were:</b>")
		else
			to_chat(world, "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>")
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			to_chat(world, "[robolist]")

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in mob_list)

		if(istype(robo,/mob/living/silicon/robot/drone) && !istype(robo,/mob/living/silicon/robot/drone/swarm))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_chat(world, "<b>[robo.name] (Played by: [robo.key]) survived as an AI-less stationbound synthetic! Its laws were:</b>")
			else
				to_chat(world, "<b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a stationbound synthetic without an AI. Its laws were:</b>")

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_chat(world, "<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b>")

	mode.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	SSevents.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	return 1