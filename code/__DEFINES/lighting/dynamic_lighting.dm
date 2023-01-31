//! ## DYNAMIC LIGHTING STATE
/// Dynamic lighting disabled. (area stays at full brightness)
#define DYNAMIC_LIGHTING_DISABLED    0
/// Dynamic lighting enabled.
#define DYNAMIC_LIGHTING_ENABLED     1
/// Dynamic lighting enabled even if the area doesn't require power.
#define DYNAMIC_LIGHTING_FORCED      2
/// Dynamic lighting enabled only if starlight is.
#define DYNAMIC_LIGHTING_IFSTARLIGHT 3
#define IS_DYNAMIC_LIGHTING(A) A.dynamic_lighting

/**
 * Mostly identical to below, but doesn't make sure T is valid first.
 * Should only be used by lighting code.
 */
#define TURF_IS_DYNAMICALLY_LIT_UNSAFE(T) ((T:dynamic_lighting && T:loc:dynamic_lighting))
#define TURF_IS_DYNAMICALLY_LIT(T) (isturf(T) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
