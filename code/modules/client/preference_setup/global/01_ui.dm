/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(savefile/S)
	READ_FILE(S["UI_style"], pref.UI_style)
	READ_FILE(S["UI_style_color"], pref.UI_style_color)
	READ_FILE(S["UI_style_alpha"], pref.UI_style_alpha)
	READ_FILE(S["ooccolor"], pref.ooccolor)
	READ_FILE(S["tooltipstyle"], pref.tooltipstyle)
	READ_FILE(S["client_fps"], pref.client_fps)

	READ_FILE(S["tgui_fancy"], pref.tgui_fancy)
	READ_FILE(S["tgui_lock"], pref.tgui_lock)
	READ_FILE(S["tgui_input_mode"], pref.tgui_input_mode)
	READ_FILE(S["tgui_large_buttons"], pref.tgui_large_buttons)
	READ_FILE(S["tgui_swapped_buttons"], pref.tgui_swapped_buttons)

/datum/category_item/player_setup_item/player_global/ui/save_preferences(savefile/S)
	WRITE_FILE(S["UI_style"], pref.UI_style)
	WRITE_FILE(S["UI_style_color"], pref.UI_style_color)
	WRITE_FILE(S["UI_style_alpha"], pref.UI_style_alpha)
	WRITE_FILE(S["ooccolor"], pref.ooccolor)
	WRITE_FILE(S["tooltipstyle"], pref.tooltipstyle)
	WRITE_FILE(S["client_fps"], pref.client_fps)

	WRITE_FILE(S["tgui_fancy"], pref.tgui_fancy)
	WRITE_FILE(S["tgui_lock"], pref.tgui_lock)
	WRITE_FILE(S["tgui_input_mode"], pref.tgui_input_mode)
	WRITE_FILE(S["tgui_large_buttons"], pref.tgui_large_buttons)
	WRITE_FILE(S["tgui_swapped_buttons"], pref.tgui_swapped_buttons)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style       = sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color = sanitize_hexcolor(pref.UI_style_color, 6, 1, initial(pref.UI_style_color))
	pref.UI_style_alpha = sanitize_integer(pref.UI_style_alpha, 50, 255, initial(pref.UI_style_alpha))
	pref.ooccolor       = sanitize_ooccolor(sanitize_hexcolor(pref.ooccolor, 6, 1, initial(pref.ooccolor)))
	pref.tooltipstyle   = sanitize_inlist(pref.tooltipstyle, all_tooltip_styles, initial(pref.tooltipstyle))
	pref.client_fps     = sanitize_integer(pref.client_fps, 0, MAX_CLIENT_FPS, initial(pref.client_fps))

	pref.tgui_fancy           = sanitize_integer(pref.tgui_fancy,           FALSE, TRUE, initial(pref.tgui_fancy))
	pref.tgui_lock            = sanitize_integer(pref.tgui_lock,            FALSE, TRUE, initial(pref.tgui_lock))
	pref.tgui_input_mode      = sanitize_integer(pref.tgui_input_mode,      FALSE, TRUE, initial(pref.tgui_input_mode))
	pref.tgui_large_buttons   = sanitize_integer(pref.tgui_large_buttons,   FALSE, TRUE, initial(pref.tgui_large_buttons))
	pref.tgui_swapped_buttons = sanitize_integer(pref.tgui_swapped_buttons, FALSE, TRUE, initial(pref.tgui_swapped_buttons))

