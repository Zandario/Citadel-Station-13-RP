var/global/list/uplink_locations = list("PDA", "Headset", "None")

/datum/category_item/player_setup_item/antagonism/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/antagonism/basic/load_character(savefile/S)
	READ_FILE(S["uplinklocation"], pref.uplinklocation)
	READ_FILE(S["exploit_record"], pref.exploit_record)
	READ_FILE(S["antag_faction"], pref.antag_faction)
	READ_FILE(S["antag_vis"], pref.antag_vis)

/datum/category_item/player_setup_item/antagonism/basic/save_character(savefile/S)
	WRITE_FILE(S["uplinklocation"], pref.uplinklocation)
	WRITE_FILE(S["exploit_record"], pref.exploit_record)
	WRITE_FILE(S["antag_faction"], pref.antag_faction)
	WRITE_FILE(S["antag_vis"], pref.antag_vis)

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	pref.uplinklocation	= sanitize_inlist(pref.uplinklocation, uplink_locations, initial(pref.uplinklocation))

	if(!pref.antag_faction)
		pref.antag_faction = "None"
	if(!pref.antag_vis)
		pref.antag_vis = "Hidden"

/datum/category_item/player_setup_item/antagonism/basic/copy_to_mob(mob/living/carbon/human/character)
	character.exploit_record = pref.exploit_record
	character.antag_faction  = pref.antag_faction
	character.antag_vis      = pref.antag_vis

/datum/category_item/player_setup_item/antagonism/basic/content(mob/user)
	. += "Faction: <a href='?src=\ref[src];antagfaction=1'>[pref.antag_faction]</a><br/>"
	. += "Visibility: <a href='?src=\ref[src];antagvis=1'>[pref.antag_vis]</a><br/>"
	. +="<b>Uplink Type : <a href='?src=\ref[src];antagtask=1'>[pref.uplinklocation]</a></b>"
	. +="<br>"
	. +="<b>Exploitable information:</b><br>"
	if(jobban_isbanned(user, "Records"))
		. += "<b>You are banned from using character records.</b><br>"
	else
		. +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(href, list/href_list, mob/user)
	if (href_list["antagtask"])
		pref.uplinklocation = next_list_item(pref.uplinklocation, uplink_locations)
		return TOPIC_REFRESH

	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(tgui_input_text(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record), MAX_RECORD_LENGTH, TRUE), MAX_RECORD_LENGTH, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	if(href_list["antagfaction"])
		var/choice = tgui_input_list(user, "Please choose an antagonistic faction to work for.", "Character Preference", antag_faction_choices + list("None","Other"), pref.antag_faction)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(tgui_input_text(user, "Please enter a faction.", "Character Preference", pref.antag_faction))
			if(raw_choice)
				pref.antag_faction = raw_choice
		else
			pref.antag_faction = choice
		return TOPIC_REFRESH

	if(href_list["antagvis"])
		var/choice = tgui_input_list(user, "Please choose an antagonistic visibility level.", "Character Preference", antag_visiblity_choices, pref.antag_vis)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		else
			pref.antag_vis = choice
		return TOPIC_REFRESH

	return ..()
