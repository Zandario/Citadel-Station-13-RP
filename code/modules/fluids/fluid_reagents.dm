/datum/reagents/fluid_group
	var/datum/fluid_group/my_group
	var/last_reaction_loc
	var/skip_next_update = FALSE

/datum/reagents/fluid_group/covered_turf()
	.= list()
	if (my_group)
		for (var/obj/fluid/F as anything in my_group.nodes)
			.+= F.loc

/datum/reagents/fluid_group/clear_reagents()
	..()
	if (my_group)
		my_group.evaporate()

/// Handles reagent reduction -> shrinking puddle.
/datum/reagents/fluid_group/update_total()
	var/prev_volume = src.total_volume
	..()
	//sometimes we need to change the total without automatically draining the removed volume.
	if (skip_next_update)
		skip_next_update = FALSE
		return
	if (my_group)
		my_group.contained_volume = src.total_volume

		if (src.total_volume <= 0 && prev_volume > 0)
			my_group.evaporate()
			return

		if (my_group.amt_per_tile >= my_group.required_to_spread)
			return
		if ((src.total_volume >= prev_volume))
			return

		var/member_dif = (round(src.total_volume / my_group.required_to_spread) - round(prev_volume / my_group.required_to_spread ))
		var/fluids_to_remove = 0
		if (member_dif < 0)
			fluids_to_remove = abs(member_dif)

		if (fluids_to_remove)
			var/obj/fluid/remove_source = my_group.last_reacted
			if (!remove_source)
				remove_source = my_group.spread_member
				if (!remove_source && length(my_group.nodes))
					remove_source = pick(my_group.nodes)
				if (!remove_source)
					my_group.evaporate()
					return
			skip_next_update = TRUE
			my_group.drain(remove_source, fluids_to_remove, remove_reagent = 0)

/datum/reagents/fluid_group/get_reagents_fullness()
	if(isnull(my_group))
		return FALSE

	switch (my_group.last_depth_level)
		if (1)
			return "very shallow"
		if (2)
			return "at knee height"
		if (3)
			return "at chest height"
		if (4)
			return "very deep"
		else
			return "empty"

/// Play sounds at random locs!
/datum/reagents/fluid_group/play_mix_sound(mix_sound)
	for (var/i = 0, i < length(my_group.nodes) / 20, i++)
		playsound(pick(my_group.nodes), mix_sound, 80, 1)
		if (i > 8)
			break
