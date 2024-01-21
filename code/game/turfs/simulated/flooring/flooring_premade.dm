/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/floors/carpet.dmi'
	icon_state = "carpet"
	floor_tile = /obj/item/stack/tile/carpet
	floor_tile = /obj/item/stack/tile/carpet

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET)
	canSmoothWith = (SMOOTH_GROUP_CARPET)
	overfloor_placed = TRUE

/turf/simulated/floor/carpet/bcarpet
	name = "black carpet"
	icon_state = "bcarpet"
	floor_tile = /obj/item/stack/tile/carpet/bcarpet

/turf/simulated/floor/carpet/blucarpet
	name = "blue carpet"
	icon_state = "blucarpet"
	floor_tile = /obj/item/stack/tile/carpet/blucarpet

/turf/simulated/floor/carpet/tealcarpet
	name = "teal carpet"
	icon_state = "tealcarpet"
	floor_tile = /obj/item/stack/tile/carpet/teal

// Legacy support for existing paths for blue carpet
/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blucarpet"
	floor_tile = /obj/item/stack/tile/carpet/blucarpet

/turf/simulated/floor/carpet/turcarpet
	name = "tur carpet"
	icon_state = "turcarpet"
	floor_tile = /obj/item/stack/tile/carpet/turcarpet

/turf/simulated/floor/carpet/sblucarpet
	name = "sblue carpet"
	icon_state = "sblucarpet"
	floor_tile = /obj/item/stack/tile/carpet/sblucarpet

/turf/simulated/floor/carpet/gaycarpet
	name = "clown carpet"
	icon_state = "gaycarpet"
	floor_tile = /obj/item/stack/tile/carpet/gaycarpet

/turf/simulated/floor/carpet/purcarpet
	name = "purple carpet"
	icon_state = "purcarpet"
	floor_tile = /obj/item/stack/tile/carpet/purcarpet

/turf/simulated/floor/carpet/oracarpet
	name = "orange carpet"
	icon_state = "oracarpet"
	floor_tile = /obj/item/stack/tile/carpet/oracarpet

/turf/simulated/floor/carpet/arcadecarpet
	name = "arcade carpet"
	icon_state = "arcade"
	floor_tile = /obj/item/stack/tile/carpet/arcadecarpet

/turf/simulated/floor/carpet/patterned/brown
	name = "brown patterend carpet"
	icon_state = "brown"
	floor_tile = /obj/item/stack/tile/carpet/patterned/brown

/turf/simulated/floor/carpet/patterned/blue
	name = "blue patterend carpet"
	icon_state = "blue1"
	floor_tile = /obj/item/stack/tile/carpet/patterned/blue

/turf/simulated/floor/carpet/patterned/blue/alt
	name = "blue patterend carpet"
	icon_state = "blue2"
	floor_tile = /obj/item/stack/tile/carpet/patterned/blue/alt

/turf/simulated/floor/carpet/patterned/blue/alt2
	name = "blue patterend carpet"
	icon_state = "blue3"
	floor_tile = /obj/item/stack/tile/carpet/patterned/blue/alt2

/turf/simulated/floor/carpet/patterned/red
	name = "red patterend carpet"
	icon_state = "red"
	floor_tile = /obj/item/stack/tile/carpet/patterned/red

/turf/simulated/floor/carpet/patterned/green
	name = "green patterend carpet"
	icon_state = "green"
	floor_tile = /obj/item/stack/tile/carpet/patterned/green

/turf/simulated/floor/carpet/patterned/magneta
	name = "magenta patterend carpet"
	icon_state = "magenta"
	floor_tile = /obj/item/stack/tile/carpet/patterned/magenta

/turf/simulated/floor/carpet/patterned/purple
	name = "purple patterend carpet"
	icon_state = "purple"
	floor_tile = /obj/item/stack/tile/carpet/patterned/purple

/turf/simulated/floor/carpet/patterned/orange
	name = "orange patterend carpet"
	icon_state = "orange"
	floor_tile = /obj/item/stack/tile/carpet/patterned/orange

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon_state = "bcircuit"
	#warn Circuit stacks?
	// floor_tile = /obj/item/stack/tile/reinforced/circuit
	overfloor_placed = TRUE

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon_state = "gcircuit"
	// floor_tile = /obj/item/stack/tile/reinforced/circuit/green
	overfloor_placed = TRUE

/turf/simulated/floor/wood
	name = "wooden floor"
	icon_state = "wood"
	floor_tile = /obj/item/stack/tile/wood
	overfloor_placed = TRUE

/turf/simulated/floor/wood/broken
	icon_state = "broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/broken/Initialize(mapload)
	break_tile()
	return ..()

/turf/simulated/floor/wood/sif
	name = "alien wooden floor"
	icon_state = "sifwood"
	floor_tile = /obj/item/stack/tile/wood/sif

/turf/simulated/floor/wood/sif/broken
	icon_state = "sifwood_broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/sif/broken/Initialize(mapload)
	break_tile()
	return ..()

