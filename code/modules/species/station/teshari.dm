/datum/species/teshari
	name = SPECIES_TESHARI
	name_plural = "Tesharii"
	description = "A race of feathered raptors who developed alongside the Skrell, inhabiting \
	the polar tundral regions outside of Skrell territory. Extremely fragile, they developed \
	hunting skills that emphasized taking out their prey without themselves getting hit."
	catalogue_data = list(/datum/category_item/catalogue/fauna/teshari)
	wikilink = "https://citadel-station.net/wikiRP/index.php?title=Race:_Teshari"

	max_age = 75

	health_hud_intensity = 3

	male_cough_sounds	= list('sound/effects/mob_effects/tesharicougha.ogg','sound/effects/mob_effects/tesharicoughb.ogg')
	female_cough_sounds	= list('sound/effects/mob_effects/tesharicougha.ogg','sound/effects/mob_effects/tesharicoughb.ogg')
	male_sneeze_sound	= 'sound/effects/mob_effects/tesharisneeze.ogg'
	female_sneeze_sound	= 'sound/effects/mob_effects/tesharisneeze.ogg'
	male_scream_sound	= 'sound/effects/mob_effects/teshariscream.ogg'
	female_scream_sound	= 'sound/effects/mob_effects/teshariscream.ogg'

	blood_color = "#D514F7"
	flesh_color = "#5F7BB0"
	base_color = "#001144"
	tail = "teshtail"
//	tail_hair = "feathers"
	reagent_tag = IS_TESHARI
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken/teshari

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	icobase = 'icons/mob/human_races/r_teshari_vr.dmi'
	deform = 'icons/mob/human_races/r_teshari_vr.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_teshari.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_teshari.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_teshari.dmi'
	suit_storage_icon = 'icons/mob/species/teshari/belt_mirror.dmi'
	icobase_tail = 1
	color_mult = 1

	fire_icon_state = "generic" // Humanoid is too big for them and spriting a new one is really annoying.

	slowdown = -0.5
	snow_movement = -1 // Ignores light snow
	item_slowdown_mod = 1.25 // Tiny birds don't like heavy things
	total_health = 75
	brute_mod = 1.1
	burn_mod = 1.1
	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
	holder_type = /obj/item/holder/human
