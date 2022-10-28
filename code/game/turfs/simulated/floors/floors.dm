
/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green

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

/turf/simulated/floor/grass
	name = "grass"
	desc = "A patch of grass."
	initial_flooring = /decl/flooring/smoothgrass
	icon = 'icons/turf/floors/grass.dmi'
	icon_state = "grass-0"
	base_icon_state = "grass"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_FLOOR_GRASS)
	canSmoothWith = list(SMOOTH_GROUP_FLOOR_GRASS, SMOOTH_GROUP_CLOSED_TURFS)

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

/turf/simulated/floor/wmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "lightmarble"
	initial_flooring = /decl/flooring/wmarble

/turf/simulated/floor/bmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "darkmarble"
	initial_flooring = /decl/flooring/bmarble

/turf/simulated/floor/bananium
	name = "bananium"
	desc = "This floor feels vaguely springy and rubbery, and has an almost pleasant bounce when stepped on."
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "bananium"
	initial_flooring = /decl/flooring/bananium

/turf/simulated/floor/bananium/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't make footprints.
			return ..()
		playsound(src, 'sound/items/bikehorn.ogg', 75, 1)
	..()

/turf/simulated/floor/silencium
	name = "silencium"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "silencium"
	initial_flooring = /decl/flooring/silencium

/turf/simulated/floor/plasteel
	name = "plasteel"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "plasteel"
	initial_flooring = /decl/flooring/plasteel

/turf/simulated/floor/durasteel
	name = "durasteel"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "durasteel"
	initial_flooring = /decl/flooring/durasteel

/turf/simulated/floor/silver
	name = "silver"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "silver"
	initial_flooring = /decl/flooring/silver

/turf/simulated/floor/gold
	name = "gold"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "gold"
	initial_flooring = /decl/flooring/gold

/turf/simulated/floor/phoron
	name = "phoron"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "phoron"
	initial_flooring = /decl/flooring/phoron

/turf/simulated/floor/uranium
	name = "uranium"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "uranium"
	initial_flooring = /decl/flooring/uranium

/turf/simulated/floor/diamond
	name = "diamond"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "diamond"
	initial_flooring = /decl/flooring/diamond

/turf/simulated/floor/brass
	name = "clockwork floor"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "clockwork_floor"
	initial_flooring = /decl/flooring/brass


// Placeholders

/turf/simulated/floor/airless/lava
/turf/simulated/floor/light
/*
/turf/simulated/floor/beach
/turf/simulated/floor/beach/sand
/turf/simulated/floor/beach/sand/desert
/turf/simulated/floor/beach/coastline
/turf/simulated/floor/beach/water
/turf/simulated/floor/beach/water/ocean
*/
/turf/simulated/floor/airless/ceiling
/turf/simulated/floor/plating

/turf/simulated/floor/plating/external
	outdoors = TRUE
