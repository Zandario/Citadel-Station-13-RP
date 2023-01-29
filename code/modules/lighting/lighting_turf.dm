/turf
	luminosity = 1

	var/dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	/// If non-null, a hex RGB light color that should be applied to this turf.
	var/ambient_light
	/// The power of the above is multiplied by this. Setting too high may drown out normal lights on the same turf.
	var/ambient_light_multiplier = 0.3

	/// List of light sources affecting this turf.
	var/tmp/list/datum/light_source/affecting_lights
	/// Our lighting overlay.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay
	/// Our normal map.
	var/tmp/atom/movable/normal_map/normal_map

	/// Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.
	var/tmp/has_opaque_atom = FALSE
	/// If this is TRUE, an above turf's ambient light is affecting this turf.
	var/tmp/ambient_has_indirect = FALSE

	//! Record-keeping, do not touch -- that means you, admins.
	var/tmp/ambient_light_old
	var/tmp/ambient_light_old_r = 0
	var/tmp/ambient_light_old_g = 0
	var/tmp/ambient_light_old_b = 0

/turf/proc/set_ambient_light(color, multiplier)
	if (color == ambient_light && multiplier == ambient_light_multiplier)
		return

	ambient_light = color || ambient_light
	ambient_light_multiplier = multiplier || ambient_light_multiplier
	if (!ambient_light_multiplier)
		ambient_light_multiplier = initial(ambient_light_multiplier)

	update_ambient_light()

/turf/proc/clear_ambient_light()
	if (ambient_light == null)
		return

	ambient_light = null
	update_ambient_light()

/turf/proc/update_ambient_light(no_corner_update = FALSE)
	// These are deltas.
	var/ambient_r = 0
	var/ambient_g = 0
	var/ambient_b = 0

	if (ambient_light)
		ambient_r = ((HEX_RED(ambient_light) / 255) * ambient_light_multiplier)/4 - ambient_light_old_r
		ambient_g = ((HEX_GREEN(ambient_light) / 255) * ambient_light_multiplier)/4 - ambient_light_old_g
		ambient_b = ((HEX_BLUE(ambient_light) / 255) * ambient_light_multiplier)/4 - ambient_light_old_b
	else
		ambient_r = -ambient_light_old_r
		ambient_g = -ambient_light_old_g
		ambient_b = -ambient_light_old_b

	ambient_light_old_r += ambient_r
	ambient_light_old_g += ambient_g
	ambient_light_old_b += ambient_b

	if (ambient_r + ambient_g + ambient_b == 0)
		return

	// // This list can contain nulls on things like space turfs -- they only have their neighbors' corners.
	// if (corner)
	// 	corner.update_ambient_lumcount(ambient_r, ambient_g, ambient_b, no_corner_update)

	if (ambient_light_old == null && ambient_light != ambient_light_old)
		SSlighting.total_ambient_turfs += 1
	else if (ambient_light_old != null && ambient_light == null)
		SSlighting.total_ambient_turfs -= 1

	ambient_light_old = ambient_light

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.vis_update()

// Forces a lighting update. Reconsider lights is preferred when possible.
/turf/proc/force_update_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.force_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_overlay)
		if (lighting_overlay.loc != src)
			stack_trace("Lighting overlay variable on turf [log_info_line(src)] is insane, lighting overlay actually located on [log_info_line(lighting_overlay.loc)]!")

		qdel(lighting_overlay, TRUE)
		lighting_overlay = null

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlays(now = FALSE)
	if (lighting_overlay)
		CRASH("Attempted to create lighting_overlay on tile that already had one.")

	if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
		new /atom/movable/lighting_overlay(src, now)



// Returns the average color of this tile. Roughly corresponds to the color of a single old-style lighting overlay.
/turf/proc/get_avg_color()
	if (!lighting_overlay)
		return null

	var/lum_r
	var/lum_g
	var/lum_b

	lum_r = CLAMP01(lum_r / 4) * 255
	lum_g = CLAMP01(lum_g / 4) * 255
	lum_b = CLAMP01(lum_b / 4) * 255

	return "#[num2hex(lum_r, 2)][num2hex(lum_g, 2)][num2hex(lum_g, 2)]"

#define SCALE(targ,min,max) (targ - min) / (max - min)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_overlay)
		return 0.5

	var/totallums = 0

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = SCALE(totallums, minlum, maxlum)

	return CLAMP01(totallums)

#undef SCALE

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
#ifdef AO_USE_LIGHTING_OPACITY
	var/old = has_opaque_atom
#endif

	has_opaque_atom = FALSE
	if (opacity)
		has_opaque_atom = TRUE
	else
		for (var/thing in src) // Loop through every movable atom on our tile
			var/atom/movable/A = thing
			if (A.opacity)
				has_opaque_atom = TRUE
				break 	// No need to continue if we find something opaque.

#ifdef AO_USE_LIGHTING_OPACITY
	if (old != has_opaque_atom)
		regenerate_ao()
#endif

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (!Obj)
		return

	if (Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()
