
var/global/waterflow_enabled = 1

var/list/depth_levels = list(2,50,100,200)

/turf/var/tmp/obj/fluid/active_liquid

var/mutable_appearance/fluid_ma

/obj/fluid
	name = "fluid"
	icon = 'icons/effects/fluids/fluid.dmi'
	icon_state = "fluid-0"
	base_icon_state = "fluid"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_FLUID)
	canSmoothWith = list(SMOOTH_GROUP_FLUID)

	opacity = TRUE
	plane = TURF_PLANE
	layer = FLY_LAYER
	anchored = TRUE
	animate_movement = FALSE

	/// How long the fluid sticks around before it dissipates.
	var/lifetime = 10 SECONDS
	/// Makes the fluid react to changes on/of its turf.
	var/static/loc_connections = list(
		COMSIG_TURF_CALCULATED_ADJACENT_ATMOS = .proc/react_to_atmos_adjacency_changes
	)


	//! SSfluids stuff.
	/// What SSfluids bucket this particle effect is currently in.
	var/tmp/effect_bucket
	/// The index of the fluid spread bucket this is being spread in.
	var/tmp/spread_bucket
	///	The fluid group that this particle effect belongs to.
	var/datum/fluid_group/group

	//! Everything else.

	var/const/max_slip_volume = 30
	var/const/max_slip_viscosity = 10

	var/const/max_reagent_volume = 300

	var/total_volume = 0 //amount of reagents contained - should be updated mainly by the group.

	var/const/max_viscosity = 20
	var/avg_viscosity = 1

	var/const/max_speed_mod = 3 //max. slowdown we can experience per slowdown type
	var/const/max_speed_mod_total = 5 //highest movement_speed_mod allowed
	var/movement_speed_mod = 0 //scales with viscosity + depth

	//Amt req to push an item as we spread
	var/const/push_tiny_req = 1
	var/const/push_small_req = 10
	var/const/push_med_req = 25
	var/const/push_large_req = 50

/obj/fluid/Initialize(mapload, datum/fluid_group/group, obj/fluid/source)
	. = ..()
	if(!group)
		group = source?.group || new
	group.add_node(src)
	source?.transfer_fingerprints_to(src)

	create_reagents(1000, REAGENT_HOLDER_INSTANT_REACT)
	setDir(pick(GLOB.cardinal))
	AddElement(/datum/element/connect_loc, loc_connections)
	SSfluids.start_processing(src)

/obj/fluid/Destroy()
	group.remove_node(src)
	SSfluids.stop_processing(src)
	if (spread_bucket)
		SSfluids.cancel_spread(src)
	return ..()

/obj/fluid/process(delta_time)
	lifetime -= delta_time SECONDS
	if(lifetime <= 0)
		kill_fluid()
		return FALSE
	for(var/mob/living/fluidr in loc) // In case fluid somehow winds up in a locker or something this should still behave sanely.
		fluid_mob(fluidr, delta_time)
	return TRUE

/obj/fluid/spread(delta_time = 0.1 SECONDS)
	if(group.total_size > group.target_size)
		return
	var/turf/t_loc = get_turf(src)
	if(!t_loc)
		return

	for(var/turf/spread_turf in get_adjacent_open_turfs(t_loc))
		if(group.total_size > group.target_size)
			break
		if(locate(type) in spread_turf)
			continue // Don't spread fluid where there's already fluid!
		for(var/mob/living/fluidr in spread_turf)
			fluid_mob(fluidr, delta_time)

		var/obj/fluid/spread_fluid = new type(spread_turf, group, src)
		reagents.copy_to(spread_fluid, reagents.total_volume)
		spread_fluid.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		spread_fluid.lifetime = lifetime

		// the fluid spreads rapidly, but not instantly
		SSfluids.queue_spread(spread_fluid)

/**
 * Attempts to spread this fluid node to wherever it can spread.
 *
 * Exact results vary by subtype implementation.
 */
/obj/fluid/proc/spread()
	CRASH("The base fluid spread proc is not implemented and should not be called. You called it.")

/**
 * Makes the fluid fade out and then deletes it.
 */
/obj/fluid/proc/kill_fluid()
	SSfluids.stop_processing(src)
	if (spread_bucket)
		SSfluids.cancel_spread(src)
	INVOKE_ASYNC(src, .proc/fade_out)
	QDEL_IN(src, 1 SECONDS)

/**
 * Animates the fluid gradually fading out of visibility.
 * Also makes the fluid turf transparent as it passes 160 alpha.
 *
 * Arguments:
 * - frames = 0.8 [SECONDS]: The amount of time the fluid should fade out over.
 */
/obj/fluid/proc/fade_out(frames = 0.8 SECONDS)
	if(alpha == 0) //Handle already transparent case
		if(opacity)
			set_opacity(FALSE)
		return

	if(frames == 0)
		set_opacity(FALSE)
		alpha = 0
		return

	var/time_to_transparency = round(((alpha - 160) / alpha) * frames)
	if(time_to_transparency >= 1)
		addtimer(CALLBACK(src, /atom.proc/set_opacity, FALSE), time_to_transparency)
	else
		set_opacity(FALSE)
	animate(src, time = frames, alpha = 0)

/**
 * Handles the effects of this fluid on any mobs it comes into contact with.
 *
 * Arguments:
 * - [fluidr][/mob/living/carbon]: The mob that is being exposed to this fluid.
 * - delta_time: A scaling factor for the effects this has. Primarily based off of tick rate to normalize effects to units of rate/sec.
 *
 * Returns whether the fluid effect was applied to the mob.
 */
/obj/fluid/proc/fluid_mob(mob/living/carbon/fluidr, delta_time)
	if(!istype(fluidr))
		return FALSE
	if(lifetime < 1)
		return FALSE
	if(fluidr.internal != null/* || fluidr.has_fluid_protection()*/)
		return FALSE

	return TRUE

/**
 * Makes the fluid react to nearby opening/closing airlocks and the like.
 * Makes it possible for fluid to spread through airlocks that open after the edge of the fluid cloud has already spread past them.
 *
 * Arguments:
 * - [source][/turf]: The turf that has been touched by an atmos adjacency change.
 */
/obj/fluid/proc/react_to_atmos_adjacency_changes(turf/source)
	SIGNAL_HANDLER
	if(!group)
		return NONE
	if (spread_bucket)
		return NONE
	SSfluids.queue_spread(src)
