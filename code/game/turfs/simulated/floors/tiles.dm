/turf/simulated/floor/tiled/eris/cafe
	name = "floor"
	icon = 'icons/turf/flooring/cafe.dmi'
	icon_state = "cafe-255"
	base_icon_state = "cafe"
	floor_tile = /obj/item/stack/tile/floor/eris/cafe
	// initial_flooring = /singleton/flooring/tiling/cafe

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CAFE_FLOOR)
	can_smooth_with = (SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_CAFE_FLOOR)
