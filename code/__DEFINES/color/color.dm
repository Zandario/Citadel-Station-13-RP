//GENERAL
#define COLOR_WHITE						"#FFFFFF"
#define COLOR_VERY_LIGHT_GRAY			"#EEEEEE"
#define COLOR_SILVER					"#C0C0C0"
#define COLOR_GRAY						"#808080"
#define COLOR_HALF_TRANSPARENT_BLACK	"#0000007A"
#define COLOR_BLACK						"#000000"
#define COLOR_RED_LIGHT					"#FF3333"
#define COLOR_RED						"#FF0000"
#define COLOR_MAROON					"#800000"
#define COLOR_DARK_ORANGE				"#B95A00"
#define COLOR_ORANGE					"#FF9900"
#define COLOR_YELLOW					"#FFFF00"
#define COLOR_OLIVE						"#808000"
#define COLOR_LIME						"#00FF00"
#define COLOR_GREEN						"#008000"
#define COLOR_CYAN						"#00FFFF"
#define COLOR_TEAL						"#008080"
#define COLOR_BLUE						"#0000FF"
#define COLOR_NAVY						"#000080"
#define COLOR_PINK						"#FF00FF"
#define COLOR_PURPLE					"#800080"
#define COLOR_LUMINOL					"#66FFFF"
#define COLOR_BEIGE						"#CEB689"
#define COLOR_BLUE_GRAY					"#6A97B0"
#define COLOR_BROWN						"#B19664"
#define COLOR_DARK_BROWN				"#917448"
#define COLOR_GREEN_GRAY				"#8DAF6A"
#define COLOR_RED_GRAY					"#AA5F61"
#define COLOR_PALE_BLUE_GRAY			"#8BBBD5"
#define COLOR_PALE_GREEN_GRAY			"#AED18B"
#define COLOR_PALE_RED_GRAY				"#CC9090"
#define COLOR_PALE_PURPLE_GRAY			"#BDA2BA"
#define COLOR_PURPLE_GRAY				"#A2819E"
#define COLOR_DEEP_SKY_BLUE				"#00e1ff"

// Color defines used by the assembly detailer.
#define COLOR_ASSEMBLY_BLACK	"#545454"
#define COLOR_ASSEMBLY_BGRAY	"#9497AB"
#define COLOR_ASSEMBLY_WHITE	"#E2E2E2"
#define COLOR_ASSEMBLY_RED		"#CC4242"
#define COLOR_ASSEMBLY_ORANGE	"#E39751"
#define COLOR_ASSEMBLY_BEIGE	"#AF9366"
#define COLOR_ASSEMBLY_BROWN	"#97670E"
#define COLOR_ASSEMBLY_GOLD		"#AA9100"
#define COLOR_ASSEMBLY_YELLOW	"#CECA2B"
#define COLOR_ASSEMBLY_GURKHA	"#999875"
#define COLOR_ASSEMBLY_LGREEN	"#789876"
#define COLOR_ASSEMBLY_GREEN	"#44843C"
#define COLOR_ASSEMBLY_LBLUE	"#5D99BE"
#define COLOR_ASSEMBLY_BLUE		"#38559E"
#define COLOR_ASSEMBLY_PURPLE	"#6F6192"
#define COLOR_ASSEMBLY_HOT_PINK	"#FF69B4"

///MISC
#define COLOR_ASTEROID_ROCK				"#735555"
#define COLOR_FLOORTILE_GRAY			"#8D8B8B"

///INTERFACE
#define COLOR_INPUT_DISABLED			"#F0F0F0"
#define COLOR_INPUT_ENABLED				"#D3B5B5"
#define COLOR_DARKMODE_BACKGROUND		"#202020"
#define COLOR_DARKMODE_DARKBACKGROUND	"#171717"
#define COLOR_DARKMODE_TEXT				"#a4bad6"


/*
	Used for wire name appearances. Replaces the color name on the left with the one on the right.
	The color on the left is the one used as the actual color of the wire, but it doesn't look good when written.
	So, we need to replace the name to something that looks better.
*/
#define LIST_COLOR_RENAME 				\
	list(								\
		"rebeccapurple" = "dark purple",\
		"darkslategrey" = "dark grey",	\
		"darkolivegreen"= "dark green",	\
		"darkslateblue" = "dark blue",	\
		"darkkhaki" 	= "khaki",		\
		"darkseagreen" 	= "light green",\
		"midnightblue" 	= "blue",		\
		"lightgrey" 	= "light grey",	\
		"darkgrey" 		= "dark grey",	\
		"darkmagenta"	= "dark magenta",\
		"steelblue" 	= "blue",		\
		"goldenrod"	 	= "gold"		\
	)

/// Pure Black and white colorblindness. Every species except Vulpkanins and Tajarans will have this.
#define GREYSCALE_COLOR_REPLACE		\
	list(							\
		"red"		= "grey",		\
		"blue"		= "grey",		\
		"green"		= "grey",		\
		"orange"	= "light grey",	\
		"brown"		= "grey",		\
		"gold"		= "light grey",	\
		"cyan"		= "silver",		\
		"magenta"	= "grey",		\
		"purple"	= "grey",		\
		"pink"		= "light grey"	\
	)

/// Red colorblindness. Vulpkanins/Wolpins have this.
#define PROTANOPIA_COLOR_REPLACE		\
	list(								\
		"red"		= "darkolivegreen",	\
		"darkred"	= "darkolivegreen",	\
		"green"		= "yellow",			\
		"orange"	= "goldenrod",		\
		"gold"		= "goldenrod", 		\
		"brown"		= "darkolivegreen",	\
		"cyan"		= "steelblue",		\
		"magenta"	= "blue",			\
		"purple"	= "darkslategrey",	\
		"pink"		= "beige"			\
	)

/// Green colorblindness.
#define DEUTERANOPIA_COLOR_REPLACE		\
	list(								\
		"red"			= "goldenrod",	\
		"green"			= "tan",		\
		"yellow"		= "tan",		\
		"orange"		= "goldenrod",	\
		"gold"			= "burlywood",	\
		"brown"			= "saddlebrown",\
		"cyan"			= "lavender",	\
		"magenta"		= "blue",		\
		"darkmagenta"	= "darkslateblue",	\
		"purple"		= "slateblue",	\
		"pink"			= "thistle"		\
	)

/// Yellow-Blue colorblindness. Tajarans/Farwas have this.
#define TRITANOPIA_COLOR_REPLACE		\
	list(								\
		"red"		= "rebeccapurple",	\
		"blue"		= "darkslateblue",	\
		"green"		= "darkolivegreen",	\
		"orange"	= "darkkhaki",		\
		"gold"		= "darkkhaki",		\
		"brown"		= "rebeccapurple",	\
		"cyan"		= "darkseagreen",	\
		"magenta"	= "darkslateblue",	\
		"navy"		= "darkslateblue",	\
		"purple"	= "darkslateblue",	\
		"pink"		= "lightgrey"		\
	)
