/image/fullbright
	icon = 'icons/effects/white.dmi'
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER_FULLBRIGHT
	blend_mode = BLEND_OVERLAY
	appearance_flags = PIXEL_SCALE | TILE_BOUND | RESET_ALPHA | RESET_COLOR

/image/ambient
	icon = 'icons/effects/white.dmi'
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER_BASE
	blend_mode = BLEND_ADD
	appearance_flags = PIXEL_SCALE | TILE_BOUND | RESET_ALPHA | RESET_COLOR

/obj/ambient
	icon = 'icons/effects/white.dmi'
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER_BASE
	blend_mode = BLEND_ADD
	appearance_flags = PIXEL_SCALE | TILE_BOUND | RESET_ALPHA | RESET_COLOR


/area
	var/force_fullbright = 0
	var/ambient_light = null //rgb(0.025 * 255, 0.025 * 255, 0.025 * 255)

/area/New()
	..()
	if (force_fullbright)
		lighting_overlay = new /image/fullbright
		src.add_overlay(lighting_overlay)
	else if (ambient_light)
		var/image/I = new /image/ambient
		I.color = ambient_light
		overlays += I

/area/proc/update_fullbright()
	if (force_fullbright)
		lighting_overlay = new /image/fullbright
		src.add_overlay(lighting_overlay)
	else
		src.cut_overlay(lighting_overlay)
		for (var/turf/T as anything in src)
			T.RL_Init()

/turf
	luminosity = 1
	var/fullbright = 0

/turf/proc/init_lighting()
	var/area/A = loc

	#ifdef UNDERWATER_MAP //FUCK THIS SHIT. NO FULLBRIGHT ON THE MINING LEVEL, I DONT CARE.
	if (z == AST_ZLEVEL)
		return
	#endif

	// space handles its own lighting via simple lights which already cover the turf itself too
	if (!istype(src, /turf/space) && !A.force_fullbright && fullbright) // if the area's fullbright we'll use a single overlay on the area instead
		lighting_overlay = new /image/fullbright
		src.add_overlay(lighting_overlay)
