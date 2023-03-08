/datum/gm_action/radiation_storm
	name = "radiation storm"
	departments = list(DEPARTMENT_EVERYONE)
	reusable = TRUE

	var/enterBelt			= 30
	var/radIntervall		= 5
	var/leaveBelt			= 80
	var/revokeAccess		= 165
	var/activeFor			= 0
	var/postStartTicks 		= 0
	var/active				= FALSE

/datum/gm_action/radiation_storm/announce()
	command_announcement.Announce("High levels of radiation detected near \the [station_name()]. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')

/datum/gm_action/radiation_storm/set_up()
	active = TRUE

/datum/gm_action/radiation_storm/start()
	..()
	make_maint_all_access()

	while(active)
		sleep(1 SECOND)
		activeFor ++
		if(activeFor == enterBelt)
			command_announcement.Announce("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")
			radiate()

		if(activeFor >= enterBelt && activeFor <= leaveBelt)
			postStartTicks++

		if(postStartTicks == radIntervall)
			postStartTicks = 0
			radiate()

		else if(activeFor == leaveBelt)
			command_announcement.Announce("The station has passed the radiation belt. Please allow for up to one minute while radiation levels dissipate, and report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

/datum/gm_action/radiation_storm/proc/radiate()
	var/radiation_level = rand(50, 200)
	for(var/z in GLOB.using_map.station_levels)
		z_radiation(null, z, radiation_level, z_radiate_flags = Z_RADIATE_CHECK_AREA_SHIELD)

	for(var/mob/living/complex/C in living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(A.area_flags & AREA_RAD_SHIELDED)
			continue
		if(istype(C,/mob/living/complex/human))
			var/mob/living/complex/human/H = C
			if(prob(5))
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/gm_action/radiation_storm/end()
	spawn(revokeAccess SECONDS)
		revoke_maint_all_access()

/datum/gm_action/radiation_storm/get_weight()
	return 20 + (metric.count_people_in_department(DEPARTMENT_MEDICAL) * 10) + (metric.count_all_space_mobs() * 40) + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 20)
