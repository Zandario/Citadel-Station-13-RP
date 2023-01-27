/atom/movable/lighting_overlay
	name = ""
	anchored = TRUE
	atom_flags = ATOM_ABSTRACT

	icon = LIGHTING_ICON
	icon_state = LIGHTING_BASE_ICON_STATE

	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	color = LIGHTING_BASE_MATRIX

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING
	// simulated = FALSE

	var/needs_update = FALSE

	#if WORLD_ICON_SIZE != 32
	transform = matrix(WORLD_ICON_SIZE / 32, 0, (WORLD_ICON_SIZE - 32) / 2, 0, WORLD_ICON_SIZE / 32, (WORLD_ICON_SIZE - 32) / 2)
	#endif

/atom/movable/lighting_overlay/New(newloc, update_now = FALSE)
	atom_flags |= ATOM_INITIALIZED
	SSlighting.total_lighting_overlays += 1

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = 0

	if (T.corners && T.corners.len)
		for (var/datum/lighting_corner/C in T.corners)
			C.active = TRUE

	if (update_now)
		update_overlay()
		needs_update = FALSE
	else
		needs_update = TRUE
		SSlighting.overlay_queue += src

/atom/movable/lighting_overlay/Destroy(force = FALSE)
	if (!force)
		return QDEL_HINT_LETMELIVE	// STOP DELETING ME

	SSlighting.total_lighting_overlays -= 1

	var/turf/T   = loc
	if (istype(T))
		T.lighting_overlay = null
		T.luminosity = 1

	return ..()

// These macros exist PURELY so that the if below is actually readable.
#define ALL_EQUAL \
	(red_corner.cache_r == green_corner.cache_r && green_corner.cache_r == blue_corner.cache_r && blue_corner.cache_r == alpha_corner.cache_r) && \
	(red_corner.cache_g == green_corner.cache_g && green_corner.cache_g == blue_corner.cache_g && blue_corner.cache_g == alpha_corner.cache_g) && \
	(red_corner.cache_b == green_corner.cache_b && green_corner.cache_b == blue_corner.cache_b && blue_corner.cache_b == alpha_corner.cache_b)

/atom/movable/lighting_overlay/proc/update_overlay()
	var/turf/T = loc
	if (!isturf(T)) // Erm...
		if (loc)
			stack_trace("A lighting overlay realised its loc was NOT a turf (actual loc: [loc], [loc.type]) in update_overlay() and got deleted!")

		else
			stack_trace("A lighting overlay realised it was in nullspace in update_overlay() and got deleted!")

		qdel(src, TRUE)
		return

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/list/corners = T.corners
	var/datum/lighting_corner/red_corner   = dummy_lighting_corner
	var/datum/lighting_corner/green_corner = dummy_lighting_corner
	var/datum/lighting_corner/blue_corner  = dummy_lighting_corner
	var/datum/lighting_corner/alpha_corner = dummy_lighting_corner
	if (corners)
		red_corner   = corners[3] || dummy_lighting_corner
		green_corner = corners[2] || dummy_lighting_corner
		blue_corner  = corners[4] || dummy_lighting_corner
		alpha_corner = corners[1] || dummy_lighting_corner

	var/max = max(red_corner.cache_mx, green_corner.cache_mx, blue_corner.cache_mx, alpha_corner.cache_mx)
	luminosity = max > LIGHTING_SOFT_THRESHOLD


	if(red_corner.cache_r & green_corner.cache_r & blue_corner.cache_r & alpha_corner.cache_r && \
		   (red_corner.cache_g + green_corner.cache_g + blue_corner.cache_g + alpha_corner.cache_g + \
		    red_corner.cache_b + green_corner.cache_b + blue_corner.cache_b + alpha_corner.cache_b == 8))
		icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		color = null
	else if (!luminosity)
		icon_state = LIGHTING_DARKNESS_ICON_STATE
		color = null
	else if (red_corner.cache_r == LIGHTING_DEFAULT_TUBE_R && red_corner.cache_g == LIGHTING_DEFAULT_TUBE_G && red_corner.cache_b == LIGHTING_DEFAULT_TUBE_B && ALL_EQUAL)
		icon_state = LIGHTING_HALOGEN_ICON_STATE
		color = null
	else if (red_corner.cache_r == LIGHTING_NIGHTSHIT_TUBE_R && red_corner.cache_g == LIGHTING_NIGHTSHIT_TUBE_G && red_corner.cache_b == LIGHTING_NIGHTSHIT_TUBE_B && ALL_EQUAL)
		icon_state = LIGHTING_NIGHT_SHIFT_ICON_STATE
		color = null
	else
		icon_state = LIGHTING_BASE_ICON_STATE
		color = list(
			red_corner.cache_r, red_corner.cache_g, red_corner.cache_b, 00,
			green_corner.cache_r, green_corner.cache_g, green_corner.cache_b, 00,
			blue_corner.cache_r, blue_corner.cache_g, blue_corner.cache_b, 00,
			alpha_corner.cache_r, alpha_corner.cache_g, alpha_corner.cache_b, 00,
			00, 00, 00, 01
		)

	// If there's a Z-turf above us, update its shadower.
	if (T.above)
		if (T.above.shadower)
			T.above.shadower.copy_lighting(src)
		else
			T.above.update_mimic()

#undef ALL_EQUAL

// Variety of overed_cornerides so the overlays don't get affected by weird things.

/atom/movable/lighting_overlay/ex_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/lighting_overlay/singularity_act()
	return

/atom/movable/lighting_overlay/singularity_pull()
	return

/atom/movable/lighting_overlay/singuloCanEat()
	return FALSE

/atom/movable/lighting_overlay/can_fall()
	return FALSE

// Overed_corneride here to prevent things accidentally moving around overlays.
/atom/movable/lighting_overlay/forceMove(atom/destination, harderforce = FALSE)
	if(QDELING(src))
		. = ..()
