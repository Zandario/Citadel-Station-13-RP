/datum/species/shapeshifter/xenochimera/add_inherent_spells(var/mob/living/carbon/human/H)
	var/master_type = /atom/movable/screen/movable/spell_master/chimera
	var/atom/movable/screen/movable/spell_master/chimera/new_spell_master = new master_type

	if(!H.spell_masters)
		H.spell_masters = list()

	if(H.client)
		H.client.screen += new_spell_master
	new_spell_master.spell_holder = H
	H.spell_masters.Add(new_spell_master)

	for(var/spell_to_add in inherent_spells)
		var/spell/S = new spell_to_add(H)
		H.add_spell(S, "cult", master_type)

/datum/species/shapeshifter/xenochimera/proc/add_feral_spells(var/mob/living/carbon/human/H)
	if(!has_feral_spells)
		var/check = FALSE
		var/master_type = /atom/movable/screen/movable/spell_master/chimera
		for(var/spell/S as anything in feral_spells)
			var/spell/spell_to_add = new S(H)
			check = H.add_spell(spell_to_add, "cult", master_type)
			removable_spells += spell_to_add
		if(check)
			has_feral_spells = TRUE
		else
			return
	else
		return

/datum/species/shapeshifter/xenochimera/proc/remove_feral_spells(var/mob/living/carbon/human/H)
	for(var/spell/S as anything in removable_spells)
		S.remove_self(H)
	removable_spells.Cut()
	has_feral_spells = FALSE

/datum/species/shapeshifter/xenochimera/handle_post_spawn(mob/living/carbon/human/H)
	..()
	for(var/spell/S as anything in feral_spells)
		S = new S(H)

/datum/species/shapeshifter/xenochimera/proc/handle_feralness(var/mob/living/carbon/human/H)

	//Low-ish nutrition has messages and eventually feral
	var/hungry = H.nutrition <= 200

	//At 360 nutrition, this is 30 brute/burn, or 18 halloss. Capped at 50 brute/30 halloss - if they take THAT much, no amount of satiation will help them. Also they're fat.
	var/shock = H.traumatic_shock > min(60, H.nutrition/10)

	//Caffeinated xenochimera can become feral and have special messages
	var/jittery = H.jitteriness >= 100

	//To reduce distant object references
	var/feral = H.feral

//Are we in danger of ferality?
	var/danger = FALSE
	var/feral_state = FALSE

