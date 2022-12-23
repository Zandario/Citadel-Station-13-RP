/turf/simulated/floor/attackby(obj/item/object, mob/living/user, params)
	if(!object || !user)
		return TRUE
	. = ..()
	if(.)
		return .
	if(overfloor_placed && istype(object, /obj/item/stack/tile))
		try_replace_tile(object, user, params)
		return TRUE
	//! Not yet.
	// if((user.a_intent == INTENT_HARM) && istype(object, /obj/item/stack/sheet))
	// 	var/obj/item/stack/sheet/sheets = object
	// 	return sheets.on_attack_floor(user, params)
	return FALSE

/turf/simulated/floor/crowbar_act(mob/living/user, obj/item/I)
	if(overfloor_placed && pry_tile(I, user))
		return TRUE

/turf/simulated/floor/proc/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	if(T.turf_type == type && T.turf_dir == dir)
		return
	var/obj/item/tool/crowbar/CB = user.is_holding_item_of_type(/obj/item/tool/crowbar)
	if(!CB)
		return
	var/turf/simulated/floor/plating/P = pry_tile(CB, user, TRUE)
	if(!istype(P))
		return
	P.attackby(T, user, params)

/turf/simulated/floor/proc/pry_tile(obj/item/I, mob/user, silent = FALSE)
	// I.play_tool_sound(src, 80)
	return remove_tile(user, silent)

/turf/simulated/floor/proc/remove_tile(mob/user, silent = FALSE, make_tile = TRUE, force_plating)
	if(broken || burnt)
		broken = FALSE
		burnt = FALSE
		if(user && !silent)
			to_chat(user, SPAN_NOTICE("You remove the broken plating."))
	else
		if(user && !silent)
			to_chat(user, SPAN_NOTICE("You remove the floor tile."))
		if(make_tile)
			spawn_tile()
	return make_plating(force_plating)

/turf/simulated/floor/proc/has_tile()
	return floor_tile

/turf/simulated/floor/proc/spawn_tile()
	if(!has_tile())
		return null
	return new floor_tile(src)
