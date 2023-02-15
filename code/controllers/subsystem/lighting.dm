SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = LIGHTING_INTERVAL
	priority = FIRE_PRIORITY_LIGHTING
	init_order = INIT_ORDER_LIGHTING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/total_lighting_overlays = 0
	var/total_lighting_sources = 0
	var/total_ambient_turfs = 0

	/// lighting sources  queued for update.
	var/list/light_update_queue = list()
	var/lq_idex = 1
	/// lighting overlays queued for update.
	var/list/overlay_queue = list()
	var/oq_idex = 1

	var/tmp/processed_lights = 0
	var/tmp/processed_overlays = 0

	var/total_ss_updates = 0
	var/total_instant_updates = 0

	var/instant_ctr = 0

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	var/force_queued = TRUE
	/// For admins.
	var/force_override = FALSE
#endif

/datum/controller/subsystem/lighting/stat_entry()
	var/list/out = list(
#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
		"IUR: [total_ss_updates ? round(total_instant_updates/(total_instant_updates+total_ss_updates)*100, 0.1) : "NaN"]% Instant: [force_queued ? "Disabled" : "Allowed"] <br>",
#endif
		"&emsp;T: { L: [total_lighting_sources] O:[total_lighting_overlays] A: [total_ambient_turfs] }<br>",
		"&emsp;P: { L: [light_update_queue.len - (lq_idex - 1)] O: [overlay_queue.len - (oq_idex - 1)] }<br>",
		"&emsp;L: { L: [processed_lights] O: [processed_overlays]}<br>"
	)
	return ..() + out.Join()

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES

/hook/roundstart/proc/lighting_init_roundstart()
	SSlighting.handle_roundstart()
	return TRUE

/datum/controller/subsystem/lighting/proc/handle_roundstart()
	force_queued = FALSE
	total_ss_updates = 0
	total_instant_updates = 0

#endif

/// Disable instant updates, relying entirely on the (slower, but less laggy) queued pathway. Use if changing a *lot* of lights.
/datum/controller/subsystem/lighting/proc/pause_instant()
	if (force_override)
		return

	instant_ctr += 1
	if (instant_ctr == 1)
		force_queued = TRUE

/// Resume instant updates.
/datum/controller/subsystem/lighting/proc/resume_instant()
	if (force_override)
		return

	instant_ctr = max(instant_ctr - 1, 0)

	if (!instant_ctr)
		force_queued = FALSE

/datum/controller/subsystem/lighting/Initialize(timeofday)
	var/overlaycount = 0
	var/starttime = REALTIMEOFDAY

	// Tick once to clear most lights.
	fire(FALSE, TRUE)

	var/time = (REALTIMEOFDAY - starttime) / 10
	var/list/blockquote_data = list(
		SPAN_BOLDANNOUNCE("Lighting pre-bake completed within [time] second[time == 1 ? "" : "s"]!<hr>"),
		SPAN_DEBUGINFO("Processed [processed_lights] light sources."),
		SPAN_DEBUGINFO("\nProcessed [processed_overlays] light overlays."),
	)

	to_chat(
		target = world,
		html   = SPAN_BLOCKQUOTE(JOINTEXT(blockquote_data), "info"),
		type   = MESSAGE_TYPE_DEBUG,
	)
	log_subsystem("lighting", "NOv:[overlaycount] L:[processed_lights] O:[processed_overlays]")

	return ..()

/datum/controller/subsystem/lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processed_lights = 0

	MC_SPLIT_TICK_INIT(3)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_lights = light_update_queue

	while (lq_idex <= curr_lights.len)
		var/datum/light/L = curr_lights[lq_idex++]

		if (L && L.dirty_flags != NONE)

			if (L.dirty_flags & D_ENABLE)
				if (L.enabled)
					L.disable(queued_run = 1)
					L.dirty_flags &= ~D_ENABLE

			if (L.dirty_flags & D_BRIGHT)
				L.set_brightness(L.brightness_des, queued_run = 1)
			if (L.dirty_flags & D_COLOR)
				L.set_color(L.r_des,L.g_des,L.b_des, queued_run = 1)
			if (L.dirty_flags & D_HEIGHT)
				L.set_height(L.height_des, queued_run = 1)

			if (L.dirty_flags & D_MOVE)
				L.move(L.x_des,L.y_des,L.z_des,L.dir_des, queued_run = 1)


			if (L.dirty_flags & D_ENABLE)
				if (!L.enabled)
					L.enable(queued_run = 1)
					L.dirty_flags &= ~D_ENABLE

			L.dirty_flags = NONE

			processed_lights++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break




/datum/controller/subsystem/lighting/Recover()
	total_lighting_overlays = SSlighting.total_lighting_overlays
	total_lighting_sources = SSlighting.total_lighting_sources

	light_update_queue = SSlighting.light_update_queue
	overlay_queue = SSlighting.overlay_queue

	lq_idex = SSlighting.lq_idex
	oq_idex = SSlighting.oq_idex

	if (lq_idex > 1)
		light_update_queue.Cut(1, lq_idex)
		lq_idex = 1

	if (oq_idex > 1)
		overlay_queue.Cut(1, oq_idex)
		oq_idex = 1