/turf/simulated/floor/grass
	name = "grass patch"
	icon_state = "grass0"
	floor_tile = /obj/item/stack/tile/grass

/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "tiled"
	floor_tile = /obj/item/stack/tile/floor
	overfloor_placed = TRUE

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon_state = "techmaint"
	floor_tile = /obj/item/stack/tile/floor/techmaint

/turf/simulated/floor/tiled/techmaint/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/monofloor
	name = "floor"
	icon_state = "monofloor"
	floor_tile = /obj/item/stack/tile/floor/monofloor

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon_state = "techfloor_gray"
	floor_tile = /obj/item/stack/tile/floor/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon_state = "monotile"
	floor_tile = /obj/item/stack/tile/floor/monotile

/turf/simulated/floor/tiled/monowhite
	name = "floor"
	icon_state = "monowhite"
	floor_tile = /obj/item/stack/tile/floor/monowhite

/turf/simulated/floor/tiled/monodark
	name = "floor"
	icon_state = "monodark"
	floor_tile = /obj/item/stack/tile/floor/monodark

/turf/simulated/floor/tiled/monotechmaint
	name = "floor"
	icon_state = "monotechmaint"
	floor_tile = /obj/item/stack/tile/floor/monotechmaint

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon_state = "steel_grid"
	floor_tile = /obj/item/stack/tile/floor/steel_grid

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon_state = "steel_ridged"
	floor_tile = /obj/item/stack/tile/floor/steel_ridged

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	floor_tile = /obj/item/stack/tile/floor
/turf/simulated/floor/tiled/old_tile/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_tile/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_tile/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_tile/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_tile/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_tile/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_tile/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_tile/green
	color = "#46725c"



/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	floor_tile = /obj/item/stack/tile/floor/cargo_one

/turf/simulated/floor/tiled/old_cargo/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_cargo/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_cargo/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_cargo/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_cargo/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_cargo/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_cargo/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_cargo/green
	color = "#46725c"


/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	floor_tile = /obj/item/stack/tile/floor/kafel

/turf/simulated/floor/tiled/kafel_full/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/kafel_full/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/kafel_full/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/kafel_full/gray
	color = "#687172"
/turf/simulated/floor/tiled/kafel_full/beige
	color = "#385e60"
/turf/simulated/floor/tiled/kafel_full/red
	color = "#964e51"
/turf/simulated/floor/tiled/kafel_full/purple
	color = "#906987"
/turf/simulated/floor/tiled/kafel_full/green
	color = "#46725c"


/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	floor_tile = /obj/item/stack/tile/floor/techgrid

/turf/simulated/floor/tiled/techfloor/monogrid
	name = "floor"
	icon_state = "techfloor_monogrid"
	floor_tile = /obj/item/stack/tile/floor/tech/monogrid

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "reinforced"
	floor_tile = /obj/item/stack/rods
	overfloor_placed = TRUE

CREATE_STANDARD_TURFS(/turf/simulated/floor/reinforced)

/turf/simulated/floor/reinforced/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/reinforced/airmix
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_AIRMIX

/turf/simulated/floor/reinforced/nitrogen
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_NITROGEN

/turf/simulated/floor/reinforced/oxygen
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_OXYGEN

/turf/simulated/floor/reinforced/phoron
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_PHORON

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_CO2

/turf/simulated/floor/reinforced/n20
	initial_gas_mix = GAS_STRING_PRIMARY_TANK_N2O

/turf/simulated/floor/cult
	name = "engraved floor"
	icon_state = "cult"
	// floor_tile = /obj/item/stack/tile/reinforced/cult
	overfloor_placed = TRUE

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	floor_tile = /obj/item/stack/tile/floor/dark

/turf/simulated/floor/tiled/hydro
	name = "hydro floor"
	icon_state = "hydrofloor"
	floor_tile = /obj/item/stack/tile/floor/hydro

/turf/simulated/floor/tiled/neutral
	name = "light floor"
	icon_state = "neutral"
	floor_tile = /obj/item/stack/tile/floor/neutral

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	icon_state = "white"
	floor_tile = /obj/item/stack/tile/floor/red

/turf/simulated/floor/tiled/steel
	name = "steel floor"
	icon_state = "steel"
	floor_tile = /obj/item/stack/tile/floor/steel

/turf/simulated/floor/tiled/steel_dirty
	name = "steel floor"
	icon_state = "steel_dirty"
	floor_tile = /obj/item/stack/tile/floor/steel_dirty

/turf/simulated/floor/tiled/steel_dirty/dark
	color = COLOR_GRAY

/turf/simulated/floor/tiled/steel_dirty/red
	color = COLOR_RED_GRAY

/turf/simulated/floor/tiled/steel_dirty/cyan
	color = COLOR_CYAN

/turf/simulated/floor/tiled/steel_dirty/olive
	color = COLOR_OLIVE

/turf/simulated/floor/tiled/steel_dirty/silver
	color = COLOR_SILVER

/turf/simulated/floor/tiled/steel_dirty/yellow
	color = COLOR_BROWN

