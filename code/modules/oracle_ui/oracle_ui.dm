
/**
 * The main datum which handles the UI for Oracle UI windows.
 */
/datum/oracle_ui
	/// The list of mobs which can view the UI.
	var/viewers[0]
	/// The atom which is the data source for the UI window.
	var/atom/datasource
	/// The asset datum to send to the client.
	var/datum/asset/assets
	/// The ID of the UI window.
	var/window_id

	/// The width of the UI window.
	var/width  = 512
	/// The height of the UI window.
	var/height = 512

	/// Whether the UI window can be closed by the user.
	var/can_close = TRUE
	/// Whether the UI window can be minimized by the user.
	var/can_minimize = FALSE
	/// Whether the UI window can be resized by the user.
	var/can_resize = TRUE
	/// Whether the UI window has a titlebar.
	var/titlebar = TRUE
	/// Whether the UI window should be checked for viewability automatically.
	var/auto_check_view = TRUE
	/// Whether the UI window should be refreshed automatically.
	var/auto_refresh = FALSE

/**
 * public
 *
 * Creates a new Oracle UI window.
 *
 * Arguments:
 * * n_datasource - The atom which is the data source for the UI window.
 * * n_width      - The width of the UI window.
 * * n_height     - The height of the UI window.
 * * n_assets     - The asset datum to send to the client.
 */
/datum/oracle_ui/New(atom/n_datasource, n_width = 512, n_height = 512, datum/asset/n_assets)
	window_id = REF(src)
	if (!isnull(n_datasource))
		datasource = n_datasource
	if (!isnull(n_width))
		width = n_width
	if (!isnull(n_height))
		height = n_height
	if (!isnull(n_assets))
		assets = n_assets

/datum/oracle_ui/Destroy()
	close_all()
	if(src.datum_flags & DF_ISPROCESSING)
		STOP_PROCESSING(SSobj, src)
	return ..()

/datum/oracle_ui/process()
	if(auto_check_view)
		check_view_all()
	if(auto_refresh)
		render_all()

/**
 * Returns the HTML that should be displayed for a specified target mob.
 * Calls `oui_getcontent` on the datasource to get the return value.
 * This proc is not used in the themed subclass.
 */
/datum/oracle_ui/proc/get_content(mob/target)
	return call(datasource, "oui_getcontent")(target)

/**
 * Returns whether the specified target mob can view the UI.
 * Calls `oui_canview` on the datasource to get the return value.
 */
/datum/oracle_ui/proc/can_view(mob/target)
	return call(datasource, "oui_canview")(target)

/**
 * Tests whether the client is valid and can view the UI.
 * If updating is TRUE, checks to see if they still have the UI window open.
 */
/datum/oracle_ui/proc/test_viewer(mob/target, updating)
	// If the target is null or does not have a client, remove from viewers and return.
	if(!target || !target.client || !can_view(target))
		viewers -= target
		if(viewers.len < 1 && (src.datum_flags & DF_ISPROCESSING))
			STOP_PROCESSING(SSobj, src) // No more viewers, stop polling.
		close(target)
		return FALSE
	// If this is an update, and they have closed the window, remove from viewers and return.
	if(updating && winget(target, window_id, "is-visible") != "true")
		viewers -= target
		if(viewers.len < 1 && (src.datum_flags & DF_ISPROCESSING))
			STOP_PROCESSING(SSobj, src) // No more viewers, stop polling.
		return FALSE
	return TRUE

/**
 * Opens the UI for a target mob, sending HTML.
 * If updating is TRUE, will only do it to clients which still have the window open.
 */
/datum/oracle_ui/proc/render(mob/target, updating = FALSE)
	set waitfor = FALSE // Makes this an async call.
	if(!can_view(target))
		return
	// Check to see if they have the window open still if updating.
	if(updating && !test_viewer(target, updating))
		return
	// Send assets.
	if(!updating && assets)
		assets.send(target.client)
	// Add them to the viewers if they aren't there already.
	viewers |= target
	if(!(src.datum_flags & DF_ISPROCESSING) && (auto_refresh | auto_check_view))
		START_PROCESSING(SSobj, src) // Start processing to poll for viewability.
	// Send the content.
	if(updating)
		target << output(get_content(target), "[window_id].browser")
	else
		target << browse(get_content(target), "window=[window_id];size=[width]x[height];can_close=[can_close];can_minimize=[can_minimize];can_resize=[can_resize];titlebar=[titlebar];focus=false;")
	steal_focus(target)

/**
 * Does the same as render, but for all viewers and with updating set to TRUE.
 */
/datum/oracle_ui/proc/render_all()
	for(var/viewer in viewers)
		render(viewer, TRUE)

/**
 * Closes the UI for the specified target mob.
 */
/datum/oracle_ui/proc/close(mob/target)
	if(target && target.client)
		target << browse(null, "window=[window_id]")

/**
 * Does the same as close, but for all viewers.
 */
/datum/oracle_ui/proc/close_all()
	for(var/viewer in viewers)
		close(viewer)
	viewers = list()

/**
 * Does the same as check_view, but for all viewers.
 */
/datum/oracle_ui/proc/check_view(mob/target)
	set waitfor = FALSE // Makes this an async call.
	if(!test_viewer(target, TRUE))
		close(target)

/**
 * Checks if the specified target mob can view the UI, and if they can't closes their UI.
 */
/datum/oracle_ui/proc/check_view_all()
	for(var/viewer as anything in viewers)
		check_view(viewer)

/**
 * Invokes `js_func` in the UI of the specified target mob with the specified parameters.
 */
/datum/oracle_ui/proc/call_js(mob/target, js_func, list/parameters = list())
	set waitfor = FALSE // Makes this an async call.
	if(!test_viewer(target, TRUE))
		return
	target << output(list2params(parameters),"[window_id].browser:[js_func]")

/**
 * Does the same as call_js, but for all viewers.
 */
/datum/oracle_ui/proc/call_js_all(js_func, list/parameters = list())
	for(var/viewer as anything in viewers)
		call_js(viewer, js_func, parameters)

/**
 * Causes the UI to steal focus for the specified target mob.
 */
/datum/oracle_ui/proc/steal_focus(mob/target)
	set waitfor = FALSE //Makes this an async call
	winset(target, "[window_id]","focus=true")

/**
 * Does the same as steal_focus, but for all viewers.
 */
/datum/oracle_ui/proc/steal_focus_all()
	for(var/viewer as anything in viewers)
		steal_focus(viewer)

/**
 * Causes the UI to flash for the specified target mob the specified number of times.
 * the default keeps the element flashing until focused.
 */
/datum/oracle_ui/proc/flash(mob/target, times = -1)
	set waitfor = FALSE // Makes this an async call.
	winset(target, "[window_id]","flash=[times]")

/**
 * Does the same as flash, but for all viewers.
 */
/datum/oracle_ui/proc/flash_all(times = -1)
	for(var/viewer as anything in viewers)
		flash(viewer, times)

/**
 * Generates a href for the specified user which will invoke `oui_act` on the datasource with the specified action and parameters.
 */
/datum/oracle_ui/proc/href(mob/user, action, list/parameters = list())
	var/params_string = replacetext(list2params(parameters),"&",";")
	return "?src=[REF(src)];sui_action=[action];sui_user=[REF(user)];[params_string]"

/datum/oracle_ui/Topic(href, parameters)
	var/action = parameters["sui_action"]
	var/mob/current_user = locate(parameters["sui_user"])
	if(!call(datasource, "oui_canuse")(current_user))
		return
	if(datasource)
		call(datasource, "oui_act")(current_user, action, parameters);
