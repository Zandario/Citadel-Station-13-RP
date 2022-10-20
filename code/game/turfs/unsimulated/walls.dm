/turf/unsimulated/wall
	name = "riveted wall"
	icon = 'icons/turf/walls/riveted.dmi'
	icon_state = "riveted-0"
	base_icon_state = "riveted"

	opacity = TRUE
	density = TRUE
	blocks_air = TRUE

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_SOLID, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS)

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = FALSE

/turf/unsimulated/wall/other
	icon_state = "r_wall"
