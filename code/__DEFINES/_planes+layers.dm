// TODO: UNFUCK PLANES. HALF OF THESE HAVE NO REASON TO EXIST. WHOEVER ADDED THEM IS AN IDIOT! @silicons
/**
 *! This file is a list of all preclaimed planes & layers
 *
 * All planes & layers should be given a value here instead of using a magic/arbitrary number.
 *
 * After fiddling with planes and layers for some time, I figured I may as well provide some documentation:
 *
 *? What are planes?
 *    Think of Planes as a sort of layer for a layer - if plane X is a larger number than plane Y, the highest number for a layer in X will be below the lowest
 *    number for a layer in Y.
 *    Planes also have the added bonus of having planesmasters.
 *
 *? What are Planesmasters?
 *    Planesmasters, when in the sight of a player, will have its appearance properties (for example, colour matrices, alpha, transform, etc)
 *    applied to all the other objects in the plane. This is all client sided.
 *    Usually you would want to add the planesmaster as an invisible image in the client's screen.
 *
 *? What can I do with Planesmasters?
 *    You can: Make certain players not see an entire plane,
 *    Make an entire plane have a certain colour matrices,
 *    Make an entire plane transform in a certain way,
 *    Make players see a plane which is hidden to normal players - I intend to implement this with the antag HUDs for example.
 *    Planesmasters can be used as a neater way to deal with client images or potentially to do some neat things
 *
 *? How do planes work?
 *    A plane can be any integer from -100 to 100. (If you want more, bug lummox.)
 *    All planes above 0, the 'base plane', are visible even when your character cannot 'see' them, for example, the HUD.
 *    All planes below 0, the 'base plane', are only visible when a character can see them.
 *
 *? How do I add a plane?
 *    Think of where you want the plane to appear, look through the pre-existing planes and find where it is above and where it is below
 *    Slot it in in that place, and change the pre-existing planes, making sure no plane shares a number.
 *    Add a description with a comment as to what the plane does.
 *
 *? How do I make something a planesmaster?
 *    Add the PLANE_MASTER appearance flag to the appearance_flags variable.
 *
 *? What is the naming convention for planes or layers?
 *    Make sure to use the name of your object before the _LAYER or _PLANE, eg: [NAME_OF_YOUR_OBJECT HERE]_LAYER or [NAME_OF_YOUR_OBJECT HERE]_PLANE
 *    Also, as it's a define, it is standard practice to use capital letters for the variable so people know this.
 */

//! ------------------- BYOND DEFINES ------------------- !//

/**
 *? For easy recordkeeping; these are all byond defines. They are IMPORTANT.
 *! #define FLOAT_LAYER -1
 *! #define AREA_LAYER   1
 *! #define TURF_LAYER   2
 *! #define OBJ_LAYER    3
 *! #define MOB_LAYER    4
 *! #define FLY_LAYER    5
 */

// TODO: Layers still need to be linear regardless of plane. stuff like projectiles DO CARE. @silicons

//! ------------------- SUB-TURF PLANES ------------------- !//

/**
 *! CLICKCATCHER_PLANE Plane
 */
#define CLICKCATCHER_PLANE -99

/**
 *! SPACE_PLANE Plane
 *? Reserved for use in space/parallax.
 */
#define SPACE_PLANE -95

/**
 *! PARALLAX_PLANE Plane
 *? Reserved for use in space/parallax.
 */
#define PARALLAX_PLANE -90

#define PARALLAX_VIS_LAYER_BELOW -10000 //? Everything layering below.
#define PARALLAX_LAYER_CENTER         0
#define PARALLAX_VIS_LAYER_ABOVE  10000 //? Ditto.

/**
 *! LOOKINGGLASS_PLANE Planes
 *? For the Looking Glass holodecks.
 */
#define LOOKINGGLASS_PLANE     -77
#define PLANE_LOOKINGGLASS_IMG -76

/**
 *! OPENSPACE_PLANE Planes
 *? OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
 *? /turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
 */
