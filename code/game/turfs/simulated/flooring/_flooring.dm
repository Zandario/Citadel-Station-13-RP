var/list/flooring_types

/proc/populate_flooring_types()
	flooring_types = list()
	for (var/flooring_path in typesof(/decl/flooring))
		flooring_types["[flooring_path]"] = new flooring_path

/proc/get_flooring_data(var/flooring_path)
	if(!flooring_types)
		flooring_types = list()
	if(!flooring_types["[flooring_path]"])
		flooring_types["[flooring_path]"] = new flooring_path
	return flooring_types["[flooring_path]"]

// State values:
// [base_icon_state]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [base_icon_state][has_base_range]
// [base_icon_state]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [base_icon_state]_broken[has_damage_range]
// [base_icon_state]_edges: directional overlays for edges.
// [base_icon_state]_corners: directional overlays for non-edge corners.

/decl/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/base_icon_state

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/can_paint
	var/list/footstep_sounds = list() // key=species name, value = list of soundss
	var/is_plating = FALSE
	var/list/flooring_cache = list() // Cached overlays for our edges and corners and junk

	//Plating types, can be overridden
	var/plating_type = null

	//Resistance is subtracted from all incoming damage
	//var/resistance = RESISTANCE_FRAGILE

	//Damage the floor can take before being destroyed
	//var/health = 50

	//var/removal_time = WORKTIME_FAST * 0.75

	//Flooring Icon vars
	var/smooth_nothing = FALSE //True/false only, optimisation
	//If true, all smoothing logic is entirely skipped

	//The rest of these x_smooth vars use one of the following options
	//SMOOTH_NONE: Ignore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: Ignore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_GREYLIST: Objects only: Use both lists

	//How we smooth with other flooring
	var/floor_smooth = SMOOTH_NONE
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_NONE
	//There are no lists for spaces

	/**
	 *	How we smooth with movable atoms
	 *	These are checked after the above turf based smoothing has been handled
	 *	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	 *	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing
	 *
	 *	Movable atom lists are much more complex, to account for many possibilities
	 *	Each entry in a list, is itself a list consisting of three items:
	 *		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
	 *		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
	 *		Vars: An associative list of variables (varnames in text) and desired values
	 *			Code will look for the desired vars on the target item and only call it a match if all desired values match
	 *			This can be used, for example, to check that objects are dense and anchored
	 *			there are no safety checks on this, it will probably throw runtimes if you make typos
	 *
	 *	Common example:
	 *	Don't smooth with dense anchored objects except airlocks
	 *
	 *	smooth_movable_atom = SMOOTH_GREYLIST
	 *	movable_atom_blacklist = list(
	 *		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
	 *		)
	 *	movable_atom_whitelist = list(
	 *	list(/obj/machinery/door/airlock, list(), 2)
	 *	)
	 *
	 */
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

/decl/flooring/proc/get_plating_type(turf/T)
	return plating_type

/decl/flooring/proc/get_flooring_overlay(cache_key, base_icon_state, icon_dir = 0, layer = TURF_OVERLAY_DECAL_LAYER)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = base_icon_state, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/decl/flooring/proc/drop_product(atom/A)
	if(ispath(build_type, /obj/item/stack))
		new build_type(A, build_cost)
	else
		for(var/i in 1 to min(build_cost, 50))
			new build_type(A)

/decl/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	base_icon_state = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null

/decl/flooring/snow
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow_new.dmi'
	base_icon_state = "snow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/decl/flooring/snow/gravsnow
	name = "snowy gravel"
	desc = "A layer of coarse ice pebbles and assorted gravel."
	icon = 'icons/turf/snow_new.dmi'
	base_icon_state = "gravsnow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'))

/decl/flooring/snow/snow2
	name = "snow"
	desc = "A layer of many tiny bits of frozen water. It's hard to tell how deep it is."
	icon = 'icons/turf/snow.dmi'
	base_icon_state = "snow"
	flags = TURF_HAS_EDGES

/decl/flooring/snow/gravsnow2
	name = "gravsnow"
	icon = 'icons/turf/snow.dmi'
	base_icon_state = "gravsnow"

/decl/flooring/snow/plating
	name = "snowy plating"
	desc = "Steel plating coated with a light layer of snow."
	base_icon_state = "snowyplating"
	flags = null

