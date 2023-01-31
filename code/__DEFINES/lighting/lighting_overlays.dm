/// Icon used for lighting shading effects
#define LIGHTING_ICON 'icons/effects/lighting/lighting_overlay.dmi'
/// icon_state used for normal color-matrix based lighting overlays.
#define LIGHTING_BASE_ICON_STATE "matrix"
/// icon_state used for lighting overlays with no luminosity.
#define LIGHTING_DARKNESS_ICON_STATE "black"
#define LIGHTING_TRANSPARENT_ICON_STATE "blank"

/// Icon used for normal-based effects
#define NORMAL_MAP_ICON 'icons/effects/lighting/normal_map.dmi'

//! If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list            \
	(               \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		0, 0, 0, 1  \
	)               \

// Helpers so we can (more easily) control the colour matrices.
#define CL_MATRIX_RR 1
#define CL_MATRIX_RG 2
#define CL_MATRIX_RB 3
#define CL_MATRIX_RA 4
#define CL_MATRIX_GR 5
#define CL_MATRIX_GG 6
#define CL_MATRIX_GB 7
#define CL_MATRIX_GA 8
#define CL_MATRIX_BR 9
#define CL_MATRIX_BG 10
#define CL_MATRIX_BB 11
#define CL_MATRIX_BA 12
#define CL_MATRIX_AR 13
#define CL_MATRIX_AG 14
#define CL_MATRIX_AB 15
#define CL_MATRIX_AA 16
#define CL_MATRIX_CR 17
#define CL_MATRIX_CG 18
#define CL_MATRIX_CB 19
#define CL_MATRIX_CA 20


/**
 * This color of overlay is very common - most of the station is this color when lit fully.
 * Tube lights are a bluish-white, so we can't just assume 1-1-1 is full-illumination.
 * -- If you want to change these, find them *by checking in-game*, just converting tubes' RGB color into floats will not work!
 */
#define LIGHTING_DEFAULT_TUBE_R 0.96
#define LIGHTING_DEFAULT_TUBE_G 1
#define LIGHTING_DEFAULT_TUBE_B 1
