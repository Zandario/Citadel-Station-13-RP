/**
 *! ## Lighting engine shit.
 */

/// frequency, in 1/10ths of a second, of the lighting process
#define LIGHTING_INTERVAL 5

#define MINIMUM_USEFUL_LIGHT_RANGE 1.4


/// Height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone.
#define LIGHTING_HEIGHT 1
/// Z diff is multiplied by this and LIGHTING_HEIGHT to get the final height of a light source. Affects how much darker A Z light gets with each level transitioned.
#define LIGHTING_Z_FACTOR 10

/**
 * ? Value used to round lumcounts.
 *
 * ! PLEASE READ THIS BEFORE TOUCHING ANYTHING BELOW THIS COMMENT.
 * ! MANY PEOPLE MISUNDERSTAND THIS AND ITS FOR GOOD REASON.
 *
 * ? 1/255 is the smallest value that can be represented in BYOND's color system.
 *
 * ? Values smaller than 1/255 DON'T MATTER! (if they do, thanks sinking points)
 * ? Values greater than 1/255 will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.
 */
#define LIGHTING_ROUND_VALUE (1 / 200)


/**
 * If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting overlays.
 */
#define LIGHTING_SOFT_THRESHOLD 0.001

/**
 * How much the range of a directional light will be reduced while facing a wall.
 */
#define LIGHTING_BLOCKED_FACTOR 0.5


/**
 * If defined, instant updates will be used whenever server load permits.
 * Otherwise queued updates are always used.
 */
#define USE_INTELLIGENT_LIGHTING_UPDATES

/**
 * Maximum light_range before forced to always queue instead of using sync updates.
 * Setting this too high will cause server stutter with moving large lights.
 */
#define LIGHTING_MAXIMUM_INSTANT_RANGE 8
