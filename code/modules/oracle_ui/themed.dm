GLOBAL_LIST_EMPTY(oui_template_variables)
GLOBAL_LIST_EMPTY(oui_file_cache)

/**
 * A subclass which supports templating and theming.
 */
/datum/oracle_ui/themed
	var/theme = ""
	var/current_page = "index.html"
	var/root_template = ""

/datum/oracle_ui/themed/New(atom/n_datasource, n_width = width, n_height = height)
	root_template = get_themed_file("index.html")
	return ..(n_datasource, n_width, n_height, get_asset_datum(assets))

/datum/oracle_ui/themed/process()
	if(closing)
		return
	if(auto_check_view)
		check_view_all()
	if(auto_refresh)
		soft_update_fields()

/**
 * Loads a file from disk and returns the contents.
 * Caches files loaded from disk for you.
 */
/datum/oracle_ui/themed/proc/get_file(path)
	if(GLOB.oui_file_cache[path])
		return GLOB.oui_file_cache[path]
	else if(fexists(path))
		var/data = file2text(path)
		GLOB.oui_file_cache[path] = data
		return data
	else
		stack_trace("MISSING PATH '[path]'")
		// TODO: TGUI-Inspired error page.
		return "MISSING PATH '[path]'"

/**
 * Loads a file from the current content folder and returns the contents.
 */
/datum/oracle_ui/themed/proc/get_content_file(filename)
	return get_file("./html/oracle_ui/content/[interface]/[filename]")

/**
 * Loads a file from the current theme folder and returns the contents.
 */
/datum/oracle_ui/themed/proc/get_themed_file(filename)
	return get_file("./html/oracle_ui/themes/[theme]/[filename]")

/**
 * Processes a template and populates it with the provided variables.
 */
/datum/oracle_ui/themed/proc/process_template(template, variables)
	var/regex/pattern = regex("\\@\\{(\\w+)\\}","gi")
	GLOB.oui_template_variables = variables
	var/replaced = pattern.Replace(template, /proc/oui_process_template_replace)
	GLOB.oui_template_variables = null
	return replaced

/**
 * A callback for the regex.Replace() call in process_template().
 */
/proc/oui_process_template_replace(match, group1)
	var/value = GLOB.oui_template_variables[group1]
	return "[value]"

/**
 * Returns the templated content to be inserted into the main template for the specified target mob.
 */
/datum/oracle_ui/themed/proc/get_inner_content(mob/target)
	var/list/data = datasource.oui_data(target)
	return process_template(get_content_file(current_page), data)

/proc/upperCaseFirst(str)
	var/list/string = splittext(str, "")
	string[1] = uppertext(string[1])
	return jointext(string, "")

/proc/capitalize_title(str)
	var/list/title = splittext(str, " ")
	for(var/i = 1 to length(title))
		title[i] = upperCaseFirst(title[i])
	return jointext(title, " ")

/**
 * Processes the page for the specified target mob.
 */
/datum/oracle_ui/themed/get_content(mob/target)
	var/list/template_data = list(
		"title" = capitalize_title("[datasource.name]"),
		"body"  = get_inner_content(target),
	)
	return process_template(root_template, template_data)

/**
 * For all viewers, updates the fields in the template via the `updateFields` javaScript function.
 */
/datum/oracle_ui/themed/proc/soft_update_fields()
	for(var/viewer as anything in viewers)
		var/json = json_encode(datasource.oui_data(viewer))
		call_js(viewer, "updateFields", list(json))

/**
 * For all viewers, updates the content body in the template via the `replaceContent` javaScript function.
 */
/datum/oracle_ui/themed/proc/soft_update_all()
	for(var/viewer as anything in viewers)
		call_js(viewer, "replaceContent", list(get_inner_content(viewer)))

/**
 * Changes the template to use to draw the page and forces an update to all viewers.
 */
/datum/oracle_ui/themed/proc/change_page(newpage)
	if(newpage == current_page)
		return
	current_page = newpage
	render_all()

/**
 * returns a fully formed hyperlink for the specified user
 *
 * Arguments:
 * * label: hyperlink label
 * * action: passed to oui_act
 * * parameters: passed to oui_act
 * * class: CSS classes to apply to the hyperlink
 * * disabled: disables the hyperlink label
 */
/datum/oracle_ui/themed/proc/act(label, mob/user, action, list/parameters = list(), class = "", disabled = FALSE)
	if(disabled)
		return "<a class=\"disabled\">[label]</a>"
	else
		return "<a class=\"[class]\" href=\"" + href(user, action, parameters) + "\">[label]</a>"

/datum/oracle_ui/themed/nano
	theme = "nano"
	assets = /datum/asset/simple/oui_theme_nano

/datum/oracle_ui/themed/paper
	theme = "paper"
	assets = /datum/asset/simple/oui_theme_paper
