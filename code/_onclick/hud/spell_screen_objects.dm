// TODO: KILL THIS SHIT FOR ACTION BUTTONS
// TODO: NEW SCREEN LOC DECODING PROCS.
atom/movable/screen/movable/spell_master
	name = "Spells"
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "wiz_spell_ready"
	var/list/atom/movable/screen/spell/spell_objects = list()
	var/showing = 0

	var/open_state = "master_open"
	var/closed_state = "master_closed"

	screen_loc = ui_spell_master
	var/opens_to_left = TRUE
	var/opens_downwards = TRUE

	var/mob/spell_holder

atom/movable/screen/movable/spell_master/Destroy()
	. = ..()
	for(var/atom/movable/screen/spell/spells in spell_objects)
		spells.spellmaster = null
	spell_objects.Cut()
	if(spell_holder)
		spell_holder.spell_masters -= src
		if(spell_holder.client && spell_holder.client.screen)
			spell_holder.client.screen -= src
		spell_holder = null

atom/movable/screen/movable/spell_master/OnMouseDropLegacy()
	if(showing)
		return

	return ..()

atom/movable/screen/movable/spell_master/Click()
	if(!spell_objects.len)
		qdel(src)
		return

	toggle_open()

atom/movable/screen/movable/spell_master/proc/toggle_open(forced_state = 0)
	cut_overlays()
	if(showing && (forced_state != 2))
		for(var/atom/movable/screen/spell/O in spell_objects)
			if(spell_holder && spell_holder.client)
				spell_holder.client.screen -= O
			O.handle_icon_updates = 0
		showing = 0
		add_overlay(closed_state)
	else if(forced_state != 1)
		open_spellmaster()
		update_spells(1)
		showing = 1
		add_overlay(open_state)

atom/movable/screen/movable/spell_master/proc/open_spellmaster()
	var/list/screen_loc_xy = splittext(screen_loc,",")

	//Create list of X offsets
	var/list/screen_loc_X = splittext(screen_loc_xy[1],":")
	var/x_position = decode_screen_X(screen_loc_X[1])
	var/x_pix = text2num(screen_loc_X[2])

	//Create list of Y offsets
	var/list/screen_loc_Y = splittext(screen_loc_xy[2],":")
	var/y_position = decode_screen_Y(screen_loc_Y[1])
	var/y_pix = text2num(screen_loc_Y[2])

	for(var/i = 1; i <= spell_objects.len; i++)
		var/atom/movable/screen/spell/S = spell_objects[i]
		// TODO: WARNING THIS IS SHITCODE AND MONKEY PATCHED AND WILL BREAK VERY SOON
		// Pray we finish abilities refactor by then!
		var/xpos = x_position + (opens_to_left? -1 : 1) * ((i % 7) + 1) - 1
		var/ypos = y_position + (opens_downwards? -1 : 1) * (round(i / 7) + 0) - 1
		if(spell_holder && spell_holder.client)
			S.screen_loc = "[encode_screen_X(xpos)]:[x_pix],[encode_screen_Y(ypos)]:[y_pix]"
			spell_holder.client.screen += S
			S.handle_icon_updates = 1

atom/movable/screen/movable/spell_master/proc/add_spell(var/spell/spell)
	if(!spell) return

	if(spell.connected_button) //we have one already, for some reason
		if(spell.connected_button in spell_objects)
			return
		else
			spell_objects.Add(spell.connected_button)
			if(spell_holder.client)
				toggle_open(2)
			return

	if(spell.spell_flags & NO_BUTTON) //no button to add if we don't get one
		return

	var/atom/movable/screen/spell/newscreen = new /atom/movable/screen/spell()
	newscreen.spellmaster = src
	newscreen.spell = spell

	spell.connected_button = newscreen

	if(!spell.override_base) //if it's not set, we do basic checks
		if(spell.spell_flags & CONSTRUCT_CHECK)
			newscreen.spell_base = "const" //construct spells
		else
			newscreen.spell_base = "wiz" //wizard spells
	else
		newscreen.spell_base = spell.override_base
	newscreen.name = spell.name
	newscreen.update_charge(1)
	spell_objects.Add(newscreen)
	if(spell_holder.client)
		toggle_open(2) //forces the icons to refresh on screen

