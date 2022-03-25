/datum/species/monkey
	name = SPECIES_HUMAN_MONKEY
	name_plural = "Monkeys"
	description = "Ook."

	icobase = 'icons/mob/human_races/species/monkeys/monkey_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/monkey_body.dmi'
	damage_overlays = 'icons/mob/human_races/species/monkeys/damage_overlays.dmi'
	damage_mask = 'icons/mob/human_races/species/monkeys/damage_mask.dmi'
	blood_mask = 'icons/mob/human_races/species/monkeys/blood_mask.dmi'
	greater_form = SPECIES_HUMAN
	mob_size = MOB_SMALL
	has_fine_manipulation = 0
	show_ssd = null
	health_hud_intensity = 2

	gibbed_anim = "gibbed-m"
	dusted_anim = "dust-m"
	death_message = "lets out a faint chimper as it collapses and stops moving..."
	tail = "chimptail"
	fire_icon_state = "monkey"

	unarmed_types = list(/datum/unarmed_attack/bite, /datum/unarmed_attack/claws)
	inherent_verbs = list(/mob/living/proc/ventcrawl)
	hud_type = /datum/hud_data/monkey
	meat_type = /obj/item/reagent_containers/food/snacks/meat/monkey

	rarity_value = 0.1
	total_health = 75
	brute_mod = 1.5
	burn_mod = 1.5

	spawn_flags = SPECIES_IS_RESTRICTED

	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	pass_flags = PASSTABLE

	has_limbs = list(
		BP_TORSO =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/no_eyes),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_MONKEY,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return
	if(prob(33) && H.canmove && isturf(H.loc) && !H.pulledby) //won't move if being pulled
		step(H, pick(GLOB.cardinal))
	if(prob(1))
		H.emote(pick("scratch","jump","roll","tail"))

	..()

/datum/species/monkey/tajaran
	name = SPECIES_TAJARA_MONKEY
	name_plural = "Farwa"

	icobase = 'icons/mob/human_races/species/monkeys/farwa_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/farwa_body.dmi'

	greater_form = SPECIES_TAJARA
	flesh_color = "#AFA59E"
	base_color = "#333333"
	tail = "farwatail"

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_FARWA,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/skrell
	name = SPECIES_SKRELL_MONKEY
	name_plural = "Neaera"

	icobase = 'icons/mob/human_races/species/monkeys/neaera_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/neaera_body.dmi'

	greater_form = SPECIES_SKRELL
	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	reagent_tag = IS_SKRELL
	tail = null

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_NEARA,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/unathi
	name = SPECIES_UNATHI_MONKEY
	name_plural = "Stok"

	icobase = 'icons/mob/human_races/species/monkeys/stok_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/stok_body.dmi'

	tail = "stoktail"
	greater_form = SPECIES_UNATHI
	flesh_color = "#34AF10"
	base_color = "#066000"
	reagent_tag = IS_UNATHI

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_STOK,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/shark
	name = SPECIES_AKULA_MONKEY
	name_plural = "Sobaka"
	icobase = 'icons/mob/human_races/species/monkeys/sobaka_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/sobaka_body.dmi'
	tail = null //The tail is part of its body due to tail using the "icons/effects/species.dmi" file. It must be null, or they'll have a chimp tail.
	greater_form = SPECIES_AKULA

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_SOBAKA,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/sergal
	name = SPECIES_SERGAL_MONKEY
	greater_form = "Sergal"
	icobase = 'icons/mob/human_races/species/monkeys/sergaling_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/sergaling_body.dmi'
	tail = null
	greater_form = SPECIES_SERGAL

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_SERGALING,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/sparra
	name = SPECIES_NEVREAN_MONKEY
	name_plural = "Sparra"
	icobase = 'icons/mob/human_races/species/monkeys/sparra_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/sparra_body.dmi'
	tail = null
	greater_form = SPECIES_NEVREAN

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_MONKEY,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

/datum/species/monkey/vulpkanin
	name = SPECIES_VULPKANIN_MONKEY
	name_plural = "Wolpin"
	icobase = 'icons/mob/human_races/species/monkeys/wolpin_body.dmi'
	deform = 'icons/mob/human_races/species/monkeys/wolpin_body.dmi'
	tail = null
	greater_form = SPECIES_VULPKANIN
	flesh_color = "#966464"
	base_color = "#000000"

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_WOLPIN,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_TEST_SUBJECTS
	)

//INSERT CODE HERE SO MONKEYS CAN BE SPAWNED.
//Also, M was added to the end of the spawn names to signify that it's a monkey, since some names were conflicting.

/mob/living/carbon/human/sharkm/Initialize(mapload)
	..(mapload, "Sobaka")

/mob/living/carbon/human/sergallingm/Initialize(mapload)
	..(mapload, "Saru")

/mob/living/carbon/human/sparram/Initialize(mapload)
	..(mapload, "Sparra")

/mob/living/carbon/human/wolpin/Initialize(mapload)
	..(mapload, "Wolpin")
