// Based on railing.dmi from https://github.com/Endless-Horizon/CEV-Eris
/obj/structure/railing
	name = "railing"
	desc = "A railing to stop people from falling"
	icon = 'icons/obj/structures/railing.dmi'
	icon_state = "railing0"
	base_icon_state = "" // Yes.
	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_CLICK | ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_CLICK
	climbable = TRUE
	plane = MOB_PLANE
	layer = BELOW_MOB_LAYER
	anchored = TRUE
	atom_flags = ATOM_BORDER
	max_integrity = 250

	var/broken = FALSE
	var/health = 70
	var/maxhealth = 70
	var/check = 0

/obj/structure/railing/grey
	name = "grey railing"
	icon_state = "grey_railing0"
	base_icon_state = "grey_"

/obj/structure/railing/handrail
	name = "handrail"
	desc = "A waist high handrail, perhaps you could climb over it."
	icon_state = "hand_railing0"
	base_icon_state = "hand_"
	max_integrity = 100

/obj/structure/railing/handrail/unachored
	anchored = FALSE


/obj/structure/railing/Initialize(mapload, constructed = FALSE)
	. = ..()
	// TODO - "constructed" is not passed to us. We need to find a way to do this safely.
	if (constructed) // player-constructed railings
		anchored = FALSE
	if(climbable)
		verbs += /obj/structure/proc/climb_on
	if(anchored)
		update_appearance(update_neighbors = FALSE)

/obj/structure/railing/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/railing/R in orange(location, 1))
		R.update_appearance()

/obj/structure/railing/CanAllowThrough(atom/movable/mover, turf/target)
	if(!(get_dir(mover, target) & turn(dir, 180)))
		return TRUE
	return ..()

/obj/structure/railing/CheckExit(atom/movable/mover, atom/newLoc)
	if(check_standard_flag_pass(mover))
		return TRUE
	if(!(get_dir(src, newLoc) & dir))
		return TRUE
	return !density

/obj/structure/railing/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				. += "<span class='warning'>It looks severely damaged!</span>"
			if(0.25 to 0.5)
				. += "<span class='warning'>It looks damaged!</span>"
			if(0.5 to 1.0)
				. += "<span class='notice'>It has a few scrapes and dents.</span>"

/obj/structure/railing/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		new /obj/item/stack/rods(get_turf(src))
		qdel(src)

