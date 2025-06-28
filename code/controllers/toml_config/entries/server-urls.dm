//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/toml_config_entry/server/urls
	abstract_type = /datum/toml_config_entry/server/urls
	category = parent_type::category + ".urls"

/datum/toml_config_entry/server/urls/ban_appeals
	key = "ban_appeals"
	desc = {"The URL for the server's ban appeals."}
	default = ""

/datum/toml_config_entry/server/urls/wiki
	key = "wiki"
	desc = {"The URL for the server's wiki."}
	default = "https://citadel-station.net/wikiRP/index.php"

/datum/toml_config_entry/server/urls/wiki_search
	key = "wiki_search"
	desc = {"The URL for the server's wiki search."}
	default = "https://citadel-station.net/wikiRP/index.php?title="

/datum/toml_config_entry/server/urls/rules
	key = "rules"
	desc = {"The URL for the server's rules."}
	default = null

/datum/toml_config_entry/server/urls/forum
	key = "forum"
	desc = {"The URL for the server's forum."}
	default = null

/datum/toml_config_entry/server/urls/discord
	key = "discord"
	desc = {"The URL for the server's Discord."}
	default = null

/datum/toml_config_entry/server/urls/github
	key = "github"
	desc = {"The URL for the server's GitHub."}
	default = "https://github.com/Citadel-Station-13/Citadel-Station-13-RP"

/datum/toml_config_entry/server/urls/map
	key = "map"
	desc = {"The URL for the server's map."}
	default = null