/decl/flooring/snow/ice
	name = "ice"
	desc = "Looks slippery."
	base_icon_state = "ice"

/decl/flooring/snow/plating/drift
	base_icon_state = "snowyplayingdrift"

/decl/flooring/carpet
	name = "carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	base_icon_state = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'))

/decl/flooring/carpet/bcarpet
	name = "black carpet"
	base_icon_state = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/decl/flooring/carpet/blucarpet
	name = "blue carpet"
	base_icon_state = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/decl/flooring/carpet/turcarpet
	name = "tur carpet"
	base_icon_state = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/decl/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	base_icon_state = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/flooring/carpet/gaycarpet
	name = "clown carpet"
	base_icon_state = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/decl/flooring/carpet/purcarpet
	name = "purple carpet"
	base_icon_state = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/decl/flooring/carpet/oracarpet
	name = "orange carpet"
	base_icon_state = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

/decl/flooring/carpet/tealcarpet
	name = "teal carpet"
	base_icon_state = "tealcarpet"
	build_type = /obj/item/stack/tile/carpet/teal

/decl/flooring/carpet/arcadecarpet
	name = "arcade carpet"
	base_icon_state = "arcade"
	build_type = /obj/item/stack/tile/carpet/arcadecarpet

/decl/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles.dmi' // More ERIS Sprites... For now...
	base_icon_state = "tiled"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_sounds = list(
		"human" = list(
			'sound/effects/footstep/floor1.ogg',
			'sound/effects/footstep/floor2.ogg',
			'sound/effects/footstep/floor3.ogg',
			'sound/effects/footstep/floor4.ogg',
			'sound/effects/footstep/floor5.ogg',
		),
	)

/decl/flooring/tiling/tech
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/techfloor.dmi'
	base_icon_state = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor/techgrey
	can_paint = null

/decl/flooring/tiling/tech/grid
	base_icon_state = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/techgrid

/decl/flooring/tiling/new_tile
	name = "floor"
	base_icon_state = "tile_full"
	flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE
	build_type = null

/decl/flooring/tiling/new_tile/cargo_one
	base_icon_state = "cargo_one_full"

/decl/flooring/tiling/new_tile/kafel
	base_icon_state = "kafel_full"

/decl/flooring/tiling/new_tile/techmaint
	base_icon_state = "techmaint"

/decl/flooring/tiling/new_tile/monofloor
	base_icon_state = "monofloor"

/decl/flooring/tiling/new_tile/monotile
	base_icon_state = "monotile"

/decl/flooring/tiling/new_tile/monowhite
	base_icon_state = "monowhite"

/decl/flooring/tiling/new_tile/steel_grid
	base_icon_state = "steel_grid"

/decl/flooring/tiling/new_tile/steel_ridged
	base_icon_state = "steel_ridged"

/decl/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	base_icon_state = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER

/decl/flooring/tiling/red
	name = "floor"
	base_icon_state = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/red

/decl/flooring/tiling/steel
	name = "floor"
	base_icon_state = "steel"
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/steel_dirty
	name = "floor"
	base_icon_state = "steel_dirty"
	build_type = /obj/item/stack/tile/floor/steel_dirty

/decl/flooring/tiling/asteroidfloor
	name = "floor"
	base_icon_state = "asteroidfloor"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/white
	name = "floor"
	desc = "How sterile."
	base_icon_state = "white"
	build_type = /obj/item/stack/tile/floor/white

/decl/flooring/tiling/yellow
	name = "floor"
	base_icon_state = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/yellow

/decl/flooring/tiling/dark
	name = "floor"
	desc = "How ominous."
	base_icon_state = "dark"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor/dark

/decl/flooring/tiling/hydro
	name = "floor"
	base_icon_state = "hydrofloor"
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/neutral
	name = "floor"
	base_icon_state = "neutral"
	build_type = /obj/item/stack/tile/floor/steel

/decl/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	base_icon_state = "freezer"
	build_type = /obj/item/stack/tile/floor/freezer

