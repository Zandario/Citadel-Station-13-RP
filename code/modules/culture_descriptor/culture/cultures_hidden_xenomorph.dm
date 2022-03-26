/decl/cultural_info/culture/hidden/xenomorph
	name = CULTURE_XENOMORPH_D
	language = LANGUAGE_XENOMORPH
	default_language = LANGUAGE_XENOMORPH
	additional_langs = list(LANGUAGE_XENOMORPH_HIVE)
	var/caste_name = "drone"
	var/caste_number = 0

/decl/cultural_info/culture/hidden/xenomorph/get_random_name()
	return "alien [caste_name] ([caste_number])"

/decl/cultural_info/culture/hidden/xenomorph/hunter
	name = CULTURE_XENOMORPH_H
	caste_name = "hunter"

/decl/cultural_info/culture/hidden/xenomorph/sentinel
	name = CULTURE_XENOMORPH_S
	caste_name = "sentinel"

/decl/cultural_info/culture/hidden/xenomorph/queen
	name = CULTURE_XENOMORPH_Q
	caste_name = "queen"

/decl/cultural_info/culture/hidden/xenomorph/queen/get_random_name(var/mob/living/carbon/human/queen)
	if(!istype(queen) || !alien_queen_exists(1, queen))
		return "alien queen ([caste_number])"
	else
		return "alien princess ([caste_number])"
