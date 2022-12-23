GLOBAL_DATUM_INIT(no_ceiling_image, /image, generate_no_ceiling_image())
GLOBAL_LIST_EMPTY(flooring_cache)

/proc/generate_no_ceiling_image()
	var/image/I = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	I.plane = PLANE_MESONS
	return I

/turf/simulated/floor/update_appearance(updates=ALL)
	if(!flooring)
		return ..()

	cut_overlays()

	flooring = GET_SINGLETON(flooring)
	// Set initial icon and strings.
	name = flooring.name
	desc = flooring.desc
	icon = flooring.icon

	if(flooring_override)
		icon_state = flooring_override
	else
		base_icon_state = flooring.base_icon_state
		if(flooring.has_base_range)
			icon_state = "[base_icon_state][rand(0, flooring.has_base_range)]"
			flooring_override = icon_state
		else
			icon_state = flooring.base_icon_state

	if(is_plating() && !(isnull(broken) && isnull(burnt)))
		if(flooring.plating_type)
			flooring = GET_SINGLETON(flooring.plating_type)
			icon       = flooring.icon
			icon_state = flooring.base_icon_state
			layer      = flooring.flooring_layer

			smoothing_flags  = flooring.smoothing_flags
			smoothing_groups = flooring.smoothing_groups
			can_smooth_with  = flooring.can_smooth_with
		else
			icon = 'icons/turf/flooring/plating.dmi'
			icon_state = "dmg[rand(1,4)]"
			smoothing_flags  = NONE
			smoothing_groups = null
			can_smooth_with  = null
			layer            = initial(layer)
	else
		smoothing_flags  = flooring.smoothing_flags
		smoothing_groups = flooring.smoothing_groups
		can_smooth_with  = flooring.can_smooth_with
		layer            = flooring.flooring_layer
		// Plating should never have a pixel offset. But if you ever want that for some reason, just tab this block down. @Zandario
		if(flooring.has_pixel_offsets)
			var/matrix/translation = new
			translation.Translate(flooring.base_pixel_x, flooring.base_pixel_y)
			transform = translation

	if(IS_SMOOTH(src))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

	if(!isnull(broken) && (flooring.flooring_flags & TURF_CAN_BREAK))
		add_overlay(get_damage_overlay("broken[broken]", BLEND_MULTIPLY))

	if(!isnull(burnt) && (flooring.flooring_flags & TURF_CAN_BURN))
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
