/mob/living/complex/alien/diona/say_understands(var/mob/other,var/datum/language/speaking = null)

	if (istype(other, /mob/living/complex/human) && !speaking)
		if(languages.len >= 2) // They have sucked down some blood.
			return 1
	return ..()
