#define FLUID_EVAPORATION_POINT 3      // Depth a fluid begins self-deleting
#define FLUID_DELETING -1              // Depth a fluid counts as qdel'd
#define FLUID_SHALLOW 200              // Depth shallow icon is used
#define FLUID_OVER_MOB_HEAD 300        //
#define FLUID_DEEP 800                 // Depth deep icon is used
#define FLUID_MAX_DEPTH FLUID_DEEP * 4 // Arbitrary max value for flooding.
#define FLUID_PUSH_THRESHOLD 20        // Amount of water flow needed to push items.

// Expects /turf for target_turf.
#define ADD_ACTIVE_FLUID_SOURCE(target_turf)    SSfluids.water_sources[target_turf] = TRUE
#define REMOVE_ACTIVE_FLUID_SOURCE(target_turf) SSfluids.water_sources -= target_turf

// Expects /obj/effect/fluid for target_fluid.
#define ADD_ACTIVE_FLUID(target_fluid)           SSfluids.active_fluids[target_fluid] = TRUE
#define REMOVE_ACTIVE_FLUID(target_fluid)        SSfluids.active_fluids -= target_fluid

// Expects /obj/effect/fluid for target_fluid, int for amt.
#define LOSE_FLUID(target_fluid, amt) \
	target_fluid:fluid_amount = max(-1, target_fluid:fluid_amount - amt); \
	ADD_ACTIVE_FLUID(target_fluid)
#define SET_FLUID_DEPTH(target_fluid, amt) \
	target_fluid:fluid_amount = min(FLUID_MAX_DEPTH, amt); \
	ADD_ACTIVE_FLUID(target_fluid)

// Expects turf for target_turf,
#define UPDATE_FLUID_BLOCKED_DIRS(target_turf) \
	if(isnull(target_turf:fluid_blocked_dirs)) {\
		target_turf:fluid_blocked_dirs = 0; \
		for(var/obj/structure/window/W in target_turf) { \
			if(W.density) target_turf:fluid_blocked_dirs |= W.dir; \
		} \
		for(var/obj/machinery/door/window/D in target_turf) {\
			if(D.density) target_turf:fluid_blocked_dirs |= D.dir; \
		} \
	}

// Expects turf for target_turf, bool for dry_run.
#define FLOOD_TURF_NEIGHBORS(target_turf, dry_run) \
	for(var/spread_dir in GLOB.cardinal) {\
		UPDATE_FLUID_BLOCKED_DIRS(target_turf); \
		if(target_turf:fluid_blocked_dirs & spread_dir) \
			continue; \
		var/turf/next = get_step(target_turf, spread_dir); \
		if(!istype(next) || next.flooded) \
			continue; \
		UPDATE_FLUID_BLOCKED_DIRS(next); \
		if((next.fluid_blocked_dirs & GLOB.reverse_dir[spread_dir]) || !next.can_fluid_pass(spread_dir)) \
			continue; \
		flooded_a_neighbor = TRUE; \
		var/obj/effect/fluid/target_fluid = locate() in next; \
		if(!target_fluid && !dry_run) {\
			target_fluid = new /obj/effect/fluid(next); \
			var/datum/gas_mixture/GM = target_turf:return_air(); \
			if(GM) \
				target_fluid.temperature = GM.temperature; \
		} \
		if(target_fluid) { \
			if(target_fluid.fluid_amount >= FLUID_MAX_DEPTH) \
				continue; \
			if(!dry_run) \
				SET_FLUID_DEPTH(target_fluid, FLUID_MAX_DEPTH); \
		} \
	} \
	if(!flooded_a_neighbor) \
		REMOVE_ACTIVE_FLUID_SOURCE(target_turf);

// We share overlays for all fluid turfs to sync icon animation.
#define APPLY_FLUID_OVERLAY(img_state) \
	if(!SSfluids.fluid_images[img_state]) SSfluids.fluid_images[img_state] = image('icons/effects/fluids/liquids.dmi',img_state); \
	overlays += SSfluids.fluid_images[img_state];

#define FLUID_MAX_ALPHA 160
#define FLUID_MIN_ALPHA 45
