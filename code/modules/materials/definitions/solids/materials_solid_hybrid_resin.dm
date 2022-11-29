/datum/material/hybrid_resin
	name = "resin compound"
	base_icon_state = "resin"
	reinf_icon_state = "reinf_mesh"
	door_icon_base = "resin"
	base_color = "#321a49"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	melting_point = T0C+200//we melt faster this isnt a building material you wanna built engines from
	sheet_singular_name = "bar"
	sheet_plural_name = "bars"
	conductive = 0
	explosion_resistance = 20//normal resin has 60, we are much softer
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/hybrid_resin

/obj/item/stack/material/hybrid_resin
	name = "resin compound"
	icon_state = "sheet-resin"
	default_type = "resin compound"
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/datum/material/hybrid_resin/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/hybrid_resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/effect/alien/hybrid_resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/hybrid_nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/effect/alien/hybrid_resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE)
