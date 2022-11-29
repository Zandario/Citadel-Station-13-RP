#define MATERIAL_UNMELTABLE (1<<0)
#define MATERIAL_BRITTLE    (1<<1)
#define MATERIAL_PADDING    (1<<2)

DEFINE_BITFIELD(material_flags, list(
	BITFIELD(MATERIAL_UNMELTABLE),
	BITFIELD(MATERIAL_BRITTLE),
	BITFIELD(MATERIAL_PADDING),
))


//! Material init_flags
#define MATERIAL_INIT_MAPLOAD (1<<0) // Used to make a material initialize at roundstart.
#define MATERIAL_INIT_BESPOKE (1<<1) // Used to make a material type able to be instantiated on demand after roundstart.

DEFINE_BITFIELD(material_init_flags, list(
	BITFIELD(MATERIAL_INIT_MAPLOAD),
	BITFIELD(MATERIAL_INIT_BESPOKE),
))


//! Material wall_flags
#define WALL_FLAG_PAINTABLE  (1<<0)
#define WALL_FLAG_STRIPABLE  (1<<1)
#define WALL_FLAG_DETAILABLE (1<<2)
#define WALL_FLAG_HAS_EDGES  (1<<4)

DEFINE_BITFIELD(wall_flags, list(
	BITFIELD(WALL_FLAG_PAINTABLE),
	BITFIELD(WALL_FLAG_STRIPABLE),
	BITFIELD(WALL_FLAG_DETAILABLE),
	BITFIELD(WALL_FLAG_HAS_EDGES),
))
