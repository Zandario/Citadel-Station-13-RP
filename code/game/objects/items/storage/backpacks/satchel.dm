/**
 *# Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "briefcase", SLOT_ID_LEFT_HAND = "briefcase")

/obj/item/storage/backpack/satchel/withwallet
	starts_with = list(/obj/item/storage/wallet/random)

/obj/item/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "engiepack", SLOT_ID_LEFT_HAND = "engiepack")

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "medicalpack", SLOT_ID_LEFT_HAND = "medicalpack")

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "viropack", SLOT_ID_LEFT_HAND = "viropack")

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "chempack", SLOT_ID_LEFT_HAND = "chempack")

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "genpack", SLOT_ID_LEFT_HAND = "genpack")

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-sci"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "toxpack", SLOT_ID_LEFT_HAND = "toxpack")

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "securitypack", SLOT_ID_LEFT_HAND = "securitypack")

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/cap
	name = "Facility Director's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel-cap"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "captainpack", SLOT_ID_LEFT_HAND = "captainpack")

/obj/item/storage/backpack/satchel/cap/talon
	name = "Talon captain's satchel"
	desc = "An exclusive satchel for the Talon's captain."

/obj/item/storage/backpack/satchel/voyager
	name = "voyager satchel"
	desc = "A leather satchel designed for expeditions."
	icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/bone
	name = "bone satchel"
	desc = "A grotesque satchel made of sinew and bone."
	icon_state = "satchel-bone"
