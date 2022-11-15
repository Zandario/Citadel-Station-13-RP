/* smoothing_flags */
/// Smoothing system in where adjacencies are calculated and used to build an image by mounting each corner at runtime.
#define SMOOTH_CORNERS			(1<<0)
/// Smoothing system in where adjacencies are calculated and used to select a pre-baked icon_state, encoded by bitmasking.
#define SMOOTH_BITMASK			(1<<1)
/// Atom has diagonal corners, with underlays under them.
#define SMOOTH_DIAGONAL_CORNERS	(1<<2)
/// Atom will smooth with the borders of the map.
#define SMOOTH_BORDER			(1<<3)
/// Atom is currently queued to smooth.
#define SMOOTH_QUEUED			(1<<4)
/// Smooths with objects, and will thus need to scan turfs for contents.
#define SMOOTH_OBJ				(1<<5)
/// custom smoothing - citrp snowflake for floors. don't you dare use this with normal things unless you absolutely know what you're doing.
#define SMOOTH_CUSTOM			(1<<6)

/// macro for checking if something is smooth
#define IS_SMOOTH(A)			(A.smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK|SMOOTH_CUSTOM))

DEFINE_BITFIELD(smoothing_flags, list(
	"SMOOTH_CORNERS" = SMOOTH_CORNERS,
	"SMOOTH_BITMASK" = SMOOTH_BITMASK,
	"SMOOTH_DIAGONAL_CORNERS" = SMOOTH_DIAGONAL_CORNERS,
	"SMOOTH_BORDER" = SMOOTH_BORDER,
	"SMOOTH_QUEUED" = SMOOTH_QUEUED,
	"SMOOTH_OBJ" = SMOOTH_OBJ,
	"SMOOTH_CUSTOM" = SMOOTH_CUSTOM,
))

/*smoothing macros*/

#define QUEUE_SMOOTH(thing_to_queue) if(IS_SMOOTH(thing_to_queue)) {SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/neighbor in orange(1, thing_to_queue)) {var/atom/atom_neighbor = neighbor; QUEUE_SMOOTH(atom_neighbor)}

/* smoothing internals */
#define NORTH_JUNCTION NORTH //(1<<0)
#define SOUTH_JUNCTION SOUTH //(1<<1)
#define EAST_JUNCTION EAST  //(1<<2)
#define WEST_JUNCTION WEST  //(1<<3)
#define NORTHEAST_JUNCTION (1<<4)
#define SOUTHEAST_JUNCTION (1<<5)
#define SOUTHWEST_JUNCTION (1<<6)
#define NORTHWEST_JUNCTION (1<<7)

#define NO_ADJ_FOUND 0
#define ADJ_FOUND 1
#define NULLTURF_BORDER 2

DEFINE_BITFIELD(smoothing_junction, list(
	"NORTH_JUNCTION" = NORTH_JUNCTION,
	"SOUTH_JUNCTION" = SOUTH_JUNCTION,
	"EAST_JUNCTION" = EAST_JUNCTION,
	"WEST_JUNCTION" = WEST_JUNCTION,
	"NORTHEAST_JUNCTION" = NORTHEAST_JUNCTION,
	"SOUTHEAST_JUNCTION" = SOUTHEAST_JUNCTION,
	"SOUTHWEST_JUNCTION" = SOUTHWEST_JUNCTION,
	"NORTHWEST_JUNCTION" = NORTHWEST_JUNCTION,
))

#define DEFAULT_UNDERLAY_ICON 'icons/turf/floors.dmi'
#define DEFAULT_UNDERLAY_ICON_STATE "plating"

/**SMOOTHING GROUPS
 * Groups of things to smooth with.
 * * Contained in the `list/smoothing_groups` variable.
 * * Matched with the `list/canSmoothWith` variable to check whether smoothing is possible or not.
 */

///Not any different from the number itself, but kept this way in case someone wants to expand it by adding stuff before it.
#define S_TURF(num) ((24 * 0) + num)
/* /turf only */

#define SMOOTH_GROUP_TURF_OPEN S_TURF(0) // /turf/open

#define SMOOTH_GROUP_CLOSED_TURFS S_TURF(50) // /turf/closed

//! Always match this value with the one above it.
#define MAX_S_TURF SMOOTH_GROUP_CLOSED_TURFS

#define S_OBJ(num) (MAX_S_TURF + 1 + num)
/* /obj included */

#define SMOOTH_GROUP_WALLS S_OBJ(0) // /turf/simulated/wall

#define SMOOTH_GROUP_WINDOW_FULLTILE         S_OBJ(21) // Fulltile windows
#define SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE S_OBJ(24) ///obj/structure/window/reinforced/shuttle

#define SMOOTH_GROUP_LATTICE  S_OBJ(30) ///obj/structure/lattice
#define SMOOTH_GROUP_CATWALK  S_OBJ(31) ///obj/structure/catwalk
#define SMOOTH_GROUP_GRILLE   S_OBJ(32) ///obj/structure/grille
#define SMOOTH_GROUP_LOW_WALL S_OBJ(33) ///obj/structure/low_wall

#define SMOOTH_GROUP_AIRLOCK             S_OBJ(40) ///obj/machinery/door/airlock
#define SMOOTH_GROUP_SHUTTERS_BLASTDOORS S_OBJ(41) ///obj/machinery/door/poddoor

#define SMOOTH_GROUP_SANDBAGS S_OBJ(50) // /obj/structure/sandbag

#define SMOOTH_GROUP_SHUTTLE_PARTS S_OBJ(66) ///obj/structure/window/reinforced/shuttle, /obj/structure/window/reinforced/plasma/plastitanium, /turf/closed/indestructible/opsglass, /obj/machinery/power/shuttle_engine

//! Always match this value with the one above it.
#define MAX_S_OBJ SMOOTH_GROUP_SHUTTLE_PARTS
