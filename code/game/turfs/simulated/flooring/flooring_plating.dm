/singleton/flooring/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	base_icon_state = "plating"
	is_plating = TRUE
	plating_type = null

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR)
	can_smooth_with = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_OPEN_FLOOR)
