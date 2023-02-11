/**
 *# Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."

	icon = 'icons/clothing/back/backpack/_backpack.dmi'
	icon_state = "backpack"
	worn_render_flags = NONE
	worn_bodytypes    = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_WEREBEAST)

	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = INVENTORY_STANDARD_SPACE
	drop_sound   = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'


	var/flippable = FALSE
	var/side = 0 //! 0 = right, 1 = left

/obj/item/storage/backpack/attackby(obj/item/I, mob/user)
	if (use_sound)
		playsound(loc, use_sound, 50, TRUE, -5)
	return ..()

/obj/item/storage/backpack/equipped(mob/user, slot)
	if (slot == SLOT_ID_BACK && use_sound)
		playsound(loc, use_sound, 50, TRUE, -5)
	..(user, slot)

/*
/obj/item/storage/backpack/dropped(mob/user, flags, atom/newLoc)
	if (loc == user && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..(user)
*/

/**
 *# Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	max_w_class = ITEMSIZE_LARGE
	max_storage_space = ITEMSIZE_COST_NORMAL * 14 // 56
	storage_cost = INVENTORY_STANDARD_SPACE + 1

	icon_state = "holdingpack"
	icon = 'icons/clothing/back/backpack/holding.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/holding/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/backpack/holding))
		to_chat(user, SPAN_WARNING("The Bluespace interfaces of the two devices conflict and malfunction."))
		//qdel(W) - fuck this holy shit
		return
	. = ..()

/obj/item/storage/backpack/holding/singularity_act(obj/singularity/S, current_size)
	var/turf/lastLoc = get_turf(src)
	. = ..()
	if(lastLoc)
		var/dist = max((current_size - 2),1)
		log_game("Bag of holding detonated at [COORD(lastLoc)]")
		explosion(lastLoc, (dist), (dist*2), (dist*4))

//Please don't clutter the parent storage item with stupid hacks.
/*/obj/item/storage/backpack/holding/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(istype(W, /obj/item/storage/backpack/holding))
		return 1
	return ..()*/ //- let's not


/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."

	icon = 'icons/clothing/back/backpack/cult.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."

	icon = 'icons/clothing/back/backpack/clown.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "A silent backpack made for those silent workers. Silence Co."

	icon = 'icons/clothing/back/backpack/mime.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."

	icon = 'icons/clothing/back/backpack/medic.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."

	icon = 'icons/clothing/back/backpack/security.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/captain
	name = "Facility Director's backpack"
	desc = "It's a special backpack made exclusively for officers."

	icon = 'icons/clothing/back/backpack/captain.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)

/obj/item/storage/backpack/captain/talon
	name = "talon captain's backpack"
	desc = "It's a special backpack made exclusively for the Talon's captain."


/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."

	icon = 'icons/clothing/back/backpack/industrial.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack modeled for use in laboratories and other scientific institutions."

	icon = 'icons/clothing/back/backpack/science.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."

	icon = 'icons/clothing/back/backpack/hydroponics.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."

	icon = 'icons/clothing/back/backpack/genetics.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack able to withstand different pathogens from entering its fabric."

	icon = 'icons/clothing/back/backpack/virology.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack which was designed to hold beakers, pill bottles and bottles."

	icon = 'icons/clothing/back/backpack/chemistry.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/voyager
	name = "voyager backpack"
	desc = "A leather pack designed for expeditions, covered in multi-purpose pouches and pockets."

	icon = 'icons/clothing/back/backpack/explorer.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)



/**
 *# ERT backpacks
 *TODO: Teshari sprites for these. @Zandario
 */
/obj/item/storage/backpack/ert
	abstract_type = /obj/item/storage/backpack/ert


/// Commander
/obj/item/storage/backpack/ert/commander
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."

	icon = 'icons/clothing/back/backpack/ert_commander.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)


/// Security
/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."

	icon = 'icons/clothing/back/backpack/ert_security.dmi'


/// Engineering
/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."

	icon = 'icons/clothing/back/backpack/ert_engineering.dmi'


/// Medical
/obj/item/storage/backpack/ert/medical
	name = "emergency response team medical backpack"
	desc = "A spacious backpack with lots of pockets, worn by medical members of an Emergency Response Team."

	icon = 'icons/clothing/back/backpack/ert_medical.dmi'


/// Para
/obj/item/storage/backpack/ert/para
	name = "PARA trophy rack"
	desc = "A special trophy rack bearing the device of an all-seeing eye; the symbol of the PMD."

	icon = 'icons/clothing/back/backpack/ert_para.dmi'
