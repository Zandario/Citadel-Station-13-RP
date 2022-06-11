/datum/atmosphere/planet/lavaland
	base_gases = list(
	/datum/gas/oxygen = 0.14,
	/datum/gas/nitrogen = 0.20,
	/datum/gas/carbon_dioxide = 0.66
	)
	base_target_pressure = 35.1
	minimum_pressure = 32.1
	maximum_pressure = 37.1
	minimum_temp = 310.3
	maximum_temp = 350.1

#define LAVALAND_SET_ATMOS	initial_gas_mix=ATMOSPHERE_ID_LAVALAND
#define LAVALAND_TURF_CREATE(x)	x/lavaland/initial_gas_mix=ATMOSPHERE_ID_LAVALAND

LAVALAND_TURF_CREATE(/turf/simulated/shuttle/floor)
LAVALAND_TURF_CREATE(/turf/simulated/shuttle/wall)
LAVALAND_TURF_CREATE(/turf/simulated/wall)
LAVALAND_TURF_CREATE(/turf/simulated/wall/wood)
LAVALAND_TURF_CREATE(/turf/simulated/wall/sandstone)
LAVALAND_TURF_CREATE(/turf/simulated/wall/sandstonediamond)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors/beach/sand)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors/beach/sand/desert)
LAVALAND_TURF_CREATE(/turf/simulated/grass/outdoors)
LAVALAND_TURF_CREATE(/turf/simulated/water)
LAVALAND_TURF_CREATE(/turf/simulated/lava)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors)
LAVALAND_TURF_CREATE(/turf/simulated/water/deep)
LAVALAND_TURF_CREATE(/turf/simulated/water/shoreline)
LAVALAND_TURF_CREATE(/turf/simulated/water/shoreline/corner)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors/beach/sand)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors/beach/sand/dirt)
LAVALAND_TURF_CREATE(/turf/simulated/dirt)
LAVALAND_TURF_CREATE(/turf/simulated/outdoors/rocks)
LAVALAND_TURF_CREATE(/turf/simulated/floor/plating)
LAVALAND_TURF_CREATE(/turf/simulated/floor/wood)
LAVALAND_TURF_CREATE(/turf/simulated/floor/wood/broken)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/old_tile)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/monotile)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/dark)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/steel_dirty)
LAVALAND_TURF_CREATE(/turf/simulated/floor/tiled/steel_grid)
LAVALAND_TURF_CREATE(/turf/simulated/floor)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/black)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/blue)
LAVALAND_TURF_CREATE(/turf/simulated/floor/carpet/purple)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/ignore_mapgen)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/cave)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/floor/ignore_mapgen)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/rich/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/floor/bluegrid)
LAVALAND_TURF_CREATE(/turf/simulated/floor/greengrid)
LAVALAND_TURF_CREATE(/turf/unsimulated/mineral/triumph)
LAVALAND_TURF_CREATE(/turf/simulated/mineral/)
