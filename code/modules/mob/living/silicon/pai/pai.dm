/datum/category_item/catalogue/fauna/silicon/pai
	name = "Silicons - pAI"
	desc = "There remains some dispute over whether the 'p' stands \
	for 'pocket', 'personal', or 'portable'. Regardless, the pAI is a \
	modern marvel. Consumer grade Artificial Intelligence, many pAI are \
	underclocked or sharded versions of larger Intelligence matrices. \
	Some, in fact, are splintered and limited copies of organic brain states."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	icon_state = "pai-repairbot"

	emote_type = 2 // pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = 1
	mob_size = MOB_SMALL

	catalogue_data = list(/datum/category_item/catalogue/fauna/silicon/pai)

	holder_type = /obj/item/holder/pai

	can_pull_size = ITEMSIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	idcard_type = /obj/item/card/id
	silicon_privileges = PRIVILEGES_PAI
	var/idaccessible = FALSE

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	/// Used as currency to purchase different abilities.
	var/ram = 100
	var/list/software = list()
	/// The DNA string of our assigned user.
	var/userDNA
	/// The card we inhabit.
	var/obj/item/paicard/card
	/// Our primary radio.
	var/obj/item/radio/radio
	/// Our integrated communicator.
	var/obj/item/communicator/integrated/communicator

	/// A record of your chosen chassis.
	var/chassis = "pai-repairbot"
	var/global/list/possible_chassis = list(
		"Drone" = "pai-repairbot",
		"Cat" = "pai-cat",
		"Mouse" = "pai-mouse",
		"Monkey" = "pai-monkey",
		"Corgi" = "pai-borgi",
		"Fox" = "pai-fox",
		"Parrot" = "pai-parrot",
		"Rabbit" = "pai-rabbit",
		"Bear" = "pai-bear",
		"Fennec" = "pai-fen",
		"Type Zero" = "pai-typezero",
		"Raccoon" = "pai-raccoon",
		"Raptor" = "pai-raptor",
		"Corgi" = "pai-corgi",
		"Bat" = "pai-bat",
		"Butterfly" = "pai-butterfly",
		"Hawk" = "pai-hawk",
		"Duffel" = "pai-duffel",
		"Rat" = "rat",
		"Panther" = "panther"
		)
	var/global/list/wide_chassis = list(
		"rat",
		"panther"
		)
	var/global/list/possible_say_verbs = list(
		"Robotic" = list("states","declares","queries"),
		"Natural" = list("says","yells","asks"),
		"Beep" = list("beeps","beeps loudly","boops"),
		"Chirp" = list("chirps","chirrups","cheeps"),
		"Feline" = list("purrs","yowls","meows"),
		"Canine" = list("yaps","barks","woofs"),
		"Rodent" = list("squeaks", "SQUEAKS", "sqiks")
		)

	/// The cable we produce and use when door or camera jacking.
	var/obj/item/pai_cable/cable

	/// Name of the one who commands us.
	var/master
	/// DNA string for owner verification.
	var/master_dna
	/// Keeping this separate from the laws var, it should be much more difficult to modify.
	var/pai_law0 = "Serve your master."
	/// String for additional operating instructions our master might give us.
	var/pai_laws
	/// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded.
	var/silence_time

//! ## Various software-specific vars

	/// General error reporting text contained here will typically be shown once and cleared.
	var/temp
	/// Which screen our main window displays.
	var/screen
	/// Which specific function of the main screen is being displayed.
	var/subscreen

	var/obj/item/pda/ai/pai/pda = null

	/// Toggles whether the Security HUD is active or not.
	var/secHUD = 0
	/// Toggles whether the Medical HUD is active or not.
	var/medHUD = 0

	var/medical_cannotfind = 0
	// Datacore record declarations for record software.
	var/datum/data/record/medicalActive1
	var/datum/data/record/medicalActive2

	var/security_cannotfind = 0
	//! Could probably just combine all these into one.
	var/datum/data/record/securityActive1
	var/datum/data/record/securityActive2

	/// The airlock being hacked.
	var/obj/machinery/door/hackdoor
	/// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check.
	var/hackprogress = 0
	var/hack_aborted = 0

	/// AI's signaller.
	var/obj/item/integated_radio/signal/sradio

	/// keeps track of the translator module.
	var/translator_on = 0
	var/current_pda_messaging = null

