





/singleton/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	base_icon_state = "snowyplating"

/singleton/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	base_icon_state = "ice"

/singleton/flooring/snow/plating/drift
	base_icon_state = "snowyplayingdrift"

/singleton/flooring/carpet
	name = "carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	base_icon_state = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flooring_flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'))

/singleton/flooring/carpet/bcarpet
	name = "black carpet"
	base_icon_state = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/singleton/flooring/carpet/blucarpet
	name = "blue carpet"
	base_icon_state = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/singleton/flooring/carpet/turcarpet
	name = "tur carpet"
	base_icon_state = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/singleton/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	base_icon_state = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/singleton/flooring/carpet/gaycarpet
	name = "clown carpet"
	base_icon_state = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/singleton/flooring/carpet/purcarpet
	name = "purple carpet"
	base_icon_state = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/singleton/flooring/carpet/oracarpet
	name = "orange carpet"
	base_icon_state = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

/singleton/flooring/carpet/tealcarpet
	name = "teal carpet"
	base_icon_state = "tealcarpet"
	build_type = /obj/item/stack/tile/carpet/teal

/singleton/flooring/carpet/arcadecarpet
	name = "arcade carpet"
	base_icon_state = "arcade"
	build_type = /obj/item/stack/tile/carpet/arcadecarpet

/singleton/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles_vr.dmi' // More ERIS Sprites... For now...
	base_icon_state = "tiled"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flooring_flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/singleton/flooring/tiling/tech
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/techfloor_vr.dmi'
	base_icon_state = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor/techgrey
	can_paint = null

/singleton/flooring/tiling/tech/grid
	base_icon_state = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/techgrid

/singleton/flooring/tiling/new_tile
	name = "floor"
	base_icon_state = "tile_full"
	flooring_flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE
	build_type = null

/singleton/flooring/tiling/new_tile/cargo_one
	base_icon_state = "cargo_one_full"

/singleton/flooring/tiling/new_tile/kafel
	base_icon_state = "kafel_full"

/singleton/flooring/tiling/new_tile/techmaint
	base_icon_state = "techmaint"

/singleton/flooring/tiling/new_tile/monofloor
	base_icon_state = "monofloor"

/singleton/flooring/tiling/new_tile/monotile
	base_icon_state = "monotile"

/singleton/flooring/tiling/new_tile/monowhite
	base_icon_state = "monowhite"

/singleton/flooring/tiling/new_tile/steel_grid
	base_icon_state = "steel_grid"

/singleton/flooring/tiling/new_tile/steel_ridged
	base_icon_state = "steel_ridged"

/singleton/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	base_icon_state = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flooring_flags = TURF_REMOVE_SCREWDRIVER

/singleton/flooring/tiling/red
	name = "floor"
	base_icon_state = "white"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/red

/singleton/flooring/tiling/steel
	name = "floor"
	base_icon_state = "steel"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/steel_dirty
	name = "floor"
	base_icon_state = "steel_dirty"
	build_type = /obj/item/stack/tile/floor/steel_dirty

/singleton/flooring/tiling/asteroidfloor
	name = "floor"
	base_icon_state = "asteroidfloor"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/white
	name = "floor"
	desc = "How sterile."
	base_icon_state = "white"
	build_type = /obj/item/stack/tile/floor/white

/singleton/flooring/tiling/yellow
	name = "floor"
	base_icon_state = "white"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/yellow

/singleton/flooring/tiling/dark
	name = "floor"
	desc = "How ominous."
	base_icon_state = "dark"
	has_damage_range = null
	flooring_flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/dark

/singleton/flooring/tiling/hydro
	name = "floor"
	base_icon_state = "hydrofloor"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/neutral
	name = "floor"
	base_icon_state = "neutral"
	build_type = /obj/item/stack/tile/floor/steel

/singleton/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	base_icon_state = "freezer"
	build_type = /obj/item/stack/tile/floor/freezer

