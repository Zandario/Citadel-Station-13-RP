//RIG Spines
/obj/item/storage/backpack/rig
	name = "resource integration gear"
	desc = "An advanced system that mounts to the user's spine to serve as a load bearing structure with medical utilities. More complex variants have a wider array of functions and uses."
	icon_state = "civilian_rig"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "backpack", SLOT_ID_LEFT_HAND = "backpack")

/*
/obj/item/storage/backpack/rig/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/storage/backpack/rig/process(mob/living/M)
	if(M.health <= M.maxHealth)
		update_icon()

/obj/item/storage/backpack/rig/update_icon(mob/living/M)
	if(M.stat > 1) // Dead
		icon_state = "[initial(icon_state)]_0"
		item_state = "[initial(icon_state)]_0"
		M.update_inv_back()
	else if(round((M.health/M.getMaxHealth())*100) <= 25)
		icon_state = "[initial(icon_state)]_25"
		item_state = "[initial(icon_state)]_25"
		M.update_inv_back()
	else if(round((M.health/M.getMaxHealth())*100) <= 50)
		icon_state = "[initial(icon_state)]_50"
		item_state = "[initial(icon_state)]_50"
		M.update_inv_back()
	else if(round((M.health/M.getMaxHealth())*100) <= 75)
		icon_state = "[initial(icon_state)]_75"
		item_state = "[initial(icon_state)]_75"
		M.update_inv_back()
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(icon_state)]"
		M.update_inv_back()
*/

//Purses
/obj/item/storage/backpack/purse
	name = "purse"
	desc = "A small, fashionable bag typically worn over the shoulder."
	icon_state = "purse"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "lgpurse", SLOT_ID_LEFT_HAND = "lgpurse")
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 5

//Parachutes
/obj/item/storage/backpack/parachute
	name = "parachute"
	desc = "A specially made backpack, designed to help one survive jumping from incredible heights. It sacrifices some storage space for that added functionality."
	icon_state = "parachute"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "backpack", SLOT_ID_LEFT_HAND = "backpack")
	max_storage_space = ITEMSIZE_COST_NORMAL * 5

/obj/item/storage/backpack/parachute/examine(mob/user)
	. = ..()
	if(get_dist(src, user) <= 1)
		if(parachute)
			. += " It seems to be packed."
		else
			. += " It seems to be unpacked."

/obj/item/storage/backpack/parachute/handleParachute()
	parachute = FALSE	//If you parachute in, the parachute has probably been used.

/obj/item/storage/backpack/parachute/verb/pack_parachute()

	set name = "Pack/Unpack Parachute"
	set category = "Object"
	set src in usr

	if(!istype(src.loc, /mob/living))
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.back == src)
		to_chat(H, "<span class='warning'>How do you expect to work on \the [src] while it's on your back?</span>")
		return

	if(!parachute)	//This packs the parachute
		H.visible_message("<span class='notice'>\The [H] starts to pack \the [src]!</span>", \
					"<span class='notice'>You start to pack \the [src]!</span>", \
					"You hear the shuffling of cloth.")
		if(do_after(H, 50))
			H.visible_message("<span class='notice'>\The [H] finishes packing \the [src]!</span>", \
					"<span class='notice'>You finish packing \the [src]!</span>", \
					"You hear the shuffling of cloth.")
			parachute = TRUE
		else
			H.visible_message("<span class='notice'>\The [src] gives up on packing \the [src]!</span>", \
					"<span class='notice'>You give up on packing \the [src]!</span>")
			return
	else			//This unpacks the parachute
		H.visible_message("<span class='notice'>\The [src] starts to unpack \the [src]!</span>", \
					"<span class='notice'>You start to unpack \the [src]!</span>", \
					"You hear the shuffling of cloth.")
		if(do_after(H, 25))
			H.visible_message("<span class='notice'>\The [src] finishes unpacking \the [src]!</span>", \
					"<span class='notice'>You finish unpacking \the [src]!</span>", \
					"You hear the shuffling of cloth.")
			parachute = FALSE
		else
			H.visible_message("<span class='notice'>\The [src] decides not to unpack \the [src]!</span>", \
					"<span class='notice'>You decide not to unpack \the [src]!</span>")
	return