// What is this recursive Bullshit. @Zandario
/obj/structure/railing/proc/neighbor_check(update_neighbors = TRUE)
	check = 0
	//if (!anchored) return
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in src.loc)
		if ((R.dir == Lturn) && R.anchored)
			check |= 32
			if (update_neighbors)
				R.update_appearance(update_neighbors = FALSE)
		if ((R.dir == Rturn) && R.anchored)
			check |= 2
			if (update_neighbors)
				R.update_appearance(update_neighbors = FALSE)

	for (var/obj/structure/railing/R in get_step(src, Lturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 16
			if (update_neighbors)
				R.update_appearance(update_neighbors = FALSE)
	for (var/obj/structure/railing/R in get_step(src, Rturn))
		if ((R.dir == src.dir) && R.anchored)
			check |= 1
			if (update_neighbors)
				R.update_appearance(update_neighbors = FALSE)

	for (var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if ((R.dir == Rturn) && R.anchored)
			check |= 64
			if (update_neighbors)
				R.update_appearance(update_neighbors = FALSE)
	for (var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))
		if ((R.dir == Lturn) && R.anchored)
			check |= 4
			if (update_neighbors)
				R.update_appearance(update_neighbors = FALSE)

/obj/structure/railing/update_appearance(updates, update_neighbors = TRUE)
	neighbor_check(update_neighbors)

	// Ensure layering is appropriate to direction.
	switch (dir)
		if (NORTH)
			layer = BELOW_MOB_LAYER
		if (SOUTH)
			layer = ABOVE_MOB_LAYER
		if (EAST)
			layer = BELOW_MOB_LAYER
		if (WEST)
			layer = BELOW_MOB_LAYER

	return ..()

/obj/structure/railing/update_icon_state()
	. = ..()

	if (!check || !anchored)
		icon_state = "[base_icon_state]railing0"
	else
		icon_state = "[base_icon_state]railing1"

/obj/structure/railing/update_overlays()
	. = ..()

	var/list/overlays_to_add = list()
	if (check || anchored)
		if (check & 32)
			overlays_to_add += image(icon, src, "[base_icon_state]corneroverlay")
		if ((check & 16) || !(check & 32) || (check & 64))
			overlays_to_add += image(icon, src, "[base_icon_state]frontoverlay_l")
		if (!(check & 2) || (check & 1) || (check & 4))
			overlays_to_add += image(icon, src, "[base_icon_state]frontoverlay_r")
			if(check & 4)
				switch (dir)
					if (NORTH)
						overlays_to_add += image (icon, src, "[base_icon_state]mcorneroverlay", pixel_x = 32)
					if (SOUTH)
						overlays_to_add += image (icon, src, "[base_icon_state]mcorneroverlay", pixel_x = -32)
					if (EAST)
						overlays_to_add += image (icon, src, "[base_icon_state]mcorneroverlay", pixel_y = -32)
					if (WEST)
						overlays_to_add += image (icon, src, "[base_icon_state]mcorneroverlay", pixel_y = 32)

	. += overlays_to_add

/obj/structure/railing/verb/rotate_counterclockwise()
	set name = "Rotate Railing Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	src.setDir(turn(src.dir, 90))
	update_appearance()
	return

/obj/structure/railing/verb/rotate_clockwise()
	set name = "Rotate Railing Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	src.setDir(turn(src.dir, 270))
	update_appearance()
	return

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if (!can_touch(usr) || ismouse(usr))
		return

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't flip it!")
		return 0

	var/obj/occupied = neighbor_turf_impassable()
	if(occupied)
		to_chat(usr, "You can't flip \the [src] because there's \a [occupied] in the way.")
		return 0

	src.loc = get_step(src, src.dir)
	setDir(turn(dir, 180))
	update_appearance()
	return

/obj/structure/railing/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(W.is_wrench() && !anchored)
		playsound(src.loc, W.tool_sound, 50, 1)
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/stack/material/steel(get_turf(usr), 2)
			qdel(src)
			return

	// Repair
	if(health < maxhealth && istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/F = W
		if(F.welding)
			playsound(src.loc, F.tool_sound, 50, 1)
			if(do_after(user, 20, src))
				user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>", "<span class='notice'>You repair some damage to \the [src].</span>")
				health = min(health+(maxhealth/5), maxhealth) // 20% repair per application
				return

	// Install
	if(W.is_screwdriver())
		user.visible_message(anchored ? "<span class='notice'>\The [user] begins unscrewing \the [src].</span>" : "<span class='notice'>\The [user] begins fasten \the [src].</span>" )
		playsound(loc, W.tool_sound, 75, 1)
		if(do_after(user, 10, src))
			to_chat(user, (anchored ? "<span class='notice'>You have unfastened \the [src] from the floor.</span>" : "<span class='notice'>You have fastened \the [src] to the floor.</span>"))
			anchored = !anchored
			update_appearance()
			return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
				return
			if (G.state < 2)
				if(user.a_intent == INTENT_HARM)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = "head")
					take_damage(8)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
				else
					to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
					return
			else
				if (get_turf(G.affecting) == get_turf(src))
					G.affecting.forceMove(get_step(src, src.dir))
				else
					G.affecting.forceMove(get_turf(src))
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] throws [G.affecting] over \the [src]!</span>")
			qdel(W)
			return

	else
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)
		take_damage(W.force)
		user.setClickCooldown(user.get_attack_speed(W))

	return ..()

/obj/structure/railing/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

// Duplicated from structures.dm, but its a bit different.
/obj/structure/railing/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	usr.visible_message("<span class='warning'>[user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		usr.forceMove(get_step(src, src.dir))
	else
		usr.forceMove(get_turf(src))

	usr.visible_message("<span class='warning'>[user] climbed over \the [src]!</span>")
	if(!anchored)	take_damage(maxhealth) // Fatboy
	climbers -= user

/obj/structure/railing/can_climb(var/mob/living/user, post_climb_check=0)
	if(!..())
		return 0

	// Normal can_climb() handles climbing from adjacent turf onto our turf.  But railings also allow climbing
	// from our turf onto an adjacent! If that is the case we need to do checks for that too...
	if(get_turf(user) == get_turf(src))
		var/obj/occupied = neighbor_turf_impassable()
		if(occupied)
			to_chat(user, "<span class='danger'>You can't climb there, there's \a [occupied] in the way.</span>")
			return 0
	return 1

// TODO - This here might require some investigation
/obj/structure/proc/neighbor_turf_impassable()
	var/turf/T = get_step(src, src.dir)
	if(!T || !istype(T))
		return 0
	if(T.density == 1)
		return T
	for(var/obj/O in T.contents)
		if(istype(O,/obj/structure))
			var/obj/structure/S = O
			if(S.climbable) continue
		if(O && O.density && !(O.atom_flags & ATOM_BORDER && !(turn(O.dir, 180) & dir)))
			return O
