//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/server
	abstract_type = /datum/toml_config_entry/server
	category = "server"

/datum/toml_config_entry/server/name
	key = "name"
	desc = {"The name of the server, used in the world name and status."}
	default = "Citadel Station 13 RP"

/datum/toml_config_entry/server/address
	key = "address"
	desc = {"The address of the server, used in the world name and status."}
	default = "localhost"

/datum/toml_config_entry/server/port
	key = "port"
	desc = {"The port of the server, used in the world name and status."}
	default = 1337
