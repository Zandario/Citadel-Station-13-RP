/datum/lighting_object

	/// Whether we are already in the SSlighting.objects_queue list
	var/needs_update = FALSE

	/// The turf that our light is applied to
	var/turf/affected_turf

	/// The overlay we are currently applying to our turf to apply light
	var/mutable_appearance/current_underlay
	var/mutable_appearance/additive_underlay

	#if WORLD_ICON_SIZE != 32
	transform = matrix(WORLD_ICON_SIZE / 32, 0, (WORLD_ICON_SIZE - 32) / 2, 0, WORLD_ICON_SIZE / 32, (WORLD_ICON_SIZE - 32) / 2)
	#endif

/datum/lighting_object/New(turf/source, update_now = FALSE)
	if(!isturf(source))
		qdel(src, force=TRUE)
		stack_trace("a lighting object was assigned to [source], a non turf! ")
		return
	. = ..()
	SSlighting.total_lighting_overlays += 1

	affected_turf = source // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	affected_turf.lighting_overlay = src
	affected_turf.luminosity = 0

	current_underlay  = mutable_appearance(LIGHTING_ICON, LIGHTING_BASE_ICON_STATE, LIGHTING_LAYER, LIGHTING_PLANE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)
	additive_underlay = mutable_appearance(LIGHTING_ICON, LIGHTING_BASE_ICON_STATE, LIGHTING_LAYER, LIGHTING_PLANE_ADDITIVE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)
	// additive_underlay.blend_mode = BLEND_ADD

	if (affected_turf.corners && affected_turf.corners.len)
		for (var/datum/lighting_corner/C in affected_turf.corners)
			C.active = TRUE

	if (update_now)
		update_overlay()
		needs_update = FALSE
	else
		needs_update = TRUE
		SSlighting.overlay_queue += src

/datum/lighting_object/Destroy(force = FALSE)
	if (!force)
		return QDEL_HINT_LETMELIVE	// STOP DELETING ME

	SSlighting.total_lighting_overlays -= 1

	if (isturf(affected_turf))
		affected_turf.lighting_overlay = null
		affected_turf.luminosity = 1
		affected_turf.overlays -= current_underlay
		affected_turf.overlays -= additive_underlay
	affected_turf = null
	return ..()

/datum/lighting_object/proc/update_overlay()

	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/datum/lighting_corner/red_corner   = affected_turf.corners[3] || dummy_lighting_corner
	var/datum/lighting_corner/green_corner = affected_turf.corners[2] || dummy_lighting_corner
	var/datum/lighting_corner/blue_corner  = affected_turf.corners[4] || dummy_lighting_corner
	var/datum/lighting_corner/alpha_corner = affected_turf.corners[1] || dummy_lighting_corner

	var/max = max(red_corner.cache_mx, green_corner.cache_mx, blue_corner.cache_mx, alpha_corner.cache_mx)

	var/rr = red_corner.cache_r
	var/rg = red_corner.cache_g
	var/rb = red_corner.cache_b

	var/gr = green_corner.cache_r
	var/gg = green_corner.cache_g
	var/gb = green_corner.cache_b

	var/br = blue_corner.cache_r
	var/bg = blue_corner.cache_g
	var/bb = blue_corner.cache_b

	var/ar = alpha_corner.cache_r
	var/ag = alpha_corner.cache_g
	var/ab = alpha_corner.cache_b

	var/set_luminosity = max > 1e-6

	if((rr & gr & br & ar) && (rg + gg + bg + ag + rb + gb + bb + ab == 8))
		//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		affected_turf.underlays -= current_underlay
		current_underlay.icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		current_underlay.color = null
		affected_turf.underlays += current_underlay
	else if (!set_luminosity)
		affected_turf.underlays -= current_underlay
		current_underlay.icon_state = LIGHTING_DARKNESS_ICON_STATE
		current_underlay.color = null
		affected_turf.underlays += current_underlay
	else
		affected_turf.underlays -= current_underlay
		current_underlay.icon_state = LIGHTING_BASE_ICON_STATE
		if(islist(current_underlay.color))
			// Does this even save a list alloc?
			var/list/c_list = current_underlay.color
			c_list[CL_MATRIX_RR] = rr
			c_list[CL_MATRIX_RG] = rg
			c_list[CL_MATRIX_RB] = rb
			c_list[CL_MATRIX_GR] = gr
			c_list[CL_MATRIX_GG] = gg
			c_list[CL_MATRIX_GB] = gb
			c_list[CL_MATRIX_BR] = br
			c_list[CL_MATRIX_BG] = bg
			c_list[CL_MATRIX_BB] = bb
			c_list[CL_MATRIX_AR] = ar
			c_list[CL_MATRIX_AG] = ag
			c_list[CL_MATRIX_AB] = ab
			current_underlay.color = c_list
		else
			current_underlay.color = list(
				rr, rg, rb, 00,
				gr, gg, gb, 00,
				br, bg, bb, 00,
				ar, ag, ab, 00,
				00, 00, 00, 01
			)
		affected_turf.underlays += current_underlay

	if(red_corner.applying_additive || green_corner.applying_additive || blue_corner.applying_additive || alpha_corner.applying_additive)
		affected_turf.underlays -= additive_underlay
		additive_underlay.icon_state = LIGHTING_BASE_ICON_STATE
		var/a_rr = red_corner.add_r
		var/a_rg = red_corner.add_g
		var/a_rb = red_corner.add_b

		var/a_gr = green_corner.add_r
		var/a_gg = green_corner.add_g
		var/a_gb = green_corner.add_b

		var/a_br = blue_corner.add_r
		var/a_bg = blue_corner.add_g
		var/a_bb = blue_corner.add_b

		var/a_ar = alpha_corner.add_r
		var/a_ag = alpha_corner.add_g
		var/a_ab = alpha_corner.add_b

		if(islist(additive_underlay.color))
			// Does this even save a list alloc?
			var/list/c_list = additive_underlay.color
			c_list[CL_MATRIX_RR] = a_rr
			c_list[CL_MATRIX_RG] = a_rg
			c_list[CL_MATRIX_RB] = a_rb
			c_list[CL_MATRIX_GR] = a_gr
			c_list[CL_MATRIX_GG] = a_gg
			c_list[CL_MATRIX_GB] = a_gb
			c_list[CL_MATRIX_BR] = a_br
			c_list[CL_MATRIX_BG] = a_bg
			c_list[CL_MATRIX_BB] = a_bb
			c_list[CL_MATRIX_AR] = a_ar
			c_list[CL_MATRIX_AG] = a_ag
			c_list[CL_MATRIX_AB] = a_ab
			additive_underlay.color = c_list
		else
			additive_underlay.color = list(
				a_rr, a_rg, a_rb, 00,
				a_gr, a_gg, a_gb, 00,
				a_br, a_bg, a_bb, 00,
				a_ar, a_ag, a_ab, 00,
				00, 00, 00, 01
			)
		affected_turf.underlays += additive_underlay
	else
		affected_turf.underlays -= additive_underlay

	affected_turf.luminosity = set_luminosity

	// If there's a Z-turf above us, update its shadower.
	if (affected_turf.above)
		if (affected_turf.above.shadower)
			affected_turf.above.shadower.copy_lighting(src)
		else
			affected_turf.above.update_mimic()
