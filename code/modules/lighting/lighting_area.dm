/area
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED

/area/proc/set_dynamic_lighting(new_dynamic_lighting = DYNAMIC_LIGHTING_ENABLED)
	if (new_dynamic_lighting == dynamic_lighting)
		return FALSE

	dynamic_lighting = new_dynamic_lighting

	if(IS_DYNAMIC_LIGHTING(src))
		cut_overlay(/obj/effect/fullbright)

	else
		add_overlay(/obj/effect/fullbright)

	return TRUE

/area/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("dynamic_lighting")
			set_dynamic_lighting(var_value)
			return TRUE
	return ..()
