/*ALL DEFINES RELATED TO COMBAT GO HERE*/

//Damage and status effect defines

//Damage defines //TODO: merge these down to reduce on defines
/// Physical fracturing and warping of the material.
#define BRUTE "brute"
/// Scorching and charring of the material.
#define BURN "burn"
/// Poisng. Mostly caused by reagents.
#define TOX "tox"
/// Suffocation.
#define OXY "oxy"
/// How painful is this?
#define PAIN "pain"
/// Cellular degredation. Rare and difficult to treat.
#define CLONE "clone"
/// Electric Shocks. Maybe you should've worn insuls.
#define ELECTROCUTE "electrocute"

//Damage flag defines //
/// Involves a melee attack or a thrown object.
#define MELEE "melee"
/// Involves a solid projectile.
#define BULLET "bullet"
/// Involves a laser.
#define LASER "laser"
/// Involves an EMP or energy-based projectile.
#define ENERGY "energy"
/// Involves a shockwave, usually from an explosion.
#define BOMB "bomb"
/// Involved in checking wheter a disease can infect or spread. Also involved in xeno neurotoxin.
#define BIO "bio"
/// Involves fire or temperature extremes.
#define FIRE "fire"
/// Involves corrosive substances.
#define ACID "acid"
/// Involved in checking the likelyhood of applying a wound to a mob.
#define WOUND "wound"
/// Involves being eaten
#define CONSUME "consume"

// Damage things. //TODO: Merge these down to reduce on defines.

#define CUT       "cut"
#define BRUISE    "bruise"
#define PIERCE    "pierce"

#define STUN      "stun"
#define WEAKEN    "weaken"
#define PARALYZE  "paralize"
#define IRRADIATE "irradiate"
#define SLUR      "slur"
#define STUTTER   "stutter"
#define EYE_BLUR  "eye_blur"
#define DROWSY    "drowsy"

// I hate adding defines like this but I'd much rather deal with bitflags than lists and string searches.
#define BRUTELOSS 0x1
#define FIRELOSS  0x2
#define TOXLOSS   0x4
#define OXYLOSS   0x8

#define FIRE_DAMAGE_MODIFIER 0.0215 // Higher values result in more external fire damage to the skin. (default 0.0215)
#define  AIR_DAMAGE_MODIFIER 2.025  // More means less damage from hot air scalding lungs, less = more damage. (default 2.025)

// Organ defines. Bitflag into organ.status
#define ORGAN_CUT_AWAY   (1<<0)
#define ORGAN_BLEEDING   (1<<1)
#define ORGAN_BROKEN     (1<<2)
#define ORGAN_DESTROYED  (1<<3)
#define ORGAN_DEAD       (1<<4)
#define ORGAN_MUTATED    (1<<5)
#define ORGAN_BRITTLE	 (1<<6)// The organ takes additional blunt damage. If robotic, cannot be repaired through normal means.

#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_REPAIR_CAP 30

//The condition defines. /SET/ into organ.robotic [example: if(organ.robotic == ORGAN_NANOFORM) to_chat("Organ is nanites")]
#define ORGAN_FLESH    0 // Normal organic organs.
#define ORGAN_ASSISTED 1 // Like pacemakers, not robotic
#define ORGAN_ROBOT    2 // Fully robotic, no organic parts
#define ORGAN_LIFELIKE 3 // Robotic, made to appear organic
#define ORGAN_NANOFORM 4 // Fully nanoswarm organ
#define ORGAN_CRYSTAL  5 // The organ does not suffer laser damage, but shatters on droplimb.

//Germs and infections.
#define GERM_LEVEL_AMBIENT  110 // Maximum germ level you can reach by standing still.		//CITADEL CHANGE - Restored back to 110. Using no gloves on surgery WILL give a high risk of infection now.
#define GERM_LEVEL_MOVE_CAP 200 // Maximum germ level you can reach by running around.	//CITADEL CHANGE - Restroed to 200. Clean yourselves.

#define INFECTION_LEVEL_ONE   100
#define INFECTION_LEVEL_TWO   500
#define INFECTION_LEVEL_THREE 1000
#define INFECTION_LEVEL_MAX   1500
