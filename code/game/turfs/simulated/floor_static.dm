// This type of flooring cannot be altered short of being destroyed and rebuilt.
// Use this to bypass the flooring system entirely ie. event areas, holodeck, etc.

/turf/simulated/floor/fixed
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = null

/turf/simulated/floor/fixed/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack) && !istype(I, /obj/item/stack/cable_coil))
		return
	return ..()

/turf/simulated/floor/fixed/update_icon()
	update_flood_overlay()

/turf/simulated/floor/fixed/is_plating()
	return FALSE

/turf/simulated/floor/fixed/set_flooring()
	return
