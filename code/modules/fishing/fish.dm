// Fish path used for autogenerated fish
obj/item/fish
	name = "generic looking aquarium fish"
	desc = "very bland"
	icon = 'icons/modules/fishing/fish.dmi'
	icon_state = "bugfish"

	w_class = WEIGHT_CLASS_TINY

	//? stats

	/// Size in centimeters
	var/size = 50
	/// Average size for this fish type in centimeters. Will be used as gaussian distribution with 20% deviation for fishing, bought fish are always standard size
	var/average_size = 50
	/// Weight in grams
	var/weight = 1000
	/// Average weight for this fish type in grams
	var/average_weight = 1000

	//? icon

	/// Resulting width of aquarium visual icon - default size of "fish_greyscale" state
	var/sprite_width = 3
	/// Resulting height of aquarium visual icon - default size of "fish_greyscale" state
	var/sprite_height = 3
	/// Original width of aquarium visual icon - used to calculate scaledown factor
	var/source_width = 32
	/// Original height of aquarium visual icon - used to calculate scaledown factor
	var/source_height = 32
	/// If present this icon will be used for in-aquarium visual for the fish instead of icon_state
	var/dedicated_in_aquarium_icon_state
	/// If present aquarium visual will be this color
	var/aquarium_vc_color

	//? aquarium

	/// Required fluid type for this fish to live.
	var/required_fluid_type = AQUARIUM_FLUID_FRESHWATER
	/// Required minimum temperature for the fish to live.
	var/required_temperature_min = MIN_AQUARIUM_TEMP
	/// Maximum possible temperature for the fish to live.
	var/required_temperature_max = MAX_AQUARIUM_TEMP
	/// What type of reagent this fish needs to be fed.
	var/food = /datum/reagent/nutriment
	// todo: make this constant over time due to this being a rp server where people don't want to click every x minutes
	/// How often the fish needs to be fed 1 unit of its food
	var/feeding_frequency = 90 MINUTES
	/// last consumption of food
	var/last_feeding

	//? health

	/// Fish status define
	var/status = FISH_ALIVE
	/// Current fish health. Dies at 0.
	health = 100
	/// flopping?
	var/flopping = FALSE
	/// stasis (won't die)?
	var/in_stasis = FALSE

	//? reproduction

	/// Won't breed more than this amount in single aquarium.
	var/stable_population = 1
	/// Last time new fish was created
	var/last_breeding
	/// How long it takes to produce new fish
	var/breeding_timeout = 2 MINUTES

	//? fishing minigame

	/// List of fishing trait types, these modify probabilty/difficulty depending on rod/user properties
	var/list/fishing_traits = list()
	/// Fishing minigame AI behavior
	var/fish_ai_type = FISH_AI_DUMB
	/// Base additive modifier to fishing difficulty
	var/fishing_difficulty_modifier = 0
	/**
	 * Bait identifiers that make catching this fish easier and more likely
	 * Bait identifiers: Path | Trait | list(FISH_BAIT_SPECIAL_TYPE=FISH_BAIT_SPECIAL_TYPE_FOOD,FISH_BAIT_SPECIAL_VALUE= Food Type Flag like [MEAT])
	 */
	var/list/favorite_bait = list()
	/**
	 * Bait identifiers that make catching this fish harder and less likely
	 * Bait identifiers: Path | Trait | list(FISH_BAIT_SPECIAL_TYPE=FISH_BAIT_SPECIAL_TYPE_FOOD,FISH_BAIT_SPECIAL_VALUE= Food Type Flag like [MEAT])
	 */
	var/list/disliked_bait = list()

	//? rarity

	/// Should this fish type show in fish catalog
	var/show_in_catalog = TRUE
	/// Should this fish spawn in random fish cases
	var/available_in_random_cases = TRUE
	/// How rare this fish is in the random cases
	var/random_case_rarity = FISH_RARITY_BASIC

	//? products

	/// Fish autogenerated from this behaviour will be processable into this
	var/fillet_type = /obj/item/reagent_containers/food/snacks/carpmeat/fish
	/// amount to drop
	var/fillet_amount = 1

