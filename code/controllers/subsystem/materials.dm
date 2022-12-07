/**
 *! How material datums work.
 *
 * Materials are now instanced datums, with an associative list of them being kept in SSmaterials.
 * We only instance the materials once and then re-use these instances for everything.
 *
 * These materials call on_applied() on whatever item they are applied to, common effects are adding components, changing color and changing description.
 * This allows us to differentiate items based on the material they are made out of.
 */
SUBSYSTEM_DEF(materials)
	name = "Materials"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// Dictionary of material.uid || material ref.
	var/list/materials
	/// Dictionary of type || list of material refs.
	var/list/materials_by_type
	/// Dictionary of type || list of material uid.
	var/list/material_uids_by_type


/// Ran on initialize, populated the materials and materials_by_category dictionaries with their appropiate vars (See these variables for more info)
/datum/controller/subsystem/materials/proc/initialize_materials()
	materials = list()
	materials_by_type = list()
	material_uids_by_type = list()
	for(var/type in subtypesof(/datum/material))
		var/datum/material/mat_type = type
		if(!(initial(mat_type.init_flags) & MATERIAL_INIT_MAPLOAD))
			continue // Do not initialize at mapload
		initialize_material(list(mat_type))

/**
 *! Creates and caches a material datum.
 *
 * Arugments:
 * - [arguments][/list]: The arguments to use to create the material datum
 *   - The first element is the type of material to initialize.
 */
/datum/controller/subsystem/materials/proc/initialize_material(list/arguments)
	var/datum/material/mat_type = arguments[1]
	if(initial(mat_type.init_flags) & MATERIAL_INIT_BESPOKE)
		arguments[1] = get_uid_from_arguments(arguments)

	var/datum/material/mat_ref = new mat_type
	if(!mat_ref.Initialize(arglist(arguments)))
		return null

	var/mat_uid = mat_ref.uid
	materials[mat_uid] = mat_ref
	materials_by_type[mat_type] += list(mat_ref)
	material_uids_by_type[mat_type] += list(mat_uid)

	SEND_SIGNAL(src, COMSIG_MATERIALS_INIT_MAT, mat_ref)
	return mat_ref

/**
 *! Fetches a cached material singleton when passed sufficient arguments.
 *
 * Arguments:
 * - [arguments][/list]: The list of arguments used to fetch the material ref.
 *   - The first element is a material datum, text string, or material type.
 *     - [Material datums][/datum/material] are assumed to be references to the cached datum and are returned
 *     - Text is assumed to be the text ID of a material and the corresponding material is fetched from the cache
 *     - A material type is checked for bespokeness:
 *       - If the material type is not bespoke the type is assumed to be the uid for a material and the corresponding material is loaded from the cache.
 *       - If the material type is bespoke a text ID is generated from the arguments list and used to load a material datum from the cache.
 *   - The following elements are used to generate bespoke IDs
 */
/datum/controller/subsystem/materials/proc/_get_material_ref(list/arguments)
	if(!materials)
		initialize_materials()

	var/datum/material/key = arguments[1]
	if(istype(key))
		return key // We are assuming here that the only thing allowed to create material datums is [/datum/controller/subsystem/materials/proc/initialize_material]

	if(istext(key)) // Handle text uid
		. = materials[key]
		if(!.)
			WARNING("Attempted to fetch material ref with invalid text uid '[isnull(key) ? "null" : key]'")
		return

	if(!ispath(key, /datum/material))
		CRASH("Attempted to fetch material ref with invalid key [isnull(key) ? "null" : key]")

	if(!(initial(key.init_flags) & MATERIAL_INIT_BESPOKE))
		. = materials[key]
		if(!.)
			WARNING("Attempted to fetch reference to an abstract material with key [isnull(key) ? "null" : key]")
		return

	key = get_uid_from_arguments(arguments)
	return materials[key] || initialize_material(arguments)

/**
 *! I'm not going to lie, this was swiped from [SSdcs][/datum/controller/subsystem/processing/dcs].
 * Credit does to @ninjanomnom
 *
 * Generates an uid for bespoke ~~elements~~ materials when given the argument list
 * Generating the uid here is a bit complex because we need to support named arguments
 * Named arguments can appear in any order and we need them to appear after ordered arguments
 * We assume that no one will pass in a named argument with a value of null
 **/
/datum/controller/subsystem/materials/proc/get_uid_from_arguments(list/arguments)
	var/datum/material/mattype = arguments[1]
	var/list/full_uid = list("[initial(mattype.uid) || mattype]")
	var/list/named_arguments = list()
	for(var/i in 2 to length(arguments))
		var/key = arguments[i]
		var/value
		if(istext(key))
			value = arguments[key]
		if(!(istext(key) || isnum(key)))
			key = REF(key)
		key = "[key]" // Key is stringified so numbers dont break things
		if(!isnull(value))
			if(!(istext(value) || isnum(value)))
				value = REF(value)
			named_arguments["[key]"] = value
		else
			full_uid += "[key]"

	if(length(named_arguments))
		named_arguments = sort_list(named_arguments)
		full_uid += named_arguments
	return list2params(full_uid)