/turf/simulated/floor/tiled/steel/airless
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/asteroid_steel
	icon_state = "asteroidfloor"
	floor_tile = /obj/item/stack/tile/floor/asteroidfloor

/turf/simulated/floor/tiled/asteroid_steel/airless
	name = "plating"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	floor_tile = /obj/item/stack/tile/floor/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	icon_state = "white"
	floor_tile = /obj/item/stack/tile/floor/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	temperature = 277.15
	floor_tile = /obj/item/stack/tile/floor/freezer

/turf/simulated/floor/lino
	name = "linoleum"
	icon_state = "linoleum"
	floor_tile = /obj/item/stack/tile/linoleum
	overfloor_placed = TRUE

/turf/simulated/floor/wmarble
	name = "marble"
	icon_state = "lightmarble"
	floor_tile = /obj/item/stack/tile/wmarble
	overfloor_placed = TRUE

/turf/simulated/floor/bmarble
	name = "marble"
	icon_state = "darkmarble"
	floor_tile = /obj/item/stack/tile/bmarble
	overfloor_placed = TRUE

/turf/simulated/floor/bananium
	name = "bananium"
	desc = "This floor feels vaguely springy and rubbery, and has an almost pleasant bounce when stepped on."
	icon_state = "bananium"
	floor_tile = /obj/item/stack/tile/bananium
	overfloor_placed = TRUE

/turf/simulated/floor/bananium/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't make footprints.
			return ..()
		playsound(src, 'sound/items/bikehorn.ogg', 75, 1)
	..()

/turf/simulated/floor/silencium
	name = "silencium"
	icon_state = "silencium"
	floor_tile = /obj/item/stack/tile/silencium
	overfloor_placed = TRUE

/turf/simulated/floor/plasteel
	name = "plasteel"
	icon_state = "plasteel"
	floor_tile = /obj/item/stack/tile/plasteel
	overfloor_placed = TRUE

/turf/simulated/floor/durasteel
	name = "durasteel"
	icon_state = "durasteel"
	floor_tile = /obj/item/stack/tile/durasteel
	overfloor_placed = TRUE

/turf/simulated/floor/silver
	name = "silver"
	icon_state = "silver"
	floor_tile = /obj/item/stack/tile/silver
	overfloor_placed = TRUE

/turf/simulated/floor/gold
	name = "gold"
	icon_state = "gold"
	floor_tile = /obj/item/stack/tile/gold
	overfloor_placed = TRUE

/turf/simulated/floor/phoron
	name = "phoron"
	icon_state = "phoron"
	floor_tile = /obj/item/stack/tile/phoron
	overfloor_placed = TRUE

/turf/simulated/floor/uranium
	name = "uranium"
	icon_state = "uranium"
	floor_tile = /obj/item/stack/tile/uranium
	overfloor_placed = TRUE

/turf/simulated/floor/diamond
	name = "diamond"
	icon_state = "diamond"
	floor_tile = /obj/item/stack/tile/diamond
	overfloor_placed = TRUE

/turf/simulated/floor/brass
	name = "clockwork floor"
	icon_state = "clockwork_floor"
	floor_tile = /obj/item/stack/tile/brass
	overfloor_placed = TRUE

/turf/simulated/floor/sandstone
	name = "sandstone"
	icon_state = "sandstone"
	floor_tile = /obj/item/stack/tile/sandstone
	overfloor_placed = TRUE

/turf/simulated/floor/bone
	name = "bone floor"
	icon_state = "bone"
	floor_tile = /obj/item/stack/tile/bone
	overfloor_placed = TRUE

/turf/simulated/floor/bone/engraved
	name = "engraved bone floor"
	icon_state = "bonecarve"
	floor_tile = /obj/item/stack/tile/bone/engraved

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/airless
	name = "plating"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/tiled/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/bluegrid/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/greengrid/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

/turf/simulated/floor/greengrid/nitrogen
	initial_gas_mix = GAS_STRING_STANDARD_NO_OXYGEN

/turf/simulated/floor/tiled/white/airless
	name = "floor"
	initial_gas_mix = GAS_STRING_VACUUM

// Placeholders
#warn what the fuck
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

/turf/simulated/floor/tiled/external
	outdoors = TRUE

//**** Here lives snow ****
/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "snow"
	var/list/crossed_dirs = list()

/turf/simulated/floor/snow/gravsnow
	name = "snowy gravel"
	icon = 'icons/turf/snow_new.dmi'
	icon_state = "gravsnow"

/turf/simulated/floor/snow/snow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	floor_tile = /obj/item/stack/tile/snow

/turf/simulated/floor/snow/gravsnow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "gravsnow"
	floor_tile = /obj/item/stack/tile/snow/gravsnow2

/turf/simulated/floor/snow/plating
	name = "snowy playing"
	icon_state = "snowyplating"
	floor_tile = /obj/item/stack/tile/snow/plating

/turf/simulated/floor/snow/plating/drift
	name = "snowy plating"
	icon_state = "snowyplayingdrift"
	floor_tile = /obj/item/stack/tile/snow/plating/drift
