mob/living/silicon/robot/drone/swarm
	name = "swarm drone"
	real_name = "drone"
	icon = 'icons/mob/swarmbot.dmi'
	icon_state = "swarmer"
	faction = "swarmer"
	maxHealth = 75
	health = 75
	cell_emp_mult = 0.5
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	pass_flags = ATOM_PASS_TABLE
	braintype = "Drone"
	lawupdate = 0
	density = 1
	idcard_type = /obj/item/card/id/syndicate
	req_access = list(999)
	integrated_light_power = 3
	local_transmit = 0

	can_pull_size = ITEMSIZE_NO_CONTAINER
	can_pull_mobs = MOB_PULL_SMALLER
	can_enter_vent_with = list(
		/obj)

	mob_always_swap = 1

	softfall = TRUE

	mob_size = MOB_LARGE

	law_type = /datum/ai_laws/swarm_drone
	module_type = /obj/item/robot_module/drone/swarm

	hat_x_offset = 0
	hat_y_offset = -10

	foreign_droid = TRUE
	scrambledcodes = TRUE

	holder_type = /obj/item/holder/drone

	can_be_antagged = TRUE

	var/spell_setup = list(
		/spell/aoe_turf/conjure/swarmer,
		/spell/aoe_turf/conjure/forcewall/swarm,
		/spell/aoe_turf/blink/swarm,
		/spell/aoe_turf/conjure/swarmer/gunner,
		/spell/aoe_turf/conjure/swarmer/melee
		)

mob/living/silicon/robot/drone/swarm/Initialize(mapload)
	. = ..()

	add_language(LANGUAGE_SWARMBOT, 1)

	for(var/spell in spell_setup)
		src.add_spell(new spell, "nano_spell_ready", /atom/movable/screen/movable/spell_master/swarm)

mob/living/silicon/robot/drone/swarm/init()
	..()
	QDEL_NULL(aiCamera)
	flavor_text = "Some form of ancient machine."

mob/living/silicon/robot/drone/swarm/gunner
	name = "swarm gunner"
	real_name = "drone"
	icon = 'icons/mob/swarmbot.dmi'
	icon_state = "swarmer_ranged"
	faction = "swarmer"

	law_type = /datum/ai_laws/swarm_drone/soldier
	module_type = /obj/item/robot_module/drone/swarm/ranged

	spell_setup = list(
		/spell/aoe_turf/conjure/swarmer,
		/spell/aoe_turf/conjure/forcewall/swarm,
		/spell/aoe_turf/blink/swarm
		)

mob/living/silicon/robot/drone/swarm/melee
	name = "swarm melee"
	real_name = "drone"
	icon = 'icons/mob/swarmbot.dmi'
	icon_state = "swarmer_melee"
	faction = "swarmer"

	law_type = /datum/ai_laws/swarm_drone/soldier
	module_type = /obj/item/robot_module/drone/swarm/melee

	spell_setup = list(
		/spell/aoe_turf/conjure/swarmer,
		/spell/aoe_turf/conjure/forcewall/swarm,
		/spell/aoe_turf/blink/swarm
		)
