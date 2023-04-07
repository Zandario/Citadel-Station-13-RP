/atom
	var/atom/movable/lighting_overlay/light_obj
	var/light_type = LIGHT_SOFT
	var/light_power = 1
	var/light_range = 0
	var/light_color = "#F4FFFA"

// Nonsensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999

/**
 * Updates all appropriate lighting values and then applies all changed values
 * to the objects light_obj overlay atom.
 */
/atom/proc/set_light(l_range, l_power, l_color, l_type, fadeout)

	if(!loc)
		if(light_obj)
			qdel(light_obj)
			light_obj = null
		return

	// Update or retrieve our variable data.
	if(isnull(l_range))
		l_range = light_range
	else
		light_range = l_range
	if(isnull(l_power))
		l_power = light_power
	else
		light_power = l_power
	if(isnull(l_color))
		l_color = light_color
	else
		light_color = l_color
	if(isnull(l_type))
		l_type = light_type
	else
		light_type = l_type

	/// Apply data and update light casting/bleed masking.
	var/update_cast
	if(!light_obj)
		update_cast = TRUE
		light_obj = new(src)

	if(light_obj.light_range != l_range)
		update_cast = TRUE
		light_obj.light_range = l_range

	if(light_obj.light_power != l_power)
		update_cast = TRUE
		light_obj.light_power = l_power

	if(light_obj.light_color != l_color)
		update_cast = TRUE
		light_obj.light_color = l_color
		light_obj.color = l_color

	if(light_obj.current_power != l_range)
		update_cast = TRUE
		light_obj.update_transform(l_range)

	if(light_obj.light_type != l_type)
		update_cast = TRUE
		light_obj.light_type = l_type

	if(!light_obj.alpha)
		update_cast = TRUE

	// Makes sure the obj isn't somewhere weird (like inside the holder). Also calls bleed masking.
	if(update_cast)
		light_obj.follow_holder()

	// Rare enough that we can probably get away with calling animate().
	if(fadeout)
		animate(light_obj, alpha = 0, time = fadeout)

/**
 * Destroys and removes a light.
 * Replaces previous system's kill_light().
 */
/atom/proc/kill_light()
	if(light_obj)
		qdel(light_obj)
		light_obj = null
	return

/**
 * Used to change hard BYOND opacity.
 * This means a lot of updates are needed.
 */
/atom/proc/set_opacity(newopacity)
	opacity = newopacity ? TRUE : FALSE
	var/turf/T = get_turf(src)
	if(istype(T))
		T.blocks_light = -1
		for(var/atom/movable/lighting_overlay/L in range(get_turf(src), world.view)) //view(world.view, dview_mob))
			L.cast_light()

/atom/proc/copy_light(atom/other)
	light_range = other.light_range
	light_power = other.light_power
	light_color = other.light_color
	set_light()

/atom/proc/update_all_lights()
	if(light_obj && !QDELETED(light_obj))
		light_obj.follow_holder()

/atom/proc/update_contained_lights(list/specific_contents)
	if(!specific_contents)
		specific_contents = contents
	for(var/thing in (specific_contents + src))
		var/atom/A = thing
		spawn()
			if(A && !QDELETED(A))
				A.update_all_lights()

/atom/Destroy()
	if(light_obj)
		qdel(light_obj)
		light_obj = null
	return ..()

/atom/movable/setDir(newdir)
	. = ..()
	update_contained_lights()

/atom/movable/Move()
	. = ..()
	update_contained_lights()

/atom/movable/forceMove()
	. = ..()
	update_contained_lights()

/atom/movable/Moved(atom/OldLoc, Dir)
	. = ..()
	if(opacity)
		var/turf/T = OldLoc
		if(istype(T))
			T.blocks_light = -1
			T.force_light_update()

/atom/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("light_range")
			set_light(l_range = var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if("light_power")
			set_light(l_power = var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if("light_color")
			set_light(l_color = var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if("light_type")
			set_light(l_type = var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

	return ..()


/atom/proc/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	return

/turf/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	if(!_duration)
		stack_trace("Lighting FX obj created on a turf without a duration")
	new /obj/effect/dummy/lighting_obj (src, _color, _range, _power, _duration)

/obj/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	var/temp_color
	var/temp_power
	var/temp_range
	if(!_reset_lighting) //incase the obj already has a lighting color that you don't want cleared out after, ie computer monitors.
		temp_color = light_color
		temp_power = light_power
		temp_range = light_range
	set_light(_range, _power, _color)
	addtimer(CALLBACK(src, /atom/proc/set_light, _reset_lighting ? initial(light_range) : temp_range, _reset_lighting ? initial(light_power) : temp_power, _reset_lighting ? initial(light_color) : temp_color), _duration, TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	mob_light(_color, _range, _power, _duration)

/mob/living/proc/mob_light(_color, _range, _power, _duration)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = new (src, _color, _range, _power, _duration)
	return mob_light_obj
