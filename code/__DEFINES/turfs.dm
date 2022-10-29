//! flooring flags
#define TURF_REMOVE_CROWBAR     (1<<0) // Remove turf with crowbar.
#define TURF_REMOVE_SCREWDRIVER (1<<1) // Remove turf with screwdriver.
#define TURF_REMOVE_SHOVEL      (1<<2) // Remove turf with shovel.
#define TURF_REMOVE_WRENCH      (1<<3) // Remove turf with wrench.
#define TURF_CAN_BREAK          (1<<4) // Can break turf.
#define TURF_CAN_BURN           (1<<5) // Can burn turf.
#define TURF_HAS_EDGES          (1<<6) // Has edges.
#define TURF_HAS_CORNERS        (1<<7) // Has corners.
#define TURF_IS_FRAGILE         (1<<8) // Is fragile.
#define TURF_ACID_IMMUNE        (1<<9) // Is immune to acid.

//! Used for floor/wall smoothing
#define FLOORING_SMOOTH_NONE      0 // Smooth only with itself.
#define FLOORING_SMOOTH_ALL       1 // Smooth with all of type.
#define FLOORING_SMOOTH_WHITELIST 2 // Smooth with a whitelist of subtypes.
#define FLOORING_SMOOTH_BLACKLIST 3 // Smooth with all but a blacklist of subtypes.
#define FLOORING_SMOOTH_GREYLIST  4 // Use a whitelist and a blacklist at the same time. atom smoothing only.

// #define IS_CARDINAL(x) ((x & (x - 1)) == 0) // Cardinal using math.
#define IS_CARDINAL(DIR) (DIR == NORTH || DIR == SOUTH || DIR == EAST || DIR == WEST)
#define IS_DIAGONAL(DIR) (DIR == NORTHEAST || DIR == SOUTHEAST || DIR == NORTHWEST || DIR == SOUTHWEST)


// Supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a

/**
 *! Return a list of turfs in a square.
 */
#define RANGE_TURFS(RADIUS, CENTER) \
	RECT_TURFS(RADIUS, RADIUS, CENTER)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
		locate(max(CENTER.x-(H_RADIUS),1),          max(CENTER.y-(V_RADIUS),1),          CENTER.z), \
		locate(min(CENTER.x+(H_RADIUS),world.maxx), min(CENTER.y+(V_RADIUS),world.maxy), CENTER.z), \
	)

/**
 *! Return a list of turfs in a square or null.
 */
#define RANGE_TURFS_OR_EMPTY(RADIUS, CENTER) \
	RECT_TURFS_OR_EMPTY(RADIUS, RADIUS, CENTER)

#define RECT_TURFS_OR_EMPTY(H_RADIUS, V_RADIUS, CENTER) \
	(CENTER? block( \
		locate(max(CENTER.x-(H_RADIUS),1),          max(CENTER.y-(V_RADIUS),1),          CENTER.z), \
		locate(min(CENTER.x+(H_RADIUS),world.maxx), min(CENTER.y+(V_RADIUS),world.maxy), CENTER.z), \
	) : list())
