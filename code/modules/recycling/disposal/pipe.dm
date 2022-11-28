/// Disposal pipes
/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = TRUE
	density = FALSE

	layer = ABOVE_TILE_LAYER
	level = ATOM_LEVEL_UNDER_TILE
	dir = 0 // dir will contain dominant direction for junction pipes

	/// bitmask of pipe directions
	var/dpdir = 0
	/// health points 0-10
	var/health = 10
	var/sortType = ""
	var/subtype = 0
	// new pipe, set the icon_state as on map

/obj/structure/disposalpipe/Initialize(mapload)
	. = ..()
	alpha = 255
	layer = DISPOSALS_PIPE_LAYER
	base_icon_state = icon_state
	update_appearance()


/**
 * Pipe is deleted.
 * Ensure if holder is present, it is expelled.
 */
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	..()


/**
 * Returns the direction of the next pipe object, given the entrance dir.
 * By default, returns the bitmask of remaining directions.
 */
/obj/structure/disposalpipe/proc/nextdir(fromdir)
	return dpdir & (~turn(fromdir, 180))


/**
 * Transfer the holder through this pipe segment.
 * Overriden for special behaviour.
 */
/obj/structure/disposalpipe/proc/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P


// update the icon_state to reflect hidden status
/obj/structure/disposalpipe/update_appearance(updates)
	. = ..()
	var/turf/T = src.loc
	hide(!T.is_plating() && !istype(T,/turf/space)) // space never hides pipes


/obj/structure/disposalpipe/update_icon_state()
	. = ..()
	icon_state = base_icon_state


/**
 * Hide called by levelupdate if turf intact status changes.
 * Change visibility status and force update of icon.
 */
/obj/structure/disposalpipe/hide(intact)
	invisibility = intact ? 101: 0 // Hide if floor is intact.
	update_appearance()


// expel the held objects into a turf
// called when there is a break in the pipe
/obj/structure/disposalpipe/proc/expel(var/obj/structure/disposalholder/H, var/turf/T, var/direction)
	if(!istype(H))
		return

	// Empty the holder if it is expelled into a dense turf.
	// Leaving it intact and sitting in a wall is stupid.
	if(T.density)
		for(var/atom/movable/AM in H)
			AM.loc = T
			AM.pipe_eject(0)
		qdel(H)
		return


	if(!T.is_plating() && istype(T,/turf/simulated/floor)) //intact floor, pop the tile
		var/turf/simulated/floor/F = T
		F.break_tile()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff

	var/turf/target
	if(direction)		// direction is specified
		if(istype(T, /turf/space)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(direction)
				spawn(1)
					if(AM)
						AM.throw_at_old(target, 100, 1)
			H.vent_gas(T)
			qdel(H)

	else	// no specified direction, so throw in random direction

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(H)
			for(var/atom/movable/AM in H)
				target = get_offset_target_turf(T, rand(5)-rand(5), rand(5)-rand(5))

				AM.forceMove(T)
				AM.pipe_eject(0)
				spawn(1)
					if(AM)
						AM.throw_at_old(target, 5, 1)

			H.vent_gas(T)	// all gas vent to turf
			qdel(H)

	return

// call to break the pipe
// will expel any holder inside at the time
// then delete the pipe
// remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/proc/broken(var/remains = 0)
	if(remains)
		for(var/D in GLOB.cardinal)
			if(D & dpdir)
				var/obj/structure/disposalpipe/broken/P = new(src.loc)
				P.setDir(D)

	src.invisibility = 101	// make invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)

	spawn(2)	// delete pipe after 2 ticks to ensure expel proc finished
		qdel(src)


// pipe affected by explosion
/obj/structure/disposalpipe/legacy_ex_act(severity)

	switch(severity)
		if(1.0)
			broken(0)
			return
		if(2.0)
			health -= rand(5,15)
			healthcheck()
			return
		if(3.0)
			health -= rand(0,15)
			healthcheck()
			return


// test health for brokenness
/obj/structure/disposalpipe/proc/healthcheck()
	if(health < -2)
		broken(0)
	else if(health<1)
		broken(1)
	return

//attack by item
//weldingtool: unfasten and convert to obj/disposalconstruct

/obj/structure/disposalpipe/attackby(var/obj/item/I, var/mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user, 0, I)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0,user))
			playsound(src, W.tool_sound, 50, 1)
			// check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			to_chat(user, "Slicing the disposal pipe.")
			sleep(30)
			if(!W.isOn()) return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")
			return

// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()

	var/obj/structure/disposalconstruct/C = new (src.loc)
	switch(base_icon_state)
		if("pipe-s")
			C.ptype = 0
		if("pipe-c")
			C.ptype = 1
		if("pipe-j1")
			C.ptype = 2
		if("pipe-j2")
			C.ptype = 3
		if("pipe-y")
			C.ptype = 4
		if("pipe-t")
			C.ptype = 5
		if("pipe-j1s")
			C.ptype = 9
			C.sortType = sortType
		if("pipe-j2s")
			C.ptype = 10
			C.sortType = sortType
