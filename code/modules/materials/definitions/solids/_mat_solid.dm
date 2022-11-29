/datum/material/solid
	abstract_type = /datum/material/solid

	name = null
	melting_point = 1000
	boiling_point = 30000
	molar_mass = 0.232 //iron Fe3O4
	latent_heat = 6120 //iron
	door_icon_base = "stone"
	// table_icon_base = "stone"
	base_icon = 'icons/turf/walls/stone.dmi'
	reinf_icon = 'icons/turf/walls/reinforced_stone.dmi'
	// stack_type =  = /obj/item/stack/material/brick
	// default_solid_form = /obj/item/stack/material/brick

/datum/material/solid/Initialize()
	if(!liquid_name)
		liquid_name = "molten [name]"
	if(!gas_name)
		gas_name = "vaporized [name]"
	// if(!ore_compresses_to)
	// 	ore_compresses_to = type
	. = ..()
