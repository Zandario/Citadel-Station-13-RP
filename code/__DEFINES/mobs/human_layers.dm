/**
 *? These are used as the layers for the icons, as well as indexes in a list that holds onto them.
 *! Technically the layers used are all -100+layer to make them FLOAT_LAYER overlays.
 */
#define HUMAN_LAYER_OFFSET     -100
//! Human Layer Indexes
#define HUMAN_LAYER_MUTATION      1 // Mutations like fat, and lasereyes.
#define HUMAN_LAYER_SKIN          2 // Skin things added by a call on species.
#define HUMAN_LAYER_BLOOD         3 // Bloodied hands/feet/anything else.
#define HUMAN_LAYER_DAMAGE        4 // Injury overlay sprites like open wounds.
#define HUMAN_LAYER_SURGERY       5 // Overlays for open surgical sites.
#define HUMAN_LAYER_UNDERWEAR     6 // Underwear/bras/etc.
#define HUMAN_LAYER_SHOES_ALT     7 // Shoe-slot item. (when set to be under uniform via verb)
#define HUMAN_LAYER_UNIFORM       8 // Uniform-slot item.
#define HUMAN_LAYER_ID            9 // ID-slot item.
#define HUMAN_LAYER_SHOES        10 // Shoe-slot item.
#define HUMAN_LAYER_GLOVES       11 // Glove-slot item.
#define HUMAN_LAYER_BELT         12 // Belt-slot item.
#define HUMAN_LAYER_SUIT         13 // Suit-slot item.
#define HUMAN_LAYER_TAIL         14 // Some species have tails to render.
#define HUMAN_LAYER_GLASSES      15 // Eye-slot item.
#define HUMAN_LAYER_BELT_ALT     16 // Belt-slot item. (when set to be above suit via verb)
#define HUMAN_LAYER_SUIT_STORAGE 17 // Suit storage-slot item.
#define HUMAN_LAYER_BACK         18 // Back-slot item.
#define HUMAN_LAYER_HAIR         19 // The human's hair.
#define HUMAN_LAYER_EARS         20 // Both ear-slot items. (combined image)
#define HUMAN_LAYER_EYES         21 // Mob's eyes. (used for glowing eyes)
#define HUMAN_LAYER_MASK         22 // Mask-slot item.
#define HUMAN_LAYER_HEAD         23 // Head-slot item.
#define HUMAN_LAYER_HANDCUFF     24 // Handcuffs, if the human is handcuffed, in a secret inv slot.
#define HUMAN_LAYER_LEGCUFF      25 // Same as handcuffs, for legcuffs.
#define HUMAN_LAYER_L_HAND       26 // Left-hand item.
#define HUMAN_LAYER_R_HAND       27 // Right-hand item.
#define HUMAN_LAYER_WING         28 // Wing overlay layer.
#define HUMAN_LAYER_TAIL_ALT     29 // Tail alt. overlay layer for fixing overlay issues.
#define HUMAN_LAYER_MODFIERS     30 // Effects drawn by modifiers.
#define HUMAN_LAYER_FIRE         31 // 'Mob on fire' overlay layer.
#define HUMAN_LAYER_WATER        32 // 'Mob submerged' overlay layer.
#define HUMAN_LAYER_TARGETED     33 // 'Aimed at' overlay layer.
//! KEEP THIS UPDATED, should always equal the highest number here, used to initialize a list.
#define TOTAL_HUMAN_LAYERS       33