//Handle feral triggers and pre-feral messages
	if(!feral && (hungry || shock || jittery))

		// If they're hungry, give nag messages (when not bellied)
		if(H.nutrition >= 100 && prob(0.5) && !isbelly(H.loc))
			switch(H.nutrition)
				if(150 to 200)
					to_chat(H,"<span class='info'>You feel rather hungry. It might be a good idea to find some some food...</span>")
				if(100 to 150)
					to_chat(H,"<span class='warning'>You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat...</span>")
					danger = TRUE

		// Going feral due to hunger
		else if(H.nutrition < 100 && !isbelly(H.loc))
			to_chat(H,"<span class='danger'><big>Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.</big></span>")
			log_and_message_admins("has gone feral due to hunger.", H)
			feral = 5
			danger = TRUE
			feral_state = TRUE
			if(!H.stat)
				H.emote("twitch")

		// If they're hurt, chance of snapping.
		else if(shock)

			//If the majority of their shock is due to halloss, greater chance of snapping.
			if(2.5*H.halloss >= H.traumatic_shock)
				if(prob(min(10,(0.2 * H.traumatic_shock))))
					to_chat(H,"<span class='danger'><big>The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...</big></span>")
					log_and_message_admins("has gone feral due to halloss.", H)
					feral = 5
					danger = TRUE
					feral_state = TRUE
					if(!H.stat)
						H.emote("twitch")

			//Majority due to other damage sources
			else if(prob(min(10,(0.1 * H.traumatic_shock))))
				to_chat(H,"<span class='danger'><big>Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.</big></span>")
				feral = 5
				danger = TRUE
				feral_state = TRUE
				log_and_message_admins("has gone feral due to injury.", H)
				if(!H.stat)
					H.emote("twitch")

		//No hungry or shock, but jittery
		else if(jittery)
			to_chat(H,"<span class='warning'><big>Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!</big></span>")
			feral = 5
			danger = TRUE
			feral_state = TRUE
			log_and_message_admins("has gone feral due to jitteriness.", H)
			if(!H.stat)
				H.emote("twitch")

	// Handle being feral
	if(feral)
		//we're feral
		feral_state = TRUE

		//We check if the current spell list already has feral spells.
		if(!has_feral_spells)
			add_feral_spells(H)

		//Shock due to mostly halloss. More feral.
		if(shock && 2.5*H.halloss >= H.traumatic_shock)
			danger = TRUE
			feral = max(feral, H.halloss)

		//Shock due to mostly injury. More feral.
		else if(shock)
			danger = TRUE
			feral = max(feral, H.traumatic_shock * 2)

		//Still jittery? More feral.
		if(jittery)
			danger = TRUE
			feral = max(feral, H.jitteriness-100)

		//Still hungry? More feral.
		if(H.feral + H.nutrition < 150)
			danger = TRUE
			feral++
		else
			feral = max(0,--feral)

		//Set our real mob's var to our temp var
		H.feral = feral

		//Did we just finish being feral?
		if(!feral)
			feral_state = FALSE
			if(has_feral_spells)
				remove_feral_spells(H)
			to_chat(H,"<span class='info'>Your thoughts start clearing, your feral urges having passed - for the time being, at least.</span>")
			log_and_message_admins("is no longer feral.", H)
			update_xenochimera_hud(H, danger, feral_state)
			return

		//If they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.
		H.shock_stage = max(H.shock_stage-(feral/20), 0)

		//Handle light/dark areas
		var/turf/T = get_turf(H)
		if(!T)
			update_xenochimera_hud(H, danger, feral_state)
			return //Nullspace
		var/darkish = T.get_lumcount() <= 0.1

		//Don't bother doing heavy lifting if we weren't going to give emotes anyway.
		if(!prob(1))

			//This is basically the 'lite' version of the below block.
			var/list/nearby = H.living_mobs(world.view)

			//Not in the dark and out in the open.
			if(!darkish && isturf(H.loc))

				//Always handle feral if nobody's around and not in the dark.
				if(!nearby.len)
					H.handle_feral()

				//Rarely handle feral if someone is around
				else if(prob(1))
					H.handle_feral()

			//And bail
			update_xenochimera_hud(H, danger, feral_state)
			return

		// In the darkness or "hidden". No need for custom scene-protection checks as it's just an occational infomessage.
		if(darkish || !isturf(H.loc))
			// If hurt, tell 'em to heal up
			if (shock)
				to_chat(H,"<span class='info'>This place seems safe, secure, hidden, a place to lick your wounds and recover...</span>")

			//If hungry, nag them to go and find someone or something to eat.
			else if(hungry)
				to_chat(H,"<span class='info'>Secure in your hiding place, your hunger still gnaws at you. You need to catch some food...</span>")

			//If jittery, etc
			else if(jittery)
				to_chat(H,"<span class='info'>sneakysneakyyesyesyescleverhidingfindthingsyessssss</span>")

			//Otherwise, just tell them to keep hiding.
			else
				to_chat(H,"<span class='info'>...safe...</span>")

		// NOT in the darkness
		else

			//Twitch twitch
			if(!H.stat)
				H.emote("twitch")

			var/list/nearby = H.living_mobs(world.view)

			// Someone/something nearby
			if(nearby.len)
				var/M = pick(nearby)
				if(shock)
					to_chat(H,"<span class='danger'>You're hurt, in danger, exposed, and [M] looks to be a little too close for comfort...</span>")
				else if(hungry || jittery)
					to_chat(H,"<span class='danger'>Every movement, every flick, every sight and sound has your full attention, your hunting instincts on high alert... In fact, [M] looks extremely appetizing...</span>")

			// Nobody around
			else
				if(hungry)
					to_chat(H,"<span class='danger'>Confusing sights and sounds and smells surround you - scary and disorienting it may be, but the drive to hunt, to feed, to survive, compels you.</span>")
				else if(jittery)
					to_chat(H,"<span class='danger'>yesyesyesyesyesyesgetthethingGETTHETHINGfindfoodsfindpreypounceyesyesyes</span>")
				else
					to_chat(H,"<span class='danger'>Confusing sights and sounds and smells surround you, this place is wrong, confusing, frightening. You need to hide, go to ground...</span>")

	// HUD update time
	update_xenochimera_hud(H, danger, feral_state)

