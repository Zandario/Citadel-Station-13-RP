/datum/technomancer/spell/summon_creature
	name = "Summon Creature"
	desc = "Teleports a specific creature from their current location in the universe to the targeted tile, \
	after a delay. The creature summoned can be chosen by using the ability in your hand. \
	Available creatures are; mice, crabs, parrots, bats, goats, cats, corgis, spiders, and space carp. \
	The creatures take a few moments to be teleported to the targeted tile. Note that the creatures summoned are \
	not inherently loyal to the technomancer, and that the creatures will be hurt slightly from being teleported to you."
	enhancement_desc = "Summoned entities will never harm their summoner."
	spell_power_desc = "The strength and endurance of the summoned creature will be greater."
	cost = 100
	obj_path = /obj/item/spell/summon/summon_creature
	category = UTILITY_SPELLS

/obj/item/spell/summon/summon_creature
	name = "summon creature"
	desc = "Chitter chitter."
	summoned_mob_type = null
	summon_options = list(
		"Mouse"			=	/mob/living/simple/animal/passive/mouse,
		"Lizard"		=	/mob/living/simple/animal/passive/lizard,
		"Chicken"		=	/mob/living/simple/animal/passive/chicken,
		"Chick"			=	/mob/living/simple/animal/passive/chick,
		"Crab"			=	/mob/living/simple/animal/passive/crab,
		"Parrot"		=	/mob/living/simple/animal/passive/bird/parrot,
		"Goat"			=	/mob/living/simple/animal/goat,
		"Cat"			=	/mob/living/simple/animal/passive/cat,
		"Kitten"		=	/mob/living/simple/animal/passive/cat/kitten,
		"Corgi"			=	/mob/living/simple/animal/passive/dog/corgi,
		"Corgi Pup"		=	/mob/living/simple/animal/passive/dog/corgi/puppy,
		"BAT"			=	/mob/living/simple/animal/space/bats,
		"SPIDER"		=	/mob/living/simple/animal/giant_spider,
		"SPIDER HUNTER"	=	/mob/living/simple/animal/giant_spider/hunter,
		"SPIDER NURSE"	=	/mob/living/simple/animal/giant_spider/nurse,
		"CARP"			=	/mob/living/simple/animal/space/carp,
		"BEAR"			=	/mob/living/simple/animal/space/bear
		)
	cooldown = 30
	instability_cost = 10
	energy_cost = 1000

/obj/item/spell/summon/summon_creature/on_summon(var/mob/living/simple/summoned)
	if(check_for_scepter())
//		summoned.faction = "technomancer"
		summoned.friends += owner

	// Makes their new pal big and strong, if they have spell power.
	summoned.maxHealth = calculate_spell_power(summoned.maxHealth)
	summoned.health = calculate_spell_power(summoned.health)
	summoned.melee_damage_lower = calculate_spell_power(summoned.melee_damage_lower)
	summoned.melee_damage_upper = calculate_spell_power(summoned.melee_damage_upper)
	// This makes the summon slower, so the crew has a chance to flee from massive monsters.
	summoned.movement_cooldown = calculate_spell_power(round(summoned.movement_cooldown))

	var/new_size = calculate_spell_power(1)
	if(new_size != 1)
		adjust_scale(new_size)


	// Now we hurt their new pal, because being forcefully abducted by teleportation can't be healthy.
	summoned.adjustBruteLoss(summoned.getMaxHealth() * 0.3) // Lose 30% of max health on arrival (but could be healed back up).
