/atom/movable/lighting_overlay
	name = ""
	anchored = TRUE
	atom_flags = ATOM_ABSTRACT

	icon = LIGHTING_ICON
	icon_state = LIGHTING_BASE_ICON_STATE

	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER_BASE
	color = LIGHTING_BASE_MATRIX

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING
	// simulated = FALSE

	#if WORLD_ICON_SIZE != 32
	transform = matrix(WORLD_ICON_SIZE / 32, 0, (WORLD_ICON_SIZE - 32) / 2, 0, WORLD_ICON_SIZE / 32, (WORLD_ICON_SIZE - 32) / 2)
	#endif

/atom/movable/lighting_overlay/New(newloc, update_now = FALSE)
	atom_flags |= ATOM_INITIALIZED
	SSlighting.total_lighting_overlays += 1

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = 0

	if (!update_now)
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

// Variety of overrides so the overlays don't get affected by weird things.

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

// Override here to prevent things accidentally moving around overlays.
/atom/movable/lighting_overlay/forceMove(atom/destination, harderforce = FALSE)
	if(QDELING(src))
		. = ..()