/singleton/flooring/wmarble
	name = "marble floor"
	desc = "Very regal white marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "lightmarble"
	build_type = /obj/item/stack/tile/wmarble
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bmarble
	name = "marble floor"
	desc = "Very regal black marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "darkmarble"
	build_type = /obj/item/stack/tile/bmarble
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/bananium
	name = "bananium floor"
	desc = "Have you ever seen a clown frown?"
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "bananium"
	build_type = /obj/item/stack/tile/bananium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/plasteel
	name = "plasteel floor"
	desc = "Sturdy metal flooring. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "plasteel"
	build_type = /obj/item/stack/tile/plasteel
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/durasteel
	name = "durasteel floor"
	desc = "Incredibly sturdy metal flooring. Definitely a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "durasteel"
	build_type = /obj/item/stack/tile/durasteel
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/silver
	name = "silver floor"
	desc = "This opulent flooring reminds you of the ocean. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silver"
	build_type = /obj/item/stack/tile/silver
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/gold
	name = "gold floor"
	desc = "This richly tooled flooring makes you feel powerful."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "gold"
	build_type = /obj/item/stack/tile/gold
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/phoron
	name = "phoron floor"
	desc = "Although stable for now, this solid phoron flooring radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "phoron"
	build_type = /obj/item/stack/tile/phoron
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/uranium
	name = "uranium floor"
	desc = "This flooring literally radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "uranium"
	build_type = /obj/item/stack/tile/uranium
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/diamond
	name = "diamond floor"
	desc = "This flooring proves that you are a king among peasants. It's virtually impossible to scuff."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "diamond"
	build_type = /obj/item/stack/tile/diamond
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/brass
	name = "brass floor"
	desc = "There's something strange about this tile. If you listen closely, it sounds like it's ticking."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "clockwork_floor"
	build_type = /obj/item/stack/tile/brass
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood_vr.dmi'
	base_icon_state = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flooring_flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	smoothing_flags = NONE
	smoothing_groups = null
	can_smooth_with = null
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))

/singleton/flooring/wood/sif
	name = "alien wooden floor"
	desc = "Polished alien wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	base_icon_state = "sifwood"
	build_type = /obj/item/stack/tile/wood/sif

/singleton/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	base_icon_state = "reinforced"
	flooring_flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1

/singleton/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	base_icon_state = "bcircuit"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1

/singleton/flooring/reinforced/circuit/green
	name = "processing strata"
	base_icon_state = "gcircuit"

/singleton/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	base_icon_state = "cult"
	build_type = null
	has_damage_range = 6
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/singleton/flooring/outdoors/classd
	name = "irradiated sand"
	desc = "It literally glows in the dark."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/singleton/flooring/outdoors/dirt
	name = "dirt"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "dirt-dark"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/singleton/flooring/outdoors/grass
	name = "grass"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "grass"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/singleton/flooring/outdoors/grass/sif
	name = "growth"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "grass_sif"

/singleton/flooring/water
	name = "water"
	desc = "Water is wet, gosh, who knew!"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "seashallow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'))

/singleton/flooring/outdoors/beach
	name = "beach"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "sand"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/turf/simulated/floor/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "flesh_floor"
	initial_flooring = /singleton/flooring/flesh

/turf/simulated/floor/flesh/colour
	icon_state = "c_flesh_floor"
	initial_flooring = /singleton/flooring/flesh

/turf/simulated/floor/flesh/attackby()
	return

/singleton/flooring/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	base_icon_state = "flesh_floor"

/singleton/flooring/outdoors/beach/sand/desert
	name = "sand"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "sand"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))
/turf/simulated/floor/tiled/freezer/cold
	temperature = T0C - 5

/singleton/flooring/trap
	name = "suspicious flooring"
	desc = "There's something off about this tile."
	icon = 'icons/turf/flooring/plating_vr.dmi'
	base_icon_state = "plating"
	build_type = null
	flooring_flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/wax
	name = "wax floor"
	desc = "Soft wax sheets shaped into tile sheets. It's a little squishy, and leaves a waxy residue when touched."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "wax"
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/wax
	flooring_flags = TURF_REMOVE_CROWBAR

/singleton/flooring/honeycomb
	name = "honeycomb floor"
	desc = "A shallow layer of honeycomb. Some pods have been filled with honey and sealed over in wax, while others are vacant."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "honeycomb"
	has_damage_range = 6
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/honeycomb
	flooring_flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
