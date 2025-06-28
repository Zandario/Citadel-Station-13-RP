//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/game/chat
	abstract_type = /datum/toml_config_entry/game/chat
	category = parent_type::category + ".chat"

/datum/toml_config_entry/game/chat/language_prefixes
	key = "language_prefixes"
	desc = {"
		List of prefixes used to denote languages in chat.
		These are used to determine what language a message is in, and how it should be displayed.
	"}
	default = list(",", "#")
