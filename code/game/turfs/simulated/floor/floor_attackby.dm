/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(isliving(user) && istype(C, /obj/item))
		var/mob/living/L = user
		if(L.a_intent != INTENT_HELP)
			attack_tile(C, L) // Be on help intent if you want to decon something.
			return

	if(istype(C, /obj/item/stack/tile/roofing))
		var/expended_tile = FALSE // To track the case. If a ceiling is built in a multiz zlevel, it also necessarily roofs it against weather
		var/turf/T = above()
		var/obj/item/stack/tile/roofing/R = C

		// Patch holes in the ceiling
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
			 	// Must be build adjacent to an existing floor/wall, no floating floors
				var/list/cardinalTurfs = list() // Up a Z level
				for(var/dir in GLOB.cardinal)
					var/turf/B = get_step(T, dir)
					if(B)
						cardinalTurfs += B

				var/turf/simulated/A = locate(/turf/simulated/floor) in cardinalTurfs
				if(!A)
					A = locate(/turf/simulated/wall) in cardinalTurfs
				if(!A)
					to_chat(user, "<span class='warning'>There's nothing to attach the ceiling to!</span>")
					return

				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ReplaceWithLattice()
					T.ChangeTurf(/turf/simulated/floor, flags = CHANGETURF_INHERIT_AIR | CHANGETURF_PRESERVE_OUTDOORS)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] patches a hole in the ceiling.</span>", "<span class='notice'>You patch a hole in the ceiling.</span>")
					expended_tile = TRUE
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return

		// Create a ceiling to shield from the weather
		if(outdoors)
			for(var/dir in GLOB.cardinal)
				var/turf/A = get_step(src, dir)
				if(A && !A.outdoors)
					if(expended_tile || R.use(1))
						make_indoors()
						playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
						user.visible_message("<span class='notice'>[user] roofs a tile, shielding it from the elements.</span>", "<span class='notice'>You roof this tile, shielding it from the elements.</span>")
					break
		return

	if(flooring)
		if(istype(C, /obj/item))
			try_deconstruct_tile(C, user)
			return
		else if(istype(C, /obj/item/stack/cable_coil))
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return
		else if(istype(C, /obj/item/stack/tile))
			try_replace_tile(C, user)
			return
	else

		if(istype(C, /obj/item/stack/cable_coil))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
			return

		//? Tile Handling.
			// TODO: Murder and Refactor. @Zandario
		else if(istype(C, /obj/item/stack/tile))
			if(broken || burnt)
				to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
				return

			var/obj/item/stack/tile/tile_stack = C

			var/singleton/flooring/use_flooring
			for(var/singleton/flooring/Flooring as anything in flooring_types)
				Flooring = flooring_types[Flooring]
				if(!Flooring.build_type)
					continue
				if((tile_stack.type == Flooring.build_type) || (tile_stack.turf_type == Flooring.build_type))
					use_flooring = Flooring
					break

			// Failed to get a turf from the stack.
			if(!use_flooring)
				stack_trace("Failed to get a Flooring Type from the stack ([use_flooring])!")
				return

			// Do we have enough?
			if(use_flooring.build_cost && tile_stack.amount < use_flooring.build_cost)
				to_chat(user, SPAN_WARNING("You require at least [use_flooring.build_cost] [tile_stack.name] to complete the [use_flooring.descriptor]."))
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time))
				return
			if(flooring || !tile_stack || !user || !use_flooring)
				return
			if(tile_stack.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, TRUE)
				return
			// End of awful flooring code.

		// Repairs.
		else if(istype(C, /obj/item/weldingtool))
			var/obj/item/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.remove_fuel(0,user))
						to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
						playsound(src, welder.tool_sound, 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")

/turf/simulated/floor/proc/try_deconstruct_tile(obj/item/W as obj, mob/user as mob)
	if(W.is_crowbar())
		if(broken || burnt)
			to_chat(user, "<span class='notice'>You remove the broken [flooring.descriptor].</span>")
			make_plating(place_product = FALSE)
		else if(flooring.flooring_flags & TURF_IS_FRAGILE)
			to_chat(user, "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>")
			make_plating(place_product = FALSE)
		else if(flooring.flooring_flags & TURF_REMOVE_CROWBAR)
			to_chat(user, "<span class='notice'>You lever off the [flooring.descriptor].</span>")
			make_plating(place_product = TRUE)
		else
			return 0
		playsound(src, W.tool_sound, 80, 1)
		return 1
	else if(W.is_screwdriver() && (flooring.flooring_flags & TURF_REMOVE_SCREWDRIVER))
		if(broken || burnt)
			return 0
		to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
		make_plating(place_product = TRUE)
		playsound(src, W.tool_sound, 80, 1)
		return 1
	else if(W.is_wrench() && (flooring.flooring_flags & TURF_REMOVE_WRENCH))
		to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
		make_plating(place_product = TRUE)
		playsound(src, W.tool_sound, 80, 1)
		return 1
	else if(istype(W, /obj/item/shovel) && (flooring.flooring_flags & TURF_REMOVE_SHOVEL))
		to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
		make_plating(place_product = TRUE)
		playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
		return 1
	return 0

/turf/simulated/floor/proc/try_replace_tile(obj/item/stack/tile/T as obj, mob/user as mob)
	if(T.type == flooring.build_type)
		return
	var/obj/item/W = user.get_inactive_held_item()
	if(!try_deconstruct_tile(W, user))
		return
	if(flooring)
		return
	attackby(T, user)
