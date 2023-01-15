// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/landmark/spawnpoint/new_player)

/obj/landmark/spawnpoint/new_player
	name = "New Player"

/obj/landmark/spawnpoint/new_player/Initialize(mapload)
	..()
	GLOB.newplayer_start += loc
	return INITIALIZE_HINT_QDEL