#define OPENSPACE_PLANE       -75
#define OPENSPACE_PLANE_START -73
#define OPENSPACE_PLANE_END   -58
#define OVER_OPENSPACE_PLANE  -57

//! ------------------- WORLD PLANES ------------------- !//
//? Stuff that is "tangible"

/**
 *! PLATING_PLANE Plane
 * TODO: kill these too because frankly, fuck off. @silicons
 */
#define PLATING_PLANE -44

//#define TURF_LAYER        2   //! Placed for easy reference.
#define DISPOSAL_LAYER      2.1
#define PIPES_LAYER         2.2
#define WIRES_LAYER         2.3
#define ATMOS_LAYER         2.4 //? Pipe-like atmos machinery that goes on the floor, like filters.
#define ABOVE_UTILITY_LAYER 2.5 //? Above stuff like pipes and wires.

/**
 *! TURF_PLANE Plane
 *? Turfs themselves, most flooring.
 */
#define TURF_PLANE -45

#define WATER_FLOOR_LAYER   2.0  //? The 'bottom' of water tiles.
#define BUILTIN_DECAL_LAYER 2.01 //? For floors that automatically add decal overlays.
#define MAPPER_DECAL_LAYER  2.02 //? For intentionally placed floor decal overlays.
#define UNDERWATER_LAYER    2.5  //? Anything on this layer will render under the water layer.
//#define OBJ_LAYER         3    //! Placed for easy reference.
#define WATER_LAYER         3.0  //? Layer for water overlays.
#define ABOVE_TURF_LAYER    3.1  //? Snow and wallmounted/floormounted equipment.

/**
 *! DECAL_PLANE Plane
 * TODO: kill all these useless goddamn arbitrary planes and unify things to 3-5 of turf, floor, obj, mob, there is no excuse for this utter charade. @silicons
 */
#define DECAL_PLANE -44

//Obj planes
/**
 *! OBJ_PLANE Plane
 */
#define OBJ_PLANE -35

#define DEBRIS_LAYER       2.4 //? Cleanable debris.
#define STAIRS_LAYER       2.5 //? Layer for stairs.
#define HIDING_LAYER       2.6 //? Layer at which mobs hide to be under things like tables.
#define DOOR_OPEN_LAYER    2.7 //? Under all objects if opened. 2.7 due to tables being at 2.6
#define TABLE_LAYER        2.8 //? Just under stuff that wants to be slightly below common objects.
#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
#define UNDER_JUNK_LAYER   2.9 //? Things that want to be slightly below common objects.
//#define OBJ_LAYER        3   //! Placed for easy reference.
#define ABOVE_JUNK_LAYER   3.1 //? Things that want to be slightly above common objects.
#define DOOR_CLOSED_LAYER  3.1 //? Doors when closed.
#define WINDOW_LAYER       3.2 //? Windows.
#define ON_WINDOW_LAYER    3.3 //? Ontop of a window.
#define ABOVE_WINDOW_LAYER 3.4 //? Above full tile windows so wall items are clickable.
#define MID_LANDMARK_LAYER 3.5

/**
 *! MOB_PLANE Plane
 */
#define MOB_PLANE -25

#define BELOW_MOB_LAYER 3.9
//#define MOB_LAYER     4 //! Placed for easy reference.
#define ABOVE_MOB_LAYER 4.1

/**
 *! CLOAKED_PLANE Plane
 *? Invisible things plane.
 */
#define CLOAKED_PLANE -15

/**
 *! ABOVE_PLANE Plane
 *? Top plane (in the sense that it's the highest in 'the world' and not a UI element)
 */
#define ABOVE_PLANE -10

/**
 *! PLANE_WORLD Plane
 *? BYOND's default value for plane, the "base plane"
 */
#define PLANE_WORLD 0

#define HUD_LAYER    20 //? Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define SCREEN_LAYER 22 //? Mob HUD/effects layer

