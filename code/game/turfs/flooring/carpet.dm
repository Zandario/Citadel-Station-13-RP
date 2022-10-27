/decl/flooring/carpet
	name = "carpet"
	desc = "Soft velvet carpeting. Feels good between your toes."
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet-255"
	base_icon_state = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg',
	))

/decl/flooring/carpet/black
	icon = 'icons/turf/floors/carpet_black.dmi'
	icon_state = "carpet_black-255"
	base_icon_state = "carpet_black"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/decl/flooring/carpet/blue
	icon = 'icons/turf/floors/carpet_blue.dmi'
	icon_state = "carpet_blue-255"
	base_icon_state = "carpet_blue"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/flooring/carpet/cyan
	icon = 'icons/turf/floors/carpet_cyan.dmi'
	icon_state = "carpet_cyan-255"
	base_icon_state = "carpet_cyan"
	build_type = /obj/item/stack/tile/carpet/teal

/decl/flooring/carpet/green
	icon = 'icons/turf/floors/carpet_green.dmi'
	icon_state = "carpet_green-255"
	base_icon_state = "carpet_green"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/decl/flooring/carpet/orange
	icon = 'icons/turf/floors/carpet_orange.dmi'
	icon_state = "carpet_orange-255"
	base_icon_state = "carpet_orange"
	build_type = /obj/item/stack/tile/carpet/oracarpet

/decl/flooring/carpet/purple
	icon = 'icons/turf/floors/carpet_purple.dmi'
	icon_state = "carpet_purple-255"
	base_icon_state = "carpet_purple"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/decl/flooring/carpet/red
	icon = 'icons/turf/floors/carpet_red.dmi'
	icon_state = "carpet_red-255"
	base_icon_state = "carpet_red"
	build_type = /obj/item/stack/tile/carpet/red
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_RED)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_RED)

/decl/flooring/carpet/royalblack
	icon = 'icons/turf/floors/carpet_royalblack.dmi'
	icon_state = "carpet_royalblack-255"
	base_icon_state = "carpet_royalblack"
	build_type = /obj/item/stack/tile/carpet/royalblack
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_ROYAL_BLACK)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_ROYAL_BLACK)

/decl/flooring/carpet/royalblue
	icon = 'icons/turf/floors/carpet_royalblue.dmi'
	icon_state = "carpet_royalblue-255"
	base_icon_state = "carpet_royalblue"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/decl/flooring/carpet/executive
	name = "executive carpet"
	icon = 'icons/turf/floors/carpet_executive.dmi'
	icon_state = "executive_carpet-255"
	base_icon_state = "executive_carpet"
	build_type = /obj/item/stack/tile/carpet/executive
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_EXECUTIVE)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_EXECUTIVE)

/decl/flooring/carpet/stellar
	name = "stellar carpet"
	icon = 'icons/turf/floors/carpet_stellar.dmi'
	icon_state = "stellar_carpet-255"
	base_icon_state = "stellar_carpet"
	build_type = /obj/item/stack/tile/carpet/stellar
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_STELLAR)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_STELLAR)

/decl/flooring/carpet/donk
	name = "Donk Co. carpet"
	icon = 'icons/turf/floors/carpet_donk.dmi'
	icon_state = "donk_carpet-255"
	base_icon_state = "donk_carpet"
	build_type = /obj/item/stack/tile/carpet/donk
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_DONK)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_DONK)

/decl/flooring/carpet/gaycarpet
	name = "Yell at a mapper to remove me"
	icon = 'icons/turf/debug.dmi'
	icon_state = null
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/decl/flooring/carpet/arcadecarpet
	name = "arcade carpet"
	icon_state = "arcade"
	icon = 'icons/turf/flooring/carpet.dmi'
	build_type = /obj/item/stack/tile/carpet/arcadecarpet

	smoothing_flags = NONE
	smoothing_groups = NONE
	canSmoothWith = NONE
