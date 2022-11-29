/**
 *	MATERIAL DATUMS
 *	This data is used by various parts of the game for basic physical properties and behaviors
 *	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
 *	self-explanatory but the various object types may have their own documentation. ~Z
 *
 *	PATHS THAT USE DATUMS
 *		turf/simulated/wall
 *		obj/item/material
 *		obj/structure/barricade
 *		obj/item/stack/material
 *		obj/structure/table
 *
 *	VALID ICONS
 *		WALLS
 *			stone
 *			metal
 *			solid
 *			resin
 *			ONLY WALLS
 *				cult
 *				hull
 *				curvy
 *				jaggy
 *				brick
 *				REINFORCEMENT
 *					reinf_over
 *					reinf_mesh
 *					reinf_cult
 *					reinf_metal
 *		DOORS
 *			stone
 *			metal
 *			resin
 *			wood
*/

/// Assoc list containing all material datums indexed by name.
var/list/name_to_material


/**
 * Returns the material the object is made of, if applicable.
 * Will we ever need to return more than one value here? Or should we just return the "dominant" material.
 */
/obj/proc/get_material()
	return null


// Mostly for convenience.
/obj/proc/get_material_name()
	var/datum/material/material = get_material()
	if(material)
		return material.name

// Builds the datum list above.
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/datum/material) - /datum/material)
		var/datum/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

/// Safety proc to make sure the material list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	return name_to_material[name]

/proc/material_display_name(name)
	var/datum/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null

// Material definition and procs follow.
/datum/material
	//! Abstract
	/**
	 * What the material is indexed by in the SSmaterials.materials list.
	 * Defaults to the type of the material.
	 */
	var/id

	/// Unique name for use in indexing the list.
	var/name
	/// Prettier name for display.
	var/display_name
	var/solid_name
	var/gas_name
	var/liquid_name
	var/use_name
	/// Name given to walls of this material.
	var/wall_name = "wall"
	/// Various status modifiers.
	var/material_flags = NONE
	///Bitflags that influence how SSmaterials handles this material.
	var/init_flags = MATERIAL_INIT_MAPLOAD
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel

	//! Shards/tables/structures
	/// Path of debris object.
	var/shard_type = SHARD_SHRAPNEL
	/// Related to above.
	var/shard_icon
	/// Can shards be turned into sheets with a welder?
	var/shard_can_repair = 1
	/// Holder for all recipes usable with a sheet of this material.
	var/list/recipes
	/// Fancy string for barricades/tables/objects exploding.
	var/destruction_desc = "breaks apart"

	//! Appearance
	/// Color applied to products of this material.
	var/base_color
	/// Will stacks made from this material pass their colors onto objects?
	var/pass_stack_colors = FALSE
	/// Do we have directional reinforced states on walls?
	var/icon_reinf_directionals = TRUE
	/// Research level for stacks.
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1)
	/// Controls various appearance settings for walls.
	var/wall_flags = NONE
	/// Which wall icon types walls of this material type will consider blending with. Assoc list (icon path = TRUE/FALSE)
	var/list/wall_blend_icons = list()

	//! Icons
	/// The icon we use for walls for this material.
	var/base_icon    = 'icons/turf/walls/solid.dmi'
	/// The icon we use for walls for this material when used to reinforce walls.
	var/reinf_icon   = 'icons/turf/walls/reinforced_metal.dmi'
	/// The icon we use for the bottomhalf of walls for this material.
	var/stripe_icon = 'icons/turf/walls/solid_stripe.dmi'
	/// The icon we use for walls for this material when it's naturally occurring.
	var/natural_icon = 'icons/turf/walls/natural.dmi'

	/// The icon we use for doors for this material.
	var/door_icon_base = 'icons/obj/doors/material_doors.dmi'

	//! Icon States
	/// The icon_state we use for walls for this material.
	var/base_icon_state    = "wall"
	/// Overlay icon_state state used to reinforce walls.
	var/reinf_icon_state   = "wall"

	//! Attributes
	/// Delay in ticks when cutting through this wall.
	var/cut_delay = 0
	/// Radiation var. Used in wall and object processing to irradiate surroundings.
	var/radioactivity
	/// K, point at which the material catches on fire.
	var/ignition_point
	/// K, walls will take damage if they're next to a fire hotter than this
	var/melting_point = 1800
	/// K, point that material will become a gas.
	var/boiling_point = 3000 //TODO: Implement
	/// kJ/kg, enthalpy of vaporization
	var/latent_heat = 7000 //TODO: Implement
	/// kg/mol,
	var/molar_mass = 0.06 //TODO: Implement
	/// General-use HP value for products.
	var/integrity = 150
	/// How well this material works as armor.  Higher numbers are better, diminishing returns applies.
	var/protectiveness = 10
	/// Is the material transparent? 0.5< makes transparent walls/doors.
	var/opacity = TRUE
	/// How reflective to light is the material?  Currently used for laser reflection and defense.
	var/reflectivity = 0
	/// Only used by walls currently.
	var/explosion_resistance = 5
	/// Objects that respect this will randomly absorb impacts with this var as the percent chance.
	var/negation = 0
	/// Objects that have trouble staying in the same physical space by sheer laws of nature have this. Percent for respecting items to cause teleportation.
	var/spatial_instability = 0
	/// Objects without this var add NOCONDUCT to flags on spawn.
	var/conductive = 1
	/// How conductive the material is. Iron acts as the baseline, at 10.
	var/conductivity = null
	/// If set, object matter var will be a list containing these values.
	var/list/composite_material
	var/luminescence
	/// Radiation resistance, which is added on top of a material's weight for blocking radiation. Needed to make lead special without superrobust weapons.
	var/radiation_resistance = 0

	//! Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/created_fulltile_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	//! Damage values.
	/// Prob of wall destruction by hulk, used for edge damage in weapons.  Also used for bullet protection in armor.
	var/hardness = 60
	/// Determines blunt damage/throw_force for weapons.
	var/weight = 20

	/// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	/// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	/// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	/// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"