obj/item/fish/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/aquarium_content, PROC_REF(get_aquarium_animation), list(COMSIG_FISH_STATUS_CHANGED,COMSIG_FISH_STIRRED))
	RegisterSignal(src, COMSIG_ATOM_TEMPORARY_ANIMATION_START, PROC_REF(on_temp_animation))

	check_environment_after_movement()
	if(status != FISH_DEAD)
		START_PROCESSING(SSobj, src)

	size = average_size
	weight = average_weight

obj/item/fish/examine(mob/user)
	. = ..()
	// All spacemen have magic eyes of fish weight perception until fish scale (get it?) is implemented.
	. += SPAN_NOTICE("It's [size] cm long.")
	. += SPAN_NOTICE("It weighs [weight] g.")

obj/item/fish/proc/randomize_weight_and_size(modifier = 0)
	var/size_deviation = 0.2 * average_size
	var/size_mod = modifier * average_size
	size = max(1,gaussian(average_size + size_mod, size_deviation))

	var/weight_deviation = 0.2 * average_weight
	var/weight_mod = modifier * average_weight
	weight = max(1,gaussian(average_weight + weight_mod, weight_deviation))

obj/item/fish/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	check_environment_after_movement()

obj/item/fish/proc/enter_stasis()
	in_stasis = TRUE
	// Stop processing until inserted into aquarium again.
	stop_flopping()
	STOP_PROCESSING(SSobj, src)

obj/item/fish/proc/exit_stasis()
	in_stasis = FALSE
	if(status != FISH_DEAD)
		START_PROCESSING(SSobj, src)

obj/item/fish/proc/on_aquarium_insertion(obj/structure/aquarium)
	if(isnull(last_feeding)) //Fish start fed.
		last_feeding = world.time
	RegisterSignal(aquarium, COMSIG_ATOM_EXITED, PROC_REF(aquarium_exited))
	RegisterSignal(aquarium, COMSIG_AQUARIUM_DISTURB_FISH, PROC_REF(disturb_reaction))

