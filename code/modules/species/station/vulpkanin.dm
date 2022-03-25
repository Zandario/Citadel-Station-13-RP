/datum/species/vulpkanin
	name = SPECIES_VULPKANIN
	name_plural = "Vulpkanin"
	icobase = 'icons/mob/human_races/species/vulpkanin/body.dmi'
	deform = 'icons/mob/human_races/species/vulpkanin/body.dmi'
	preview_icon = 'icons/mob/human_races/species/vulpkanin/preview.dmi'
//	path = /mob/living/carbon/human/vulpkanin
//	default_language = "Sol Common"
	primitive_form = "Wolpin"
	tail = "vulptail"
	tail_animation = 'icons/mob/species/vulpkanin/tail.dmi' // probably need more than just one of each, but w/e
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 5 //worse than cats, but better than lizards. -- Poojawa
//	gluttonous = 1
	color_mult = 1
	inherent_verbs = list(
		/mob/living/proc/shred_limb,
		/mob/living/carbon/human/proc/tie_hair
		)

	description = "Vulpkanin are a species of sharp-witted canine-pideds residing on the planet Altam just barely within the \
	dual-star Vazzend system. Their politically de-centralized society and independent natures have led them to become a species and \
	culture both feared and respected for their scientific breakthroughs. Discovery, loyalty, and utilitarianism dominates their lifestyles \
	to the degree it can cause conflict with more rigorous and strict authorities. They speak a guttural language known as 'Canilunzt' \
	which has a heavy emphasis on utilizing tail positioning and ear twitches to communicate intent."

	catalogue_data = list(/datum/category_item/catalogue/fauna/vulpkanin)

	primitive_form = "Wolpin"

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#966464"
	base_color = "#B43214"

	min_age = 18
	max_age = 80
