/datum/preferences
	var/media_volume = 100
	var/media_player = 2 // 0 = VLC, 1 = WMP, 2 = HTML5, 3+ = unassigned

/datum/category_item/player_setup_item/player_global/media
	name = "Media"
	sort_order = 3

/datum/category_item/player_setup_item/player_global/media/load_preferences(savefile/S)
	READ_FILE(S["media_volume"], pref.media_volume)
	READ_FILE(S["media_player"], pref.media_player)

/datum/category_item/player_setup_item/player_global/media/save_preferences(savefile/S)
	WRITE_FILE(S["media_volume"], pref.media_volume)
	WRITE_FILE(S["media_player"], pref.media_player)

/datum/category_item/player_setup_item/player_global/media/sanitize_preferences()
	pref.media_volume = isnum(pref.media_volume) ? pref.media_volume : initial(pref.media_volume)
	pref.media_player = sanitize_inlist(pref.media_player, list(0, 1, 2), initial(pref.media_player))

/datum/category_item/player_setup_item/player_global/media/content(mob/user)
	. += "<b>Media Preferences</b><hr>"
	. += "Jukebox Volume: <a href='?src=\ref[src];change_media_volume=1'><b>[pref.media_volume]%</b></a><br>"
	. += "Media Player Type: "
	. += (pref.media_player == 2) ? "<span class='linkOn'><b>HTML5</b></span> " : "<a href='?src=\ref[src];set_media_player=2'>HTML5</a> "
	. += (pref.media_player == 1) ? "<span class='linkOn'><b>WMP</b></span> " : "<a href='?src=\ref[src];set_media_player=1'>WMP</a> "
	. += (pref.media_player == 0) ? "<span class='linkOn'><b>VLC</b></span> " : "<a href='?src=\ref[src];set_media_player=0'>VLC</a> "
	. += {"<br><b>HTML5 Media Player</b><br>
		HTML5 is the default media player for the jukebox. It is the most compatible and will work on any device.<br>
		<b>WMP Media Player</b><br>
		WMP is the Windows Media Player. It is only compatible with Windows and Internet Explorer.<br>
		<b>VLC Media Player</b><br>
		VLC is a free and open source media player. It is compatible with most operating systems and browsers.<br>"}

/datum/category_item/player_setup_item/player_global/media/OnTopic(href, list/href_list, mob/user)
	if(href_list["change_media_volume"])
		if(CanUseTopic(user))
			var/value = tgui_input_number(user, "Choose your Jukebox volume (0-100%)", "Media Preference", pref.media_volume, 100, 0, round_value = TRUE)
			if(value != pref.media_volume)
				pref.media_volume = value
				if(user.client && user.client.media)
					user.client.media.update_volume(pref.media_volume)
			return TOPIC_REFRESH

	else if(href_list["set_media_player"])
		if(CanUseTopic(user))
			var/newval = sanitize_inlist(text2num(href_list["set_media_player"]), list(0, 1, 2), pref.media_player)
			if(newval != pref.media_player)
				pref.media_player = newval
				if(user.client && user.client.media)
					user.client.media.open()
					spawn(10)
						user.update_music()
			return TOPIC_REFRESH
	return ..()
