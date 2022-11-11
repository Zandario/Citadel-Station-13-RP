

/**
 * A group of fluid objects.
 */
/datum/fluid_group
	/**
	 * Member that we want to spread from.
	 * Should be changed on add amt, displace, etc.
	 */
	var/obj/fluid/spread_node
	/// The set of fluid objects currently in this group.
	var/list/nodes
	/// The number of fluid object that this group wants to have contained.
	var/target_size
	/// The total number of fluid objects that have ever been in this group.
	var/total_size = 0

	var/base_evaporation_time = 1500
	var/bonus_evaporation_time = 9000 //Ranges from 0 to this value depending on average viscosity
	var/const/max_viscosity = 20

	var/const/max_alpha = 230

	var/datum/reagents/fluid_group/reagents = null
	/// The total reagent volume including all nodes.
	var/contained_volume = 0
	/// Don't pull from this value for group calculations without updating it first.
	var/volume_per_tile = 0
	var/required_to_spread = 30

	/**
	 * Already updating?
	 * Block another loop from being started.
	 */
	var/updating = 0

	//! Times
	var/last_add_time = 0
	var/last_temp_change = 0
	var/last_spread_node = 0
	var/last_contained_volume = -1
	var/last_node_volume = 0
	var/last_depth_level = 0
	var/avg_viscosity = 1
	var/last_update_time = 0
	var/obj/fluid/last_reacted = 0

/datum/fluid_group/New(target_size = 0)
	. = ..()
	src.nodes = list()
	src.target_size = target_size

	src.last_add_time = world.time

	reagents = new /datum/reagents/fluid_group(90000000) //high number lol.
	reagents.my_group = src


/datum/fluid_group/Destroy(force)
	QDEL_LAZYLIST(nodes)
	return ..()

/**
 * Adds a fluid node to this fluid group.
 *
 * Is a noop if the node is already in the group.
 * Removes the node from any other fluid groups it is in.
 * Syncs the group of the node with the group it is being added to (this one).
 * Increments the total size of the fluid group.
 *
 * Arguments:
 * - [node][/obj/fluid]: The fluid node that is going to be added to this group.
 *
 * Returns:
 * - [TRUE]: If the node to be added is in this group by the end of the proc.
 * - [FALSE]: Otherwise.
 */
/datum/fluid_group/proc/add_node(obj/fluid/node)
	if(!istype(node))
		CRASH("Attempted to add non-fluid node [isnull(node) ? "NULL" : node] to a fluid group.")
	if(QDELING(node))
		CRASH("Attempted to add qdeling node to a fluid group")

	if(node.group)
		if(node.group == src)
			return TRUE
		if(!node.group.remove_node(node))
			return FALSE

	nodes += node
	node.group = src
	total_size++
	return TRUE


/**
 * Removes a fluid node from this fluid group.
 *
 * Is a noop if the node is not in this group.
 * Nulls the nodes fluid group ref to sync it with its new state.c
 * DOES NOT decrement the total size of the fluid group.
 *
 * Arguments:
 * - [node][/obj/fluid]: The fluid node that is going to be removed from this group.
 *
 * Returns:
 * - [TRUE]: If the node to be removed is not in the group by the end of the proc.
 */
/datum/fluid_group/proc/remove_node(obj/fluid/node)
	if(node.group != src)
		return TRUE

	nodes -= node
	node.group = null
	return TRUE // Note: does not decrement total size since we don't want the group to expand again when it begins to dissipate or it will never stop.

/datum/fluid_group/proc/update_volume_per_tile()
	contained_volume = src.reagents.total_volume
	volume_per_tile = length(nodes) ? contained_volume / length(nodes) : 0


/datum/fluid_group/proc/evaporate()
	if (last_add_time == 0) //this should nOT HAPPEN
		last_add_time = world.time
		return

	for (var/obj/fluid/F as anything in src.nodes)
		if (!F)
			continue
		if (F.gc_destroyed)
			continue
		src.remove(F,0,1,1)

	if(!gc_destroyed)
		Destroy()

/datum/fluid_group/proc/add(var/obj/fluid/F, var/gained_fluid = 0, var/do_update = 1, var/guarantee_is_member = 0)
	if (!F || gc_destroyed || !nodes)
		return

	if (gained_fluid)
		spread_node = F

	//if (!length(src.nodes)) //very first member! do special stuff	we should def. have defined before anything else can happen
	//	contained_amt = src.reagents.total_volume
	//	amt_per_tile = contained_amt

	if (!guarantee_is_member)
		if (!length(src.nodes) || !(F in nodes))
			nodes += F
			F.group = src

	if (length(src.nodes) == 1)
		F.update_icon() //update icon of the very first fluid in this group

	src.last_add_time = world.time

	if (!do_update) return

	src.update_loop()

	// recalculate depth level based on fluid amount
	// to account for change to fluid until fluid_core
	// can perform spread
	update_volume_per_tile()
	var/my_depth_level = 0
	for(var/x in depth_levels)
		if (src.volume_per_tile > x)
			my_depth_level++
		else
			break

	if (F.last_depth_level != my_depth_level)
		F.last_depth_level = my_depth_level

//fluid has been removed from its tile. use 'lightweight' in evaporation procedure cause we dont need icon updates / try split / update loop checks at that point
// if 'lightweight' parameter is 2, invoke an update loop but still ignore icon updates
/datum/fluid_group/proc/remove(var/obj/fluid/F, var/lost_fluid = 1, var/lightweight = 0, var/allow_zero = 0)
	if (!F || F.disposed || src.gc_destroyed)
		return 0
	if (!nodes || !length(src.nodes) || !(F in nodes))
		return 0

	if (!lightweight)
		var/turf/t
		for( var/dir in GLOB.cardinal )
			t = get_step( F, dir )
			if (t?.active_liquid)
				t.active_liquid.blocked_dirs = 0
				t.active_liquid.UpdateIcon(1)
	else
		var/turf/t
		for( var/dir in GLOB.cardinal )
			t = get_step( F, dir )
			if (t?.active_liquid)
				t.active_liquid.blocked_dirs = 0

	if(src.gc_destroyed || F.disposed)
		return 0 // UpdateIcon lagchecks, rip

	volume_per_tile = length(nodes) ? contained_volume / length(nodes) : 0
	nodes -= F //remove after amt per tile ok? otherwise bad thing could happen
	if (lost_fluid)
		src.reagents.skip_next_update = 1
		src.reagents.remove_any(volume_per_tile)
		src.contained_volume = src.reagents.total_volume

	F.group = null
	var/turf/removed_loc = F.loc
	if(removed_loc)
		F.turf_remove_cleanup(F.loc)

	qdel(F)

	if (!lightweight || lightweight == 2)
		if (!src.try_split(removed_loc))
			src.update_loop()

	if ((!nodes || length(src.nodes) == 0) && !allow_zero)
		qdel(src)

	return 1
