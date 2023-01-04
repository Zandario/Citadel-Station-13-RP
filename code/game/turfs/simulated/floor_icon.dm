GLOBAL_DATUM_INIT(no_ceiling_image, /image, generate_no_ceiling_image())

/proc/generate_no_ceiling_image()
	var/image/I = image(icon = 'icons/turf/open_space.dmi', icon_state = "no_ceiling")
	I.plane = PLANE_MESONS
	return I

/turf/simulated/floor/custom_smooth()
	return		// we'll update_icon().

/turf/simulated/floor/calculate_adjacencies()
	return NONE

GLOBAL_LIST_EMPTY(turf_edge_cache)

var/list/flooring_cache = list()

/turf/simulated/floor/update_icon()
	cut_overlays()
	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon

		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.icon_base
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-broken-[broken]","broken[broken]"))
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			add_overlay(flooring.get_flooring_overlay("[flooring.icon_base]-burned-[burnt]","burned[burnt]"))
	else
		// no flooring - just handle plating stuff
		if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
			icon = 'icons/turf/flooring/plating.dmi'
			icon_state = "dmg[rand(1,4)]"

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

	// Show 'ceilingless' overlay.
	var/turf/above = Above(src)
	if(isopenturf(above) && !istype(src, /turf/simulated/floor/outdoors)) // This won't apply to outdoor turfs since its assumed they don't have a ceiling anyways.
		add_overlay(GLOB.no_ceiling_image)

	update_border_spillover()	// sigh

	// ..() has to be last to prevent trampling managed overlays
	. = ..()

/**
 * welcome to the less modular but more sensical and efficient way to do icon edges
 * instead of having every turf check, we only have turfs tha can spill onto others check, and apply their edges to other turfs
 * now only on /turf/simulated/floor, because let's be honest,
 * 1. no one used borders on walls
 * 2. if you want a floor to spill onto a wall, go ahead and reconsider your life/design choices
 * 3. i can think of a reason but honestly performance is better than some niche case of floor resin creeping onto walls or something, use objs for that.
 */
/turf/simulated/floor/proc/update_border_spillover()
	if(!edge_blending_priority)
		return		// not us
	for(var/d in GLOB.cardinal)
		var/turf/simulated/F = get_step(src, d)
		// todo: BETTER ICON SYSTEM BUT HEY I GUESS WE'LL CHECK DENSITY
		if(!istype(F) || F.density)
			continue
		// check that their priority is lower than ours, and we don't have the same icon state
		if(F.edge_blending_priority < edge_blending_priority && icon_state != F.icon_state)
			var/key = "[icon_state || edge_icon_state]-[d]"
			add_overlay(GLOB.turf_edge_cache[key] || generate_border_cache_for(icon_state || edge_icon_state, d))

// todo: better system
/proc/generate_border_cache_for(state, dir)
	// make it
	var/static/list/states = icon_states('icons/turf/outdoors_edge.dmi')
	var/actual
	if(state in states)
		actual = state
	else if("[state]-edge" in states)
		actual = "[state]-edge"
	var/image/I = image('icons/turf/outdoors_edge.dmi', icon_state = actual, layer = DECAL_LAYER, dir = turn(dir, 180))
	// I.layer = flooring.decal_layer
	switch(dir)
		if(NORTH)
			I.pixel_y = 32
		if(SOUTH)
			I.pixel_y = -32
		if(EAST)
			I.pixel_x = 32
		if(WEST)
			I.pixel_x = -32
	GLOB.turf_edge_cache["[state]-[dir]"] = I
	return I

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]
