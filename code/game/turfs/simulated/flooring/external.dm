/singleton/flooring/grass
	name = "grass"
	desc = "A patch of grass."
	icon = 'icons/turf/flooring/exterior/grass.dmi'
	base_icon_state = "grass"
	flooring_layer = HIGH_TURF_LAYER

	has_pixel_offsets = TRUE
	base_pixel_x = -9
	base_pixel_y = -9

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_NO_BLEND + SMOOTH_GROUP_EXTERIOR_GRASS)
	can_smooth_with = (SMOOTH_GROUP_EXTERIOR_GRASS + SMOOTH_GROUP_NO_BLEND  + SMOOTH_GROUP_CLOSED_TURFS)

	damage_temperature = T0C+80
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/singleton/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/flooring/exterior/snow.dmi'
	base_icon_state = "snow"
	flooring_layer = HIGH_TURF_LAYER

	has_pixel_offsets = TRUE
	base_pixel_x = -4
	base_pixel_y = -4

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_NO_BLEND  + SMOOTH_GROUP_EXTERIOR_SNOW)
	can_smooth_with = (SMOOTH_GROUP_EXTERIOR_SNOW + SMOOTH_GROUP_NO_BLEND  + SMOOTH_GROUP_CLOSED_TURFS)

	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg',
	))

/singleton/flooring/snow/no_blend

/singleton/flooring/gravsnow
	name = "snowy gravel"
	desc = "A layer of coarse ice pebbles and assorted gravel."
	icon = 'icons/turf/snow_new.dmi'
	base_icon_state = "gravsnow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg',
	))


/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
