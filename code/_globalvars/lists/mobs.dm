GLOBAL_LIST_EMPTY(admins) //all clients whom are admins
GLOBAL_LIST_EMPTY(admin_datums)
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(deadmins)							//all ckeys who have used the de-admin verb.
GLOBAL_LIST_EMPTY(stealthminID)
GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client
GLOBAL_LIST_EMPTY(clients)
GLOBAL_LIST_EMPTY(players_by_zlevel)
GLOBAL_LIST_EMPTY(round_text_log)

GLOBAL_VAR_INIT(moth_amount, 0) //Solar moth addition;

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(player_list) //all mobs **with clients attached**.
// GLOBAL_LIST_EMPTY(keyloop_list) //as above but can be limited to boost performance
GLOBAL_LIST_EMPTY(mob_list) //all mobs, including clientless
// GLOBAL_LIST_EMPTY(mob_directory) //mob_id -> mob
GLOBAL_LIST_EMPTY(alive_mob_list) //all alive mobs, including clientless. Excludes /mob/dead/new_player
// GLOBAL_LIST_EMPTY(suicided_mob_list) //contains a list of all mobs that suicided, including their associated ghosts.
GLOBAL_LIST_EMPTY(drones_list)
// GLOBAL_LIST_EMPTY(joined_player_list) //all ckeys that have joined the game at round-start or as a latejoin.
// GLOBAL_LIST_EMPTY(new_player_list) //all /mob/dead/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.
// GLOBAL_LIST_EMPTY(pre_setup_antags) //minds that have been picked as antag by the gamemode. removed as antag datums are set.
GLOBAL_LIST_EMPTY(living_mob_list) //all instances of /mob/living and subtypes
GLOBAL_LIST_EMPTY(dead_mob_list) //all dead mobs, including clientless. Excludes /mob/dead/new_player
// GLOBAL_LIST_EMPTY(carbon_list) //all instances of /mob/living/carbon and subtypes, notably does not contain brains or simple animals
GLOBAL_LIST_EMPTY(human_list) //all instances of /mob/living/carbon/human and subtypes
GLOBAL_LIST_EMPTY(silicon_list) //all silicon mobs
GLOBAL_LIST_EMPTY(ai_list) //all AIs
////GLOBAL_LIST_EMPTY(pai_list)
GLOBAL_LIST_EMPTY(available_ai_shells)
// GLOBAL_LIST_INIT(simple_animals, list(list(),list(),list(),list())) // One for each AI_* status define
// GLOBAL_LIST_EMPTY(spidermobs) //all sentient spider mobs
// GLOBAL_LIST_EMPTY(bots_list)
// GLOBAL_LIST_EMPTY(aiEyes)
GLOBAL_LIST_EMPTY(suit_sensors_list) //all people with suit sensors on
GLOBAL_LIST_EMPTY(listening_objects) //all objects which care about receiving messages (communicators, radios, etc)
