/datum/category_item/player_setup_item/player_global/ooc
	name = "OOC"
	sort_order = 5

/datum/category_item/player_setup_item/player_global/ooc/load_preferences(savefile/S)
	READ_FILE(S["ignored_players"], pref.ignored_players)

/datum/category_item/player_setup_item/player_global/ooc/save_preferences(savefile/S)
	WRITE_FILE(S["ignored_players"], pref.ignored_players)

/datum/category_item/player_setup_item/player_global/ooc/sanitize_preferences()
	if(isnull(pref.ignored_players))
		pref.ignored_players = list()

/datum/category_item/player_setup_item/player_global/ooc/content(mob/user)
	. += "<b>OOC Preferences</b><hr>"
	. += "Ignored Players:<br>"
	for(var/ignored_player in pref.ignored_players)
		. += "- [ignored_player] - <a href='?src=\ref[src];unignore_player=[ignored_player]'>Unignore Player</a><br>"
	. += "- <a href='?src=\ref[src];ignore_player=1'>Ignore Another Player</a><br>"

/datum/category_item/player_setup_item/player_global/ooc/OnTopic(href, list/href_list, mob/user)
	if(href_list["unignore_player"])
		if(CanUseTopic(user))
			pref.ignored_players -= href_list["unignore_player"]
			return TOPIC_REFRESH

	if(href_list["ignore_player"])
		if(CanUseTopic(user))
			var/player_to_ignore = tgui_input_text(user, "Who do you want to ignore?", "OOC Preference")
			if(player_to_ignore)
				player_to_ignore = sanitize(ckey(player_to_ignore))
				if(player_to_ignore == user.ckey)
					to_chat(user, SPAN_NOTICE("You can't ignore yourself."))
					return TOPIC_REFRESH
				pref.ignored_players |= player_to_ignore
			return TOPIC_REFRESH

	return ..()
