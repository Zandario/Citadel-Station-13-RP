var/global/list/ashtray_cache = list()

obj/item/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/objects.dmi'
	icon_state = "blank"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	var/image/base_image
	var/max_butts = 10

obj/item/material/ashtray/Initialize(mapload, material_name)
	. = ..(mapload, material_name)
	if(!material)
		qdel(src)
		return
	max_butts = round(material.hardness/5) //This is arbitrary but whatever.
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	update_icon()
	return

obj/item/material/ashtray/update_icon()
	color = null

	cut_overlays()
	var/list/overlays_to_add = list()

	var/cache_key = "base-[material.name]"
	if(!ashtray_cache[cache_key])
		var/image/I = image('icons/obj/objects.dmi',"ashtray")
		I.color = material.icon_colour
		ashtray_cache[cache_key] = I
	overlays_to_add += ashtray_cache[cache_key]

	if (contents.len == max_butts)
		if(!ashtray_cache["full"])
			ashtray_cache["full"] = image('icons/obj/objects.dmi',"ashtray_full")
		overlays_to_add += ashtray_cache["full"]
		desc = "It's stuffed full."
	else if (contents.len > max_butts/2)
		if(!ashtray_cache["half"])
			ashtray_cache["half"] = image('icons/obj/objects.dmi',"ashtray_half")
		overlays_to_add += ashtray_cache["half"]
		desc = "It's half-filled."
	else
		desc = "An ashtray made of [material.display_name]."

	add_overlay(overlays_to_add)

obj/item/material/ashtray/attackby(obj/item/W as obj, mob/user as mob)
	if (health <= 0)
		return ..()
	if (istype(W,/obj/item/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/flame/match))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if (contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return
		if(!user.attempt_insert_item_for_installation(W, src))
			return

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				src.visible_message("[user] crushes [cig] in \the [src], putting it out.")
				STOP_PROCESSING(SSobj, cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				qdel(cig)
				W = butt
				//spawn(1)
				//	TemperatureAct(150)
			else if (cig.lit == 0)
				to_chat(user, "You place [cig] in [src] without even smoking it. Why would you do that?")

		visible_message("[user] places [W] in [src].")
		add_fingerprint(user)
		update_icon()
	else
		health = max(0,health - W.damage_force)
		to_chat(user, "You hit [src] with [W].")
		if (health < 1)
			shatter()
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (contents.len)
			src.visible_message("<span class='danger'>\The [src] slams into [hit_atom], spilling its contents!</span>")
		for (var/obj/item/clothing/mask/smokable/cigarette/O in contents)
			O.loc = src.loc
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()

obj/item/material/ashtray/plastic/Initialize(mapload, material_key)
	return ..(mapload, "plastic")

obj/item/material/ashtray/bronze/Initialize(mapload, material_key)
	return ..(mapload, "bronze")

obj/item/material/ashtray/glass/Initialize(mapload, material_key)
	return ..(mapload, "glass")
