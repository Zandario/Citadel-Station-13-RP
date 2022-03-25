/datum/species/akula
	name = SPECIES_AKULA
	name_plural = "Akula"
	icobase = 'icons/mob/human_races/species/akula/r_akula.dmi'
	deform = 'icons/mob/human_races/species/akula/r_def_akula.dmi'
	tail = "tail"
	icobase_tail = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	//darksight = 8
	//slowdown = -0.5
	//brute_mod = 1.15
	//burn_mod =  1.15
	//gluttonous = 1
	color_mult = 1
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair
		)

	min_age = 18
	max_age = 80

	description = "The Akula are a species of amphibious humanoids like the Skrell, but have an appearance very similar to that of a shark. \
	They were first discovered as a primitive race of underwater dwelling tribal creatures by the Skrell. At first they were not believed \
	to be noteworthy, but the Akula proved to be such swift and clever learners that the Skrell reclassified them as sentients. Allegedly, \
	the Akula were also the first sentient life that the Skrell had ever encountered beside themselves, and thus the two species became swift \
	allies over the next few hundred years. With the help of Skrellean technology, the Akula had their genome modified to be capable of \
	surviving in open air for long periods of time. However, Akula even today still require a high humidity environment to avoid drying out \
	after a few days, which would make life on an arid world like Virgo-Prime nearly impossible if it were not for Skrellean technology to aid them."

	wikilink="https://citadel-station.net/wikiRP/index.php?title=Akula"

	catalogue_data = list(/datum/category_item/catalogue/fauna/akula)

	primitive_form = "Sobaka"

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#777777"
	blood_color = "#1D2CBF"

	available_cultural_info = list(
		TAG_CULTURE =   list(CULTURE_OTHER),
		TAG_HOMEWORLD = list(HOME_SYSTEM_OTHER),
		TAG_FACTION =   list(FACTION_OTHER),
		TAG_RELIGION =  list(RELIGION_OTHER)
	)

/datum/species/akula/can_breathe_water()
	return TRUE // Surprise, SHERKS.
