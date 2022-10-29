/**
 * State values:
 * [base_icon_state]: initial base icon_state without edges or corners.
 * if has_base_range is set, append 0-has_base_range ie.
 *   [base_icon_state][has_base_range]
 * [base_icon_state]_broken: damaged overlay.
 * if has_damage_range is set, append 0-damage_range for state ie.
 *   [base_icon_state]_broken[has_damage_range]
 * [base_icon_state]_edges: directional overlays for edges.
 * [base_icon_state]_corners: directional overlays for non-edge corners.
 */

/decl/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/icon_state
	var/base_icon_state
	var/layer


	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	/// Unbuildable if not set. Must be /obj/item/stack.
	var/build_type
	/// Stack units.
	var/build_cost = 1
	/// BYOND ticks.
	var/build_time = 0

	var/descriptor = "tiles"
	var/flags
	var/can_paint
	/// key=species name, value = list of soundss
	var/list/footstep_sounds = list()
	var/is_plating = FALSE

	/// Cached overlays for our edges and corners and junk.
	var/list/flooring_cache = list()

	/// Plating types, can be overridden.
	var/plating_type = null

	/// Resistance is subtracted from all incoming damage.
	//var/resistance = RESISTANCE_FRAGILE

	/// Damage the floor can take before being destroyed
	//var/health = 50

	//var/removal_time = WORKTIME_FAST * 0.75

	//! ## Legacy Smoothing

	/**
	 * The rest of these x_smooth vars use one of the following options.
	 * FLOORING_SMOOTH_NONE: Ignore all of type.
	 * FLOORING_SMOOTH_ALL: Smooth with all of type.
	 * FLOORING_SMOOTH_WHITELIST: Ignore all except types on this list.
	 * FLOORING_SMOOTH_BLACKLIST: Smooth with all except types on this list.
	 * FLOORING_SMOOTH_GREYLIST: Objects only: Use both lists.
	 */

	/// How we smooth with other flooring.
	var/floor_smooth = FLOORING_SMOOTH_NONE
	/// Smooth with nothing except the contents of this list.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the contents of this list.
	var/list/flooring_blacklist = list()

	/// How we smooth with walls.
	var/wall_smooth = FLOORING_SMOOTH_NONE
	//There are no lists for walls at this time

	/// How we smooth with space and openspace tiles
	var/space_smooth = FLOORING_SMOOTH_NONE
	//There are no lists for spaces

	/**
	 * How we smooth with movable atoms
	 * These are checked after the above turf based smoothing has been handled
	 * FLOORING_SMOOTH_ALL or FLOORING_SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	 * Using the white/blacklists will override what the turfs concluded, to force or deny smoothing
	 *
	 * Movable atom lists are much more complex, to account for many possibilities
	 * Each entry in a list, is itself a list consisting of three items:
	 * 	Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
	 * 	Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
	 * 	Vars: An associative list of variables (varnames in text) and desired values
	 * 		Code will look for the desired vars on the target item and only call it a match if all desired values match
	 * 		This can be used, for example, to check that objects are dense and anchored
	 * 		there are no safety checks on this, it will probably throw runtimes if you make typos
	 *
	 * Common example:
	 * Don't smooth with dense anchored objects except airlocks
	 *
	 * smooth_movable_atom = FLOORING_SMOOTH_GREYLIST
	 * movable_atom_blacklist = list(
	 * 	list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
	 * 	)
	 * movable_atom_whitelist = list(
	 * list(/obj/machinery/door/airlock, list(), 2)
	 * )
	 *
	 */
	var/smooth_movable_atom = FLOORING_SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

	//! ## Icon Smoothing
	///
	/**
	 * Icon-smoothing behavior.
	 *! Is SMOOTH_CUSTOM by default since that would be the old system.
	 */
	var/smoothing_flags = SMOOTH_CUSTOM
	/**
	 * What directions this is currently smoothing with.
	 * This starts as null for us to know when it's first set, but after that it will hold a 8-bit mask ranging from 0 to 255.
	 *! IMPORTANT: This uses the smoothing direction flags as defined in icon_smoothing.dm, instead of the BYOND flags.
	 */
	var/smoothing_junction
	/// Smoothing variable.
	var/top_left_corner
	/// Smoothing variable.
	var/top_right_corner
	/// Smoothing variable.
	var/bottom_left_corner
	/// Smoothing variable.
	var/bottom_right_corner
	/**
	 * What smoothing groups does this atom belongs to, to match canSmoothWith.
	 * If null, nobody can smooth with it.
	 */
	var/list/smoothing_groups = null
	/**
	 * List of smoothing groups this atom can smooth with.
	 * If this is null and atom is smooth, it smooths only with itself.
	 */
	var/list/canSmoothWith = null

	/// Use this to set the X/Y offsets for icons bigger than 32x32.
	var/turf_translations

