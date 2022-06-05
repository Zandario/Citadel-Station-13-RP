GLOBAL_REAL(config, /datum/controller/configuration)

GLOBAL_DATUM(revdata, /datum/getrev)

GLOBAL_VAR_INIT(game_version, "Citadel Station RP")
GLOBAL_VAR_INIT(changelog_hash, "")
GLOBAL_VAR_INIT(hub_visibility, FALSE)

GLOBAL_VAR_INIT(ooc_allowed, TRUE) // used with admin verbs to disable ooc - not a config option apparently
GLOBAL_VAR_INIT(dooc_allowed, TRUE)
GLOBAL_VAR_INIT(enter_allowed, TRUE)
