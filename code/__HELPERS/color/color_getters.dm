/// Returns the red part of a #RRGGBBAA hex sequence as number.
#define HEX_RED(COLOR)   rgb2num(COLOR)[1]
/// Returns the green part of a #RRGGBBAA hex sequence as number.
#define HEX_GREEN(COLOR) rgb2num(COLOR)[2]
/// Returns the blue part of a #RRGGBBAA hex sequence as number.
#define HEX_BLUE(COLOR)  rgb2num(COLOR)[3]
/// Returns the alpha part of a #RRGGBBAA hex sequence as number.
#define HEX_ALPHA(COLOR) rgb2num(COLOR)[4]


/// Parse the hexadecimal color into lumcounts of each perspective.
#define PARSE_LIGHT_COLOR(source) \
do { \
	if (source.light_color) { \
		var/__light_color = source.light_color; \
		source.lum_r = HEX_RED(__light_color) / 255; \
		source.lum_g = HEX_GREEN(__light_color) / 255; \
		source.lum_b = HEX_BLUE(__light_color) / 255; \
	} else { \
		source.lum_r = 1; \
		source.lum_g = 1; \
		source.lum_b = 1; \
	}; \
} while (FALSE)
