//TODO: Change this to specieswhitelist.txt
#define WHITELISTFILE "config/alienwhitelist.txt"

var/list/species_whitelist = list()

/hook/startup/proc/loadSpeciesWhitelist()
	if(CONFIG_GET(flag/use_whitelists) && CONFIG_GET(flag/use_specieswhitelist))
		load_specieswhitelist()
	return TRUE

/proc/load_specieswhitelist()
	var/text = file2text(WHITELISTFILE)
	if (!text)
		log_misc("Failed to load [WHITELISTFILE]")
	else
		// Now we've got a bunch of "ckey = something" strings in a list.
		var/lines = splittext(text, "\n")
		for(var/line in lines)
			// Split it on the dash into left and right.
			var/list/left_and_right = splittext(line, " - ")
			if(LAZYLEN(left_and_right) != 2)
				// If we didn't end up with a left and right, the line is bad.
				warning("Alien whitelist entry is invalid: [line]")
				continue
			var/key = left_and_right[1]
			if(key != ckey(key))
				// The key contains invalid ckey characters.
				warning("Alien whitelist entry appears to have key, not ckey: [line]")
				continue
			// Try to see if we have one already and add to it.
			var/list/our_whitelists = species_whitelist[key]
			// Guess this is their first/only whitelist entry.
			if(!our_whitelists)
				our_whitelists = list()
				species_whitelist[key] = our_whitelists
			our_whitelists += left_and_right[2]

/proc/is_species_whitelisted(mob/M, datum/species/species)
	// They are admin or the whitelist isn't in use.
	if(whitelist_overrides(M))
		return TRUE

	// You did something wrong.
	if(!M || !species)
		return FALSE

	// The species isn't even whitelisted.
	if(!(species.spawn_flags & SPECIES_IS_WHITELISTED))
		return TRUE

	// Search the whitelist.
	var/list/our_whitelists = species_whitelist[M.ckey]
	if("All" in our_whitelists)
		return TRUE
	if(species.name in our_whitelists)
		return TRUE

	// Go apply!
	return FALSE

#undef WHITELISTFILE
