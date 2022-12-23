/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	var/turf/simulated/floor/plating/T = make_plating()
	if(!istype(T))
		return
	T.break_tile()


/turf/simulated/floor/break_tile()
	if(!flooring || !(flooring.flooring_flags & TURF_CAN_BREAK) || !isnull(broken))
		return
	if(flooring.has_damage_range)
		broken = rand(0,flooring.has_damage_range)
	else
		broken = 0
	update_appearance()

/turf/simulated/floor/burn_tile(exposed_temperature)
	if(!flooring || !(flooring.flooring_flags & TURF_CAN_BURN) || !isnull(burnt))
		return
	if(flooring.has_burn_range)
		burnt = rand(0,flooring.has_burn_range)
	else
		burnt = 0
	update_appearance()
