//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/roles/ai
	abstract_type = /datum/toml_config_entry/roles/ai
	category = parent_type::category + ".ai"

/datum/toml_config_entry/roles/ai/enabled
	key = "enabled"
	description = "Enables the AI job."
	default = TRUE

/datum/toml_config_entry/roles/ai/shells
	key = "shells"
	description = "Enables the use of AI shells."
	default = FALSE

/datum/toml_config_entry/roles/ai/free_shell
	key = "free_shell"
	description = {"
		Enables the AI to spawn with a free shell.
		Requires AI shells to be enabled.
	"}
	default = FALSE
