#define WHITELISTFILE "config/jobwhitelist.txt"

var/list/job_whitelist = list()

/hook/startup/proc/loadJobWhitelist()
	if(CONFIG_GET(flag/use_whitelists) && CONFIG_GET(flag/use_jobwhitelist))
		load_jobwhitelist()
	return TRUE

/proc/load_jobwhitelist()
	var/text = file2text(WHITELISTFILE)
	if (!text)
		log_misc("Failed to load [WHITELISTFILE]")
	else
		job_whitelist = splittext(text, "\n")

/proc/is_job_whitelisted(mob/M, rank)
	var/datum/job/job = SSjob.get_job(rank)
	if(!job.whitelist_only)
		return TRUE
	if(rank == USELESS_JOB)
		return TRUE
	if(check_rights(R_ADMIN, FALSE))
		return TRUE
	if(!job_whitelist)
		return FALSE
	if(M && rank)
		for (var/s in job_whitelist)
			if(findtext(s,"[lowertext(M.ckey)] - [lowertext(rank)]"))
				return TRUE
			if(findtext(s,"[M.ckey] - All"))
				return TRUE
	return FALSE

#undef WHITELISTFILE
