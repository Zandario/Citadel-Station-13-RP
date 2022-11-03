/**
 *! Bay lighting engine shit
 *? Not in /code/modules/lighting because BYOND is being shit about it.
 */

/// Frequency, in 1/10ths of a second, of the lighting process.
#define LIGHTING_INTERVAL 5

#define MINIMUM_USEFUL_LIGHT_RANGE 1.4

#define LIGHTING_FALLOFF    1 // Type of falloff to use for lighting; 1 for circular, 2 for square.
#define LIGHTING_LAMBERTIAN 0 // Use lambertian shading for light sources.
#define LIGHTING_HEIGHT     1 // Height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone.

/**
 * Value used to round lumcounts, values smaller than 1/129 don't matter (if they do, thanks sinking points).
 * Greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.
 */
#define LIGHTING_ROUND_VALUE (1 / 64)

/// Icon used for lighting shading effects.
#define LIGHTING_ICON 'icons/effects/lighting_object.dmi'

/**
 * If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting objects.
 * Set to zero to disable soft lighting. Luminosity changes then work if it's lit at all.
 */
#define LIGHTING_SOFT_THRESHOLD 0

//! If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		0, 0, 0, 1           \
	)                        \

/**
 * Some defines to generalise colours used in lighting.
 *! Important note on colors. Colors can end up significantly different from the basic html picture, especially when saturated!
 */
//! ## GENERAL COLORS
#define LIGHT_COLOR_WHITE       "#FFFFFF"
#define LIGHT_COLOR_RED         "#FA8282" // rgb(250, 130, 130) //? Warm but extremely diluted red.
#define LIGHT_COLOR_GREEN       "#64C864" // rgb(100, 200, 100) //? Bright but quickly dissipating neon green.
#define LIGHT_COLOR_BLUE        "#6496FA" // rgb(100, 150, 250) //? Cold, diluted blue.
#define LIGHT_COLOR_BLUEGREEN   "#7DE1AF" // rgb(125, 225, 175) //? Light blueish green.
#define LIGHT_COLOR_PALEBLUE    "#7DAFE1" // rgb(125, 175, 225) //? A pale blue-ish color.
#define LIGHT_COLOR_CYAN        "#7DE1E1" // rgb(125, 225, 225) //? Diluted cyan.
#define LIGHT_COLOR_LIGHT_CYAN  "#40CEFF" // rgb(64,  206, 255) //? More-saturated cyan.
#define LIGHT_COLOR_DARK_BLUE   "#6496FA" // rgb(51,  117, 248) //? Saturated blue.
#define LIGHT_COLOR_PINK        "#E17DE1" // rgb(225, 125, 225) //? Diluted, mid-warmth pink.
#define LIGHT_COLOR_YELLOW      "#E1E17D" // rgb(225, 225, 125) //? Dimmed yellow, leaning kaki.
#define LIGHT_COLOR_BROWN       "#966432" // rgb(150, 100,  50) //? Clear brown, mostly dim.
#define LIGHT_COLOR_ORANGE      "#FA9632" // rgb(250, 150,  50) //? Mostly pure orange.
#define LIGHT_COLOR_PURPLE      "#952CF4" // rgb(149,  44, 244) //? Light Purple.
#define LIGHT_COLOR_LAVENDER    "#9B51FF" // rgb(155,  81, 255) //? Less-saturated light purple.
#define LIGHT_COLOR_HOLY_MAGIC  "#FFF743" // rgb(255, 247,  67) //? Slightly desaturated bright yellow.
#define LIGHT_COLOR_BLOOD_MAGIC "#D00000" // rgb(208,   0,   0) //? Deep crimson.

//? These ones aren't a direct colour like the ones above, because nothing would fit.
#define LIGHT_COLOR_FIRE       "#FAA019" // rgb(250, 160,  25) //? Warm orange color, leaning strongly towards yellow.
#define LIGHT_COLOR_LAVA       "#C48A18" // rgb(196, 138,  24) //? Very warm yellow, leaning slightly towards orange.
#define LIGHT_COLOR_FLARE      "#FA644B" // rgb(250, 100,  75) //? Bright, non-saturated red. Leaning slightly towards pink for visibility.
#define LIGHT_COLOR_SLIME_LAMP "#AFC84B" // rgb(175, 200,  75) //? Weird color, between yellow and green, very slimy.
#define LIGHT_COLOR_TUNGSTEN   "#FAE1AF" // rgb(250, 225, 175) //? Extremely diluted yellow, close to skin color (for some reason).
#define LIGHT_COLOR_HALOGEN    "#F0FAFA" // rgb(240, 250, 250) //? Barely visible cyan-ish hue, as the doctor prescribed.

