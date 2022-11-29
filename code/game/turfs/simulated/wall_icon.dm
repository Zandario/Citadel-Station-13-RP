/**
 * generates damage overlays
 */
/proc/generate_wall_damage_overlays()
	// arbitrary, hardcoded number for now: 16
	var/amt = 16
	var/alpha_inc = 256 / 16
	var/list/generated = list()
	generated.len = amt
	. = generated
	for(var/i in 1 to 16)
		var/image/I = image(icon = 'icons/turf/walls/damage_masks.dmi', icon_state = "overlay_damage")
		I.blend_mode = BLEND_MULTIPLY
		I.alpha = (i * alpha_inc) - 1
		generated[i] = I

/turf/simulated/wall/proc/can_join_with(turf/simulated/wall/target_wall)
	if(material && istype(target_wall.material))
		var/other_wall_icon = target_wall.get_wall_icon()
		if(material.wall_blend_icons[other_wall_icon])
			return NULLTURF_BORDER
		if(get_wall_icon() == other_wall_icon)
			return ADJ_FOUND
	return NO_ADJ_FOUND

// funny thing
// we nowadays hijack tg's smoothing for our own purposes.
// we can be faster with entirely our own code but this is more generic.

// overridden find type
/turf/simulated/wall/find_type_in_direction(direction)
	if(!material)
		return NO_ADJ_FOUND

	var/turf/simulated/wall/T = get_step(src, direction)
	if(!T)
		return NULLTURF_BORDER

	return (istype(T) && (material.base_icon_state == T.material?.base_icon_state))? ADJ_FOUND : NO_ADJ_FOUND

/turf/simulated/wall/custom_smooth(dirs)
	smoothing_junction = dirs
	update_icon()

/turf/simulated/wall/proc/get_wall_icon()
	return (istype(material) && material.base_icon) || 'icons/turf/walls/solid.dmi'

/turf/simulated/wall/proc/get_wall_icon_state()
	return (istype(material) && material.base_icon_state) || "wall"

/turf/simulated/wall/proc/apply_reinf_overlay()
	return istype(reinf_material)

/turf/simulated/wall/proc/get_wall_color()
	var/wall_color = wall_paint
	if(!wall_color)
		var/datum/material/mat_ref = material
		wall_color = mat_ref.base_color
	return wall_color

/turf/simulated/wall/proc/get_stripe_color()
	var/stripe_color = stripe_paint
	if(!stripe_color)
		stripe_color = get_wall_color()
	return stripe_color

/turf/simulated/wall/update_icon()
	. = ..()
	icon = get_wall_icon()
	color = get_wall_color()

/turf/simulated/wall/update_overlays()
	if(!material)
		return ..()
	else if(!ispath(material, /datum/material))
		stack_trace("update_overlays() called on [src] with an invalid material set.")

	// Updating the unmanaged wall overlays (unmanaged for optimisations)
	overlays.Cut()

	// Soon:tm: @Zandario
	// TODO: MAKE FAKEWALLS NOT TURFS WTF
	// handle fakewalls
	if(!density)
		var/mutable_appearance/falsewall_img = mutable_appearance(get_wall_icon(), "[get_wall_icon_state()]_fwall_open")
		falsewall_img.color = material.base_color
		overlays += falsewall_img
		return ..()

	// Wall Stripes!
	if(stripe_paint)
		var/mutable_appearance/smoothed_stripe = mutable_appearance(material.stripe_icon, icon_state)
		smoothed_stripe.color = get_stripe_color()
		overlays += smoothed_stripe

	var/neighbor_stripe = NONE
	if(!neighbor_typecache)
		neighbor_typecache = typecacheof(list(
			/obj/machinery/door/airlock,
			/obj/structure/window/reinforced/full,
			/obj/machinery/door/blast,
			// /obj/structure/low_wall,
		))

	for(var/cardinal in GLOB.cardinal)
		var/turf/step_turf = get_step(src, cardinal)
		if(!can_area_smooth(step_turf))
			continue
		for(var/atom/movable/movable_thing as anything in step_turf)
			if(neighbor_typecache[movable_thing.type] || iswallturf(movable_thing.type))
				neighbor_stripe ^= cardinal
				break

	if(neighbor_stripe )//&& material.wall_flags & WALL_FLAG_HAS_EDGES
		// This is the only hardpathed icon cause we only use one set for everything.
		var/mutable_appearance/neighb_stripe_appearace = mutable_appearance('icons/turf/walls/neighbor_stripe.dmi', "stripe-[neighbor_stripe]")
		// neighb_stripe_appearace.color = get_stripe_color()
		overlays += neighb_stripe_appearace

	// if(rusted)
	// 	var/mutable_appearance/rust_overlay = mutable_appearance('icons/turf/rust_overlay.dmi', "blobby_rust", appearance_flags = RESET_COLOR)
	// 	overlays += rust_overlay

	// Construction and Reinforcement overlays

	if(construction_stage != null && construction_stage < 6)
		var/mutable_appearance/construction_overlay = mutable_appearance('icons/turf/walls/_construction_overlays.dmi', "[construction_stage]", appearance_flags = RESET_COLOR)
		construction_overlay.color = wall_paint ? wall_paint : reinf_material.base_color
		overlays += construction_overlay
	else
		var/mutable_appearance/reinforcement_overlay
		if(reinf_material.icon_reinf_directionals)
			reinforcement_overlay = mutable_appearance(reinf_material.reinf_icon, icon_state, appearance_flags = RESET_COLOR)
			reinforcement_overlay.color = wall_paint ? wall_paint : reinf_material.base_color
			overlays += reinforcement_overlay
		else
			reinforcement_overlay = mutable_appearance(reinf_material.reinf_icon, reinf_material.reinf_icon_state, appearance_flags = RESET_COLOR)
			reinforcement_overlay.color = wall_paint ? wall_paint : reinf_material.base_color
			overlays += reinforcement_overlay

	// Handle damage overlays.
	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		overlays += damage_overlays[overlay]

	// ..() has to be last to prevent trampling managed overlays
	return ..()
