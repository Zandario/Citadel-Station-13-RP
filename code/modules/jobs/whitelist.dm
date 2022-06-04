#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(CONFIG_GET(flag/usewhitelist))
		load_whitelist()
	return TRUE

/proc/load_whitelist()
	whitelist = world.file2list(WHITELISTFILE)
	if(!whitelist.len)
		whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return FALSE
	return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(CONFIG_GET(flag/usealienwhitelist))
		load_alienwhitelist()
	return TRUE

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		alien_whitelist = splittext(text, "\n")

/proc/is_alien_whitelisted(mob/M, datum/species/species)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !species)
		return FALSE

	//The species isn't even whitelisted
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return TRUE

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species.name]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE

/proc/is_lang_whitelisted(mob/M, datum/language/language)
	//They are admin or the whitelist isn't in use
	if(whitelist_overrides(M))
		return TRUE

	//You did something wrong
	if(!M || !language)
		return FALSE

	//The language isn't even whitelisted
	if(!(language.flags & WHITELISTED))
		return TRUE

	//If we have a loaded file, search it
	if(alien_whitelist)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [language.name]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE

/proc/whitelist_overrides(mob/M)
	if(!CONFIG_GET(flag/usealienwhitelist))
		return TRUE
	if(check_rights(R_ADMIN|R_EVENT, 0, M))
		return TRUE

	return FALSE

#undef WHITELISTFILE
