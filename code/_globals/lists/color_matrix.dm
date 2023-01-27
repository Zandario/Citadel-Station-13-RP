/**
 *
 * File for various color matrices.
 *
 */

/**
 * Various types of colorblindness.
 *
 * R2R, R2G, R2B,
 * G2R, G2G, G2B,
 * B2R, B2G, B2B,
 */
GLOBAL_LIST_INIT(color_matrix_achromatomaly, list(
	0.62, 0.32, 0.06,
	0.16, 0.78, 0.06,
	0.16, 0.32, 0.52
))
GLOBAL_LIST_INIT(color_matrix_achromatopsia, list(
	0.30, 0.59, 0.11,
	0.30, 0.59, 0.11,
	0.30, 0.59, 0.11
))
GLOBAL_LIST_INIT(color_matrix_deuteranomaly, list(
	0.80, 0.20, 0,
	0.26, 0.74, 0,
	0,    0.14, 0.86
))
GLOBAL_LIST_INIT(color_matrix_deuteranopia, list(
	0.63, 0.38, 0,
	0.70, 0.30, 0,
	0,    0.30, 0.70
))
GLOBAL_LIST_INIT(color_matrix_monochromia, list(
	0.33, 0.33, 0.33,
	0.59, 0.59, 0.59,
	0.11, 0.11, 0.11
))
GLOBAL_LIST_INIT(color_matrix_protanomaly, list(
	0.82, 0.18, 0,
	0.33, 0.67, 0,
	0,    0.13, 0.88
))
GLOBAL_LIST_INIT(color_matrix_protanopia, list(
	0.57, 0.43, 0,
	0.56, 0.44, 0,
	0,    0.24, 0.76
))
GLOBAL_LIST_INIT(color_matrix_tritanomaly, list(
	0.97, 0.03, 0,
	0,    0.73, 0.27,
	0,    0.18, 0.82
))
GLOBAL_LIST_INIT(color_matrix_tritanopia, list(
	0.95, 0.05, 0,
	0,    0.43, 0.57,
	0,    0.48, 0.53
))

// Below are the colorblindness matrices for the various species.

GLOBAL_LIST_INIT(color_matrix_taj_colorblind, list(
	0.40, 0.20, 0.40,
	0.40, 0.60, 0,
	0.20, 0.20, 0.60
))
GLOBAL_LIST_INIT(color_matrix_vulp_colorblind, list(
	0.50, 0.40, 0.10,
	0.50, 0.40, 0.10,
	0,    0.20, 0.80
))
