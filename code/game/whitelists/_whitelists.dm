#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(CONFIG_GET(flag/use_whitelists))
		load_whitelist()
	return TRUE

/proc/load_whitelist()
	whitelist = world.file2list(WHITELISTFILE)
	if(!whitelist.len)
		whitelist = null

/proc/check_whitelist(mob/M)
	if(!whitelist)
		return FALSE
	return ("[M.ckey]" in whitelist)

/// Checks if the whitelist is enabled or if the user is an admin.
/proc/whitelist_overrides(mob/M)
	if(!CONFIG_GET(flag/use_whitelists))
		return TRUE
	if(check_rights(R_ADMIN|R_EVENT, FALSE, M))
		return TRUE
	return FALSE

#undef WHITELISTFILE
