/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/wood/broken
	icon_state = "broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/broken/Initialize(mapload)
	break_tile()
	return ..()

/turf/simulated/floor/wood/sif
	name = "alien wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "sifwood"
	initial_flooring = /decl/flooring/wood/sif

/turf/simulated/floor/wood/sif/broken
	icon_state = "sifwood_broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/sif/broken/Initialize(mapload)
	break_tile()
	return ..()