atom/movable/screen/movable/spell_master/proc/remove_spell(var/spell/spell)
	qdel(spell.connected_button)

	spell.connected_button = null

	if(spell_objects.len)
		toggle_open(showing + 1)
	else
		qdel(src)

atom/movable/screen/movable/spell_master/proc/silence_spells(var/amount)
	for(var/atom/movable/screen/spell/spell in spell_objects)
		spell.spell.silenced = amount
		spell.update_charge(1)

atom/movable/screen/movable/spell_master/proc/update_spells(forced = 0, mob/user)
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	for(var/atom/movable/screen/spell/spell in spell_objects)
		spell.update_charge(forced)

atom/movable/screen/movable/spell_master/genetic
	name = "Mutant Powers"
	icon_state = "genetic_spell_ready"

	open_state = "genetics_open"
	closed_state = "genetics_closed"

	screen_loc = ui_genetic_master

atom/movable/screen/movable/spell_master/swarm
	name = "Swarm Abilities"
	icon_state = "nano_spell_ready"

	open_state = "swarm_open"
	closed_state = "swarm_closed"

//////////////ACTUAL SPELLS//////////////
//This is what you click to cast things//
/////////////////////////////////////////
atom/movable/screen/spell
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "wiz_spell_base"
	var/spell_base = "wiz"
	var/last_charge = 0 //not a time, but the last remembered charge value

	var/spell/spell = null
	var/handle_icon_updates = 0
	var/atom/movable/screen/movable/spell_master/spellmaster

	var/icon/last_charged_icon

atom/movable/screen/spell/Destroy()
	. = ..()
	spell = null
	last_charged_icon = null
	if(spellmaster)
		spellmaster.spell_objects -= src
		if(spellmaster.spell_holder && spellmaster.spell_holder.client)
			spellmaster.spell_holder.client.screen -= src
	if(spellmaster && !spellmaster.spell_objects.len)
		qdel(spellmaster)
	spellmaster = null

atom/movable/screen/spell/proc/update_charge(var/forced_update = 0)
	if(!spell)
		qdel(src)
		return

	if((last_charge == spell.charge_counter || !handle_icon_updates) && !forced_update)
		return //nothing to see here

	cut_overlay(spell.hud_state)

	if(spell.charge_type == Sp_RECHARGE || spell.charge_type == Sp_CHARGES)
		if(spell.charge_counter < spell.charge_max)
			icon_state = "[spell_base]_spell_base"
			if(spell.charge_counter > 0)
				var/icon/partial_charge = icon(src.icon, "[spell_base]_spell_ready")
				partial_charge.Crop(1, 1, partial_charge.Width(), round(partial_charge.Height() * spell.charge_counter / spell.charge_max))
				add_overlay(partial_charge)
				if(last_charged_icon)
					cut_overlay(last_charged_icon)
				last_charged_icon = partial_charge
			else if(last_charged_icon)
				cut_overlay(last_charged_icon)
				last_charged_icon = null
		else
			icon_state = "[spell_base]_spell_ready"
			if(last_charged_icon)
				cut_overlay(last_charged_icon)
	else
		icon_state = "[spell_base]_spell_ready"

	add_overlay(spell.hud_state)

	last_charge = spell.charge_counter

	cut_overlay("silence")
	if(spell.silenced)
		add_overlay("silence")

atom/movable/screen/spell/Click()
	if(!usr || !spell)
		qdel(src)
		return

	spell.perform(usr)
	update_charge(1)



//Xenochimera, literally just different icons
atom/movable/screen/movable/spell_master/chimera
	name = "Chimera Abilities"
	icon_state = "cult_spell_ready"
	open_state = "genetics_open"
	closed_state = "genetics_closed"
