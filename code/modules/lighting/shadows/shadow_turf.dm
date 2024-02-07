/turf
	var/shadowcast_inview
	var/shadowcast_considered
	var/shadowcasting_initialized = FALSE
	var/list/shadowcasting_overlays = list()
	var/shadow_flags = NONE

/turf/New()
	. = ..()
	QUEUE_SHADOW(src)
	QUEUE_SHADOW_NEIGHBORS(src)


/turf/proc/update_shadowcasting_overlays()
	shadow_flags &= ~SHADOW_FLAG_QUEUED
	create_shadowcast_overlays(src)
	shadowcasting_initialized = TRUE
