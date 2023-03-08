/mob/living/simple/slime/xenobio
	temperature_range = 5
	mob_bump_flag = SLIME

/mob/living/simple/slime/xenobio/Initialize(mapload, var/mob/living/simple/slime/xenobio/my_predecessor)
	. = ..()
	Weaken(2)
