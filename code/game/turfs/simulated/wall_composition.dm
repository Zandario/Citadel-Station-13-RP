/turf/simulated/wall/proc/set_material(datum/material/new_material, datum/material/new_reinf_material, datum/material/new_girder_material, defer_icon)
	material = new_material
	reinf_material = new_reinf_material
	if(!new_girder_material)
		girder_material = MAT_STEEL
	else
		girder_material = new_girder_material
	if(!defer_icon)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
	update_material(TRUE)

/turf/simulated/wall/proc/update_material(defer_icon)
	if(!material)
		stack_trace("update_material() called on [src] with no material set.")
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = get_material_by_name(MAT_STEEL)
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance

	update_name()

	SSradiation.resistance_cache.Remove(src)
	if(!defer_icon)
		update_icon()
