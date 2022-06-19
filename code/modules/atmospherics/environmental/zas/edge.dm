/*

Overview:
	These are what handle gas transfers between zones and into space.
	They are found in a zone's edges list and in air_master.edges.
	Each edge updates every air tick due to their role in gas transfer.
	They come in two flavors, /datum/zas_edge/zone and /datum/zas_edge/unsimulated.
	As the type names might suggest, they handle inter-zone and spacelike connections respectively.

Class Vars:

	A - This always holds a zone. In unsimulated edges, it holds the only zone.

	connecting_turfs - This holds a list of connected turfs, mainly for the sake of airflow.

	coefficent - This is a marker for how many connections are on this edge. Used to determine the ratio of flow.

	datum/zas_edge/zone

		B - This holds the second zone with which the first zone equalizes.

		direct - This counts the number of direct (i.e. with no doors) connections on this edge.
		         Any value of this is sufficient to make the zones mergeable.

	datum/zas_edge/unsimulated

		B - This holds an unsimulated turf which has the gas values this edge is mimicing.

		air - Retrieved from B on creation and used as an argument for the legacy ShareSpace() proc.

Class Procs:

	add_connection(datum/zas_connection/c)
		Adds a connection to this edge. Usually increments the coefficient and adds a turf to connecting_turfs.

	remove_connection(datum/zas_connection/c)
		Removes a connection from this edge. This works even if c is not in the edge, so be careful.
		If the coefficient reaches zero as a result, the edge is erased.

	contains_zone(datum/zas_zone/Z)
		Returns true if either A or B is equal to Z. Unsimulated connections return true only on A.

	erase()
		Removes this connection from processing and zone edge lists.

	tick()
		Called every air tick on edges in the processing list. Equalizes gas.

	flow(list/movable, differential, repelled)
		Airflow proc causing all objects in movable to be checked against a pressure differential.
		If repelled is true, the objects move away from any turf in connecting_turfs, otherwise they approach.
		A check against vsc.lightest_airflow_pressure should generally be performed before calling this.

	get_connected_zone(datum/zas_zone/from)
		Helper proc that allows getting the other zone of an edge given one of them.
		Only on /datum/zas_edge/zone, otherwise use A.

*/


/datum/zas_edge
	var/datum/zas_zone/A
	var/list/connecting_turfs = list()
	var/direct = 0
	var/sleeping = 1
	var/coefficient = 0

/datum/zas_edge/New()
	CRASH("Cannot make connection edge without specifications.")

/datum/zas_edge/proc/add_connection(datum/zas_connection/c)
	coefficient++
	if(c.direct()) direct++
	//to_chat(world, "Connection added: [type] Coefficient: [coefficient]")

/datum/zas_edge/proc/remove_connection(datum/zas_connection/c)
	//to_chat(world, "Connection removed: [type] Coefficient: [coefficient-1]")
	coefficient--
	if(coefficient <= 0)
		erase()
	if(c.direct()) direct--

/datum/zas_edge/proc/contains_zone(datum/zas_zone/Z)

/datum/zas_edge/proc/erase()
	air_master.remove_edge(src)
	//to_chat(world, "[type] Erased.")

/datum/zas_edge/proc/tick()

/datum/zas_edge/proc/recheck()

/datum/zas_edge/proc/flow(list/movable, differential, repelled)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/retrigger_delay, retrigger_delay)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/stun_pressure, stun_pressure)
	for(var/i = 1; i <= movable.len; i++)
		var/atom/movable/M = movable[i]

		//If they're already being tossed, don't do it again.
		if(M.last_airflow > world.time - retrigger_delay)
			continue
		if(M.airflow_speed)
			continue

		//Check for knocking people over
		if(ismob(M) && differential > stun_pressure)
			if(M:status_flags & GODMODE)
				continue
			M:airflow_stun()

		if(M.check_airflow_movable(differential))
			//Check for things that are in range of the midpoint turfs.
			var/list/close_turfs = list()
			for(var/turf/U in connecting_turfs)
				if(get_dist(M,U) < world.view) close_turfs += U
			if(!close_turfs.len)
				continue

			M.airflow_dest = pick(close_turfs) //Pick a random midpoint to fly towards.

			if(repelled)
				spawn
					if(M) M.RepelAirflowDest(differential/5)
			else
				spawn
					if(M) M.GotoAirflowDest(differential/10)

/datum/zas_edge/zone
	var/datum/zas_zone/B

/datum/zas_edge/zone/New(datum/zas_zone/A, datum/zas_zone/B)

	src.A = A
	src.B = B
	A.edges.Add(src)
	B.edges.Add(src)
	//id = edge_id(A,B)
	//to_chat(world, "New edge between [A] and [B]")