/obj/item/storage/backpack/satchel/ranger
	name = "ranger satchel"
	desc = "A satchel designed for the Go Go ERT Rangers series to allow for slightly bigger carry capacity for the ERT-Rangers.\
	 Unlike the show claims, it is not a phoron-enhanced satchel of holding with plot-relevant content."
	icon = 'icons/obj/clothing/ranger.dmi'
	icon_state = "ranger_satchel"

/obj/item/storage/backpack/saddlebag
	name = "Horse Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	var/taurtype = /datum/sprite_accessory/tail/taur/horse //Acceptable taur type to be wearing this
	var/no_message = "You aren't the appropriate taur type to wear this!"

/obj/item/storage/backpack/saddlebag/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H
	if(istype(H) && istype(H.tail_style, taurtype))
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	else
		to_chat(H, "<span class='warning'>[no_message]</span>")
		return 0

/* If anyone wants to make some... this is how you would.
/obj/item/storage/backpack/saddlebag/spider
	name = "Drider Saddlebags"
	item_state = "saddlebag_drider"
	icon_state = "saddlebag_drider"
	var/taurtype = /datum/sprite_accessory/tail/taur/spider
*/

/obj/item/storage/backpack/saddlebag_common //Shared bag for other taurs with sturdy backs
	name = "Taur Saddlebags"
	desc = "A saddle that holds items. Seems slightly bulky."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back_taur.dmi'
	item_state = "saddlebag"
	icon_state = "saddlebag"
	var/icon_base = "saddlebag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Saddlebags can hold more, like dufflebags
	slowdown = 1 //And are slower, too...Unless you're a macro, that is.
	var/no_message = "You aren't the appropriate taur type to wear this!"

/obj/item/storage/backpack/saddlebag_common/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H
	var/datum/sprite_accessory/tail/taur/TT = H.tail_style
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/horse))
		item_state = "[icon_base]_Horse"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/wolf))
		item_state = "[icon_base]_Wolf"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/cow))
		item_state = "[icon_base]_Cow"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/lizard))
		item_state = "[icon_base]_Lizard"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/feline))
		item_state = "[icon_base]_Feline"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/drake))
		item_state = "[icon_base]_Drake"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/otie))
		item_state = "[icon_base]_Otie"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	if(istype(H) && istype(TT, /datum/sprite_accessory/tail/taur/deer))
		item_state = "[icon_base]_Deer"
		if(H.size_multiplier >= RESIZE_BIG) //Are they a macro?
			slowdown = 0
		else
			slowdown = initial(slowdown)
		return 1
	else
		to_chat(H, "<span class='warning'>[no_message]</span>")
		return 0

/obj/item/storage/backpack/saddlebag_common/robust //Shared bag for other taurs with sturdy backs
	name = "Robust Saddlebags"
	desc = "A saddle that holds items. Seems robust."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back_taur.dmi'
	item_state = "robustsaddle"
	icon_state = "robustsaddle"
	icon_base = "robustsaddle"

/obj/item/storage/backpack/saddlebag_common/vest //Shared bag for other taurs with sturdy backs
	name = "Taur Duty Vest"
	desc = "An armored vest with the armor modules replaced with various handy compartments with decent storage capacity. Useless for protection though."
	icon = 'icons/obj/clothing/backpack.dmi'
	icon_override = 'icons/mob/clothing/back_taur.dmi'
	item_state = "taurvest"
	icon_state = "taurvest"
	icon_base = "taurvest"
	max_storage_space = INVENTORY_STANDARD_SPACE
	slowdown = 0

/obj/item/storage/backpack/dufflebag/fluff //Black dufflebag without syndie buffs.
	name = "plain black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon_state = "duffle-syndie"

/obj/item/storage/backpack/rebel
	name = "rebel backpack"
	desc = "A sturdy canvas bag designed to withstand harsh environmental conditions."
	icon_state = "backpack_rebel"