/decl/flooring/wmarble
	name = "marble floor"
	desc = "Very regal white marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "lightmarble"
	build_type = /obj/item/stack/tile/wmarble
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/bmarble
	name = "marble floor"
	desc = "Very regal black marble flooring."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "darkmarble"
	build_type = /obj/item/stack/tile/bmarble
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/bananium
	name = "bananium floor"
	desc = "Have you ever seen a clown frown?"
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "bananium"
	build_type = /obj/item/stack/tile/bananium
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/silencium
	name = "silencium floor"
	desc = "Surprisingly, doesn't mask your footsteps."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silencium"
	build_type = /obj/item/stack/tile/silencium
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/plasteel
	name = "plasteel floor"
	desc = "Sturdy metal flooring. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "plasteel"
	build_type = /obj/item/stack/tile/plasteel
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/durasteel
	name = "durasteel floor"
	desc = "Incredibly sturdy metal flooring. Definitely a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "durasteel"
	build_type = /obj/item/stack/tile/durasteel
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/silver
	name = "silver floor"
	desc = "This opulent flooring reminds you of the ocean. Almost certainly a waste."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "silver"
	build_type = /obj/item/stack/tile/silver
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/gold
	name = "gold floor"
	desc = "This richly tooled flooring makes you feel powerful."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "gold"
	build_type = /obj/item/stack/tile/gold
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/phoron
	name = "phoron floor"
	desc = "Although stable for now, this solid phoron flooring radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "phoron"
	build_type = /obj/item/stack/tile/phoron
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/uranium
	name = "uranium floor"
	desc = "This flooring literally radiates danger."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "uranium"
	build_type = /obj/item/stack/tile/uranium
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/diamond
	name = "diamond floor"
	desc = "This flooring proves that you are a king among peasants. It's virtually impossible to scuff."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "diamond"
	build_type = /obj/item/stack/tile/diamond
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/brass
	name = "brass floor"
	desc = "There's something strange about this tile. If you listen closely, it sounds like it's ticking."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "clockwork_floor"
	build_type = /obj/item/stack/tile/brass
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood_vr.dmi'
	base_icon_state = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'))

/decl/flooring/wood/sif
	name = "alien wooden floor"
	desc = "Polished alien wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	base_icon_state = "sifwood"
	build_type = /obj/item/stack/tile/wood/sif

/decl/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	base_icon_state = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1

/decl/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	base_icon_state = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1

/decl/flooring/reinforced/circuit/green
	name = "processing strata"
	base_icon_state = "gcircuit"

/decl/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	base_icon_state = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/decl/flooring/outdoors/lavaland
	name = "ash sand"
	desc = "Soft and ominous."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/decl/flooring/outdoors/classd
	name = "irradiated sand"
	desc = "It literally glows in the dark."
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))

/decl/flooring/outdoors/dirt
	name = "dirt"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "dirt-dark"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg'))


/decl/flooring/outdoors/grass
	name = "grass"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "grass"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'))

/decl/flooring/outdoors/grass/sif
	name = "growth"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "grass_sif"

/decl/flooring/water
	name = "water"
	desc = "Water is wet, gosh, who knew!"
	icon = 'icons/turf/outdoors.dmi'
	base_icon_state = "seashallow"
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'))

/decl/flooring/outdoors/beach
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
	initial_flooring = /decl/flooring/flesh

/turf/simulated/floor/flesh/colour
	icon_state = "c_flesh_floor"
	initial_flooring = /decl/flooring/flesh

/turf/simulated/floor/flesh/attackby()
	return

/decl/flooring/flesh
	name = "flesh"
	desc = "This slick flesh ripples and squishes under your touch"
	icon = 'icons/turf/stomach_vr.dmi'
	base_icon_state = "flesh_floor"

/decl/flooring/outdoors/beach/sand/desert
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

/decl/flooring/trap
	name = "suspicious flooring"
	desc = "There's something off about this tile."
	icon = 'icons/turf/flooring/plating.dmi'
	base_icon_state = "plating"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/decl/flooring/wax
	name = "wax floor"
	desc = "Soft wax sheets shaped into tile sheets. It's a little squishy, and leaves a waxy residue when touched."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "wax"
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/wax
	flags = TURF_REMOVE_CROWBAR

/decl/flooring/honeycomb
	name = "honeycomb floor"
	desc = "A shallow layer of honeycomb. Some pods have been filled with honey and sealed over in wax, while others are vacant."
	icon = 'icons/turf/flooring/misc.dmi'
	base_icon_state = "honeycomb"
	has_damage_range = 6
	damage_temperature = T0C+200
	build_type = /obj/item/stack/tile/honeycomb
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