/**
 *! PLANE_STATUS Plane
 *? Status Indicators that show over mobs' heads when certain things like stuns affect them.
 */
#define PLANE_STATUS 2

/**
 *! PLANE_ADMIN1 Plane
 *? Purely for shenanigans (below lighting)
 * TODO: Remove this plane, it's not actually used anywhere. @Zandario
 */
#define PLANE_ADMIN1 3

/**
 *! PLANE_PLANETLIGHTING Plane
 *? Lighting on planets.
 */
#define PLANE_PLANETLIGHTING 4

/**
 *! LIGHTING_PLANE Plane
 *? Where the lighting (and darkness) lives.
 *? Normal 1 per turf dynamic lighting underlays.
 */
#define LIGHTING_PLANE 5

#define LIGHTBULB_LAYER      0
#define LIGHTING_LAYER       1
#define ABOVE_LIGHTING_LAYER 2

/**
 *! ABOVE_LIGHTING_PLANE Plane
 *? For glowy eyes etc. that shouldn't be affected by darkness.
 */
#define ABOVE_LIGHTING_PLANE 6

#define EYE_GLOW_LAYER         1
#define BEAM_PROJECTILE_LAYER  2
#define SUPERMATTER_WALL_LAYER 3

/**
 *! SONAR_PLANE Plane
 */
#define SONAR_PLANE 8

/**
 *! PLANE_GHOSTS Plane
 *? Spooooooooky ghooooooosts~
 */
#define PLANE_GHOSTS 10

/**
 *! PLANE_AI_EYE Plane
 *? The AI eye lives here
 */
#define PLANE_AI_EYE 11

/**
 *! PLANE_MESONS Plane
 *? Stuff seen with mesons, like open ceilings.
 */
#define PLANE_MESONS 30

/**
 *! PLANE_ADMIN2 Plane
 *? Purely for shenanigans (above lighting)
 * TODO: Remove this plane, it's not actually used anywhere. @Zandario
 */
#define PLANE_ADMIN2 33

/**
 *! PLANE_AUGMENTED Plane
 */
#define PLANE_AUGMENTED 40

/**
 *! FULLSCREEN_PLANE Plane
 */
#define FULLSCREEN_PLANE 90

#define OBFUSCATION_LAYER 19.9
#define FLASH_LAYER       20
#define FULLSCREEN_LAYER  20.1
#define UI_DAMAGE_LAYER   20.2
#define BLIND_LAYER       20.3
#define CRIT_LAYER        20.4
#define CURSE_LAYER       20.5

#define FULLSCREEN_RENDER_TARGET "FULLSCREEN_PLANE"

//! ------------- Client UI HUD stuff ------------- !//

/**
 *! PLANE_PLAYER_HUD Plane
 *? The character's UI is on this plane.
 */
#define PLANE_PLAYER_HUD 95

#define LAYER_HUD_UNDER 1 //? Under the HUD items.
#define LAYER_HUD_BASE  2 //? The HUD items themselves.
#define LAYER_HUD_ITEM  3 //? Things sitting on HUD items (largely irrelevant because PLANE_PLAYER_HUD_ITEMS).
#define LAYER_HUD_ABOVE 4 //? Things that reside above items (highlights).

/**
 *! PLANE_PLAYER_HUD_ITEMS Plane
 *? Separate plane with which to apply colorblindness.
 */
#define PLANE_PLAYER_HUD_ITEMS 96

/**
 *! PLANE_PLAYER_HUD_ABOVE Plane
 *? Things above the player hud.
 */
#define PLANE_PLAYER_HUD_ABOVE 97

/**
 *! PLANE_ADMIN3 Plane
 *? Purely for shenanigans (above HUD).
 * TODO: Remove this plane, it's not actually used anywhere. @Zandario
 */
///
#define PLANE_ADMIN3 99

//! ------------- PLANE MACROS ------------- !//

/// Check if a mob can "logically" see an atom plane
#define MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible) || P >= PLANE_PLAYER_HUD)
