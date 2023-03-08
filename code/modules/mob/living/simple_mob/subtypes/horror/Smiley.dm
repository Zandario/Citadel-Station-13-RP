/datum/category_item/catalogue/fauna/horror/Smiley
	name = "*!UT#ON#A#HAPPY#FAC)#@$"
	desc = "%WARNING% PROCESSING FAILURE! RETURN SCANNER TO A CENTRAL \
	ADMINISTRATOR FOR IMMEDIATE MAINTENANCE! %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple/horror/Smiley
	name = "???"
	desc = "A giant hand, with a large, smiling head on top."

	icon_state = "Smiley"
	icon_living = "Smiley"
	icon_dead = "s_head"
	icon_rest = "Smiley"
	faction = "horror"
	icon = 'icons/mob/horror_show/GHPS.dmi'
	icon_gib = "generic_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/horror/Smiley)

	attack_sound = 'sound/h_sounds/holla.ogg'

	maxHealth = 175
	health = 175

	melee_damage_lower = 25
	melee_damage_upper = 35
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("amashes")
	friendly = list("nuzzles", "boops", "bumps against", "leans on")


	say_list_type = /datum/say_list/Smiley
	ai_holder_type = /datum/ai_holder/simple_mob/horror

	meat_amount = 5
	meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	bone_amount = 10
	hide_amount = 5

/mob/living/simple/horror/Smiley/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/weak)

/mob/living/simple/horror/Smiley/death()
	playsound(src, 'sound/h_sounds/lynx.ogg', 50, 1)
	..()

/mob/living/simple/horror/Helix/bullet_act()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple/horror/Helix/attack_hand()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple/horror/Helix/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)

/mob/living/simple/horror/Helix/attackby()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/datum/say_list/Smiley
	speak = list("Uuurrgh?","Aauuugghh...", "AAARRRGH!")
	emote_hear = list("shrieks horrifically", "groans in pain", "cries", "whines")
	emote_see = list("squeezes its fingers together", "shakes violently in place", "stares aggressively")
	say_maybe_target = list("Uuurrgghhh?")
	say_got_target = list("AAAHHHHH!")
