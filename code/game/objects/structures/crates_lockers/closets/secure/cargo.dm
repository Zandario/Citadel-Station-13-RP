/obj/structure/closet/secure_closet/cargotech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_broken = "securecargobroken"
	icon_off = "securecargooff"

	starts_with = list(
		/obj/item/clothing/under/rank/cargotech,
		/obj/item/clothing/under/rank/cargotech/skirt,
		/obj/item/clothing/under/rank/cargotech/skirt_pleated,
		/obj/item/clothing/under/rank/cargotech/jeans,
		/obj/item/clothing/under/rank/cargotech/jeans/female,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/shoes/boots/winter/supply,
		/obj/item/clothing/shoes/black,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/radio/headset/headset_cargo/alt,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/stamp/cargo,
		/obj/item/clothing/head/soft)

/obj/structure/closet/secure_closet/cargotech/Initialize(mapload)
	if(prob(75))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	if(prob(25))
		starts_with += /obj/item/storage/backpack/dufflebag
	return ..()

/obj/structure/closet/secure_closet/quartermaster
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_broken = "secureqmbroken"
	icon_off = "secureqmoff"

	starts_with = list(
		/obj/item/clothing/under/rank/cargo,
		/obj/item/clothing/under/rank/cargo/skirt,
		/obj/item/clothing/under/rank/cargo/skirt_pleated,
		/obj/item/clothing/under/rank/cargo/jeans,
		/obj/item/clothing/under/rank/cargo/jeans/female,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/radio/headset/headset_cargo/alt,
		/obj/item/radio/headset/headset_mine,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/suit/storage/hooded/wintercoat/qm,
		/obj/item/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/head/soft,
		/obj/item/clothing/suit/storage/hooded/wintercoat/cargo,
		/obj/item/clothing/shoes/boots/winter/supply)

/obj/structure/closet/secure_closet/quartermaster/Initialize(mapload)
	if(prob(75))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	if(prob(25))
		starts_with += /obj/item/storage/backpack/dufflebag
	return ..()

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(access_mining)

	starts_with = list(
		/obj/item/radio/headset/headset_mine,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/black,
		/obj/item/analyzer,
		/obj/item/storage/bag/ore,
		/obj/item/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/gps/mining,
		/obj/item/survivalcapsule,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
		/obj/item/clothing/shoes/boots/winter/mining,
		/obj/item/reagent_containers/portable_fuelcan/miniature,
		/obj/item/stack/marker_beacon/thirty)

/obj/structure/closet/secure_closet/miner/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	return ..()

/obj/structure/closet/secure_closet/miner/Initialize(mapload)
	starts_with += /obj/item/gps/mining
	return ..()
