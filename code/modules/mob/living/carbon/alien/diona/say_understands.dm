/mob/living/carbon/alien/diona/say_understands(mob/other, datum/language/speaking)

	if (ishuman(other) && !speaking)
		if(languages.len >= 2) // They have sucked down some blood.
			return 1
	return ..()
