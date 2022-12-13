//! flags for /area/var/area_flags
/// Radiation shielded.
#define AREA_RAD_SHIELDED  (1<<0)
/// bluespace shielded.
#define AREA_BLUE_SHIELDED (1<<1)
/// External as in exposed to space, or whatever external atmosphere relevant.
#define AREA_FLAG_EXTERNAL (1<<2)

DEFINE_BITFIELD(area_flags, list(
	BITFIELD(AREA_RAD_SHIELDED),
	BITFIELD(AREA_BLUE_SHIELDED),
))
