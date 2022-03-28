/decl/cultural_info
	var/name
	var/desc_type
	var/description
	var/economic_power = 1
	var/language = LANGUAGE_GALCOM
	var/name_language
	var/default_language
	var/list/optional_languages
	var/list/secondary_langs
	var/common_langs
	var/has_common_langs = TRUE
//	var/list/max_languages = 20 // Implementing later, going to use the species one for now.
	var/category
	var/subversive_potential = 0
	var/hidden

/decl/cultural_info/New()

	if(!default_language)
		default_language = language

	if(!name_language && default_language)
		name_language = default_language

	// Remove any overlap for the sake of presentation.
	if(LAZYLEN(optional_languages))
		optional_languages -= language
		optional_languages -= name_language
		optional_languages -= default_language
		UNSETEMPTY(optional_languages)

	if(LAZYLEN(secondary_langs))
		secondary_langs -= language
		secondary_langs -= name_language
		secondary_langs -= default_language
		if(LAZYLEN(optional_languages))
			secondary_langs -= optional_languages
		UNSETEMPTY(secondary_langs)

/decl/cultural_info/proc/get_random_name(var/gender)
	var/datum/language/_language
	if(name_language)
		_language = GLOB.all_languages[name_language]
	else if(default_language)
		_language = GLOB.all_languages[default_language]
	else if(language)
		_language = GLOB.all_languages[language]
	if(_language)
		return _language.get_random_name(gender)
	return capitalize(pick(gender==FEMALE ? first_names_female : first_names_male)) + " " + capitalize(pick(last_names))

/decl/cultural_info/proc/sanitize_name(var/new_name)
	return sanitizeName(new_name)

/decl/cultural_info/proc/get_description(var/header, var/append, var/verbose = TRUE)
	var/list/dat = list()
	dat += "<table padding='8px'><tr>"
	dat += "<td width = 55%>"
	dat += "[header ? header : "<b>[desc_type]:</b> [name]"]<br>"
	dat += "<small>"
	dat += "[jointext(get_text_details(), "<br>")]"
	dat += "</small></td>"
	dat += "<td width = 45%>"
	if(verbose || length(get_text_body()) <= MAX_DESC_LEN)
		dat += "[get_text_body()]"
	else
		dat += "[copytext(get_text_body(), 1, MAX_DESC_LEN)] \[...\]"
	if(append)
		dat += "<br>[append]"
	dat += "</td>"
	dat += "</tr>"
	dat += "</table><hr>"
	return jointext(dat, null)

/decl/cultural_info/proc/get_text_body()
	return description

/decl/cultural_info/proc/get_text_details()
	. = list()
	var/list/spoken_langs = get_spoken_languages()
	if(LAZYLEN(spoken_langs))
		. += "<b>Language(s):</b> [english_list(spoken_langs)]."
	if(LAZYLEN(secondary_langs))
		. += "<b>Optional language(s):</b> [english_list(secondary_langs)]."
	if(!isnull(economic_power))
		. += "<b>Economic power:</b> [round(100 * economic_power)]%"

/decl/cultural_info/proc/get_spoken_languages()
	. = list()
	if(language) . |= language
	if(default_language) . |= default_language
	if(name_language) . |= name_language
	if(LAZYLEN(optional_languages)) . |= optional_languages
