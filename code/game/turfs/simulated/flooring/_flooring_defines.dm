/**
 * State values:
 * [icon_base]: initial base icon_state without edges or corners.
 * if has_base_range is set, append 0-has_base_range ie.
 *   [icon_base][has_base_range]
 * [icon_base]_broken: damaged overlay.
 * if has_damage_range is set, append 0-damage_range for state ie.
 *   [icon_base]_broken[has_damage_range]
 * [icon_base]_edges: directional overlays for edges.
 * [icon_base]_corners: directional overlays for non-edge corners.
 */
/singleton/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/icon_base

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
	var/can_paint = TRUE
	/// key=species name, value = list of sounds
	var/list/footstep_sounds = list() // TODO: Standardize footsteps. @Zandario
	var/is_plating = FALSE
	/// Cached overlays for our edges and corners and junk.
	var/list/flooring_cache = list()

	/// Plating types, can be overridden.
	var/plating_type = null

	/// Resistance is subtracted from all incoming damage.
	// var/resistance = RESISTANCE_FRAGILE

	/// Damage the floor can take before being destroyed.
	// var/health = 50

	// var/removal_time = WORKTIME_FAST * 0.75

	//!Flooring Icon vars
	/**
	 * If true, all smoothing logic is entirely skipped
	 * True/false only, optimisation
	 */
	var/smooth_nothing = FALSE

	/**
	 *? The rest of these x_smooth vars use one of the following options:
	 *  - SMOOTH_NONE:      Ignore all of type
	 *  - SMOOTH_ALL:       Smooth with all of type
	 *  - SMOOTH_WHITELIST: Ignore all except types on this list
	 *  - SMOOTH_BLACKLIST: Smooth with all except types on this list
	 *  - SMOOTH_GREYLIST:  Objects only: Use both lists
	 */

	/// How we smooth with other flooring.
	var/floor_smooth = SMOOTH_NONE
	/// Smooth with nothing except the contents of this list.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the contents of this list.
	var/list/flooring_blacklist = list()

	/// How we smooth with walls.
	var/wall_smooth = SMOOTH_NONE
	/// There are no lists for walls at this time.

	/// How we smooth with space and openspace tiles.
	var/space_smooth = SMOOTH_NONE
	/// There are no lists for spaces.

	/**
	 * How we smooth with movable atoms
	 * These are checked after the above turf based smoothing has been handled
	 * SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	 * Using the white/blacklists will override what the turfs concluded, to force or deny smoothing
	 *
	 * Movable atom lists are much more complex, to account for many possibilities
	 * Each entry in a list, is itself a list consisting of three items:
	 *? Type:
	 *  - The typepath to allow/deny. This will be checked against istype, so all subtypes are included.
	 *
	 *? Priority:
	 *  - Used when items in two opposite lists conflict. The one with the highest priority wins out.
	 *
	 *? Vars:
	 *  - An associative list of variables (varnames in text) and desired values.
	 *  - Code will look for the desired vars on the target item and only call it a match if all desired values match.
	 *  - This can be used, for example, to check that objects are dense and anchored.
	 *  - There are no safety checks on this, it will probably throw runtimes if you make typos.
	 *
	 * Common example:
	 * Don't smooth with dense anchored objects except airlocks
	 *
	 *  ```dm
	 *  smooth_movable_atom = SMOOTH_GREYLIST
	 *  movable_atom_blacklist = list(
	 *  	list(/obj, list("density" = TRUE, "anchored" = TRUE), 1),
	 *  )
	 *  movable_atom_whitelist = list(
	 *  	list(/obj/machinery/door/airlock, list(), 2),
	 *  )
	 *  ```
	 *
	 */
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()


/singleton/flooring/proc/get_plating_type(turf/target_turf)
	return plating_type


/singleton/flooring/proc/get_flooring_overlay(cache_key, icon_base, icon_dir = 0, layer = BUILTIN_DECAL_LAYER)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]


/singleton/flooring/proc/drop_product(atom/A)
	if(ispath(build_type, /obj/item/stack))
		new build_type(A, build_cost)
	else
		for(var/i in 1 to min(build_cost, 50))
			new build_type(A)
