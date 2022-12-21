
/singleton/flooring/tiling/cafe
	name = "cafe floor"
	icon = 'icons/turf/flooring/cafe.dmi'
	base_icon_state = "cafe"
	build_type = /obj/item/stack/tile/floor/eris/cafe

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CAFE_FLOOR)
	can_smooth_with = (SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_CAFE_FLOOR)
