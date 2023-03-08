/proc/create_new_xenomorph(alien_caste, target)

	target = get_turf(target)
	if(!target || !alien_caste) return

	var/mob/living/complex/human/new_alien = new(target)
	new_alien.set_species("Xenomorph [alien_caste]")
	return new_alien

/mob/living/complex/human/xdrone
	species = /datum/species/xenos/drone
	h_style = "Bald"
	faction = "xeno"

/mob/living/complex/human/xsentinel
	species = /datum/species/xenos/sentinel
	h_style = "Bald"
	faction = "xeno"

/mob/living/complex/human/xhunter
	species = /datum/species/xenos/hunter
	h_style = "Bald"
	faction = "xeno"

/mob/living/complex/human/xqueen
	species = /datum/species/xenos/queen
	h_style = "Bald"
	faction = "xeno"

// I feel like we should generalize/condense down all the various icon-rendering antag procs.
/*----------------------------------------
Proc: AddInfectionImages()
Des: Gives the client of the alien an image on each infected mob.
----------------------------------------*/
/*
/mob/living/complex/human/proc/AddInfectionImages()
	if (client)
		for (var/mob/living/C in GLOB.mob_list)
			if(C.status_flags & XENO_HOST)
				var/obj/item/alien_embryo/A = locate() in C
				var/I = image('icons/mob/alien.dmi', loc = C, icon_state = "infected[A.stage]")
				client.images += I
	return
*/
/*----------------------------------------
Proc: RemoveInfectionImages()
Des: Removes all infected images from the alien.
----------------------------------------*/
/*
/mob/living/complex/human/proc/RemoveInfectionImages()
	if (client)
		for(var/image/I in client.images)
			if(dd_hasprefix_case(I.icon_state, "infected"))
				qdel(I)
	return
*/
