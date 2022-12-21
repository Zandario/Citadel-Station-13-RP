/singleton/flooring/grass
	name = "grass"
	desc = "A patch of grass."
	icon = 'icons/turf/flooring/exterior/grass.dmi'
	base_icon_state = "grass"
	damage_temperature = T0C+80
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/singleton/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow_new.dmi'
	base_icon_state = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg',
	))

/singleton/flooring/snow/gravsnow
	name = "snowy gravel"
	desc = "A layer of coarse ice pebbles and assorted gravel."
	icon = 'icons/turf/snow_new.dmi'
	base_icon_state = "gravsnow"


/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	flooring_flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
