/**
 *# Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."

	icon = 'icons/clothing/back/backpack/satchel/_satchel.dmi'
	icon_state = "satchel"
	worn_render_flags = NONE
	worn_bodytypes    = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_WEREBEAST)

/obj/item/storage/backpack/satchel/withwallet
	starts_with = list(/obj/item/storage/wallet/random)


/obj/item/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."

	icon = 'icons/clothing/back/backpack/satchel/norm.dmi'


/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."

	icon = 'icons/clothing/back/backpack/satchel/industrial.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."

	icon = 'icons/clothing/back/backpack/satchel/medic.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colors."

	icon = 'icons/clothing/back/backpack/satchel/virology.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colors."

	icon = 'icons/clothing/back/backpack/satchel/chemistry.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colors."

	icon = 'icons/clothing/back/backpack/satchel/genetics.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."

	icon = 'icons/clothing/back/backpack/satchel/science.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."

	icon = 'icons/clothing/back/backpack/satchel/hydroponics.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."

	icon = 'icons/clothing/back/backpack/satchel/security.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/cap
	name = "Facility Director's satchel"
	desc = "An exclusive satchel for officers."

	icon = 'icons/clothing/back/backpack/satchel/captain.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)

/obj/item/storage/backpack/satchel/cap/talon
	name = "Talon captain's satchel"
	desc = "An exclusive satchel for the Talon's captain."


/obj/item/storage/backpack/satchel/voyager
	name = "voyager satchel"
	desc = "A leather satchel designed for expeditions."

	icon = 'icons/clothing/back/backpack/satchel/explorer.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)


/obj/item/storage/backpack/satchel/bone
	name = "bone satchel"
	desc = "A grotesque satchel made of sinew and bone."

	icon = 'icons/clothing/back/backpack/satchel/bone.dmi'
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
