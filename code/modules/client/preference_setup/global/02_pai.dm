/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 2

	var/datum/paiCandidate/candidate

/datum/category_item/player_setup_item/player_global/pai/load_preferences(savefile/S)
	if(!candidate)
		candidate = new()

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/save_preferences(savefile/S)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/content(mob/user)
	if(!candidate)
		log_debug("[user] pAI prefs have a null candidate var.")
		return .

	. += {"
	<b>pAI Preferences</b><hr>
	<table>
		<tr>
			<td>Name:</td>
			<td><a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a></td>
		</tr>
		<tr>
			<td>Description:</td>
			<td><a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a></td>
		</tr>
		<tr>
			<td>Role:</td>
			<td><a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a></td>
		</tr>
		<tr>
			<td>OOC Comments:</td>
			<td><a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a></td>
		</tr>
	</table>
	"}

/datum/category_item/player_setup_item/player_global/pai/OnTopic(href, list/href_list, mob/user)
	if(href_list["option"])
		var/text_input
		switch(href_list["option"])
			if("name")
				text_input = sanitizeName(tgui_input_text(user, "Enter a name for your pAI", "Global Preference", candidate.name))
				if(text_input && CanUseTopic(user))
					candidate.name = text_input
			if("desc")
				text_input = tgui_input_text(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description), multiline = TRUE)
				if(!isnull(text_input) && CanUseTopic(user))
					candidate.description = sanitize(text_input)
			if("role")
				text_input = tgui_input_text(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role))
				if(!isnull(text_input) && CanUseTopic(user))
					candidate.role = sanitize(text_input)
			if("ooc")
				text_input = tgui_input_text(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments), multiline = TRUE)
				if(!isnull(text_input) && CanUseTopic(user))
					candidate.comments = sanitize(text_input)
		return TOPIC_REFRESH

	return ..()
