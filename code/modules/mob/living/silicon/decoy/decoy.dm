/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = TRUE // -- TLE
	canmove = 0

/mob/living/silicon/decoy/Initialize(mapload)
	. = ..()
	src.icon = 'icons/mob/AI.dmi'
	src.icon_state = "ai"
	src.anchored = TRUE
	src.canmove = 0
