/turf/simulated/floor/carpet
	name = "carpet"
	initial_flooring = /decl/flooring/carpet
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet-255"
	base_icon_state = "carpet"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET)
	canSmoothWith = list(SMOOTH_GROUP_CARPET)

/turf/simulated/floor/carpet/Initialize(mapload)
	. = ..()
	update_appearance()

/turf/simulated/floor/carpet/update_icon(updates=ALL)
	. = ..()
	if(!. || !(updates & UPDATE_SMOOTHING))
		return
	if(!broken && !burnt)
		if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
			QUEUE_SMOOTH(src)
	else
		make_plating()
		if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
			QUEUE_SMOOTH_NEIGHBORS(src)

//TODO: Rename to black
/turf/simulated/floor/carpet/bcarpet
	name = "black carpet"
	initial_flooring = /decl/flooring/carpet/black
	icon = 'icons/turf/floors/carpet_black.dmi'
	icon_state = "carpet_black-255"
	base_icon_state = "carpet_black"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_BLACK)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_BLACK)

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	initial_flooring = /decl/flooring/carpet/blue
	icon = 'icons/turf/floors/carpet_blue.dmi'
	icon_state = "carpet_blue-255"
	base_icon_state = "carpet_blue"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_BLUE)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_BLUE)

//TODO: Remove this
/turf/simulated/floor/carpet/sblucarpet
	name = "blue carpet"
	initial_flooring = /decl/flooring/carpet/blue
	icon = 'icons/turf/floors/carpet_blue.dmi'
	icon_state = "carpet_blue-255"
	base_icon_state = "carpet_blue"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_BLUE)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_BLUE)

//TODO: Rename to royalblue
/turf/simulated/floor/carpet/blucarpet
	name = "royal blue carpet"
	initial_flooring = /decl/flooring/carpet/royalblue
	icon = 'icons/turf/floors/carpet_royalblue.dmi'
	icon_state = "carpet_royalblue-255"
	base_icon_state = "carpet_royalblue"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_ROYAL_BLUE)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_ROYAL_BLUE)

//TODO: Rename to cyan
/turf/simulated/floor/carpet/tealcarpet
	name = "teal carpet"
	initial_flooring = /decl/flooring/carpet/cyan
	icon = 'icons/turf/floors/carpet_cyan.dmi'
	icon_state = "carpet_cyan-255"
	base_icon_state = "carpet_cyan"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_CYAN)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_CYAN)

//TODO: Rename to green
/turf/simulated/floor/carpet/turcarpet
	name = "green carpet"
	initial_flooring = /decl/flooring/carpet/green
	icon = 'icons/turf/floors/carpet_green.dmi'
	icon_state = "carpet_green-255"
	base_icon_state = "carpet_green"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_GREEN)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_GREEN)

//TODO: Rename to orange
/turf/simulated/floor/carpet/oracarpet
	name = "orange carpet"
	initial_flooring = /decl/flooring/carpet/orange
	icon = 'icons/turf/floors/carpet_orange.dmi'
	icon_state = "carpet_orange-255"
	base_icon_state = "carpet_orange"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_ORANGE)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_ORANGE)

//TODO: Rename to purple
/turf/simulated/floor/carpet/purcarpet
	name = "purple carpet"
	initial_flooring = /decl/flooring/carpet/purple
	icon = 'icons/turf/floors/carpet_purple.dmi'
	icon_state = "carpet_purple-255"
	base_icon_state = "carpet_purple"
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_CARPET_PURPLE)
	canSmoothWith = list(SMOOTH_GROUP_CARPET_PURPLE)

//TODO: Rename to arcade
/turf/simulated/floor/carpet/arcadecarpet
	name = "arcade carpet"
	initial_flooring = /decl/flooring/carpet/arcadecarpet
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "arcade"
	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null

//TODO: Remove
/turf/simulated/floor/carpet/gaycarpet
	name = "YELL AT SOMEONE TO REMOVE ME"
	initial_flooring = /decl/flooring/carpet/gaycarpet
	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null
