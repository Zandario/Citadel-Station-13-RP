/turf/simulated/floor/outdoors
	name = "generic ground"
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE
	can_dirty = FALSE // Looks hideous with dirt on it.
	can_build_into_floor = TRUE
	baseturfs = /turf/simulated/floor/outdoors/rocks

/turf/simulated/floor/outdoors/chill()
	PlaceOnTop(/turf/simulated/floor/outdoors/snow, flags = CHANGETURF_PRESERVE_OUTDOORS|CHANGETURF_INHERIT_AIR)

/turf/simulated/floor/outdoors/ex_act(severity)
	switch(severity)
		// Outdoor turfs are less explosion resistant
		if(1)
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		if(2)
			if(prob(66))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		if(3)
			if(prob(15))
				ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
