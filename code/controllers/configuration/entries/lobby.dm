/datum/config_entry/number/lobby_countdown
	config_entry_value = 120
	min_val = 0

/datum/config_entry/number/round_end_countdown
	config_entry_value = 180
	min_val = 0

/datum/config_entry/flag/irc_announce_new_game
	deprecated_by = /datum/config_entry/string/chat_announce_new_game

/datum/config_entry/flag/irc_announce_new_game/DeprecationUpdate(value)
	return "" //default broadcast

/datum/config_entry/string/chat_announce_new_game
	default = null

/datum/config_entry/string/chat_new_game_notifications
	default = null

/datum/config_entry/number/lobby_gamemode_vote_delay
	config_entry_value = 120
	min_val = -1		//-1 for disabled

/// if the game appears on the hub or not
/datum/config_entry/flag/hub

/datum/config_entry/number/max_hub_pop //At what pop to take hub off the server
	config_entry_value = 0 //0 means disabled
	integer = TRUE
	min_val = 0
