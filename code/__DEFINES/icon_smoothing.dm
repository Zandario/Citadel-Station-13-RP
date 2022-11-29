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

#define S_TURF(num) ((24 * 0) + num) //Not any different from the number itself, but kept this way in case someone wants to expand it by adding stuff before it.
/* /turf only */

#define SMOOTH_GROUP_TURF_OPEN S_TURF(0) ///turf/open
#define SMOOTH_GROUP_TURF_CHASM S_TURF(1) ///turf/open/chasm, /turf/open/floor/fakepit
#define SMOOTH_GROUP_FLOOR_LAVA S_TURF(2) ///turf/open/lava/smooth
#define SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS S_TURF(3) ///turf/open/floor/glass

#define SMOOTH_GROUP_OPEN_FLOOR S_TURF(4) ///turf/open/floor

#define SMOOTH_GROUP_FLOOR_GRASS S_TURF(5) ///turf/open/misc/grass
#define SMOOTH_GROUP_FLOOR_ASH S_TURF(6) ///turf/open/misc/ashplanet/ash
#define SMOOTH_GROUP_FLOOR_ASH_ROCKY S_TURF(7) ///turf/open/misc/ashplanet/rocky
#define SMOOTH_GROUP_FLOOR_ICE S_TURF(8) ///turf/open/misc/ice
#define SMOOTH_GROUP_FLOOR_SNOWED S_TURF(9) ///turf/open/floor/plating/snowed

#define SMOOTH_GROUP_CARPET S_TURF(10) ///turf/open/floor/carpet
#define SMOOTH_GROUP_CARPET_BLACK S_TURF(11) ///turf/open/floor/carpet/black
#define SMOOTH_GROUP_CARPET_BLUE S_TURF(12) ///turf/open/floor/carpet/blue
#define SMOOTH_GROUP_CARPET_CYAN S_TURF(13) ///turf/open/floor/carpet/cyan
#define SMOOTH_GROUP_CARPET_GREEN S_TURF(14) ///turf/open/floor/carpet/green
#define SMOOTH_GROUP_CARPET_ORANGE S_TURF(15) ///turf/open/floor/carpet/orange
#define SMOOTH_GROUP_CARPET_PURPLE S_TURF(16) ///turf/open/floor/carpet/purple
#define SMOOTH_GROUP_CARPET_RED S_TURF(17) ///turf/open/floor/carpet/red
#define SMOOTH_GROUP_CARPET_ROYAL_BLACK S_TURF(18) ///turf/open/floor/carpet/royalblack
#define SMOOTH_GROUP_CARPET_ROYAL_BLUE S_TURF(19) ///turf/open/floor/carpet/royalblue
#define SMOOTH_GROUP_CARPET_EXECUTIVE S_TURF(20) ///turf/open/floor/carpet/executive
#define SMOOTH_GROUP_CARPET_STELLAR S_TURF(21) ///turf/open/floor/carpet/stellar
#define SMOOTH_GROUP_CARPET_DONK S_TURF(22) ///turf/open/floor/carpet/donk

#define SMOOTH_GROUP_CLOSED_TURFS S_TURF(53) ///turf/closed
#define SMOOTH_GROUP_SURVIVAL_TITANIUM_WALLS S_TURF(53) ///turf/closed/wall/mineral/titanium/survival
#define SMOOTH_GROUP_HOTEL_WALLS S_TURF(54) ///turf/closed/indestructible/hotelwall
#define SMOOTH_GROUP_MINERAL_WALLS S_TURF(55) ///turf/closed/mineral, /turf/closed/indestructible
#define SMOOTH_GROUP_BOSS_WALLS S_TURF(56) ///turf/closed/indestructible/riveted/boss

#define MAX_S_TURF SMOOTH_GROUP_BOSS_WALLS //Always match this value with the one above it.


#define S_OBJ(num) (MAX_S_TURF + 1 + num)
/* /obj included */