//! ## STATION LIGHT COLORS
#define LIGHT_COLOR_FLUORESCENT_TUBE        "#B3D7FF" // rgb(179, 215, 255)
#define LIGHT_COLOR_FLUORESCENT_FLASHLIGHT  "#CDDDFF" // rgb(205, 221, 255)
#define LIGHT_COLOR_INCANDESCENT_TUBE       "#E0EFF0" // rgb(224, 239, 240)
#define LIGHT_COLOR_INCANDESCENT_BULB       "#FFFEB8" // rgb(255, 254, 184)
#define LIGHT_COLOR_INCANDESCENT_FLASHLIGHT "#FFCC66" // rgb(255, 204, 102)
#define LIGHT_COLOR_NIGHTSHIFT              "#EFCC86" // rgb(239, 204, 134)

/// How many tiles standard fires glow.
#define LIGHT_RANGE_FIRE 3

#define LIGHTING_PLANE_ALPHA_VISIBLE          255
#define LIGHTING_PLANE_ALPHA_NV_TRAIT         223
#define LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE   192
/// For lighting alpha, small amounts lead to big changes. even at 128 its hard to figure out what is dark and what is light, at 64 you almost can't even tell.
#define LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE 128
#define LIGHTING_PLANE_ALPHA_INVISIBLE        0

#define NIGHT_VISION_DARKSIGHT_RANGE 3

//! ## DYNAMIC LIGHTING STATE
#define DYNAMIC_LIGHTING_DISABLED    0 // Dynamic lighting disabled. (area stays at full brightness)
#define DYNAMIC_LIGHTING_ENABLED     1 // Dynamic lighting enabled.
#define DYNAMIC_LIGHTING_FORCED      2 // Dynamic lighting enabled even if the area doesn't require power.
#define DYNAMIC_LIGHTING_IFSTARLIGHT 3 // Dynamic lighting enabled only if starlight is.
#define IS_DYNAMIC_LIGHTING(A) A.dynamic_lighting


// Code assumes higher numbers override lower numbers.
#define LIGHTING_NO_UPDATE    0
#define LIGHTING_VIS_UPDATE   1
#define LIGHTING_CHECK_UPDATE 2
#define LIGHTING_FORCE_UPDATE 3

#define FLASH_LIGHT_DURATION 2
#define FLASH_LIGHT_POWER    3
#define FLASH_LIGHT_RANGE    3.8

/// Uses vis_overlays to leverage caching so that very few new items need to be made for the overlay. For anything that doesn't change outline or opaque area much or at all.
#define EMISSIVE_BLOCK_GENERIC 1
/// Uses a dedicated render_target object to copy the entire appearance in real time to the blocking layer. For things that can change in appearance a lot from the base state, like humans.
#define EMISSIVE_BLOCK_UNIQUE  2


/// Returns the red part of a #RRGGBB hex sequence as number
#define GETREDPART(hexa) hex2num(copytext(hexa, 2, 4))

/// Returns the green part of a #RRGGBB hex sequence as number
#define GETGREENPART(hexa) hex2num(copytext(hexa, 4, 6))

/// Returns the blue part of a #RRGGBB hex sequence as number
#define GETBLUEPART(hexa) hex2num(copytext(hexa, 6, 8))

/// Parse the hexadecimal color into lumcounts of each perspective.
#define PARSE_LIGHT_COLOR(source) \
do { \
	if (source.light_color) { \
		var/__light_color = source.light_color; \
		source.lum_r = GETREDPART(__light_color) / 255; \
		source.lum_g = GETGREENPART(__light_color) / 255; \
		source.lum_b = GETBLUEPART(__light_color) / 255; \
	} else { \
		source.lum_r = 1; \
		source.lum_g = 1; \
		source.lum_b = 1; \
	}; \
} while (FALSE)

//! ## COLOR FILTERS
/// Icon filter that creates ambient occlusion
#define AMBIENT_OCCLUSION filter(type="drop_shadow", x=0, y=-2, size=4, color="#04080FAA")
/// Icon filter that creates gaussian blur
#define GAUSSIAN_BLUR(filter_size) filter(type="blur", size=filter_size)
