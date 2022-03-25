/datum/unit_test/culture/Run()
	var/fails = 0
	for(var/species_name in GLOB.all_species)
		var/datum/species/species = GLOB.all_species[species_name]
		if(!islist(species.default_cultural_info))
			fails++
			Fail("Default cultural info for [species_name] is not a list.")
		else
			for(var/token in species.default_cultural_info)
				if(!(token in ALL_CULTURAL_TAGS))
					fails++
					Fail("Default cultural info for [species_name] contains invalid tag '[token]'.")
				else
					var/val = species.default_cultural_info[token]
					if(!val)
						fails++
						Fail("Default cultural value '[val]' for [species_name] tag '[token]' is null, must be a string.")
					else if(!istext(val))
						fails++
						Fail("Default cultural value '[val]' for [species_name] tag '[token]' is an invalid type, must be a string.")
					else
						var/decl/cultural_info/culture = SSculture.get_culture(val)
						if(!istype(culture))
							fails++
							Fail("Default cultural value '[val]' for [species_name] tag '[token]' is not a valid culture label.")
						else if(culture.category != token)
							fails++
							Fail("Default cultural value '[val]' for [species_name] tag '[token]' does not match culture datum category ([culture.category] must equal [token]).")
						else if(!culture.description)
							fails++
							Fail("Default cultural value '[val]' for [species_name] tag '[token]' does not have a description set.")

		if(!islist(species.force_cultural_info))
			fails++
			Fail("Forced cultural info for [species_name] is not a list.")
		else
			for(var/token in species.force_cultural_info)
				if(!(token in ALL_CULTURAL_TAGS))
					fails++
					Fail("Forced cultural info for [species_name] contains invalid tag '[token]'.")
				else
					var/val = species.force_cultural_info[token]
					if(!val)
						fails++
						Fail("Forced cultural value for [species_name] tag '[token]' is null, must be a string.")
					else if(!istext(val))
						fails++
						Fail("Forced cultural value for [species_name] tag '[token]' is an invalid type, must be a string.")
					else
						var/decl/cultural_info/culture = SSculture.get_culture(val)
						if(!istype(culture))
							fails++
							Fail("Forced cultural value '[val]' for [species_name] tag '[token]' is not a valid culture label.")
						else if(culture.category != token)
							fails++
							Fail("Forced cultural value '[val]' for [species_name] tag '[token]' does not match culture datum category ([culture.category] must equal [token]).")
						else if(!culture.description)
							fails++
							Fail("Forced cultural value '[val]' for [species_name] tag '[token]' does not have a description set.")

		if(!islist(species.available_cultural_info))
			fails++
			Fail("Available cultural info for [species_name] is not a list.")
		else
			for(var/token in ALL_CULTURAL_TAGS)
				if(!islist(species.available_cultural_info[token]))
					fails++
					Fail("Available cultural info for [species_name] tag '[token]' is invalid type, must be a list.")
				else if(!LAZYLEN(species.available_cultural_info[token]))
					fails++
					Fail("Available cultural info for [species_name] tag '[token]' is empty, must have at least one entry.")
				else
					for(var/val in species.available_cultural_info[token])
						var/decl/cultural_info/culture = SSculture.get_culture(val)
						if(!istype(culture))
							fails++
							Fail("Available cultural value '[val]' for [species_name] tag '[token]' is not a valid culture label.")
						else if(culture.category != token)
							fails++
							Fail("Available cultural value '[val]' for [species_name] tag '[token]' does not match culture datum category ([culture.category] must equal [token]).")
						else if(!culture.description)
							fails++
							Fail("Available cultural value '[val]' for [species_name] tag '[token]' does not have a description set.")

	if(fails > 0)
		Fail("[fails] invalid cultural value(s)")
	else
		pass("All cultural values are valid.")
	return TRUE
