//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/game/chat/toggles
	abstract_type = /datum/toml_config_entry/game/chat/toggles
	category = "game.chat.toggles"

/datum/toml_config_entry/game/chat/toggles/ooc
	key = "ooc"
	desc = "Whether OOC chat is allowed on the server."
	default = TRUE

/datum/toml_config_entry/game/chat/toggles/looc
	key = "looc"
	desc = "Whether LOOC chat is allowed on the server."
	default = TRUE

/datum/toml_config_entry/game/chat/toggles/dooc
	key = "dooc"
	desc = "Whether DOOC chat is allowed on the server."
	default = TRUE

/datum/toml_config_entry/game/chat/toggles/dsay
	key = "dsay"
	desc = "Whether DSAY chat is allowed on the server."
	default = TRUE