obj/item/fish/proc/aquarium_exited(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER
	if(src != gone)
		return
	UnregisterSignal(source,list(COMSIG_ATOM_EXITED, COMSIG_AQUARIUM_DISTURB_FISH))

/// Our aquarium is hit with stuff
obj/item/fish/proc/disturb_reaction(datum/source)
	SIGNAL_HANDLER
	//stirred effect
	SEND_SIGNAL(src, COMSIG_FISH_STIRRED)

obj/item/fish/proc/is_food(obj/item/thing)
	return istype(thing, /obj/item/fish_feed)

obj/item/fish/proc/on_feeding(datum/reagents/feed_reagents)
	if(isnull(feed_reagents))
		return
	if(feed_reagents.has_reagent(food))
		last_feeding = world.time

/**
 * Checks if a location will put us in stasis.
 */
obj/item/fish/proc/is_stasis_inside(atom/what)
	return isnull(what) || istype(what, /obj/item/storage/fish_case) || HAS_TRAIT(what, TRAIT_FISH_SAFE_STORAGE)

/**
 * checks if we should naturally submerge and disappear in a location
 */
obj/item/fish/proc/is_deleted_inside(atom/what)
	return istype(what, /turf/simulated/floor/water)

obj/item/fish/proc/check_environment_after_movement()
	if(QDELETED(src)) //we don't care anymore
		return

	if(is_deleted_inside(loc))
		visible_message(
			status == FISH_ALIVE? SPAN_NOTICE("[src] quickly swims back into [loc]!") : SPAN_WARNING("[src] sadly floats for a moment on [loc], before sinking to the bottom. Poor thing."),
		)
		qdel(src)
		return

	// Apply/remove stasis as needed
	if(loc && is_stasis_inside(loc))
		enter_stasis()
	else if(in_stasis)
		exit_stasis()

	// Do additional stuff
	var/in_aquarium = istype(loc,/obj/structure/aquarium)
	if(in_aquarium)
		on_aquarium_insertion(loc)

	// Start flopping if outside of fish container
	var/should_be_flopping = status == FISH_ALIVE && loc && !HAS_TRAIT(loc,TRAIT_FISH_SAFE_STORAGE) && !in_aquarium

	if(should_be_flopping)
		start_flopping()
	else
		stop_flopping()

obj/item/fish/process(seconds_per_tick)
	if(in_stasis || status != FISH_ALIVE)
		return

	process_health(seconds_per_tick)
	if(ready_to_reproduce())
		try_to_reproduce()

obj/item/fish/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(I.sharp)
		user.action_feedback(SPAN_NOTICE("You start cutting [src] into fillets..."), src)
		if(!do_after(user, 2 SECONDS, src))
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		var/atom/dropping_where = drop_location()
		for(var/i in 1 to min(50, fillet_amount))
			new fillet_type(dropping_where)
		qdel(src)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

obj/item/fish/proc/set_status(new_status)
	switch(new_status)
		if(FISH_ALIVE)
			status = FISH_ALIVE
			health = initial(health) // this is admin option anyway
			START_PROCESSING(SSobj, src)
		if(FISH_DEAD)
			status = FISH_DEAD
			STOP_PROCESSING(SSobj, src)
			stop_flopping()
			var/message = SPAN_NOTICE("\The [name] dies.")
			if(istype(loc,/obj/structure/aquarium))
				loc.visible_message(message)
			else
				visible_message(message)
	SEND_SIGNAL(src, COMSIG_FISH_STATUS_CHANGED)

obj/item/fish/proc/get_aquarium_animation()
	var/obj/structure/aquarium/aquarium = loc
	if(!istype(aquarium) || aquarium.fluid_type == AQUARIUM_FLUID_AIR || status == FISH_DEAD)
		return AQUARIUM_ANIMATION_FISH_DEAD
	else
		return AQUARIUM_ANIMATION_FISH_SWIM

/// Checks if our current environment lets us live.
obj/item/fish/proc/proper_environment()
	var/obj/structure/aquarium/aquarium = loc
	if(!istype(aquarium))
		return FALSE

	if(required_fluid_type != AQUARIUM_FLUID_ANADROMOUS)
		if(aquarium.fluid_type != required_fluid_type)
			return FALSE
	else
		if(aquarium.fluid_type != AQUARIUM_FLUID_SALTWATER && aquarium.fluid_type != AQUARIUM_FLUID_FRESHWATER)
			return FALSE
	if(aquarium.fluid_temp < required_temperature_min || aquarium.fluid_temp > required_temperature_max)
		return FALSE
	return TRUE

obj/item/fish/proc/process_health(seconds_per_tick)
	var/health_change_per_second = 0
	if(!proper_environment())
		health_change_per_second -= 3 //Dying here
	if(world.time - last_feeding >= feeding_frequency)
		health_change_per_second -= 0.5 //Starving
	else
		health_change_per_second += 0.5 //Slowly healing
	adjust_health(health + health_change_per_second * seconds_per_tick)

obj/item/fish/proc/adjust_health(amt)
	health = clamp(amt, 0, initial(health))
	if(health <= 0)
		set_status(FISH_DEAD)


obj/item/fish/proc/ready_to_reproduce()
	var/obj/structure/aquarium/aquarium = loc
	if(!istype(aquarium))
		return FALSE
	return aquarium.allow_breeding && health == initial(health) && stable_population > 1 && world.time - last_breeding >= breeding_timeout

//Fish breeding stops if fish count exceeds this.
#define AQUARIUM_MAX_BREEDING_POPULATION 20
obj/item/fish/proc/try_to_reproduce()
	var/obj/structure/aquarium/aquarium = loc
	if(!istype(aquarium))
		return
	if(length(aquarium.tracked_fish) >= AQUARIUM_MAX_BREEDING_POPULATION) //so aquariums full of fish don't need to do these expensive checks
		return
	var/list/other_fish_of_same_type = list()
	for(var/obj/item/fish/fish_in_aquarium in aquarium)
		if(fish_in_aquarium == src || fish_in_aquarium.type != type)
			continue
		other_fish_of_same_type += fish_in_aquarium
	if(length(other_fish_of_same_type) >= stable_population)
		return
	var/obj/item/fish/second_fish
	for(var/obj/item/fish/other_fish in other_fish_of_same_type)
		if(other_fish.ready_to_reproduce())
			second_fish = other_fish
			break
	if(second_fish)
		new type(loc) //could use child_type var
		last_breeding = world.time
		second_fish.last_breeding = world.time
#undef AQUARIUM_MAX_BREEDING_POPULATION

#define PAUSE_BETWEEN_PHASES 15
#define PAUSE_BETWEEN_FLOPS 2
#define FLOP_COUNT 2
#define FLOP_DEGREE 20
#define FLOP_SINGLE_MOVE_TIME 1.5
#define JUMP_X_DISTANCE 5
#define JUMP_Y_DISTANCE 6
/// This animation should be applied to actual parent atom instead of vc_object.
proc/flop_animation(atom/movable/animation_target)
	var/pause_between = PAUSE_BETWEEN_PHASES + rand(1, 5) //randomized a bit so fish are not in sync
	animate(animation_target, time = pause_between, loop = -1)
	//move nose down and up
	for(var/_ in 1 to FLOP_COUNT)
		var/matrix/up_matrix = matrix()
		up_matrix.Turn(FLOP_DEGREE)
		var/matrix/down_matrix = matrix()
		down_matrix.Turn(-FLOP_DEGREE)
		animate(transform = down_matrix, time = FLOP_SINGLE_MOVE_TIME, loop = -1)
		animate(transform = up_matrix, time = FLOP_SINGLE_MOVE_TIME, loop = -1)
		animate(transform = matrix(), time = FLOP_SINGLE_MOVE_TIME, loop = -1, easing = BOUNCE_EASING | EASE_IN)
		animate(time = PAUSE_BETWEEN_FLOPS, loop = -1)
	//bounce up and down
	animate(time = pause_between, loop = -1, flags = ANIMATION_PARALLEL)
	var/jumping_right = FALSE
	var/up_time = 3 * FLOP_SINGLE_MOVE_TIME / 2
	for(var/_ in 1 to FLOP_COUNT)
		jumping_right = !jumping_right
		var/x_step = jumping_right ? JUMP_X_DISTANCE/2 : -JUMP_X_DISTANCE/2
		animate(time = up_time, pixel_y = JUMP_Y_DISTANCE , pixel_x=x_step, loop = -1, flags= ANIMATION_RELATIVE, easing = BOUNCE_EASING | EASE_IN)
		animate(time = up_time, pixel_y = -JUMP_Y_DISTANCE, pixel_x=x_step, loop = -1, flags= ANIMATION_RELATIVE, easing = BOUNCE_EASING | EASE_OUT)
		animate(time = PAUSE_BETWEEN_FLOPS, loop = -1)
#undef PAUSE_BETWEEN_PHASES
#undef PAUSE_BETWEEN_FLOPS
#undef FLOP_COUNT
#undef FLOP_DEGREE
#undef FLOP_SINGLE_MOVE_TIME
#undef JUMP_X_DISTANCE
#undef JUMP_Y_DISTANCE

/// Starts flopping animation
obj/item/fish/proc/start_flopping()
	if(!flopping) //Requires update_transform/animate_wrappers to be less restrictive.
		flopping = TRUE
		flop_animation(src)

/// Stops flopping animation
obj/item/fish/proc/stop_flopping()
	if(flopping)
		flopping = FALSE
		animate(src, transform = matrix()) //stop animation

/// Refreshes flopping animation after temporary animation finishes
obj/item/fish/proc/on_temp_animation(datum/source, animation_duration)
	if(animation_duration > 0)
		addtimer(CALLBACK(src, PROC_REF(refresh_flopping)), animation_duration)

obj/item/fish/proc/refresh_flopping()
	if(flopping)
		flop_animation(src)

/// Returns random fish, using random_case_rarity probabilities.
proc/random_fish_type(case_fish_only=TRUE, required_fluid)
	var/static/probability_table
	var/argkey = "fish_[required_fluid]_[case_fish_only]" //If this expands more extract bespoke element arg generation to some common helper.
	if(!probability_table || !probability_table[argkey])
		if(!probability_table)
			probability_table = list()
		var/chance_table = list()
		for(var/_fish_type in subtypesof(/obj/item/fish))
			var/obj/item/fish/fish = _fish_type
			if(required_fluid && initial(fish.required_fluid_type) != required_fluid)
				continue
			if(initial(fish.available_in_random_cases) || !case_fish_only)
				chance_table[fish] = initial(fish.random_case_rarity)
		probability_table[argkey] = chance_table
	return pickweight(probability_table[argkey])
