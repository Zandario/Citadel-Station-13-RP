/*
A work in progress, lore will go here later.
List of things solar grubs should be able to do:

2. have three stages of growth depending on time. (Or energy drained altho that seems like a hard one to code)
3. be capable of eating people that get knocked out. (also be able to shock attackers that don’t wear insulated gloves.)
5. ((potentially use digested people to reproduce))
6. add glow?
*/

GLOBAL_LIST_EMPTY(solargrubs)

/datum/category_item/catalogue/fauna/solargrub		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Solargrub"
	desc = "Some form of mutated space larva, they seem to crop up on space stations wherever there is power. \
	They seem to have the chance to cocoon and mutate if left alone, but no recorded instances of this have happened yet. \
	Therefore, if you see the grubs, kill them while they're small, or things might escalate." // TODO: PORT SOLAR MOTHS - Rykka
	value = CATALOGUER_REWARD_EASY

#define SINK_POWER 1

/mob/living/simple_mob/vore/solargrub
	name = "Juvenile solargrub"
	desc = "A young sparkling solargrub"
	catalogue_data = list(/datum/category_item/catalogue/fauna/solargrub)
	icon = 'icons/mob/vore.dmi' //all of these are placeholders
	icon_state = "solargrub"
	icon_living = "solargrub"
	icon_dead = "solargrub-dead"

	// CHOMPEDIT Start, Rykka waz here. *pawstamp*; CitRP: Make moth spawning thingy's, read coms;
	var/charge = null // CHOMPEDIT The amount of power we sucked off, in K as in THOUSANDS.
	var/can_evolve = 1 // CHOMPEDIT VAR to decide whether this subspecies is allowed to become a queen
	var/list/adult_forms = list(/mob/living/simple_mob/vore/solarmoth = 70, /mob/living/simple_mob/vore/solarmoth/lunarmoth=30) // CHOMPEDIT VAR that decides what mob the queen form is; CitRP: Makes spawn of lunarmoths possible.
	//var/adult_forms = "/mob/living/simple_mob/vore/solarmoth" // CHOMPEDIT VAR that decides what mob the queen form is. ex /mob/living/simple_mob/subtypes/vore/solarmoth; CitRP: Without lunarmoth, quoted out for fun;
	// CHOMPEDIT End, Rykka waz here. *pawstamp*

	faction = "grubs"
	maxHealth = 50 //grubs can take a lot of harm
	health = 50

	melee_damage_lower = 1
	melee_damage_upper = 3	//low damage, but poison and stuns are strong

	movement_cooldown = 8

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/grubmeat

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/solargrub
	say_list_type = /datum/say_list/solargrub

	var/poison_per_bite = 5 //grubs cause a shock when they bite someone
	var/poison_type = "shockchem"
	var/poison_chance = 50
	var/datum/powernet/PN            // Our powernet
	var/obj/structure/cable/attached        // the attached cable
	var/shock_chance = 10 // Beware
	var/powerdraw = 100000 // previous value 150000 // CHOMPStation Addition, Rykka waz here. *pawstamp*; CitRP: It's for the solarmoth spawn thingy

/mob/living/simple_mob/vore/solargrub/Initialize(mapload)
	GLOB.solargrubs += src
	return ..()

/mob/living/simple_mob/vore/solargrub/Destroy()
	GLOB.solargrubs -= src
	return ..()

/datum/say_list/solargrub
	emote_see = list("squelches", "squishes")

//	This funny bit is questionable atm
// /mob/living/simple_mob/vore/solargrub/New()
//	existing_solargrubs += src
//	..()

/mob/living/simple_mob/vore/solargrub/Life()
	. = ..()
	if(!.) return

	if(!ai_holder.target)
			//first, check for potential cables nearby to powersink
		var/turf/S = loc
		attached = locate(/obj/structure/cable) in S
		if(attached)
			set_AI_busy(TRUE)
			if(prob(2))
				src.visible_message("<span class='notice'>\The [src] begins to sink power from the net.</span>")
			if(prob(5))
				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread()
				sparks.set_up(5, 0, get_turf(src))
				sparks.start()
			anchored = 1
			PN = attached.powernet
			PN.draw_power(powerdraw) // previous value 150000 // CHOMPEDIT Start, Rykka waz here. *pawstamp*
			charge = charge + (powerdraw/1000) //This adds raw powerdraw to charge(Charge is in Ks as in 1 = 1000) // CHOMPEDIT End, Rykka waz here. *pawstamp*
			var/apc_drain_rate = 750 //Going to see if grubs are better as a minimal bother. previous value : 4000
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				if(istype(T.master, /obj/machinery/power/apc))
					var/obj/machinery/power/apc/A = T.master
					if(A.operating && A.cell)
						var/cur_charge = A.cell.charge / CELLRATE
						var/drain_val = min(apc_drain_rate, cur_charge)
						A.cell.use(drain_val * CELLRATE)
		else if(!attached && anchored)
			anchored = 0
			PN = null

		// CHOMPEDIT Start, Rykka waz here. *pawstamp*
		if(prob(1) && charge >= 32000 && can_evolve == 1) // CitRP: We can quote this out and see what happens; && moth_amount <= 1) //it's reading from the moth_amount global list to determine if it can evolve. There should only ever be a maxcap of 1 existing solar moth alive at any time. TODO: make the code decrease the list after 1 has spawned this shift.
			anchored = 0
			PN = attached.powernet
			release_vore_contents()
			prey_excludes.Cut()
			GLOB.moth_amount += 1 //CitRP: There was some magic going on around this here part, it might actualy be working.
			death_star()

/mob/living/simple_mob/vore/solargrub/proc/death_star()
	visible_message("<span class='warning'>\The [src]'s shell rips open and evolves!</span>")
	var/chosen_form = pickweight(adult_forms)
	new chosen_form(get_turf(src))
	qdel(src)

/mob/living/simple_mob/vore/solargrub //active noms
	vore_bump_chance = 50
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 0 //grubs only eat incapacitated targets
	vore_default_mode = DM_DIGEST

/mob/living/simple_mob/vore/solargrub/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(shock_chance))
			A.emp_act(4) //The weakest strength of EMP
			playsound(src, 'sound/weapons/Egloves.ogg', 75, 1)
			L.Weaken(4)
			L.Stun(4)
			L.stuttering = max(L.stuttering, 4)
			var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
			sparks.set_up(5, 1, L)
			sparks.start()
			visible_message("<span class='danger'>The grub releases a powerful shock!</span>")
		else
			if(L.reagents)
				var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
				if(L.can_inject(src, null, target_zone))
					inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/vore/solargrub/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel a small shock rushing through your veins.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_mob/vore/solargrub/death()
	src.anchored = 0
	set_light(0)
	..()
//	This funny bit is questionable atm
// /mob/living/simple_mob/vore/solargrub/Destroy()
//	existing_solargrubs -= src
//	..()

/mob/living/simple_mob/vore/solargrub/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_YELLOW)
		return 1

/datum/ai_holder/simple_mob/retaliate/solargrub/react_to_attack(atom/movable/attacker)
	holder.anchored = 0
	holder.set_AI_busy(FALSE)
	..()
