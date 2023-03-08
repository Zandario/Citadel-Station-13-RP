/mob/living/complex/human/Logout()
	..()
	if(species) species.handle_logout_special(src)
	return
