
///Returns the open turf next to the center in a specific direction
/proc/get_open_turf_in_dir(atom/center, dir)
	var/turf/get_turf = get_ranged_target_turf(center, dir, 1)
	if(istype(get_turf) && (get_turf.density == FALSE))
		return get_turf

///Returns a list with all the adjacent open turfs. Clears the list of nulls in the end.
/proc/get_adjacent_open_turfs(atom/center)
	. = list(
		get_open_turf_in_dir(center, NORTH),
		get_open_turf_in_dir(center, SOUTH),
		get_open_turf_in_dir(center, EAST),
		get_open_turf_in_dir(center, WEST)
		)
	list_clear_nulls(.)

///Returns a list with all the adjacent areas by getting the adjacent open turfs
/proc/get_adjacent_open_areas(atom/center)
	. = list()
	var/list/adjacent_turfs = get_adjacent_open_turfs(center)
	for(var/near_turf in adjacent_turfs)
		. |= get_area(near_turf)
