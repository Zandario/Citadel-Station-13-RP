//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/roles/drone
	abstract_type = /datum/toml_config_entry/roles/drone
	category = parent_type::category + ".drone"

/datum/toml_config_entry/roles/drone/enabled
	key = "enabled"
	description = "Enables the Drone job."
	default = TRUE

/datum/toml_config_entry/roles/drone/max
	key = "max"
	description = "The maximum number of Drones that can be spawned in a round."
	default = 5

/datum/toml_config_entry/roles/drone/build_time
	key = "build_time"
	description = "The time it takes for a Drone a new drone to be built."
	default = 2 MINUTES
