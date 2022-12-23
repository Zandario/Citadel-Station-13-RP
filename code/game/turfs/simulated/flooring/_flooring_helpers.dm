
GLOBAL_LIST_EMPTY_TYPED(flooring_by_type, /singleton/flooring)


/singleton/flooring/proc/get_flooring_overlay(cache_key, base_icon_state, icon_dir = 0, layer = BUILTIN_DECAL_LAYER)
	if(!GLOB.flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = base_icon_state, dir = icon_dir)
		I.layer = layer
		GLOB.flooring_cache[cache_key] = I
	return GLOB.flooring_cache[cache_key]