/datum/zas_edge/zone/add_connection(datum/zas_connection/c)
	. = ..()
	connecting_turfs.Add(c.A)

/datum/zas_edge/zone/remove_connection(datum/zas_connection/c)
	connecting_turfs.Remove(c.A)
	. = ..()

/datum/zas_edge/zone/contains_zone(datum/zas_zone/Z)
	return A == Z || B == Z

/datum/zas_edge/zone/erase()
	A.edges.Remove(src)
	B.edges.Remove(src)
	. = ..()

/datum/zas_edge/zone/tick()
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/lightest_pressure, lightest_pressure)
	if(A.invalid || B.invalid)
		erase()
		return

	var/equiv = A.air.share_ratio(B.air, coefficient)

	var/differential = A.air.return_pressure() - B.air.return_pressure()
	if(abs(differential) >= lightest_pressure)
		var/list/attracted
		var/list/repelled
		if(differential > 0)
			attracted = A.movables()
			repelled = B.movables()
		else
			attracted = B.movables()
			repelled = A.movables()

		flow(attracted, abs(differential), 0)
		flow(repelled, abs(differential), 1)

	if(equiv)
		if(direct)
			erase()
			air_master.merge(A, B)
			return
		else
			A.air.equalize(B.air)
			air_master.mark_edge_sleeping(src)

	air_master.mark_zone_update(A)
	air_master.mark_zone_update(B)

/datum/zas_edge/zone/recheck()
	// Edges with only one side being vacuum need processing no matter how close.
	if(!A.air.compare(B.air, vacuum_exception = 1))
		air_master.mark_edge_active(src)

//Helper proc to get connections for a zone.
/datum/zas_edge/zone/proc/get_connected_zone(datum/zas_zone/from)
	if(A == from) return B
	else return A

/datum/zas_edge/unsimulated
	var/turf/B
	var/datum/gas_mixture/air

/datum/zas_edge/unsimulated/New(datum/zas_zone/A, turf/B)
	src.A = A
	src.B = B
	A.edges.Add(src)
	air = B.return_air()
	//id = 52*A.id
	//to_chat(world, "New edge from [A] to [B].")

/datum/zas_edge/unsimulated/add_connection(datum/zas_connection/c)
	. = ..()
	connecting_turfs.Add(c.B)
	air.group_multiplier = coefficient

/datum/zas_edge/unsimulated/remove_connection(datum/zas_connection/c)
	connecting_turfs.Remove(c.B)
	air.group_multiplier = coefficient
	. = ..()

/datum/zas_edge/unsimulated/erase()
	A.edges.Remove(src)
	. = ..()

/datum/zas_edge/unsimulated/contains_zone(datum/zas_zone/Z)
	return A == Z

/datum/zas_edge/unsimulated/tick()
	if(A.invalid)
		erase()
		return

	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/lightest_pressure, lightest_pressure)

	var/equiv = A.air.share_space(air)

	var/differential = A.air.return_pressure() - air.return_pressure()
	if(abs(differential) >= lightest_pressure)
		var/list/attracted = A.movables()
		flow(attracted, abs(differential), differential < 0)

	if(equiv)
		A.air.copy_from(air)
		air_master.mark_edge_sleeping(src)

	air_master.mark_zone_update(A)

/datum/zas_edge/unsimulated/recheck()
	// Edges with only one side being vacuum need processing no matter how close.
	// Note: This handles the glaring flaw of a room holding pressure while exposed to space, but
	// does not specially handle the less common case of a simulated room exposed to an unsimulated pressurized turf.
	if(!A.air.compare(air, vacuum_exception = 1))
		air_master.mark_edge_active(src)

/proc/ShareHeat(datum/gas_mixture/A, datum/gas_mixture/B, connecting_tiles)
	//This implements a simplistic version of the Stefan-Boltzmann law.
	var/energy_delta = ((A.temperature - B.temperature) ** 4) * STEFAN_BOLTZMANN_CONSTANT * connecting_tiles * 2.5
	var/maximum_energy_delta = max(0, min(A.temperature * A.heat_capacity() * A.group_multiplier, B.temperature * B.heat_capacity() * B.group_multiplier))
	if(maximum_energy_delta > abs(energy_delta))
		if(energy_delta < 0)
			maximum_energy_delta *= -1
		energy_delta = maximum_energy_delta

	A.temperature -= energy_delta / (A.heat_capacity() * A.group_multiplier)
	B.temperature += energy_delta / (B.heat_capacity() * B.group_multiplier)