/**
 * Handles initializing the material.
 *
 * Arugments:
 * - _id: The ID the material should use. Overrides the existing ID.
 */
/datum/material/proc/Initialize(_id, ...)
	if(_id)
		id = _id
	else if(isnull(id))
		id = type

	// TODO: Implement.
	// if(texture_layer_icon_state)
	// 	cached_texture_filter_icon = icon('icons/materials/composite.dmi', texture_layer_icon_state)

	return TRUE


// Make sure we have a display name and shard icon even if they aren't explicitly set.
/datum/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!solid_name)
		solid_name = display_name
	if(!shard_icon)
		shard_icon = shard_type


/// Placeholders for light tiles and rglass.
/datum/material/proc/build_rod_product(mob/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need one rod and one sheet of [display_name] to make anything useful.</span>")
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)


/datum/material/proc/build_wired_product(mob/living/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, "<span class='warning'>You cannot make anything out of \the [target_stack]</span>")
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, "<span class='warning'>You need five wires and one sheet of [display_name] to make anything useful.</span>")
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, "<span class='notice'>You attach wire to the [name].</span>")
	var/obj/item/product = new wire_product(get_turf(user))
	user.put_in_hands(product)


/// This is a placeholder for proper integration of windows/windoors into the system.
/datum/material/proc/build_windows(mob/living/user, obj/item/stack/used_stack)
	return FALSE


/// Weapons handle applying a divisor for this value locally.
/datum/material/proc/get_blunt_damage()
	return weight //todo


/// Return the matter comprising this material.
/datum/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	else
		temp_matter[name] = SHEET_MATERIAL_AMOUNT
	return temp_matter

// As above.
/datum/material/proc/get_edge_damage()
	return hardness //todo


/// Snowflakey, only checked for alien doors at the moment.
/datum/material/proc/can_open_material_door(mob/living/user)
	return TRUE


/// Currently used for weapons and objects made of uranium to irradiate things.
/datum/material/proc/products_need_process()
	return (radioactivity>0) //todo


/// Used by walls when qdel()ing to avoid neighbor merging.
/datum/material/placeholder
	name = "placeholder"


/// Places a girder object when a wall is dismantled, also applies reinforced material.
/datum/material/proc/place_dismantled_girder(turf/target, datum/material/reinf_material, datum/material/girder_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()
	if(girder_material)
		if(istype(girder_material, /datum/material))
			girder_material = girder_material.name
		G.set_material(girder_material)


/**
 * General wall debris product placement.
 * Not particularly necessary aside from snowflakey cult girders.
 */
/datum/material/proc/place_dismantled_product(turf/target, amount)
	place_sheet(target, amount)


/**
 * Debris product.
 *! Used ALL THE TIME.
 */
/datum/material/proc/place_sheet(turf/target, amount)
	if(stack_type)
		return new stack_type(target, ispath(stack_type, /obj/item/stack)? amount : null)

// As above.
/datum/material/proc/place_shard(turf/target)
	if(shard_type)
		return new /obj/item/material/shard(target, src.name)


/// Used by walls and weapons to determine if they break or not.
/datum/material/proc/is_brittle()
	return !!(material_flags & MATERIAL_BRITTLE)


/datum/material/proc/combustion_effect(turf/our_turf, temperature)
	return


/datum/material/proc/wall_touch_special(turf/simulated/wall/target_wall, mob/living/living_victim)
	return