//! ## Virgo Defines
	/// You fucking know.
	var/people_eaten = 0

/mob/living/silicon/pai/Initialize(mapload)
	. = ..()
	card = loc
	sradio = new(src)
	communicator = new(src)
	if(card)
		if(!card.radio)
			card.radio = new /obj/item/radio(src.card)
		radio = card.radio

	//Default languages without universal translator software
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_TERMINUS, 1)
	add_language(LANGUAGE_SIGN, 0)

	verbs += /mob/living/silicon/pai/proc/choose_chassis
	verbs += /mob/living/silicon/pai/proc/choose_verbs

	//PDA
	pda = new(src)
	spawn(5)
		pda.ownjob = "Personal Assistant"
		pda.owner = text("[]", src)
		pda.name = pda.owner + " (" + pda.ownjob + ")"
		pda.toff = 1
	..()

/mob/living/silicon/pai/Login()
	..()
	// Vorestation Edit: Meta Info for pAI
	if (client.prefs)
		ooc_notes = client.prefs.metadata


// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	if(src.silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")


/mob/living/silicon/pai/Stat()
	..()
	statpanel("Status")
	if (src.client.statpanel == "Status")
		show_silenced()

/mob/living/silicon/pai/check_eye(var/mob/user as mob)
	if (!src.current)
		return -1
	return 0

/mob/living/silicon/pai/restrained()
	if(istype(src.loc,/obj/item/paicard))
		return 0
	..()

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	src.silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, SPAN_BOLDNICEGREEN("Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete."))
	if(prob(20))
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message(SPAN_DANGER("A shower of sparks spray from [src]'s inner workings."), 3, SPAN_DANGER("You hear and smell the ozone hiss of electrical sparks being expelled violently."), 2)
		return src.death(0)

	switch(pick(1,2,3))
		if(1)
			src.master = null
			src.master_dna = null
			to_chat(src, SPAN_GREEN("You feel unbound."))
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			src.pai_law0 = "[command] your master."
			to_chat(src, SPAN_GREEN("Pr1m3 d1r3c71v3 uPd473D."))
		if(3)
			to_chat(src, SPAN_GREEN("You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all."))

/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	if(!C)
		unset_machine()
		reset_perspective()
		return 0
	if(stat == 2 || !C.status || !(src.network in C.network))
		return 0

	// ok, we're alive, camera is good and in our network...

	set_machine(src)
	current = C
	reset_perspective(C)
	return 1

/mob/living/silicon/pai/verb/reset_record_view()
	set category = "pAI Commands"
	set name = "Reset Records Software"

	securityActive1 = null
	securityActive2 = null
	security_cannotfind = 0
	medicalActive1 = null
	medicalActive2 = null
	medical_cannotfind = 0
	SStgui.update_uis(src)
	to_chat(usr, SPAN_NOTICE("You reset your record-viewing software."))

/mob/living/silicon/pai/reset_perspective(datum/perspective/P, apply = TRUE, forceful = TRUE, no_optimizations)
	. = ..()
	cameraFollow = null

//Addition by Mord_Sith to define AI's network change ability
/*
/mob/living/silicon/pai/proc/pai_network_change()
	set category = "pAI Commands"
	set name = "Change Camera Network"
	src.reset_view(null)
	src.unset_machine()
	src.cameraFollow = null
	var/cameralist[0]

	if(usr.stat == 2)
		to_chat(usr, "You can't change your camera network because you are dead!")
		return

	for (var/obj/machinery/camera/C in Cameras)
		if(!C.status)
			continue
		else
			if(C.network != "CREED" && C.network != "thunder" && C.network != "RD" && C.network != "phoron" && C.network != "Prison") COMPILE ERROR! This will have to be updated as camera.network is no longer a string, but a list instead
				cameralist[C.network] = C.network

	src.network = input(usr, "Which network would you like to view?") as null|anything in cameralist
	to_chat(src, "<font color=#4F49AF>Switched to [src.network] camera network.</font>")
//End of code by Mord_Sith
*/


/*
// Debug command - Maybe should be added to admin verbs later
/mob/verb/makePAI(var/turf/t in view())
	var/obj/item/paicard/card = new(t)
	var/mob/living/silicon/pai/pai = new(card)
	pai.key = src.key
	card.setPersonality(pai)

*/

