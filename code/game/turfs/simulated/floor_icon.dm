GLOBAL_DATUM_INIT(no_ceiling_image, /image, generate_no_ceiling_image())

/proc/generate_no_ceiling_image()
	var/image/I = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	I.plane = PLANE_MESONS
	return I

/turf/simulated/floor/custom_smooth()
	return // we'll update_icon().

/turf/simulated/floor/update_icon()
	cut_overlays()
	if (flooring)
		// Set initial icon and strings.
		name                  = flooring.name
		desc                  = flooring.desc
		icon                  = flooring.icon
		base_icon_state       = flooring.base_icon_state
		layer                 = flooring.layer
		// Smoothing Vars
		if (smoothing_flags)
			smoothing_flags     ||= flooring.smoothing_flags
			smoothing_junction  ||= flooring.smoothing_junction
			top_left_corner     ||= flooring.top_left_corner
			top_right_corner    ||= flooring.top_right_corner
			bottom_left_corner  ||= flooring.bottom_left_corner
			bottom_right_corner ||= flooring.bottom_right_corner
			smoothing_groups    ||= flooring.smoothing_groups
			canSmoothWith       ||= flooring.canSmoothWith

		else if (flooring.has_base_range)
			icon_state = "[icon_state][rand(0, flooring.has_base_range)]"
		else
			icon_state ||= flooring.icon_state

		if (flooring.turf_translations)
			var/matrix/translation = new
			translation.Translate(flooring.turf_translations)
			transform = translation

	else
		// no flooring - just handle plating stuff
		if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
			icon = 'icons/turf/flooring/plating.dmi'
			icon_state = "dmg[rand(1,4)]"

	// Re-apply floor decals
	if (LAZYLEN(decals))
		add_overlay(decals)

	// Show 'ceilingless' overlay.
	var/turf/above = Above(src)
	if (isopenturf(above) && !istype(src, /turf/simulated/floor/outdoors)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
		add_overlay(GLOB.no_ceiling_image)

	// ..() has to be last to prevent trampling managed overlays
	. = ..()
