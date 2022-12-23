/turf/simulated/floor/carpet
	name = "carpet"
	desc = "Soft velvet carpeting. Feels good between your toes."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet-255"
	base_icon_state = "carpet"

	floor_tile = /obj/item/stack/tile/carpet

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET)
	can_smooth_with = (SMOOTH_GROUP_CARPET)

/turf/simulated/floor/carpet/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("There's a <b>small crack</b> on the edge of it.")

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

// /turf/simulated/floor/carpet/royalblack
/turf/simulated/floor/carpet/bcarpet
	icon = 'icons/turf/flooring/carpet_royalblack.dmi'
	icon_state = "carpet_royalblack-255"
	base_icon_state = "carpet_royalblack"
	floor_tile = /obj/item/stack/tile/carpet/bcarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_ROYAL_BLACK)
	can_smooth_with = (SMOOTH_GROUP_CARPET_ROYAL_BLACK)

// /turf/simulated/floor/carpet/blue
/turf/simulated/floor/carpet/blucarpet
	icon = 'icons/turf/flooring/carpet_blue.dmi'
	icon_state = "carpet_blue-255"
	base_icon_state = "carpet_blue"
	floor_tile = /obj/item/stack/tile/carpet/blucarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_BLUE)
	can_smooth_with = (SMOOTH_GROUP_CARPET_BLUE)

// /turf/simulated/floor/carpet/teal
/turf/simulated/floor/carpet/tealcarpet
	icon = 'icons/turf/flooring/carpet_cyan.dmi'
	icon_state = "carpet_cyan-255"
	base_icon_state = "carpet_cyan"
	floor_tile = /obj/item/stack/tile/carpet/teal
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_CYAN)
	can_smooth_with = (SMOOTH_GROUP_CARPET_CYAN)

/turf/simulated/floor/carpet/cyan
	icon = 'icons/turf/flooring/carpet_cyan.dmi'
	icon_state = "carpet_cyan-255"
	base_icon_state = "carpet_cyan"
	floor_tile = /obj/item/stack/tile/carpet/cyan
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_CYAN)
	can_smooth_with = (SMOOTH_GROUP_CARPET_CYAN)

// Legacy support for existing paths for blue carpet
/turf/simulated/floor/carpet/blue
	icon = 'icons/turf/flooring/carpet_blue.dmi'
	icon_state = "carpet_blue-255"
	base_icon_state = "carpet_blue"
	floor_tile = /obj/item/stack/tile/carpet/blucarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_BLUE)
	can_smooth_with = (SMOOTH_GROUP_CARPET_BLUE)

// TODO: Rename to green
/turf/simulated/floor/carpet/turcarpet
	icon = 'icons/turf/flooring/carpet_green.dmi'
	icon_state = "carpet_green-255"
	base_icon_state = "carpet_green"
	floor_tile = /obj/item/stack/tile/carpet/turcarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_GREEN)
	can_smooth_with = (SMOOTH_GROUP_CARPET_GREEN)

// /turf/simulated/floor/carpet/royalblue
/turf/simulated/floor/carpet/sblucarpet
	icon = 'icons/turf/flooring/carpet_royalblue.dmi'
	icon_state = "carpet_royalblue-255"
	base_icon_state = "carpet_royalblue"
	floor_tile = /obj/item/stack/tile/carpet/sblucarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_ROYAL_BLUE)
	can_smooth_with = (SMOOTH_GROUP_CARPET_ROYAL_BLUE)

/turf/simulated/floor/carpet/gaycarpet
	name = "clown carpet"
	icon = 'icons/turf/flooring/carpet_old.dmi'
	icon_state = "gaycarpet"
	floor_tile = /obj/item/stack/tile/carpet/gaycarpet
	smoothing_flags = NONE

// /turf/simulated/floor/carpet/purple
/turf/simulated/floor/carpet/purcarpet
	icon = 'icons/turf/flooring/carpet_purple.dmi'
	icon_state = "carpet_purple-255"
	base_icon_state = "carpet_purple"
	floor_tile = /obj/item/stack/tile/carpet/purcarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_PURPLE)
	can_smooth_with = (SMOOTH_GROUP_CARPET_PURPLE)

// /turf/simulated/floor/carpet/orange
/turf/simulated/floor/carpet/oracarpet
	icon = 'icons/turf/flooring/carpet_orange.dmi'
	icon_state = "carpet_orange-255"
	base_icon_state = "carpet_orange"
	floor_tile = /obj/item/stack/tile/carpet/oracarpet
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_ORANGE)
	can_smooth_with = (SMOOTH_GROUP_CARPET_ORANGE)

/turf/simulated/floor/carpet/arcadecarpet
	name = "arcade carpet"
	icon_state = "arcade"
	icon = 'icons/turf/flooring/carpet_old.dmi'
	smoothing_flags = NONE

/turf/simulated/floor/carpet/executive
	name = "executive carpet"
	icon = 'icons/turf/flooring/carpet_executive.dmi'
	icon_state = "executive_carpet-255"
	base_icon_state = "executive_carpet"
	floor_tile = /obj/item/stack/tile/carpet/executive
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_EXECUTIVE)
	can_smooth_with = (SMOOTH_GROUP_CARPET_EXECUTIVE)

/turf/simulated/floor/carpet/stellar
	name = "stellar carpet"
	icon = 'icons/turf/flooring/carpet_stellar.dmi'
	icon_state = "stellar_carpet-255"
	base_icon_state = "stellar_carpet"
	floor_tile = /obj/item/stack/tile/carpet/stellar
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_STELLAR)
	can_smooth_with = (SMOOTH_GROUP_CARPET_STELLAR)

/turf/simulated/floor/carpet/donk
	name = "Donk Co. carpet"
	icon = 'icons/turf/flooring/carpet_donk.dmi'
	icon_state = "donk_carpet-255"
	base_icon_state = "donk_carpet"
	floor_tile = /obj/item/stack/tile/carpet/donk
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET_DONK)
	can_smooth_with = (SMOOTH_GROUP_CARPET_DONK)