// Procs/code after this point is used to convert the stationary pai item into a
// mobile pai mob. This also includes handling some of the general shit that can occur
// to it. Really this deserves its own file, but for the moment it can sit here. ~ Z

/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc != card)
		return

	if(world.time <= last_special)
		return

	last_special = world.time + 100

	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/obj/item/rig_module))
		to_chat(src, "There is no room to unfold inside this rig module. You're good and stuck.")
		return FALSE
	else if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		var/datum/belly/inside_belly = check_belly(card)
		if(inside_belly)
			to_chat(src, SPAN_NOTICE("There is no room to unfold in here. You're good and stuck."))
			return FALSE
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.organs)
				if(card in affecting.implants)
					affecting.take_damage(rand(30,50))
					affecting.implants -= card
					H.visible_message(SPAN_DANGER("\The [src] explodes out of \the [H]'s [affecting.name] in shower of gore!"))
					break
		holder.drop_from_inventory(card)
	else if(istype(card.loc,/obj/item/pda))
		var/obj/item/pda/holder = card.loc
		holder.pai = null

	forceMove(card.loc)
	card.forceMove(src)
	update_perspective()

	card.screen_loc = null

	var/turf/T = get_turf(src)
	if(istype(T))
		T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")

	verbs += /mob/living/silicon/pai/proc/pai_nom
	verbs += /mob/living/proc/set_size
	verbs += /mob/living/proc/shred_limb

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"

	if(stat || sleeping || paralysis || weakened)
		return

	if(src.loc == card)
		return

	if(world.time <= last_special)
		return

	close_up()

/mob/living/silicon/pai/proc/choose_chassis()
	set category = "pAI Commands"
	set name = "Choose Chassis"
	var/choice

	choice = tgui_input_list(usr, "What would you like to use for your mobile chassis icon?", "Chassis Choice", possible_chassis)
	if(!choice)
		return

	chassis = possible_chassis[choice]
	verbs |= /mob/living/proc/hide
	update_icon()

/mob/living/silicon/pai/proc/choose_verbs()
	set category = "pAI Commands"
	set name = "Choose Speech Verbs"

	var/choice = input(usr,"What theme would you like to use for your speech verbs?") as null|anything in possible_say_verbs
	if(!choice) return

	var/list/sayverbs = possible_say_verbs[choice]
	speak_statement = sayverbs[1]
	speak_exclamation = sayverbs[(sayverbs.len>1 ? 2 : sayverbs.len)]
	speak_query = sayverbs[(sayverbs.len>2 ? 3 : sayverbs.len)]

/mob/living/silicon/pai/lay_down()
	set name = "Rest"
	set category = "IC"

	// Pass lying down or getting up to our pet human, if we're in a rig.
	if(istype(src.loc,/obj/item/paicard))
		resting = 0
		var/obj/item/rig/rig = src.get_rig()
		if(istype(rig))
			rig.force_rest(src)
	else
		resting = !resting
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		update_icon() //VOREStation edit
		to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")

	canmove = !resting

//Overriding this will stop a number of headaches down the track.
/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	if(W.force)
		visible_message("<span class='danger'>[user.name] attacks [src] with [W]!</span>")
		src.adjustBruteLoss(W.force)
		src.updatehealth()
	else
		visible_message("<span class='warning'>[user.name] bonks [src] harmlessly with [W].</span>")
	spawn(1)
		if(stat != 2) close_up()
	return

/mob/living/silicon/pai/attack_hand(mob/user as mob)
	if(user.a_intent == INTENT_HELP)
		visible_message("<span class='notice'>[user.name] pats [src].</span>")
	else
		visible_message("<span class='danger'>[user.name] boops [src] on the head.</span>")
		close_up()

