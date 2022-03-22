/obj/item/aicard
	name = "intelliCore"
	desc = "Used to preserve and transport an AI."
	icon = 'icons/obj/pda.dmi'
	icon_state = "aicard" // aicard-full
	item_state = "aicard"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	show_messages = FALSE
	preserve_item = TRUE

	var/flush = null
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)

	var/mob/living/silicon/ai/carded_ai

/obj/item/aicard/aitater
	name = "intelliTater"
	desc = "A stylish upgrade (?) to the intelliCard."
	icon_state = "aitater"

/obj/item/aicard/aispook
	name = "intelliLantern"
	desc = "A spoOoOoky upgrade to the intelliCard."
	icon_state = "aispook"

/obj/item/aicard/attack(mob/living/silicon/decoy/M as mob, mob/user as mob)
	if (!istype (M, /mob/living/silicon/decoy))
		return ..()
	else
		M.death()
		to_chat(user, "<b>ERROR ERROR ERROR</b>")

/obj/item/aicard/attack_self(mob/user)
	ui_interact(user)

/obj/item/aicard/ui_interact(mob/user, datum/tgui/ui = null, datum/ui_state/custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AICard", "[name]") // 600, 394
		ui.open()
	if(custom_state)
		ui.set_state(custom_state)

/obj/item/aicard/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/aicard/ui_data(mob/user)
	var/data[0]

	data["has_ai"] = carded_ai != null
	if(carded_ai)
		data["name"] = carded_ai.name
		data["integrity"] = carded_ai.hardware_integrity()
		data["backup_capacitor"] = carded_ai.backup_capacitor()
		data["radio"] = !carded_ai.aiRadio.disabledAi
		data["wireless"] = !carded_ai.control_disabled
		data["operational"] = carded_ai.stat != DEAD
		data["flushing"] = flush

		var/laws[0]
		for(var/datum/ai_law/law in carded_ai.laws.all_laws())
			if(law in carded_ai.laws.ion_laws) // If we're an ion law, give it an ion index code
				laws.Add(ionnum() + ". " + law.law)
			else
				laws.Add(num2text(law.get_index()) + ". " + law.law)
		data["laws"] = laws
		data["has_laws"] = length(carded_ai.laws.all_laws())

	return data

/obj/item/aicard/ui_act(action, params)
	if(..())
		return TRUE

	if(!carded_ai)
		return

	var/user = usr
	switch(action)
		if("wipe")
			msg_admin_attack("[key_name_admin(user)] wiped [key_name_admin(AI)] with \the [src].")
			add_attack_logs(user,carded_ai,"Purged from AI Card")
			INVOKE_ASYNC(src, .proc/wipe_ai)
		if("radio")
			carded_ai.aiRadio.disabledAi = !carded_ai.aiRadio.disabledAi
			to_chat(carded_ai, "<span class='warning'>Your Subspace Transceiver has been [carded_ai.aiRadio.disabledAi ? "disabled" : "enabled"]!</span>")
			to_chat(user, "<span class='notice'>You [carded_ai.aiRadio.disabledAi ? "disable" : "enable"] the AI's Subspace Transceiver.</span>")
		if("wireless")
			carded_ai.control_disabled = !carded_ai.control_disabled
			to_chat(carded_ai, "<span class='warning'>Your wireless interface has been [carded_ai.control_disabled ? "disabled" : "enabled"]!</span>")
			to_chat(user, "<span class='notice'>You [carded_ai.control_disabled ? "disable" : "enable"] the AI's wireless interface.</span>")
			if(carded_ai.control_disabled && carded_ai.deployed_shell)
				carded_ai.disconnect_shell("Disconnecting from remote shell due to [src] wireless access interface being disabled.")
			update_icon()

	return TRUE

/obj/item/aicard/update_icon()
	overlays.Cut()
	if(carded_ai)
		if (!carded_ai.control_disabled)
			overlays += image('icons/obj/pda.dmi', "aicard-on")
		if(carded_ai.stat)
			icon_state = "aicard-404"
		else
			icon_state = "aicard-full"
	else
		icon_state = "aicard"

/obj/item/aicard/proc/grab_ai(var/mob/living/silicon/ai/ai, var/mob/living/user)
	if(!ai.client && !ai.deployed_shell)
		to_chat(user, "<span class='danger'>ERROR:</span> AI [ai.name] is offline. Unable to transfer.")
		return FALSE

	if(carded_ai)
		to_chat(user, "<span class='danger'>Transfer failed:</span> Existing AI found on remote device. Remove existing AI to install a new one.")
		return FALSE

	if(!user.IsAdvancedToolUser() && isanimal(user))
		var/mob/living/simple_mob/S = user
		if(!S.IsHumanoidToolUser(src))
			return FALSE

	user.visible_message("\The [user] starts transferring \the [ai] into \the [src]...", "You start transferring \the [ai] into \the [src]...")
	show_message(span("critical", "\The [user] is transferring you into \the [src]!"))

	if(do_after(user, 100))
		if(istype(ai.loc, /turf/))
			new /obj/structure/AIcore/deactivated(get_turf(ai))

		ai.carded = TRUE
		add_attack_logs(user,ai,"Extracted into AI Card")
		src.name = "[initial(name)] - [ai.name]"

		ai.loc = src
		ai.destroy_eyeobj(src)
		ai.cancel_camera()
		ai.control_disabled = TRUE
		ai.aiRestorePowerRoutine = FALSE
		carded_ai = ai
		ai.disconnect_shell("Disconnected from remote shell due to core intelligence transfer.") //If the AI is controlling a borg, force the player back to core!

		if(ai.client)
			to_chat(ai, "You have been transferred into a mobile core. Remote access lost.")
		if(user.client)
			to_chat(ai, "<span class='notice'><b>Transfer successful:</b></span> [ai.name] extracted from current device and placed within mobile core.")

		ai.canmove = TRUE
		update_icon()
	return TRUE

/obj/item/aicard/proc/clear()
	if(carded_ai && istype(carded_ai.loc, /turf))
		carded_ai.canmove = FALSE
		carded_ai.carded = FALSE
	name = initial(name)
	carded_ai = null
	update_icon()

/obj/item/aicard/see_emote(mob/living/M, text)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[text]</span>"
		carded_ai.show_message(rendered, 2)
	..()

/obj/item/aicard/show_message(msg, type, alt, alt_type)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		carded_ai.show_message(rendered, type)
	..()

/obj/item/aicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/aicard/proc/wipe_ai()
	var/mob/living/silicon/ai/AI = carded_ai
	flush = TRUE
	AI.suiciding = TRUE
	to_chat(AI, "Your power has been disabled!")
	while(AI && AI.stat != DEAD)
		// This is absolutely evil and I love it.
		if(AI.deployed_shell && prob(AI.oxyloss)) //You feel it creeping? Eventually will reach 100, resulting in the second half of the AI's remaining life being lonely.
			AI.disconnect_shell("Disconnecting from remote shell due to insufficent power.")
		AI.adjustOxyLoss(2)
		AI.updatehealth()
		sleep(10)
	flush = FALSE
