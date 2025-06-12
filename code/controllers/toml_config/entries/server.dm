//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/server
	abstract_type = /datum/toml_config_entry/server
	category = "server"

/datum/toml_config_entry/server/name
	key = "name"
	desc = {"
		Server name, displayed in the main menu and in the server list.
		This is not the same as the station name, which is set in the map file.
		You can use this to set a custom name for your server.
	"}
	default = "Citadel Station 13 RP"