#define SMOOTH_GROUP_WALLS S_OBJ(0) ///turf/closed/wall, /obj/structure/falsewall
#define SMOOTH_GROUP_HIERO_WALL S_OBJ(1) ///obj/effect/temp_visual/elite_tumor_wall, /obj/effect/temp_visual/hierophant/wall
#define SMOOTH_GROUP_SURVIVAL_TIANIUM_POD S_OBJ(2) ///turf/closed/wall/mineral/titanium/survival/pod, /obj/machinery/door/airlock/survival_pod, /obj/structure/window/reinforced/shuttle/survival_pod

#define SMOOTH_GROUP_PAPERFRAME S_OBJ(20) ///obj/structure/window/paperframe, /obj/structure/mineral_door/paperframe

#define SMOOTH_GROUP_WINDOW_FULLTILE S_OBJ(21) ///turf/closed/indestructible/fakeglass, /obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/reinforced/plasma/fulltile
#define SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE S_OBJ(22) ///obj/structure/window/bronze/fulltile
#define SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM S_OBJ(23) ///turf/closed/indestructible/opsglass, /obj/structure/window/reinforced/plasma/plastitanium
#define SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE S_OBJ(24) ///obj/structure/window/reinforced/shuttle

#define SMOOTH_GROUP_LATTICE  S_OBJ(30) ///obj/structure/lattice
#define SMOOTH_GROUP_CATWALK  S_OBJ(31) ///obj/structure/lattice/catwalk
#define SMOOTH_GROUP_GRILLE  S_OBJ(32) ///obj/structure/grille
#define SMOOTH_GROUP_LOW_WALL  S_OBJ(33) ///obj/structure/low_wall

#define SMOOTH_GROUP_AIRLOCK S_OBJ(40) ///obj/machinery/door/airlock
#define SMOOTH_GROUP_SHUTTERS_BLASTDOORS S_OBJ(41) ///obj/machinery/door/poddoor

#define SMOOTH_GROUP_TABLES S_OBJ(50) ///obj/structure/table
#define SMOOTH_GROUP_WOOD_TABLES S_OBJ(51) ///obj/structure/table/wood
#define SMOOTH_GROUP_FANCY_WOOD_TABLES S_OBJ(52) ///obj/structure/table/wood/fancy
#define SMOOTH_GROUP_BRONZE_TABLES S_OBJ(53) ///obj/structure/table/bronze
#define SMOOTH_GROUP_ABDUCTOR_TABLES S_OBJ(54) ///obj/structure/table/abductor
#define SMOOTH_GROUP_GLASS_TABLES S_OBJ(55) ///obj/structure/table/glass

#define SMOOTH_GROUP_ALIEN_NEST S_OBJ(59) ///obj/structure/bed/nest
#define SMOOTH_GROUP_ALIEN_RESIN S_OBJ(60) ///obj/structure/alien/resin
#define SMOOTH_GROUP_ALIEN_WALLS S_OBJ(61) ///obj/structure/alien/resin/wall, /obj/structure/alien/resin/membrane
#define SMOOTH_GROUP_ALIEN_WEEDS S_OBJ(62) ///obj/structure/alien/weeds

#define SMOOTH_GROUP_SECURITY_BARRICADE S_OBJ(63) ///obj/structure/barricade/security
#define SMOOTH_GROUP_SANDBAGS S_OBJ(64) ///obj/structure/barricade/sandbags

#define SMOOTH_GROUP_HEDGE_FLUFF S_OBJ(65) ///obj/structure/hedge

#define SMOOTH_GROUP_SHUTTLE_PARTS S_OBJ(66) ///turf/closed/indestructible/opsglass, /obj/structure/shuttle, /obj/structure/window/reinforced/shuttle/survival_pod

#define SMOOTH_GROUP_CLEANABLE_DIRT S_OBJ(67) ///obj/effect/decal/cleanable/dirt

#define SMOOTH_GROUP_INDUSTRIAL_LIFT S_OBJ(70) ///obj/structure/industrial_lift

#define SMOOTH_GROUP_GAS_TANK S_OBJ(71)

#define MAX_S_OBJ SMOOTH_GROUP_GAS_TANK //Always match this value with the one above it.
