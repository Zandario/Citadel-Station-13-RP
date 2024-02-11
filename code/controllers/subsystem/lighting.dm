GLOBAL_LIST_EMPTY(lighting_update_lights) // List of lighting sources  queued for update.
GLOBAL_LIST_EMPTY(init_lights) // List of lighting sources queued up for roundstart initialization

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 1
	init_order = INIT_ORDER_LIGHTING
	subsystem_flags = SS_TICKER

	var/list/lighting_update_lights = list()
	var/list/init_lights = list()

	var/list/currentrun_lights
	var/resuming = 0

/datum/controller/subsystem/lighting/stat_entry(msg)
	// msg = "L:[length(SSlighting.lighting_update_lights)]|C:[length(GLOB.lighting_update_corners)]|O:[length(GLOB.lighting_update_objects)]"
	msg = "L:[lighting_update_lights.len] queued"
	return ..()

/datum/controller/subsystem/lighting/Initialize(timeofday)
	for(var/atom/movable/lighting_overlay/L in init_lights)
		if(L && !QDELETED(L))
			L.cast_light(TRUE)
	init_lights = null
	initialized = TRUE

	..()

/datum/controller/subsystem/lighting/fire(resumed=FALSE)
	if (!resuming)
		currentrun_lights = lighting_update_lights
		lighting_update_lights = list()

	resuming = TRUE

	while (currentrun_lights.len)
		var/atom/movable/lighting_overlay/L = currentrun_lights[currentrun_lights.len]
		currentrun_lights.len--

		if(L && !QDELETED(L))
			L.cast_light(TRUE)

		if (MC_TICK_CHECK)
			return

	resuming = FALSE

/datum/controller/subsystem/lighting/Recover()
	src.initialized = initialized
	..()
