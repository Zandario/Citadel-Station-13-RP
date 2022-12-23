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
/singleton/flooring
	abstract_type = /singleton/flooring

	//! ## General
	var/name = "floor"
	var/descriptor = "tiles"
	var/desc

	//! ## Icon
	var/icon
	var/base_icon_state

	//! ## Ranges
	var/has_base_range
	var/has_damage_range
	var/has_burn_range

	//! ## Damage
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	//! ## Layers
	var/flooring_layer = BUILTIN_DECAL_LAYER

	//! ## Pixel Offsets
	/// Optimization Variable to skip Offset logic.
	var/has_pixel_offsets = FALSE
	/// Default pixel x shifting for the flooring's icon.
	var/base_pixel_x
	/// Default pixel y shifting for the flooring's icon.
	var/base_pixel_y

	//! ## Icon Smoothing
	/// Icon-smoothing behavior.
	var/smoothing_flags = NONE
	/**
	 * What smoothing groups does this atom belongs to, to match can_smooth_with.
	 * If null, nobody can smooth with it.
	 *! Must be sorted.
	 */
	var/list/smoothing_groups = null
	/**
	 * List of smoothing groups this atom can smooth with.
	 * If this is null and atom is smooth, it smooths only with itself.
	 *! Must be sorted.
	 */
	var/list/can_smooth_with = null

	//! ## Building
	/// Unbuildable if not set. Must be /obj/item/stack.
	var/build_type
	/// Stack units.
	var/build_cost = 1
	/// BYOND ticks.
	var/build_time = 0

	//! ## Misc
	var/flooring_flags
	var/can_paint = TRUE
	/// key=species name, value = list of sounds
	var/list/footstep_sounds = list() // TODO: Standardize footsteps. @Zandario
	var/is_plating = FALSE

	/// Plating types, can be overridden.
	var/plating_type = /singleton/flooring/plating

	/// Resistance is subtracted from all incoming damage.
	// var/resistance = RESISTANCE_FRAGILE

	/// Damage the floor can take before being destroyed.
	// var/health = 50

	// var/removal_time = WORKTIME_FAST * 0.75

/singleton/flooring/Initialize(mapload, ...)
	. = ..()

	// This is required so smoothing lists are properly setup.
	SETUP_SMOOTHING()
	stack_trace("Flooring [type] was used!")

/singleton/flooring/New()
	. = ..()
	stack_trace("Flooring [type] was used!")


/singleton/flooring/proc/get_plating_type(turf/target_turf)
	return plating_type


/singleton/flooring/proc/drop_product(atom/A)
	if(ispath(build_type, /obj/item/stack))
		new build_type(A, build_cost)
	else
		for(var/i in 1 to min(build_cost, 50))
			new build_type(A)