/datum/category_item/player_setup_item/player_global/ui/content(mob/user)
	var/html = list()
	html += {"
	<b>UI Preferences</b><hr>
	<table>
		<tr>
			<td>UI Style:</td>
			<td><a href='?src=\ref[src];select_style=1'>[pref.UI_style]</a></td>
		</tr>
		<tr>
			<td>Custom UI Tint:</td>
			<td><a href='?src=\ref[src];select_color=1'>[pref.UI_style_color]</a>
			[color_square(hex = pref.UI_style_color)] <a href='?src=\ref[src];reset=ui'>reset</a></td>
		</tr>
		<tr>
			<td>Custom UI Alpha:</td>
			<td><a href='?src=\ref[src];select_alpha=1'>[pref.UI_style_alpha]</a>
			[alpha_square(pref.UI_style_alpha)] <a href='?src=\ref[src];reset=alpha'>reset</a></td>
		</tr>
	</table><br>
	<b>Misc UI Preferences</b><hr>
	<table>
		<tr>
			<td>Tooltip Style:</td>
			<td><a href='?src=\ref[src];select_tooltip_style=1'>[pref.tooltipstyle]</a></td>
		</tr>
		<tr>
			<td>Client FPS:</td>
			<td><a href='?src=\ref[src];select_client_fps=1'>[pref.client_fps]</a></td>
		</tr>
	"}

	if(can_select_ooc_color(user))
		html += "<tr><td>OOC Color:</td>"
		if(pref.ooccolor == initial(pref.ooccolor))
			html += "<td><a href='?src=\ref[src];select_ooc_color=1'>Using Default</a><td></tr>"
		else
			html += "<td><a href='?src=\ref[src];select_ooc_color=1'>[pref.ooccolor]</a> [color_square(hex = pref.ooccolor)] <a href='?src=\ref[src];reset=ooc'>reset</a><td></tr>"

	html += "</table><br>"

	html += {"
	<b>TGUI Preferences</b><hr>
	<table>
		<tr>
			<td>TGUI Input Framework:</td>
			<td><a href='?src=\ref[src];tgui_input_mode=1'>[(pref.tgui_input_mode) ? "Enabled (default)" : "Disabled"]</a></td>
		</tr>
		<tr>
			<td>TGUI Window Mode:</td>
			<td><a href='?src=\ref[src];tgui_fancy=1'>[(pref.tgui_fancy) ? "Fancy (default)" : "Compatible (slower)"]</a></td>
		</tr>
		<tr>
			<td>TGUI Window Placement:</td>
			<td><a href='?src=\ref[src];tgui_lock=1'>[(pref.tgui_lock) ? "Primary Monitor" : "Free (default)"]</a></td>
		</tr>
		<tr>
			<td>TGUI Large Buttons:</td>
			<td><a href='?src=\ref[src];tgui_large_buttons=1'>[(pref.tgui_large_buttons) ? "Enabled (default)" : "Disabled"]</a></td>
		</tr>
		<tr>
			<td>TGUI Swapped Buttons:</td>
			<td><a href='?src=\ref[src];tgui_swapped_buttons=1'>[(pref.tgui_swapped_buttons) ? "Enabled" : "Disabled (default)"]</a></td>
		</tr>
	</table>
	"}

	return jointext(html, "")

/datum/category_item/player_setup_item/player_global/ui/OnTopic(href, list/href_list, mob/user)
	if(href_list["select_style"])
		var/UI_style_new = tgui_input_list(user, "Choose UI style.", "Global UI Preference", all_ui_styles, pref.UI_style)
		if(!UI_style_new || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global UI Preference", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = tgui_input_number(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global UI Preference", pref.UI_style_alpha, 255, 50)
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global UI Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["select_tooltip_style"])
		var/tooltip_style_new = tgui_input_list(user, "Choose tooltip style.", "Global UI Preference", all_tooltip_styles, pref.tooltipstyle)
		if(!tooltip_style_new || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.tooltipstyle = tooltip_style_new
		return TOPIC_REFRESH

	else if(href_list["select_client_fps"])
		var/fps_new = tgui_input_number(user, "Input Client FPS (1-200, 0 uses server FPS)", "Global UI Preference", pref.client_fps, 200, 0)
		if(isnull(fps_new) || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(fps_new < 0 || fps_new > MAX_CLIENT_FPS)
			return TOPIC_NOACTION
		pref.client_fps = fps_new
		if(pref.client)
			pref.client.fps = fps_new
		return TOPIC_REFRESH

	else if(href_list["tgui_fancy"])
		pref.tgui_fancy = !pref.tgui_fancy
		return TOPIC_REFRESH

	else if(href_list["tgui_lock"])
		pref.tgui_lock = !pref.tgui_lock
		return TOPIC_REFRESH

	else if(href_list["tgui_input_mode"])
		pref.tgui_input_mode = !pref.tgui_input_mode
		return TOPIC_REFRESH

	else if(href_list["tgui_large_buttons"])
		pref.tgui_large_buttons = !pref.tgui_large_buttons
		return TOPIC_REFRESH

	else if(href_list["tgui_swapped_buttons"])
		pref.tgui_swapped_buttons = !pref.tgui_swapped_buttons
		return TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(mob/user)
	return CONFIG_GET(flag/allow_admin_ooccolor) && check_rights(R_ADMIN, 0, user)
