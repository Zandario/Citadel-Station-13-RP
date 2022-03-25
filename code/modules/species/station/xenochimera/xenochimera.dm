/datum/species/shapeshifter/xenochimera //Scree's race.
	name = SPECIES_XENOCHIMERA
	name_plural = "Xenochimeras"
	icobase = 'icons/mob/human_races/species/xenochimera/r_xenochimera.dmi'
	deform = 'icons/mob/human_races/species/xenochimera/r_def_xenochimera.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	rarity_value = 4
	darksight = 8		//critters with instincts to hide in the dark need to see in the dark - about as good as tajara.
	slowdown = -0.2		//scuttly, but not as scuttly as a tajara or a teshari.
	brute_mod = 0.8		//About as tanky to brute as a Unathi. They'll probably snap and go feral when hurt though.
	burn_mod =  1.15	//As vulnerable to burn as a Tajara.
	radiation_mod = 1.15	//To help simulate the volatility of a living 'viral' cluster.
	base_species = "Xenochimera"
	selects_bodytype = TRUE

	//color_mult = 1 //It seemed to work fine in testing, but I've been informed it's unneeded.
	tail = "tail" //Scree's tail. Can be disabled in the vore tab by choosing "hide species specific tail sprite"
	icobase_tail = 1
	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/carbon/human/proc/succubus_drain,
		/mob/living/carbon/human/proc/succubus_drain_finalize,
		/mob/living/carbon/human/proc/succubus_drain_lethal,
		/mob/living/carbon/human/proc/bloodsuck,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/shred_limb,
		/mob/living/proc/flying_toggle,
		/mob/living/proc/start_wings_hovering,
		/mob/living/carbon/human/proc/tie_hair,
		/mob/living/proc/eat_trash,
		/mob/living/proc/glow_toggle,
		/mob/living/proc/glow_color,
		/mob/living/carbon/human/proc/lick_wounds,
		/mob/living/carbon/human/proc/resp_biomorph,
		/mob/living/carbon/human/proc/biothermic_adapt,
		/mob/living/carbon/human/proc/atmos_biomorph,
		/mob/living/carbon/human/proc/vocal_biomorph,
		/mob/living/carbon/human/proc/shapeshifter_select_hair,
		/mob/living/carbon/human/proc/shapeshifter_select_hair_colors,
		/mob/living/carbon/human/proc/shapeshifter_select_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_eye_colour,
		/mob/living/carbon/human/proc/shapeshifter_select_gender,
		/mob/living/carbon/human/proc/shapeshifter_select_wings,
		/mob/living/carbon/human/proc/shapeshifter_select_tail,
		/mob/living/carbon/human/proc/shapeshifter_select_ears,
		/mob/living/carbon/human/proc/shapeshifter_select_shape,
		/mob/living/carbon/human/proc/commune
		) //Xenochimera get all the special verbs since they can't select traits.

	inherent_spells = list(
		/spell/targeted/chimera/thermal_sight,
		/spell/targeted/chimera/voice_mimic,
		/spell/targeted/chimera/regenerate,
		/spell/targeted/chimera/hatch,
		/spell/targeted/chimera/no_breathe
	)

	var/list/feral_spells = list(
		/spell/aoe_turf/dissonant_shriek
	)

	var/list/removable_spells = list()

	var/has_feral_spells = FALSE
	virus_immune = 1 // They practically ARE one.
	min_age = 18
	max_age = 200

	description = "Some amalgamation of different species from across the universe,with extremely unstable DNA, making them unfit for regular cloners. \
	Widely known for their voracious nature and violent tendencies when stressed or left unfed for long periods of time. \
	Most, if not all chimeras possess the ability to undergo some type of regeneration process, at the cost of energy."

	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_The_Xenochimera"

	catalogue_data = list(/datum/category_item/catalogue/fauna/xenochimera)

	breath_type = /datum/gas/oxygen
	poison_type = /datum/gas/phoron
	exhale_type = /datum/gas/carbon_dioxide

	hazard_high_pressure = HAZARD_HIGH_PRESSURE
	warning_high_pressure = WARNING_HIGH_PRESSURE
	warning_low_pressure = WARNING_LOW_PRESSURE
	hazard_low_pressure = -1 //Prevents them from dying normally in space. Special code handled below.
	safe_pressure = ONE_ATMOSPHERE

	cold_level_1 = -1     // All cold debuffs are handled below in handle_environment_special
	cold_level_2 = -1
	cold_level_3 = -1

	cold_discomfort_level = 285
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your chilly flesh stands out in goosebumps."
		)

	heat_discomfort_level = 315
	heat_discomfort_strings = list(
		"You feel sweat drip down your neck.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)

	valid_transform_species = list(
		"Human", "Unathi", "Tajara", "Skrell",
		"Diona", "Teshari", "Monkey","Sergal",
		"Akula","Nevrean","Highlander Zorren",
		"Flatland Zorren", "Vulpkanin", "Vasilissan",
		"Rapala", "Neaera", "Stok", "Farwa", "Sobaka",
		"Wolpin", "Saru", "Sparra", "Vox")

	//primitive_form = "Farwa"

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_WHITELIST_SELECTABLE//Whitelisted as restricted is broken.
	flags = NO_SCAN | NO_INFECT | NO_DEFIB //Dying as a chimera is, quite literally, a death sentence. Well, if it wasn't for their revive, that is.
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart/xenochimera,
		O_LUNGS =    /obj/item/organ/internal/lungs/xenochimera,
		O_VOICE = 		/obj/item/organ/internal/voicebox/xenochimera,
		O_LIVER =    /obj/item/organ/internal/liver/xenochimera,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys/xenochimera,
		O_BRAIN =    /obj/item/organ/internal/brain/xenochimera,
		O_EYES =     /obj/item/organ/internal/eyes/xenochimera,
		O_STOMACH =		/obj/item/organ/internal/stomach/xenochimera,
		O_INTESTINE =	/obj/item/organ/internal/intestine/xenochimera
		)

	heal_rate = 0.5
	infect_wounds = 1
	flesh_color = "#AFA59E"
	base_color 	= "#333333"
	blood_color = "#14AD8B"

	reagent_tag = IS_CHIMERA

/datum/species/shapeshifter/xenochimera/handle_environment_special(var/mob/living/carbon/human/H)
	//If they're KO'd/dead, they're probably not thinking a lot about much of anything.
	if(!H.stat)
		handle_feralness(H)

	//While regenerating
	if(H.revive_ready == REVIVING_NOW || H.revive_ready == REVIVING_DONE)
		H.weakened = 5
		H.canmove = 0
		H.does_not_breathe = TRUE

	//Cold/pressure effects when not regenerating
	else
		var/datum/gas_mixture/environment = H.loc.return_air()
		var/pressure2 = environment.return_pressure()
		var/adjusted_pressure2 = H.calculate_affecting_pressure(pressure2)

		//Very low pressure damage
		if(adjusted_pressure2 <= 20)
			H.take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")

		//Cold hurts and gives them pain messages, eventually weakening and paralysing, but doesn't damage or trigger feral.
		//NB: 'body_temperature' used here is the 'setpoint' species var
		var/temp_diff = body_temperature - H.bodytemperature
		if(temp_diff >= 50)
			H.shock_stage = min(H.shock_stage + (temp_diff/20), 160) // Divided by 20 is the same as previous numbers, but a full scale
			H.eye_blurry = max(5,H.eye_blurry)
	..()