///// Z-Level stuff
		if("pipe-u")
			C.ptype = 11
		if("pipe-d")
			C.ptype = 12
///// Z-Level stuff
		if("pipe-tagger")
			C.ptype = 13
		if("pipe-tagger-partial")
			C.ptype = 14
	C.subtype = src.subtype
	src.transfer_fingerprints_to(C)
	C.setDir(dir)
	C.density = FALSE
	C.anchored = TRUE
	C.update_appearance()

	qdel(src)

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(H)
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case

			for(var/atom/movable/AM in H)
				AM.forceMove(T)
				AM.pipe_eject(0)
			qdel(H)
			..()
			return

		// otherwise, do normal expel from turf
		if(H)
			expel(H, T, 0)
	..()

/obj/structure/disposalpipe/hides_under_flooring()
	return 1

// *** TEST verb
//client/verb/dispstop()
//	for(var/obj/structure/disposalholder/H in world)
//		H.active = 0

// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/New()
	..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)

	update_appearance()
	return

///// Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/New()
	..()
	dpdir = dir
	update_appearance()
	return

/obj/structure/disposalpipe/up/nextdir(fromdir)
	var/nextdir
	if(fromdir == 11)
		nextdir = dir
	else
		nextdir = 12
	return nextdir

/obj/structure/disposalpipe/up/transfer(var/obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.setDir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 12)
		T = GetAbove(src)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/down/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/New()
	..()
	dpdir = dir
	update_appearance()
	return

/obj/structure/disposalpipe/down/nextdir(fromdir)
	var/nextdir
	if(fromdir == 12)
		nextdir = dir
	else
		nextdir = 11
	return nextdir

/obj/structure/disposalpipe/down/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.dir = nextdir

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 11)
		T = GetBelow(src)
		if(!T)
			H.forceMove(src.loc)
			return
		else
			for(var/obj/structure/disposalpipe/up/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P
///// Z-Level stuff

/obj/structure/disposalpipe/junction/yjunction
	icon_state = "pipe-y"

//a three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/New()
	..()
	if(icon_state == "pipe-j1")
		dpdir = dir | turn(dir, -90) | turn(dir,180)
	else if(icon_state == "pipe-j2")
		dpdir = dir | turn(dir, 90) | turn(dir,180)
	else // pipe-y
		dpdir = dir | turn(dir,90) | turn(dir, -90)
	update_appearance()
	return


// next direction to move
// if coming in from secondary dirs, then next is primary dir
// if coming in from primary dir, then next is equal chance of other dirs
/obj/structure/disposalpipe/junction/nextdir(var/fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir)	// came from secondary dir
		return dir		// so exit through primary
	else				// came from primary
						// so need to choose either secondary exit
		var/mask = ..(fromdir)

		// find a bit which is set
		var/setbit = 0
		if(mask & NORTH)
			setbit = NORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50))	// 50% chance to choose the found bit or the other one
			return setbit
		else
			return mask & (~setbit)

/obj/structure/disposalpipe/junction/flipped //for easier and cleaner mapping
	icon_state = "pipe-j2"

/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0

/obj/structure/disposalpipe/tagger/Initialize(mapload)
	. = ..()

	dpdir = dir | turn(dir, 180)
	if(sort_tag) GLOB.tagger_locations |= sort_tag
	update_appearance()

/obj/structure/disposalpipe/tagger/update_name()
	. = ..()
	if(sort_tag)
		name = "[initial(name)] ([sort_tag])"
	else
		name = initial(name)

/obj/structure/disposalpipe/tagger/update_desc()
	. = ..()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '[sort_tag]' tag."

/obj/structure/disposalpipe/tagger/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(istype(I, /obj/item/destTagger))
		var/obj/item/destTagger/O = I

		if(O.currTag)// Tag set
			sort_tag = O.currTag
			playsound(src.loc, 'sound/machines/twobeep.ogg', 100, TRUE)
			to_chat(user, SPAN_NOTICE("Changed tag to '[sort_tag]'."))
			update_appearance(UPDATE_NAME|UPDATE_DESC)

/obj/structure/disposalpipe/tagger/transfer(obj/structure/disposalholder/H)
	if(sort_tag)
		if(partial)
			H.setpartialtag(sort_tag)
		else
			H.settag(sort_tag)
	return ..()

/// Needs two passes to tag.
/obj/structure/disposalpipe/tagger/partial
	name = "partial package tagger"
	icon_state = "pipe-tagger-partial"
	partial = 1


/// A broken pipe.
/obj/structure/disposalpipe/broken
	desc = "A broken piece of disposal pipe."
	icon_state = "pipe-b"
	// broken pipes have dpdir=0 so they're not found as 'real' pipes
	// i.e. will be treated as an empty turf
	dpdir = 0

/obj/structure/disposalpipe/broken/New()
	..()
	update_appearance()
	return


/**
 * Called when welded.
 * For broken pipe, remove and turn into scrap.
 */
/obj/structure/disposalpipe/broken/welded()
	// var/obj/item/scrap/S = new(src.loc)
	// S.set_components(200,0,0)
	qdel(src)
