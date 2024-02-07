
#define QUEUE_SHADOW(thing_to_queue) if(isturf(thing_to_queue)) {SSshadows.add_to_queue(thing_to_queue)}

#define QUEUE_SHADOW_NEIGHBORS(thing_to_queue) for(var/turf/turf_neighbor in orange(7, thing_to_queue)) {QUEUE_SHADOW(turf_neighbor)}

#define SHADOW_FLAG_QUEUED (1<<0)
#define SHADOW_FLAG_INITIALIZED (1<<1)

SUBSYSTEM_DEF(shadows)
	name = "Shadow Casting"
	init_order = INIT_ORDER_LIGHTING
	// subsystem_flags = SS_NO_FIRE
	wait = 2

	var/list/shadow_queue = list()
	var/shadow_index = 1
	var/list/deferred = list()
	var/processed_shadows = 0

/datum/controller/subsystem/shadows/stat_entry()
	var/list/out = list(
		"Q: [shadow_queue.len - (shadow_index - 1)] #: [processed_shadows]"
	)
	return ..() + out.Join()

/datum/controller/subsystem/shadows/Recover()
	subsystem_flags |= SS_NO_INIT // Make extra sure we don't initialize twice.

/datum/controller/subsystem/shadows/Initialize()
	var/list/queue = shadow_queue
	shadow_queue = list()

	while(length(queue))
		var/turf/shadowing_turf = queue[length(queue)]
		queue.len--
		if(QDELETED(shadowing_turf) || !(shadowing_turf.shadow_flags & SHADOW_FLAG_QUEUED))
			continue
		shadowing_turf.update_shadowcasting_overlays()
		processed_shadows++
		CHECK_TICK

/datum/controller/subsystem/shadows/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processed_shadows = 0

	var/list/shadow_queue_cache = shadow_queue
	while(length(shadow_queue_cache))
		var/turf/shadowing_turf = shadow_queue_cache[length(shadow_queue_cache)]
		shadow_queue_cache.len--
		if(QDELETED(shadowing_turf) || !(shadowing_turf.shadow_flags & SHADOW_FLAG_QUEUED))
			continue
		if(shadowing_turf.atom_flags & ATOM_INITIALIZED)
			shadowing_turf.update_shadowcasting_overlays()
			processed_shadows++
		else
			deferred += shadowing_turf
		if (MC_TICK_CHECK)
			return

	if (!length(shadow_queue_cache))
		if (deferred.len)
			shadow_queue = deferred
			deferred = shadow_queue_cache
		else
			can_fire = FALSE

/datum/controller/subsystem/shadows/proc/add_to_queue(turf/thing)
	if(thing.shadow_flags & SHADOW_FLAG_QUEUED)
		return
	thing.shadow_flags |= SHADOW_FLAG_QUEUED
	shadow_queue += thing
	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/shadows/proc/remove_from_queues(turf/thing)
	thing.shadow_flags &= ~SHADOW_FLAG_QUEUED
	shadow_queue -= thing
	deferred -= thing