GLOBAL_LIST_EMPTY(flooring_types)

/proc/populate_flooring_types()
	GLOB.flooring_types = list()
	for (var/flooring_path in typesof(/decl/flooring))
		GLOB.flooring_types["[flooring_path]"] = new flooring_path

/proc/get_flooring_data(flooring_path)
	if(!GLOB.flooring_types)
		GLOB.flooring_types = list()
	if(!GLOB.flooring_types["[flooring_path]"])
		GLOB.flooring_types["[flooring_path]"] = new flooring_path
	return GLOB.flooring_types["[flooring_path]"]

/decl/flooring/proc/get_plating_type(turf/T)
	return plating_type

/decl/flooring/proc/get_flooring_overlay(cache_key, icon_base, icon_dir = NONE, layer = TURF_DECAL_LAYER)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]

/decl/flooring/proc/drop_product(atom/A)
	if(ispath(build_type, /obj/item/stack))
		new build_type(A, build_cost)
	else
		for(var/i in 1 to min(build_cost, 50))
			new build_type(A)

/**
 * Tests whether this flooring will smooth with the specified turf.
 * You can override this if you want a flooring to have super special snowflake smoothing behaviour.
 */
/decl/flooring/proc/test_link(turf/origin, turf/T, countercheck = FALSE)

	var/is_linked = FALSE
	if (countercheck)
		// If this is a countercheck, we skip all of the above, start off with true, and go straight to the atom lists.
		is_linked = TRUE
	else if(T)

		// If it's a wall, use the wall_smooth setting.
		if(istype(T, /turf/simulated/wall))
			if(wall_smooth == FLOORING_SMOOTH_ALL)
				is_linked = TRUE

		// If it's space or openspace, use the space_smooth setting.
		else if(isspaceturf(T) || isopenturf(T))
			if(space_smooth == FLOORING_SMOOTH_ALL)
				is_linked = TRUE

		// If we get here then its a normal floor.
		else if (istype(T, /turf/simulated/floor))
			var/turf/simulated/floor/t = T
			// If the floor is the same as us,then we're linked-
			if (t.flooring?.type == type)
				is_linked = TRUE
				/**
				 * But there's a caveat. To make atom black/whitelists work correctly, we also need to check that
				 * they smooth with us. Ill call this counterchecking for simplicity.
				 * This is needed to make both turfs have the correct borders
				 * To prevent infinite loops we have a countercheck var, which we'll set true
				 */

				if (smooth_movable_atom != FLOORING_SMOOTH_NONE)
					//We do the countercheck, passing countercheck as true
					is_linked = test_link(T, origin, countercheck = TRUE)

			else if (floor_smooth == FLOORING_SMOOTH_ALL)
				is_linked = TRUE

			else if (floor_smooth != FLOORING_SMOOTH_NONE)
				// If we get here it must be using a whitelist or blacklist.
				if (floor_smooth == FLOORING_SMOOTH_WHITELIST)
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							// Found a match on the list.
							is_linked = TRUE
							break
				else if(floor_smooth == FLOORING_SMOOTH_BLACKLIST)
					is_linked = TRUE // Default to true for the blacklist, then make it false if a match comes up.
					for (var/v in flooring_whitelist)
						if (istype(t.flooring, v))
							// Found a match on the list.
							is_linked = FALSE
							break

	/**
	 * Alright now we have a preliminary answer about smoothing, however that answer may change with the following...
	 * Atom lists!
	 */
	var/best_priority = -1
	/**
	 * A white or blacklist entry will only override smoothing if its priority is higher than this.
	 * Then this value becomes its priority.
	 */
	if(smooth_movable_atom != FLOORING_SMOOTH_NONE)
		if(smooth_movable_atom == FLOORING_SMOOTH_WHITELIST || smooth_movable_atom == FLOORING_SMOOTH_GREYLIST)
			for(var/list/v in movable_atom_whitelist)
				var/d_type = v[1]
				var/list/d_vars = v[2]
				var/d_priority = v[3]
				// Priority is the quickest thing to check first.
				if(d_priority <= best_priority)
					continue

				// Ok, now we start testing all the atoms in the target turf.
				for(var/a in T) // No implicit typecasting here, faster.
					if(istype(a, d_type))
						// It's the right type, so we're sure it will have the vars we want.

						var/atom/movable/AM = a
						/**
						 * Typecast it to a movable atom.
						 * Lets make sure its in the way before we consider it.
						 */
						if(!AM.is_between_turfs(origin, T))
							continue

						//! From here on out, we do dangerous stuff that may runtime if the coder screwed up.


						var/match = TRUE
						for (var/d_var in d_vars)
							// For each variable we want to check.
							if (AM.vars[d_var] != d_vars[d_var])
								/**
								 * We get a var of the same name from the atom's vars list.
								 * And check if it equals our desired value.
								 */
								match = FALSE
								break // If any var doesn't match the desired value, then this atom is not a match, move on.


						if(match)
							// If we've successfully found an atom which matches a list entry.
							best_priority = d_priority // This one is king until a higher priority overrides it.

							// And this is a whitelist, so this match forces is_linked to TRUE.
							is_linked = TRUE


		if (smooth_movable_atom == FLOORING_SMOOTH_BLACKLIST || smooth_movable_atom == FLOORING_SMOOTH_GREYLIST)
			// All of this blacklist code is copypasted from above, with only minor name changes.
			for (var/list/v in movable_atom_blacklist)
				var/d_type = v[1]
				var/list/d_vars = v[2]
				var/d_priority = v[3]
				// Priority is the quickest thing to check first.
				if (d_priority <= best_priority)
					continue

				// Ok, now we start testing all the atoms in the target turf.
				for (var/a in T) // No implicit typecasting here, faster.

					if (istype(a, d_type))
						// It's the right type, so we're sure it will have the vars we want.

						var/atom/movable/AM = a
						/**
						 * Typecast it to a movable atom.
						 * Lets make sure its in the way before we consider it.
						 */
						if (!AM.is_between_turfs(origin, T))
							continue

						//! From here on out, we do dangerous stuff that may runtime if the coder screwed up. Again.

						var/match = TRUE
						for (var/d_var in d_vars)
							// For each variable we want to check.
							if (AM.vars[d_var] != d_vars[d_var])
								/**
								 * We get a var of the same name from the atom's vars list.
								 * And check if it equals our desired value.
								 */
								match = FALSE
								break // If any var doesn't match the desired value, then this atom is not a match, move on.


						if (match)
							// f we've successfully found an atom which matches a list entry.
							best_priority = d_priority // This one is king until a higher priority overrides it.

							// And this is a blacklist, so this match forces is_linked to FALSE.
							is_linked = FALSE

	return is_linked

/decl/flooring/grass
	name = "grass"
	desc = "A patch of grass."
	icon = 'icons/turf/flooring/grass.dmi'
	base_icon_state = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

/decl/flooring/smoothgrass
	name = "grass"
	desc = "A patch of grass."
	icon = 'icons/turf/floors/grass.dmi'
	icon_state = "grass-255"
	base_icon_state = "grass"
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass

	layer = HIGH_TURF_LAYER
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_GRASS, SMOOTH_GROUP_CLOSED_TURFS)
	turf_translations = -9


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
		'sound/effects/footstep/snow5.ogg',
	))
	flags = TURF_HAS_EDGES

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
		'sound/effects/footstep/snow5.ogg',
	))
	flags = TURF_HAS_EDGES

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


/decl/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles_vr.dmi' // More ERIS Sprites... For now...
	base_icon_state = "tiled"
	has_damage_range = 2
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg',
	))

/decl/flooring/tiling/tech
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/techfloor_vr.dmi'
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
	icon = 'icons/turf/flooring/plating_vr.dmi'
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
