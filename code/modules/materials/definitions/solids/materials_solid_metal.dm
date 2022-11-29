/datum/material/solid/metal
	abstract_type = /datum/material/solid/metal
	name = null
	wall_name = "bulkhead"
	// weight = MAT_VALUE_HEAVY
	// hardness = MAT_VALUE_RIGID
	// wall_support_value = MAT_VALUE_HEAVY
	wall_flags = WALL_FLAG_PAINTABLE
	wall_blend_icons = list(
		'icons/turf/walls/wood.dmi' = TRUE,
		'icons/turf/walls/stone.dmi' = TRUE,
	)
	// default_solid_form = /obj/item/stack/material/ingot
	stack_type = /obj/item/stack/material

	base_icon = 'icons/turf/walls/solid.dmi'
	reinf_icon = 'icons/turf/walls/reinforced.dmi'
	// table_icon_base = "metal"
	door_icon_base = "metal"

/datum/material/solid/metal/steel
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	base_icon = 'icons/turf/walls/solid.dmi'
	reinf_icon = 'icons/turf/walls/reinforced.dmi'
	base_icon_state = "wall"
	reinf_icon_state = "wall"
	base_color = "#666666"

/datum/material/solid/metal/steel/hull
	name = MAT_STEELHULL
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250
	explosion_resistance = 10
	base_icon = 'icons/turf/walls/metal.dmi'
	reinf_icon = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_reinf_directionals = FALSE
	base_color = "#666677"

/datum/material/solid/metal/steel/hull/place_sheet(var/turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)


/datum/material/solid/metal/steel/holographic
	name = "holo" + MAT_STEEL
	display_name = MAT_STEEL
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/solid/metal/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	base_icon = 'icons/turf/walls/solid.dmi'
	reinf_icon = 'icons/turf/walls/reinforced.dmi'
	base_icon_state = "wall"
	reinf_icon_state = "wall"
	base_color = "#a8a9b2"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14

/datum/material/solid/metal/plasteel/hull
	name = MAT_PLASTEELHULL
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600
	base_icon = 'icons/turf/walls/metal.dmi'
	reinf_icon = 'icons/turf/walls/reinforced_mesh.dmi'
	icon_reinf_directionals = FALSE
	base_color = "#777788"
	explosion_resistance = 40

/datum/material/solid/metal/plasteel/hull/place_sheet(var/turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)
