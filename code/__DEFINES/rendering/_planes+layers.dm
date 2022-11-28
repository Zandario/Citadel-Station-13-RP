/**
 *! Planes and Layer Defines.
 *
 * From stddef.dm, planes & layers built into byond.
 *
 * FLOAT_LAYER      = -1
 * AREA_LAYER       =  1
 * TURF_LAYER       =  2
 * OBJ_LAYER        =  3
 * MOB_LAYER        =  4
 * FLY_LAYER        =  5
 * EFFECTS_LAYER    =  5000
 * TOPDOWN_LAYER    =  10000
 * BACKGROUND_LAYER =  20000
 * ------
 * FLOAT_PLANE      = -32767
 */

#define LOWEST_PLANE         -200

#define CLICKCATCHER_PLANE   -100

#define SPACE_PLANE           -99
#define PARALLAX_PLANE        -98
	#define PARALLAX_VIS_LAYER_BELOW -100 // everything layering below
	#define PARALLAX_LAYER_CENTER       0
	#define PARALLAX_VIS_LAYER_ABOVE  100 /// ditto

//OPENSPACE_PLANE reserves all planes between OPENSPACE_PLANE_START and OPENSPACE_PLANE_END inclusive
///turf/simulated/open will use OPENSPACE_PLANE + z (Valid z's being 2 thru 17)
#define OPENSPACE_PLANE       -75
#define OPENSPACE_PLANE_START -73
#define OPENSPACE_PLANE_END   -58
#define OVER_OPENSPACE_PLANE  -57

//Turf Planes
///Plating
#define PLATING_PLANE			-44
	#define DISPOSALS_PIPE_LAYER        1.03
	#define ABOVE_TILE_LAYER            2.05
	///Under objects, even when planeswapped
	#define DISPOSAL_LAYER		2.1
	///Under objects, even when planeswapped
	#define PIPES_LAYER			2.2
	///Under objects, even when planeswapped
	#define WIRES_LAYER			2.3
	///Pipe-like atmos machinery that goes on the floor, like filters.
	#define ATMOS_LAYER			2.4
	///Above stuff like pipes and wires
	#define ABOVE_UTILITY		2.5
///Turfs themselves, most flooring
#define TURF_PLANE				-45
	///The 'bottom' of water tiles.
	#define WATER_FLOOR_LAYER	2.0
	///For floors that automatically add decal overlays
	#define BUILTIN_DECAL_LAYER 2.01
	///For intentionally placed floor decal overlays
	#define MAPPER_DECAL_LAYER	2.02
	///Anything on this layer will render under the water layer.
	#define UNDERWATER_LAYER	2.5
	///Layer for water overlays.
	#define WATER_LAYER			3.0
	///Snow and wallmounted/floormounted equipment
	#define ABOVE_TURF_LAYER	3.1
// todo: kill all these useless goddamn arbitrary planes and unify things to 3-5 of turf, floor, obj, mob, there is no excuse for this utter charade.
#define DECAL_PLANE				-44
//Obj planes
#define OBJ_PLANE				-35
	/// cleanable debris
	#define DEBRIS_LAYER			2.4
	///Layer for stairs
	#define STAIRS_LAYER			2.5
	///Layer at which mobs hide to be under things like tables
	#define HIDING_LAYER			2.6
	///Under all objects if opened. 2.7 due to tables being at 2.6
	#define DOOR_OPEN_LAYER			2.7
	///Just under stuff that wants to be slightly below common objects.
	#define TABLE_LAYER				2.8
	#define PROJECTILE_HIT_THRESHOLD_LAYER 2.8
	///Things that want to be slightly below common objects
	#define UNDER_JUNK_LAYER		2.9
	//Turf/Obj layer boundary
	///Things that want to be slightly above common objects
	#define ABOVE_JUNK_LAYER		3.1
	///Doors when closed
	#define DOOR_CLOSED_LAYER		3.1
	///Windows
	#define WINDOW_LAYER			3.2
	///Ontop of a window
	#define ON_WINDOW_LAYER			3.3
	///Above full tile windows so wall items are clickable
	#define ABOVE_WINDOW_LAYER		3.4
	#define MID_LANDMARK_LAYER		3.5