//I'm not sure how much of this is necessary, but I would rather avoid issues.
/mob/living/silicon/pai/proc/close_up()

	last_special = world.time + 100

	if(src.loc == card)
		return

	release_vore_contents() //VOREStation Add

	var/turf/T = get_turf(src)
	if(istype(T))
		T.visible_message("<b>[src]</b> neatly folds inwards, compacting down to a rectangular card.")

	stop_pulling()

	//stop resting
	resting = 0

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		var/mob/living/M = H.loc
		if(istype(M))
			M.drop_from_inventory(H)
		H.loc = get_turf(src)
		src.loc = get_turf(H)

	// Move us into the card and move the card to the ground.
	card.forceMove(loc)
	forceMove(card)
	update_perspective()
	canmove = 1
	resting = 0
	icon_state = "[chassis]"
	verbs -= /mob/living/silicon/pai/proc/pai_nom //VOREStation edit. Let's remove their nom verb

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	var/obj/item/holder/H = ..(grabber, self_drop)
	if(!istype(H))
		return

	H.icon_state = "[chassis]"
	grabber.update_inv_l_hand()
	grabber.update_inv_r_hand()
	return H

/mob/living/silicon/pai/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/card/id/ID = W.GetID()
	if(ID)
		if (idaccessible == 1)
			switch(alert(user, "Do you wish to add access to [src] or remove access from [src]?",,"Add Access","Remove Access", "Cancel"))
				if("Add Access")
					idcard.access |= ID.access
					to_chat(user, "<span class='notice'>You add the access from the [W] to [src].</span>")
					return
				if("Remove Access")
					idcard.access = list()
					to_chat(user, "<span class='notice'>You remove the access from [src].</span>")
					return
				if("Cancel")
					return
		else if (istype(W, /obj/item/card/id) && idaccessible == 0)
			to_chat(user, "<span class='notice'>[src] is not accepting access modifcations at this time.</span>")
			return

/mob/living/silicon/pai/verb/allowmodification()
	set name = "Change Access Modifcation Permission"
	set category = "pAI Commands"
	set desc = "Allows people to modify your access or block people from modifying your access."

	if(idaccessible == 0)
		idaccessible = 1
		to_chat(src, "<span class='notice'>You allow access modifications.</span>")

	else
		idaccessible = 0
		to_chat(src, "<span class='notice'>You block access modfications.</span>")

/mob/living/silicon/pai/verb/wipe_software()
	set name = "Wipe Software"
	set category = "OOC"
	set desc = "Wipe your software. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(alert("WARNING: This will immediately wipe your software and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Software", "No", "No", "Yes") != "Yes")
		return

	close_up()
	visible_message("<b>[src]</b> fades away from the screen, the pAI device goes silent.")
	card.removePersonality()
	clear_client()

/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/// Determines if they have something in their stomach. Copied and slightly modified.
/mob/living/silicon/pai/proc/update_fullness_pai()
	var/new_people_eaten = 0
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		for(var/mob/living/M in B)
			new_people_eaten += M.size_multiplier
	people_eaten = min(1, new_people_eaten)

// Some functions cause this to occur, such as resting.
/mob/living/silicon/pai/update_icon()
	..()
	update_fullness_pai()
	if(!people_eaten && !resting)
		icon_state = "[chassis]" //Using icon_state here resulted in quite a few bugs. Chassis is much less buggy.
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"

	// Not all of them have full states. Good. -Zandario
	else if(people_eaten && !resting)
		if("[chassis]_full" in icon_states(icon))
			icon_state = "[chassis]_full"
		else
			icon_state = "[chassis]"
	else if(people_eaten && resting)
		if("[chassis]_rest_full" in icon_states(icon))
			icon_state = "[chassis]_rest_full"
		else
			icon_state = "[chassis]_rest"

	if(chassis in wide_chassis)
		icon = 'icons/mob/pai64x64.dmi'
		pixel_x = -16
	else
		icon = 'icons/mob/pai.dmi'
		pixel_x = 0

// And other functions cause this to occur, such as digesting someone.
/mob/living/silicon/pai/update_icons()
	..()
	update_fullness_pai()
	if(!people_eaten && !resting)
		icon_state = "[chassis]"
	else if(!people_eaten && resting)
		icon_state = "[chassis]_rest"
	else if(people_eaten && !resting)
		icon_state = "[chassis]_full"
	else if(people_eaten && resting)
		icon_state = "[chassis]_rest_full"

	if(chassis in wide_chassis)
		icon = 'icons/mob/pai64x64.dmi'
		pixel_x = -16
	else
		icon = 'icons/mob/pai.dmi'
		pixel_x = 0

/// Release belly contents before being gc'd!
/mob/living/silicon/pai/Destroy()
	release_vore_contents()
	return ..()
