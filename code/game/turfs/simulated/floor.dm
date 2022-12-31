/turf/simulated/floor
	name = "plating"
	desc = "Unfinished flooring."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating_preview"
	base_icon_state = "plating"
	thermal_conductivity = 0.040
	heat_capacity = 10000

	smoothing_flags = SMOOTH_CUSTOM
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_OPEN_FLOOR)
	canSmoothWith = list(SMOOTH_GROUP_OPEN_FLOOR, SMOOTH_GROUP_TURF_OPEN)

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/static/list/base_footstep_sounds = list("human" = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'))

	var/list/old_decals = null // Remember what decals we had between being pried up and replaced.

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/singleton/flooring/flooring
	var/mineral = MAT_STEEL

	// var/health = 100
	// var/maxHealth = 100

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/Initialize(mapload, floortype)
	. = ..()
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(get_flooring_data(floortype), TRUE, FALSE)
	else
		footstep_sounds = base_footstep_sounds
	if(mapload && can_dirty && can_start_dirty)
		if(prob(dirty_prob))
			dirt += rand(50,100)
			update_dirt() //5% chance to start with dirt on a floor tile- give the janitor something to do

/turf/simulated/proc/make_outdoors()
	outdoors = TRUE
	SSplanets.addTurf(src)

/turf/simulated/proc/make_indoors()
	outdoors = FALSE
	SSplanets.removeTurf(src)

/turf/simulated/AfterChange(flags, oldType)
	. = ..()
	RemoveLattice()
	// If it was outdoors and still is, it will not get added twice when the planet controller gets around to putting it in.
	if(flags & CHANGETURF_PRESERVE_OUTDOORS)
		// if it didn't preserve then we don't need to recheck now do we
		if(outdoors)
			make_outdoors()
		else
			make_indoors()

/**
 * TODO: REWORK FLOORING GETTERS/INIT/SETTERS THIS IS BAD
 */

//If the update var is false we don't call update icons
/turf/simulated/floor/proc/set_flooring(singleton/flooring/newflooring, init, update = TRUE)
	make_plating(null, TRUE)
	flooring = newflooring
	name = flooring.name
	footstep_sounds = newflooring.footstep_sounds
	// We are plating switching to flooring, swap out old_decals for decals
	var/list/overfloor_decals = old_decals
	old_decals = decals
	decals = overfloor_decals
	// maxHealth = flooring.health
	// health = maxHealth
	flooring_override = null

	/*This is passed false in the New() flooring set, so that we're not calling everything up to
	nine times when the world is created. This saves on tons of roundstart processing*/
	if (update)
		update_icon(1)
	if(!init)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

	levelupdate()

//
//
/**
 * This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
 * This proc auto corrects the grass tiles' siding.
 * Use strip_bare as an override to create a lattice instead of plating.
 */
/turf/simulated/floor/proc/make_plating(place_product, defer_icon_update, strip_bare = FALSE)

	cut_overlays()
	if(flooring)
		if(islist(decals))
			// We are flooring switching to plating, swap out old_decals for decals.
			var/list/underfloor_decals = old_decals
			old_decals = decals
			decals = underfloor_decals

		if(place_product)
			flooring.drop_product(src)
		// We attempt to get whatever should be under this floor.
		var/newtype = flooring.get_plating_type(src) // This will return null if there's nothing underneath.
		if(newtype || !strip_bare) // Has a custom plating type to become
			set_flooring(get_flooring_data(newtype))
		else
			flooring = null
			ReplaceWithLattice() // IF there's nothing underneath, turn ourselves into an openspace.
			// this branch is only if we don't set flooring because otherwise it'll do it for us
			if(!defer_icon_update)
				name = base_name
				desc = base_desc
				icon = base_icon
				icon_state = base_icon_state
				footstep_sounds = base_footstep_sounds
				QUEUE_SMOOTH(src)
				QUEUE_SMOOTH_NEIGHBORS(src)
				levelupdate()

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null


/turf/simulated/floor/levelupdate()
	if (flooring)
		for(var/obj/O in src)
			O.hide(O.hides_under_flooring() && (flooring.flags & TURF_HIDES_THINGS))
			SEND_SIGNAL(O, COMSIG_TURF_LEVELUPDATE, (flooring.flags & TURF_HIDES_THINGS))

/turf/simulated/floor/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			// A wall costs four sheets to build (two for the grider and two for finishing it).
			var/cost = RCD_SHEETS_PER_MATTER_UNIT * 4
			// R-walls cost five sheets, however.
			if(the_rcd.make_rwalls)
				cost += RCD_SHEETS_PER_MATTER_UNIT * 1
			return list(
				RCD_VALUE_MODE = RCD_FLOORWALL,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = cost
			)
		if(RCD_AIRLOCK)
			// Airlock assemblies cost four sheets. Let's just add another for the electronics/wires/etc.
			return list(
				RCD_VALUE_MODE = RCD_AIRLOCK,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
		if(RCD_WINDOWGRILLE)
			// One steel sheet for the girder (two rods, which is one sheet).
			return list(
				RCD_VALUE_MODE = RCD_WINDOWGRILLE,
				RCD_VALUE_DELAY = 1 SECOND,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 1
			)
		if(RCD_DECONSTRUCT)
			// Old RCDs made deconning the floor cost 10 units (IE, three times on full RCD).
			// Now it's ten sheets worth of units (which is the same capacity-wise, three times on full RCD).
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 10
			)
	return FALSE


/turf/simulated/floor/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, SPAN_NOTICE("You build a wall."))
			PlaceOnTop(/turf/simulated/wall)
			var/turf/simulated/wall/T = get_turf(src) // Ref to the wall we just built.
			// Apparently set_material(...) for walls requires refs to the material singletons and not strings.
			// This is different from how other material objects with their own set_material(...) do it, but whatever.
			var/datum/material/M = name_to_material[the_rcd.material_to_use]
			T.set_material(M, the_rcd.make_rwalls ? M : null, M)
			T.add_hiddenprint(user)
			return TRUE
		if(RCD_AIRLOCK)
			if(locate(/obj/machinery/door/airlock) in src)
				return FALSE // No more airlock stacking.
			to_chat(user, SPAN_NOTICE("You build an airlock."))
			new the_rcd.airlock_type(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(locate(/obj/structure/grille) in src)
				return FALSE
			to_chat(user, SPAN_NOTICE("You construct the grille."))
			var/obj/structure/grille/G = new(src)
			G.anchored = TRUE
			return TRUE
		if(RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			ScrapeAway(flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
			return TRUE