//Mob planes
#define MOB_PLANE				-25
	#define BELOW_MOB_LAYER			3.9
	#define ABOVE_MOB_LAYER			4.1

//Invisible things plane
#define CLOAKED_PLANE			-15

//Top plane (in the sense that it's the highest in 'the world' and not a UI element)
#define ABOVE_PLANE				-10

	//define FLOAT_LAYER		-1	//For easy recordkeeping; this is a byond define

////////////////////////////////////////////////////////////////////////////////////////
///BYOND's default value for plane, the "base plane"
#define PLANE_WORLD				0
////////////////////////////////////////////////////////////////////////////////////////

	//#define AREA_LAYER		1	//For easy recordkeeping; this is a byond define

	//#define TURF_LAYER		2	//For easy recordkeeping; this is a byond define

	//#define OBJ_LAYER			3	//For easy recordkeeping; this is a byond define

	//#define MOB_LAYER			4	//For easy recordkeeping; this is a byond define

	//#define FLY_LAYER			5	//For easy recordkeeping; this is a byond define

	///Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define HUD_LAYER				20
	///Mob HUD/effects layer
#define SCREEN_LAYER			22
///Status Indicators that show over mobs' heads when certain things like stuns affect them.
#define PLANE_STATUS			2
///Purely for shenanigans (below lighting)
#define PLANE_ADMIN1			3
///Lighting on planets
#define PLANE_PLANETLIGHTING	4
///Where the lighting (and darkness) lives (ignoring all other higher planes)
#define LIGHTING_PLANE			5
	#define LIGHTBULB_LAYER			0
	#define LIGHTING_LAYER			1
	#define ABOVE_LIGHTING_LAYER	2
///For glowy eyes etc. that shouldn't be affected by darkness
#define ABOVE_LIGHTING_PLANE	6
	#define EYE_GLOW_LAYER			1
	#define BEAM_PROJECTILE_LAYER	2
	#define SUPERMATTER_WALL_LAYER	3

#define SONAR_PLANE				8

///Spooooooooky ghooooooosts
#define PLANE_GHOSTS			10
///The AI eye lives here
#define PLANE_AI_EYE			11
///Stuff seen with mesons, like open ceilings. This is 30 for downstreams.
#define PLANE_MESONS			30
///Purely for shenanigans (above lighting)
#define PLANE_ADMIN2			33
///Augmented-reality plane
#define PLANE_AUGMENTED				40
#define FULLSCREEN_PLANE 90
#define OBFUSCATION_LAYER 19.9
#define FLASH_LAYER 20
#define FULLSCREEN_LAYER 20.1
#define UI_DAMAGE_LAYER 20.2
#define BLIND_LAYER 20.3
#define CRIT_LAYER 20.4
#define CURSE_LAYER 20.5
#define FULLSCREEN_RENDER_TARGET "FULLSCREEN_PLANE"

//Client UI HUD stuff
///The character's UI is on this plane
#define PLANE_PLAYER_HUD		95
	///Under the HUD items
#define LAYER_HUD_UNDER		1
	///The HUD items themselves
#define LAYER_HUD_BASE		2
	///Things sitting on HUD items (largely irrelevant because PLANE_PLAYER_HUD_ITEMS)
#define LAYER_HUD_ITEM		3
	///Things that reside above items (highlights)
#define LAYER_HUD_ABOVE		4
///Separate layer with which to apply colorblindness
#define PLANE_PLAYER_HUD_ITEMS	96
///Things above the player hud
#define PLANE_PLAYER_HUD_ABOVE	97
///Purely for shenanigans (above HUD)
#define PLANE_ADMIN3			99
//////////////////////////

//Check if a mob can "logically" see an atom plane
#define 	MOB_CAN_SEE_PLANE(M, P) (P <= PLANE_WORLD || (P in M.planes_visible) || P >= PLANE_PLAYER_HUD)
