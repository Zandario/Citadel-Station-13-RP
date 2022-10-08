/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(savefile/S)
	READ_FILE(S["all_underwear"], pref.all_underwear)
	READ_FILE(S["all_underwear_metadata"], pref.all_underwear_metadata)
	READ_FILE(S["backbag"], pref.backbag)
	READ_FILE(S["pdachoice"], pref.pdachoice)
	READ_FILE(S["communicator_visibility"], pref.communicator_visibility)
	READ_FILE(S["ringtone"], pref.ringtone)

/datum/category_item/player_setup_item/general/equipment/save_character(savefile/S)
	WRITE_FILE(S["all_underwear"], pref.all_underwear)
	WRITE_FILE(S["all_underwear_metadata"], pref.all_underwear_metadata)
	WRITE_FILE(S["backbag"], pref.backbag)
	WRITE_FILE(S["pdachoice"], pref.pdachoice)
	WRITE_FILE(S["communicator_visibility"], pref.communicator_visibility)
	WRITE_FILE(S["ringtone"], pref.ringtone)

/datum/category_item/player_setup_item/general/equipment/copy_to_mob(mob/living/carbon/human/character)
	character.all_underwear.Cut()
	character.all_underwear_metadata.Cut()

	for(var/underwear_category_name in pref.all_underwear)
		var/datum/category_group/underwear/underwear_category = GLOB.global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = pref.all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
			if(pref.all_underwear_metadata[underwear_category_name])
				character.all_underwear_metadata[underwear_category_name] = pref.all_underwear_metadata[underwear_category_name]
		else
			pref.all_underwear -= underwear_category_name

	// TODO - Looks like this is duplicating the work of sanitize_character() if so, remove
	if(pref.backbag > 7 || pref.backbag < 1)
		pref.backbag = 1 //Same as above
	character.backbag = pref.backbag

	if(pref.pdachoice > 7 || pref.pdachoice < 1)
		pref.pdachoice = 1
	character.pdachoice = pref.pdachoice

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	if(!islist(pref.gear)) pref.gear = list()

	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in GLOB.global_underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.identifying_gender ? pref.identifying_gender : MALE))
					pref.all_underwear[WRC.name] = WRI.name
					break

	if(!istype(pref.all_underwear_metadata))
		pref.all_underwear_metadata = list()

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = GLOB.global_underwear.categories_by_name[underwear_category]
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[pref.all_underwear[underwear_category]]
			if(!UWI)
				pref.all_underwear -= underwear_category

	for(var/underwear_metadata in pref.all_underwear_metadata)
		if(!(underwear_metadata in pref.all_underwear))
			pref.all_underwear_metadata -= underwear_metadata

	pref.backbag   = sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))
	pref.pdachoice = sanitize_integer(pref.pdachoice, 1, pdachoicelist.len, initial(pref.pdachoice))
	pref.ringtone  = sanitize(pref.ringtone, 20)

/datum/category_item/player_setup_item/general/equipment/content()
	var/html = list()
	html += "<b>Equipment Preferences</b><hr>"
	for(var/datum/category_group/underwear/UWC in GLOB.global_underwear.categories)
		var/item_name = pref.all_underwear[UWC.name] ? pref.all_underwear[UWC.name] : "None"
		html += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'>[item_name]</a>"
		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				html += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_metadata(UWC.name, gt))]</a>"

		html += "<br>"
	html += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'>[backbaglist[pref.backbag]]</a><br>"
	html += "PDA Type: <a href='?src=\ref[src];change_pda=1'>[pdachoicelist[pref.pdachoice]]</a><br>"
	html += "Communicator Visibility: <a href='?src=\ref[src];toggle_comm_visibility=1'>[(pref.communicator_visibility) ? "Yes" : "No"]</a><br>"
	html += "Ringtone: "
	if(pref.ringtone == initial(pref.ringtone))
		html += "<a href='?src=\ref[src];set_ringtone=1'>Using Job Default</a><br>"
	else
		html += "<a href='?src=\ref[src];set_ringtone=1'>[pref.ringtone]</a> <a href='?src=\ref[src];reset_ringtone=1'>reset</a><br>"

	return jointext(html,null)

/datum/category_item/player_setup_item/general/equipment/proc/get_metadata(underwear_category, datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/general/equipment/proc/set_metadata(underwear_category, datum/gear_tweak/gt, new_metadata)
	var/list/metadata = pref.all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata


/datum/category_item/player_setup_item/general/equipment/OnTopic(href, list/href_list, mob/user)
	if(href_list["change_backpack"])
		var/new_backbag = tgui_input_list(user, "Choose your character's style of bag:", "Character Preference", backbaglist, backbaglist[pref.backbag])
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_pda"])
		var/new_pdachoice = tgui_input_list(user, "Choose your character's style of PDA:", "Character Preference", pdachoicelist, pdachoicelist[pref.pdachoice])
		if(!isnull(new_pdachoice) && CanUseTopic(user))
			pref.pdachoice = pdachoicelist.Find(new_pdachoice)
			return TOPIC_REFRESH

	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = GLOB.global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return
		var/datum/category_item/underwear/selected_underwear = tgui_input_list(user, "Choose underwear:", "Character Preference", UWC.items, pref.all_underwear[UWC.name])
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear[UWC.name] = selected_underwear.name
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["underwear"] && href_list["tweak"])
		var/underwear = href_list["underwear"]
		if(!(underwear in pref.all_underwear))
			return TOPIC_NOACTION

		var/datum/gear_tweak/gt = locate(href_list["tweak"])
		if(!gt)
			return TOPIC_NOACTION

		var/new_metadata = gt.get_metadata(usr, get_metadata(underwear, gt))
		if(new_metadata)
			set_metadata(underwear, gt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_comm_visibility"])
		if(CanUseTopic(user))
			pref.communicator_visibility = !pref.communicator_visibility
			return TOPIC_REFRESH

	else if(href_list["set_ringtone"])
		if(CanUseTopic(user))
			pref.ringtone = sanitize(tgui_input_text(user, "Choose your character's name:", "Character Name", pref.ringtone, 20))
			return TOPIC_REFRESH

	else if(href_list["reset_ringtone"])
		if(CanUseTopic(user))
			pref.ringtone = initial(pref.ringtone)
			return TOPIC_REFRESH

	return ..()
