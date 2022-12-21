GLOBAL_DATUM_INIT(no_ceiling_image, /image, generate_no_ceiling_image())

/proc/generate_no_ceiling_image()
	var/image/I = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	I.plane = PLANE_MESONS
	return I

/turf/simulated/floor/update_appearance(updates=ALL)
	if(!flooring)
		return ..()

	cut_overlays()

	var/singleton/flooring/our_flooring_data = get_flooring_data(flooring)
	// Set initial icon and strings.
	name = our_flooring_data.name
	desc = our_flooring_data.desc
	icon = our_flooring_data.icon

	if(flooring_override)
		icon_state = flooring_override
	else
		base_icon_state = our_flooring_data.base_icon_state
		if(our_flooring_data.has_base_range)
			icon_state = "[base_icon_state][rand(0, our_flooring_data.has_base_range)]"
			flooring_override = icon_state
		else
			icon_state = our_flooring_data.base_icon_state

	if(is_plating() && !(isnull(broken) && isnull(burnt)))
		if(our_flooring_data.plating_type)
			var/singleton/flooring/our_plating = our_flooring_data.plating_type
			icon       = our_plating.icon
			icon_state = our_plating.base_icon_state

			smoothing_flags  = our_plating.smoothing_flags
			smoothing_groups = our_plating.smoothing_groups
			can_smooth_with  = our_plating.can_smooth_with
		else
			icon = 'icons/turf/flooring/plating.dmi'
			icon_state = "dmg[rand(1,4)]"
			smoothing_flags  = NONE
			smoothing_groups = null
			can_smooth_with  = null
	else
		smoothing_flags  = our_flooring_data.smoothing_flags
		smoothing_groups = our_flooring_data.smoothing_groups
		can_smooth_with  = our_flooring_data.can_smooth_with

	if(IS_SMOOTH(src))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(!isnull(broken) && (our_flooring_data.flooring_flags & TURF_CAN_BREAK))
		add_overlay(get_damage_overlay("broken[broken]", BLEND_MULTIPLY))

	if(!isnull(burnt) && (our_flooring_data.flooring_flags & TURF_CAN_BURN))
		add_overlay(get_damage_overlay("burned[burnt]"))

	// Show 'ceilingless' overlay.
	var/turf/above = Above(src)
	if(isopenturf(above) && !istype(src, /turf/simulated/floor/outdoors)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
		add_overlay(GLOB.no_ceiling_image)

	return ..()

/turf/proc/get_damage_overlay(overlay_state, blend, damage_overlay_icon = 'icons/turf/flooring/damage.dmi')
	var/cache_key = "[icon]-[overlay_state]"
	if(!GLOB.flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		if(blend)
			I.blend_mode = blend
		I.layer = BUILTIN_DECAL_LAYER
		GLOB.flooring_cache[cache_key] = I
	return GLOB.flooring_cache[cache_key]
