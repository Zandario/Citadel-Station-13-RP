//! WTF. That is all. @Zandario

// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/material
	health = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	icon = 'icons/obj/weapons.dmi'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = ITEMSIZE_NORMAL
	sharp = 0
	edge = 0
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_material.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_material.dmi',
			)

	var/applies_material_color = 1
	var/unbreakable = 0		//Doesn't lose health
	var/fragile = 0			//Shatters when it dies
	var/dulled = 0			//Has gone dull
	var/can_dull = 1		//Can it go dull?
	var/force_divisor = 0.3
	var/thrown_force_divisor = 0.3
	var/dulled_divisor = 0.1	//Just drops the damage to a tenth
	var/datum/material/material = MAT_STEEL
	var/drops_debris = 1

/obj/item/material/Initialize(mapload, material_key)
	. = ..()

	// BEHOLD ME REALLY MAKING SURE I GET THE MATERIAL REFERENCE AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA @Zandario
	if(ispath(material_key, /datum/material))
		material_key = GET_MATERIAL_REF(material_key)
	if(material_key)
		material = GET_MATERIAL_REF(material_key)
	else
		material = GET_MATERIAL_REF(get_default_material())
	set_material(material)

	set_material(material_key)
	if(!material)
		qdel(src)
		return
	matter = material.get_matter()
	if(matter.len)
		for(var/material_type in matter)
			if(!isnull(matter[material_type]))
				matter[material_type] *= force_divisor // May require a new var instead.

	if(!(material.conductive))
		src.flags |= NOCONDUCT

/obj/item/material/get_default_material()
	if (initial(material)) // plz
		return initial(material)
	else
		return MAT_STEEL // oh no

/obj/item/material/proc/update_force()
	if(edge || sharp)
		force = material.get_edge_damage()
	else
		force = material.get_blunt_damage()
	force = round(force*force_divisor)
	if(dulled)
		force = round(force*dulled_divisor)
	throw_force = round(material.get_blunt_damage()*thrown_force_divisor)
	if(material.name == "supermatter")
		damtype = BURN //its hot
		force = 150 //double the force of a durasteel claymore.
		armor_penetration = 100 //regardless of armor
		throw_force = 150

	//spawn(1)
	//	to_chat(world, "[src] has force [force] and throw_force [throw_force] when made from default material [material.use_name]")

/obj/item/material/proc/set_material(mateiral_key)
	if(!ispath(mateiral_key, /datum/material) && !material)
		qdel(src)
		stack_trace("set_material called on [src] with [isnull(mateiral_key) ? "a null mateiral_key" : mateiral_key ]!")
	else
		material = GET_MATERIAL_REF(mateiral_key || material)
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_color)
			color = material.color
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		update_force()

/obj/item/material/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/material/apply_hit_effect()
	..()
	if(!unbreakable)
		if(material.is_brittle())
			health = 0
		else if(!prob(material.hardness))
			health--
		check_health()

/obj/item/material/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/whetstone))
		var/obj/item/whetstone/whet = W
		repair(whet.repair_amount, whet.repair_time, user)
	if(istype(W, /obj/item/material/sharpeningkit))
		var/obj/item/material/sharpeningkit/SK = W
		repair(SK.repair_amount, SK.repair_time, user)
	..()

/obj/item/material/proc/check_health(var/consumed)
	if(health<=0)
		if(fragile)
			shatter(consumed)
		else if(!dulled && can_dull)
			dull()

/obj/item/material/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris)
		material.place_shard(T)
	qdel(src)

/obj/item/material/proc/dull()
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] goes dull!</span>")
	playsound(src, "shatter", 70, 1)
	dulled = 1
	if(is_sharp() || has_edge())
		sharp = 0
		edge = 0

/obj/item/material/proc/repair(var/repair_amount, var/repair_time, mob/living/user)
	if(!fragile)
		if(health < initial(health))
			user.visible_message("[user] begins repairing \the [src].", "You begin repairing \the [src].")
			if(do_after(user, repair_time))
				user.visible_message("[user] has finished repairing \the [src]", "You finish repairing \the [src].")
				health = min(health + repair_amount, initial(health))
				dulled = 0
				sharp = initial(sharp)
				edge = initial(edge)
		else
			to_chat(user, "<span class='notice'>[src] doesn't need repairs.</span>")
	else
		to_chat(user, "<span class='warning'>You can't repair \the [src].</span>")
		return

/obj/item/material/proc/sharpen(var/material, var/sharpen_time, var/kit, mob/living/M)
	if(!fragile)
		if(health < initial(health))
			to_chat(M, "You should repair [src] first. Try using [kit] on it.")
			return FALSE
		M.visible_message("[M] begins to replace parts of [src] with [kit].", "You begin to replace parts of [src] with [kit].")
		if(do_after(usr, sharpen_time))
			M.visible_message("[M] has finished replacing parts of [src].", "You finish replacing parts of [src].")
			src.set_material(material)
			return TRUE
	else
		to_chat(M, "<span class = 'warning'>You can't sharpen and re-edge [src].</span>")
		return FALSE

/*
Commenting this out pending rebalancing of radiation based on small objects.
/obj/item/material/process(delta_time)
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/30),IRRADIATE,0)
*/

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/obj/item/material/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

// This might need adjustment. Will work that out later.
/obj/item/material/proc/TemperatureAct(temperature)
	health -= material.combustion_effect(get_turf(src), temperature, 0.1)
	check_health(1)

/obj/item/material/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		return ..()
*/