/datum/species/shapeshifter/xenochimera/proc/produceCopy(var/datum/species/to_copy,var/list/traits,var/mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = GLOB.all_species[to_copy]

	var/datum/species/shapeshifter/xenochimera/new_copy = new()

	//Initials so it works with a simple path passed, or an instance
	new_copy.base_species = to_copy.name
	new_copy.icobase = to_copy.icobase
	new_copy.deform = to_copy.deform
	new_copy.tail = to_copy.tail
	new_copy.tail_animation = to_copy.tail_animation
	new_copy.icobase_tail = to_copy.icobase_tail
	new_copy.color_mult = to_copy.color_mult
	new_copy.primitive_form = to_copy.primitive_form
	new_copy.appearance_flags = to_copy.appearance_flags
	new_copy.flesh_color = to_copy.flesh_color
	new_copy.base_color = to_copy.base_color
	new_copy.blood_mask = to_copy.blood_mask
	new_copy.damage_mask = to_copy.damage_mask
	new_copy.damage_overlays = to_copy.damage_overlays

	//Set up a mob
	H.species = new_copy
	H.icon_state = lowertext(new_copy.get_bodytype())

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy

/datum/species/shapeshifter/xenochimera/get_bodytype()
	return base_species

/datum/species/shapeshifter/xenochimera/get_race_key()
	var/datum/species/real = GLOB.all_species[base_species]
	return real.race_key

/datum/species/shapeshifter/xenochimera/proc/update_xenochimera_hud(var/mob/living/carbon/human/H, var/danger, var/feral)
	if(H.xenochimera_danger_display)
		H.xenochimera_danger_display.invisibility = 0
		if(danger && feral)
			H.xenochimera_danger_display.icon_state = "danger11"
		else if(danger && !feral)
			H.xenochimera_danger_display.icon_state = "danger10"
		else if(!danger && feral)
			H.xenochimera_danger_display.icon_state = "danger01"
		else
			H.xenochimera_danger_display.icon_state = "danger00"

	return

/atom/movable/screen/xenochimera
	icon = 'icons/mob/chimerahud.dmi'
	invisibility = 101

/atom/movable/screen/xenochimera/danger_level
	name = "danger level"
	icon_state = "danger00"		//first number is bool of whether or not we're in danger, second is whether or not we're feral
	alpha = 200

/mob/living/carbon/human/proc/reconstitute_form() //Scree's race ability.in exchange for: No cloning.
	set name = "Reconstitute Form"
	set category = "Abilities"

	// Sanity is mostly handled in chimera_regenerate()

	var/confirm = alert(usr, "Are you sure you want to completely reconstruct your form? This process can take up to twenty minutes, depending on how hungry you are, and you will be unable to move.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		chimera_regenerate()

/mob/living/carbon/human/proc/chimera_regenerate()
	//If they're already regenerating
	switch(revive_ready)
		if(REVIVING_NOW)
			to_chat(src, "You are already reconstructing, just wait for the reconstruction to finish!")
			return
		if(REVIVING_DONE)
			to_chat(src, "Your reconstruction is done, but you need to hatch now.")
			return
	if(revive_ready > world.time)
		to_chat(src, "You can't use that ability again so soon!")
		return

	var/nutrition_used = nutrition * 0.5
	var/time = (240+960/(1 + nutrition_used/75))

	//Clicked regen while dead.
	if(stat == DEAD)

		//Has nutrition and dead, allow regen.
		if(hasnutriment())
			to_chat(src, "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds.")

			//Scary spawnerization.
			revive_ready = REVIVING_NOW
			spawn(time SECONDS)
				// Was dead, now not dead.
				if(stat != DEAD)
					to_chat(src, "<span class='notice'>Your body has recovered from its ordeal, ready to regenerate itself again.</span>")
					revive_ready = REVIVING_READY //reset their cooldown

				// Was dead, still dead.
				else
					to_chat(src, "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch.</span>")
					verbs |= /mob/living/carbon/human/proc/hatch
					revive_ready = REVIVING_DONE

		//Dead until nutrition injected.
		else
			to_chat(src, "<span class='warning'>Your body is too damaged to regenerate without additional nutrients to feed what few living cells remain.</span>")

	//Clicked regen while NOT dead
	else
		to_chat(src, "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds.")

		//Waiting for regen after being alive
		revive_ready = REVIVING_NOW
		spawn(time SECONDS)

			//If they're still alive after regenning.
			if(stat != DEAD)
				to_chat(src, "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>")
				verbs |= /mob/living/carbon/human/proc/hatch
				revive_ready = REVIVING_DONE

			//Was alive, now dead
			else if(hasnutriment())
				to_chat(src, "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>")
				verbs |= /mob/living/carbon/human/proc/hatch
				revive_ready = REVIVING_DONE

			//Dead until nutrition injected.
			else
				to_chat(src, "<span class='warning'>Your body was unable to regenerate, what few living cells remain require additional nutrients to complete the process.</span>")
				revive_ready = REVIVING_READY //reset their cooldown

/mob/living/carbon/human/proc/hatch()
	set name = "Hatch"
	set category = "Abilities"

	if(revive_ready != REVIVING_DONE)
		//Hwhat?
		verbs -= /mob/living/carbon/human/proc/hatch
		return

	var/confirm = alert(usr, "Are you sure you want to hatch right now? This will be very obvious to anyone in view.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")

		//Dead when hatching
		if(stat == DEAD)
			chimera_hatch()
			adjustBrainLoss(10) // if they're reviving from dead, they come back with 10 brainloss on top of whatever's unhealed.
			visible_message("<span class='danger'><p><font size=4>The lifeless husk of [src] bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") //Bloody hell...
			return

		//Alive when hatching
		else
			chimera_hatch()
			visible_message("<span class='danger'><p><font size=4>The dormant husk of [src] bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>") //Bloody hell...

/mob/living/carbon/human/proc/chimera_hatch()
	verbs -= /mob/living/carbon/human/proc/hatch
	to_chat(src, "<span class='notice'>Your new body awakens, bursting free from your old skin.</span>")

	//Modify and record values (half nutrition and braindamage)
	var/old_nutrition = nutrition * 0.5
	var/braindamage = (brainloss * 0.5) //Can only heal half brain damage.

	//I did have special snowflake code, but this is easier.
	revive()
	mutations.Remove(HUSK)
	nutrition = old_nutrition
	setBrainLoss(braindamage)

	//Drop everything
	for(var/obj/item/W in src)
		drop_from_inventory(W)

	//Unfreeze some things
	does_not_breathe = FALSE
	update_canmove()
	weakened = 2

	//Visual effects
	var/T = get_turf(src)
	new /obj/effect/gibspawner/human/xenochimera(T)

	revive_ready = world.time + 1 HOUR //set the cooldown

/mob/living/carbon/human/proc/revivingreset() // keep this as a debug proc or potential future use
		revive_ready = REVIVING_READY

/obj/effect/gibspawner/human/xenochimera
	fleshcolor = "#14AD8B"
	bloodcolor = "#14AD8B"

/mob/living/carbon/human/proc/handle_feral()
	if(handling_hal) return
	handling_hal = 1

	if(client && feral >= 10) // largely a copy of handle_hallucinations() without the fake attackers. Unlike hallucinations, only fires once - if they're still feral they'll get hit again anyway.
		spawn(rand(200,500)/(feral/10))
			if(!feral) return //just to avoid fuckery in the event that they un-feral in the time it takes for the spawn to proc
			var/halpick = rand(1,100)
			switch(halpick)
				if(0 to 15) //15% chance
					//Screwy HUD
					//to_chat(src, "Screwy HUD")
					hal_screwyhud = pick(1,2,3,3,4,4)
					spawn(rand(100,250))
						hal_screwyhud = 0
				if(16 to 25) //10% chance
					//Strange items
					//to_chat(src, "Traitor Items")
					if(!halitem)
						halitem = new
						var/list/slots_free = list(ui_lhand,ui_rhand)
						if(l_hand) slots_free -= ui_lhand
						if(r_hand) slots_free -= ui_rhand
						if(istype(src,/mob/living/carbon/human))
							var/mob/living/carbon/human/H = src
							if(!H.belt) slots_free += ui_belt
							if(!H.l_store) slots_free += ui_storage1
							if(!H.r_store) slots_free += ui_storage2
						if(slots_free.len)
							halitem.screen_loc = pick(slots_free)
							halitem.layer = 50
							switch(rand(1,6))
								if(1) //revolver
									halitem.icon = 'icons/obj/gun/ballistic.dmi'
									halitem.icon_state = "revolver"
									halitem.name = "Revolver"
								if(2) //c4
									halitem.icon = 'icons/obj/assemblies.dmi'
									halitem.icon_state = "plastic-explosive0"
									halitem.name = "Mysterious Package"
									if(prob(25))
										halitem.icon_state = "c4small_1"
								if(3) //sword
									halitem.icon = 'icons/obj/weapons.dmi'
									halitem.icon_state = "sword1"
									halitem.name = "Sword"
								if(4) //stun baton
									halitem.icon = 'icons/obj/weapons.dmi'
									halitem.icon_state = "stunbaton"
									halitem.name = "Stun Baton"
								if(5) //emag
									halitem.icon = 'icons/obj/card.dmi'
									halitem.icon_state = "emag"
									halitem.name = "Cryptographic Sequencer"
								if(6) //flashbang
									halitem.icon = 'icons/obj/grenade.dmi'
									halitem.icon_state = "flashbang1"
									halitem.name = "Flashbang"
							if(client) client.screen += halitem
							spawn(rand(100,250))
								if(client)
									client.screen -= halitem
								halitem = null
				if(26 to 35) //10% chance
					//Flashes of danger
					//to_chat(src, "Danger Flash")
					if(!halimage)
						var/list/possible_points = list()
						for(var/turf/simulated/floor/F in view(src,world.view))
							possible_points += F
						if(possible_points.len)
							var/turf/simulated/floor/target = pick(possible_points)

							switch(rand(1,3))
								if(1)
									//to_chat(src, "Space")
									halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
								if(2)
									//to_chat(src, "Fire")
									halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
								if(3)
									//to_chat(src, "C4")
									halimage = image('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


							if(client) client.images += halimage
							spawn(rand(10,50)) //Only seen for a brief moment.
								if(client) client.images -= halimage
								halimage = null

				if(36 to 55) //20% chance
					//Strange audio
					//to_chat(src, "Strange Audio")
					switch(rand(1,12))
						if(1) SEND_SOUND(src, sound('sound/machines/airlock.ogg'))
						if(2)
							if(prob(50))SEND_SOUND(src, sound('sound/effects/Explosion1.ogg'))
							else SEND_SOUND(src, sound('sound/effects/Explosion2.ogg'))
						if(3) SEND_SOUND(src, sound('sound/effects/explosionfar.ogg'))
						if(4) SEND_SOUND(src, sound('sound/effects/Glassbr1.ogg'))
						if(5) SEND_SOUND(src, sound('sound/effects/Glassbr2.ogg'))
						if(6) SEND_SOUND(src, sound('sound/effects/Glassbr3.ogg'))
						if(7) SEND_SOUND(src, sound('sound/machines/twobeep.ogg'))
						if(8) SEND_SOUND(src, sound('sound/machines/windowdoor.ogg'))
						if(9)
							//To make it more realistic, I added two gunshots (enough to kill)
							SEND_SOUND(src, sound('sound/weapons/Gunshot1.ogg'))
							spawn(rand(10,30))
								SEND_SOUND(src, sound('sound/weapons/Gunshot2.ogg'))
						if(10) SEND_SOUND(src, sound('sound/weapons/smash.ogg'))
						if(11)
							//Same as above, but with tasers.
							SEND_SOUND(src, sound('sound/weapons/Taser.ogg'))
							spawn(rand(10,30))
								SEND_SOUND(src, sound('sound/weapons/Taser.ogg'))
					//Rare audio
						if(12)
	//These sounds are (mostly) taken from Hidden: Source
							var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
								'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
								'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
								'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
								'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
							SEND_SOUND(src, pick(creepyasssounds))
				if(56 to 60) //5% chance
					//Flashes of danger
					//to_chat(src, "Danger Flash")
					if(!halbody)
						var/list/possible_points = list()
						for(var/turf/simulated/floor/F in view(src,world.view))
							possible_points += F
						if(possible_points.len)
							var/turf/simulated/floor/target = pick(possible_points)
							switch(rand(1,4))
								if(1)
									halbody = image('icons/mob/human.dmi',target,"husk_l",TURF_LAYER)
								if(2,3)
									halbody = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
								if(4)
									halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)
		//						if(5)
		//							halbody = image('xcomalien.dmi',target,"chryssalid",TURF_LAYER)

							if(client) client.images += halbody
							spawn(rand(50,80)) //Only seen for a brief moment.
								if(client) client.images -= halbody
								halbody = null
				if(61 to 85) //25% chance
					//food
					if(!halbody)
						var/list/possible_points = list()
						for(var/turf/simulated/floor/F in view(src,world.view))
							possible_points += F
						if(possible_points.len)
							var/turf/simulated/floor/target = pick(possible_points)
							switch(rand(1,10))
								if(1)
									halbody = image('icons/mob/animal.dmi',target,"cow",TURF_LAYER)
								if(2)
									halbody = image('icons/mob/animal.dmi',target,"chicken",TURF_LAYER)
								if(3)
									halbody = image('icons/obj/food.dmi',target,"bigbiteburger",TURF_LAYER)
								if(4)
									halbody = image('icons/obj/food.dmi',target,"meatbreadslice",TURF_LAYER)
								if(5)
									halbody = image('icons/obj/food.dmi',target,"sausage",TURF_LAYER)
								if(6)
									halbody = image('icons/obj/food.dmi',target,"bearmeat",TURF_LAYER)
								if(7)
									halbody = image('icons/obj/food.dmi',target,"fishfillet",TURF_LAYER)
								if(8)
									halbody = image('icons/obj/food.dmi',target,"meat",TURF_LAYER)
								if(9)
									halbody = image('icons/obj/food.dmi',target,"meatstake",TURF_LAYER)
								if(10)
									halbody = image('icons/obj/food.dmi',target,"monkeysdelight",TURF_LAYER)

							if(client) client.images += halbody
							spawn(rand(50,80)) //Only seen for a brief moment.
								if(client) client.images -= halbody
								halbody = null
				if(86 to 100) //15% chance
					//hear voices. Could make the voice pick from nearby creatures, but nearby creatures make feral hallucinations rare so don't bother.
					var/list/hiddenspeakers = list("Someone distant", "A voice nearby","A familiar voice", "An echoing voice", "A cautious voice", "A scared voice", "Someone around the corner", "Someone", "Something", "Something scary", "An urgent voice", "An angry voice")
					var/list/speakerverbs = list("calls out", "yells", "screams", "exclaims", "shrieks", "shouts", "hisses", "snarls")
					var/list/spookyphrases = list("It's over here!","Stop it!", "Hunt it down!", "Get it!", "Quick, over here!", "Anyone there?", "Who's there?", "Catch that thing!", "Stop it! Kill it!", "Anyone there?", "Where is it?", "Find it!", "There it is!")
					to_chat(src, "<span class='game say'><span class='name'>[pick(hiddenspeakers)]</span> [pick(speakerverbs)], \"[pick(spookyphrases)]\"</span>")


	handling_hal = 0
	return
