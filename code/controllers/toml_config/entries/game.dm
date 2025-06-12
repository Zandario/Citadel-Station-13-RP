//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/game
	abstract_type = /datum/toml_config_entry/game
	category = "game"

/datum/toml_config_entry/game/fps
	key = "fps"
	desc = {"
		Frames per second.
		This is the target FPS for the game.
		It is used to calculate the tick length, which is used to determine how long each tick should take.
	"}
	default = 20
