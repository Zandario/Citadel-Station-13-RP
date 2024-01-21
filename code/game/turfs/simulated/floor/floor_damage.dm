#warn move these to a proper place

/turf/simulated/floor/proc/gets_drilled()
	return


/turf/simulated/floor/proc/break_tile_to_plating()
	var/turf/simulated/floor/Floor = make_plating()
	if(!istype(Floor))
		return
	Floor.break_tile()


/turf/proc/break_tile()
	return

/turf/proc/burn_tile()
	return

/turf/simulated/floor/break_tile()
	if(isnull(damaged_dmi) || broken)
		return FALSE
	broken = TRUE
	update_appearance()
	return TRUE


/turf/simulated/floor/burn_tile()
	if(isnull(damaged_dmi) || burnt)
		return FALSE
	burnt = TRUE
	update_appearance()
	return TRUE
