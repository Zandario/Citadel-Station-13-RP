GLOBAL_DATUM_INIT(no_ceiling_image, /image, generate_no_ceiling_image())
GLOBAL_LIST_EMPTY(flooring_cache)

/proc/generate_no_ceiling_image()
	var/image/I = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	I.plane = PLANE_MESONS
	return I

/turf/proc/get_damage_overlay(overlay_state, blend, damage_overlay_icon = 'icons/turf/flooring/damage.dmi')
	var/cache_key = "[icon]-[overlay_state]"
	if(!GLOB.flooring_cache[cache_key])
		var/image/I = image(icon = damage_overlay_icon, icon_state = overlay_state)
		if(blend)
			I.blend_mode = blend
		I.layer = BUILTIN_DECAL_LAYER
		GLOB.flooring_cache[cache_key] = I
	return GLOB.flooring_cache[cache_key]