//	short_sighted = 1
	gluttonous = 1
	blood_volume = 400
	hunger_factor = 0.2

	ambiguous_genders = TRUE

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180 // Default 260
	cold_level_2 = 130 // Default 200
	cold_level_3 = 70 // Default 120

	breath_cold_level_1 = 180 // Default 240 - Lower is better
	breath_cold_level_2 = 100 // Default 180
	breath_cold_level_3 = 60 // Default 100

	heat_level_1 = 320 // Default 360
	heat_level_2 = 370 // Default 400
	heat_level_3 = 600 // Default 1000

	breath_heat_level_1 = 350 // Default 380 - Higher is better
	breath_heat_level_2 = 400 // Default 450
	breath_heat_level_3 = 800 // Default 1250

	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		"Your hands and feet feel hot as your body tries to regulate heat",
		)
	cold_discomfort_level = 180
	cold_discomfort_strings = list(
		"You feel a bit chilly.",
		"You fluff up your feathers against the cold.",
		"You move your arms closer to your body to shield yourself from the cold.",
		"You press your ears against your head to conserve heat",
		"You start to feel the cold on your skin",
		)

	minimum_breath_pressure = 12	// Smaller, so needs less air

	has_limbs = list(
		BP_TORSO	= list("path" = /obj/item/organ/external/chest),
		BP_GROIN	= list("path" = /obj/item/organ/external/groin),
		BP_HEAD		= list("path" = /obj/item/organ/external/head/teshari),
		BP_L_ARM	= list("path" = /obj/item/organ/external/arm),
		BP_R_ARM	= list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG	= list("path" = /obj/item/organ/external/leg),
		BP_R_LEG	= list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND	= list("path" = /obj/item/organ/external/hand/teshari),
		BP_R_HAND	= list("path" = /obj/item/organ/external/hand/right/teshari),
		BP_L_FOOT	= list("path" = /obj/item/organ/external/foot/teshari),
		BP_R_FOOT	= list("path" = /obj/item/organ/external/foot/right/teshari)
		)

	has_organ = list(
		O_HEART		= /obj/item/organ/internal/heart,
		O_LUNGS		= /obj/item/organ/internal/lungs,
		O_VOICE		= /obj/item/organ/internal/voicebox,
		O_LIVER		= /obj/item/organ/internal/liver,
		O_KIDNEYS	= /obj/item/organ/internal/kidneys,
		O_BRAIN		= /obj/item/organ/internal/brain,
		O_EYES		= /obj/item/organ/internal/eyes,
		O_STOMACH	= /obj/item/organ/internal/stomach,
		O_INTESTINE	= /obj/item/organ/internal/intestine
		)

	unarmed_types = list(
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/stomp/weak
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/sonar_ping,
		/mob/living/proc/hide,
		/mob/living/proc/shred_limb,
		/mob/living/proc/toggle_pass_table,
		/mob/living/carbon/human/proc/tie_hair
		)

	descriptors = list(
		/datum/mob_descriptor/height = -3,
		/datum/mob_descriptor/build = -3
		)

	var/static/list/flight_bodyparts = list(
		BP_L_ARM,
		BP_R_ARM,
		BP_L_HAND,
		BP_R_HAND
	)
	var/static/list/flight_suit_blacklisted_types = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/suit/straight_jacket
	)


	//economic_power = 6
	max_languages = 4
	//secondary_langs = list(LANGUAGE_SCHECHI, LANGUAGE_SKRELLIAN)
	//name_language = LANGUAGE_SCHECHI
	//species_language = LANGUAGE_SCHECHI


	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_TESHARI
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_QERRBALAK
		),
		TAG_FACTION = list(
		),
		TAG_RELIGION = list(
		)
	)


/datum/species/teshari/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H),slot_shoes)

/datum/species/teshari/handle_falling(mob/living/carbon/human/H, atom/hit_atom, damage_min, damage_max, silent, planetary)

	// Tesh can glide to save themselves from some falls. Basejumping bird
	// without parachute, or falling bird without free wings goes splat.

	// Are we landing from orbit, or handcuffed/unconscious/tied to something?
	if(planetary || !istype(H) || H.incapacitated())
		return ..()

	// Are we landing on a turf? Not sure how this could not be the case, but let's be safe.
	var/turf/landing = get_turf(hit_atom)
	if(!istype(landing))
		return ..()

	if(H.buckled)
		if(!silent)
			to_chat(H, SPAN_WARNING("You try to spread your wings to slow your fall, but \the [H.buckled] weighs you down!"))
		return ..()

	// Is there enough air to flap against?
	var/datum/gas_mixture/environment = landing.return_air()
	if(!environment || environment.return_pressure() < (ONE_ATMOSPHERE * 0.75))
		if(!silent)
			to_chat(H, SPAN_WARNING("You spread your wings to slow your fall, but the air is too thin!"))
		return ..()

	// Are we wearing a space suit?
	if(H.wear_suit)
		for(var/blacklisted_type in flight_suit_blacklisted_types)
			if(istype(H.wear_suit, blacklisted_type))
				if(!silent)
					to_chat(H, SPAN_WARNING("You try to spread your wings to slow your fall, but \the [H.wear_suit] is in the way!"))
				return ..()

	// Do we have working wings?
	for(var/bp in flight_bodyparts)
		var/obj/item/organ/external/E = H.organs_by_name[bp]
		if(!istype(E) || !E.is_usable() || E.is_broken() || E.is_stump())
			if(!silent)
				to_chat(H, SPAN_WARNING("You try to spread your wings to slow your fall, but they won't hold your weight!"))
			return ..()

	// Handled!
	if(!silent)
		to_chat(H, SPAN_NOTICE("You catch the air in your wings and greatly slow your fall."))
		H.visible_message(SPAN_NOTICE("\The [H] glides down from above, landing safely."))
		H.Stun(2)
		playsound(H, "rustle", 25, 1)
	return TRUE
