// This is the define used to calculate falloff.
#define LUM_FALLOFF(Cx,Cy,Tx,Ty,HEIGHT) (1 - CLAMP01(sqrt(((Cx) - (Tx)) ** 2 + ((Cy) - (Ty)) ** 2 + HEIGHT) / max(1, actual_range)))

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.

// Converts two Z levels into a height value for LUM_FALLOFF or HEIGHT_FALLOFF.
#define CALCULATE_CORNER_HEIGHT(ZA,ZB) (((max(ZA,ZB) - min(ZA,ZB)) + 1) * LIGHTING_HEIGHT * LIGHTING_Z_FACTOR)
