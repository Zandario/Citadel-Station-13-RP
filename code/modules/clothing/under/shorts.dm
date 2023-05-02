//these need item states -S2-
obj/item/clothing/under/shorts
	name = "athletic shorts"
	desc = "95% Polyester, 5% Spandex!"
	gender = PLURAL
	body_cover_flags = LOWER_TORSO

obj/item/clothing/under/shorts/red
	name = "red athletic shorts"
	icon_state = "redshorts"

obj/item/clothing/under/shorts/green
	name = "green athletic shorts"
	icon_state = "greenshorts"

obj/item/clothing/under/shorts/blue
	name = "blue athletic shorts"
	icon_state = "blueshorts"

obj/item/clothing/under/shorts/black
	name = "black athletic shorts"
	icon_state = "blackshorts"

obj/item/clothing/under/shorts/grey
	name = "grey athletic shorts"
	icon_state = "greyshorts"

obj/item/clothing/under/shorts/white
	name = "white shorts"
	icon_state = "whiteshorts"

obj/item/clothing/under/shorts/white/female
	name = "white short shorts"
	icon_state = "whiteshorts_f"

obj/item/clothing/under/shorts/jeans
	name = "jeans shorts"
	desc = "Some jeans! Just in short form!"
	icon_state = "jeans_shorts"

obj/item/clothing/under/shorts/jeans/female
	name = "jeans short shorts"
	icon_state = "jeans_shorts_f"

obj/item/clothing/under/shorts/jeans/classic
	name = "classic jeans shorts"
	icon_state = "jeansclassic_shorts"

obj/item/clothing/under/shorts/jeans/classic/female
	name = "classic jeans short shorts"
	icon_state = "jeansclassic_shorts_f"

obj/item/clothing/under/shorts/jeans/mustang
	name = "mustang jeans shorts"
	icon_state = "jeansmustang_shorts"

obj/item/clothing/under/shorts/jeans/mustang/female
	name = "mustang jeans short shorts"
	icon_state = "jeansmustang_shorts_f"

obj/item/clothing/under/shorts/jeans/youngfolks
	name = "young folks jeans shorts"
	icon_state = "jeansyoungfolks_shorts"

obj/item/clothing/under/shorts/jeans/youngfolks/female
	name = "young folks jeans short shorts"
	icon_state = "jeansyoungfolks_shorts_f"

obj/item/clothing/under/shorts/jeans/black
	name = "black jeans shorts"
	icon_state = "blackpants_shorts"

obj/item/clothing/under/shorts/jeans/black/female
	name = "black jeans short shorts"
	icon_state = "black_shorts_f"

obj/item/clothing/under/shorts/jeans/grey
	name = "grey jeans shorts"
	icon_state = "greypants_shorts"

obj/item/clothing/under/shorts/jeans/grey/female
	name = "grey jeans short shorts"
	icon_state = "grey_shorts_f"

obj/item/clothing/under/shorts/khaki
	name = "khaki shorts"
	desc = "For that island getaway. It's five o'clock somewhere, right?"
	icon_state = "tanpants_shorts"

obj/item/clothing/under/shorts/khaki/female
	name = "khaki short shorts"
	icon_state = "khaki_shorts_f"

//Argh, skirts be below this line -> ------------------------------

obj/item/clothing/under/skirt
	name = "short black skirt"
	desc = "A skirt that is a shiny black."
	icon_state = "skirt_short_black"
	body_cover_flags = LOWER_TORSO
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

obj/item/clothing/under/skirt/khaki
	name = "khaki skirt"
	desc = "A skirt that is a khaki color."
	icon_state = "skirt_khaki"

obj/item/clothing/under/skirt/blue
	name = "short blue skirt"
	desc = "A skirt that is a shiny blue."
	icon_state = "skirt_short_blue"

obj/item/clothing/under/skirt/red
	name = "short red skirt"
	desc = "A skirt that is a shiny red."
	icon_state = "skirt_short_red"

obj/item/clothing/under/skirt/denim
	name = "short denim skirt"
	desc = "A skirt that is made of denim."
	icon_state = "skirt_short_denim"

obj/item/clothing/under/skirt/swept
	name = "swept skirt"
	desc = "A skirt that is swept to one side."
	icon_state = "skirt_swept"

obj/item/clothing/under/skirt/loincloth
	name = "loincloth"
	desc = "A piece of cloth wrapped around the waist."
	icon_state = "loincloth"

obj/item/clothing/under/skirt/pleated
	name = "pleated skirt"
	desc = "A simple pleated skirt. It's like high school all over again."
	icon_state = "pleated"
	addblends = "pleated_a"

obj/item/clothing/under/skirt/outfit
	name = "black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS

obj/item/clothing/under/skirt/outfit/plaid_blue
	name = "blue plaid skirt"
	desc = "A preppy blue skirt with a white blouse."
	icon_state = "plaid_blue"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue", SLOT_ID_LEFT_HAND = "blue")

obj/item/clothing/under/skirt/outfit/plaid_red
	name = "red plaid skirt"
	desc = "A preppy red skirt with a white blouse."
	icon_state = "plaid_red"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red", SLOT_ID_LEFT_HAND = "red")

obj/item/clothing/under/skirt/outfit/plaid_purple
	name = "purple plaid skirt"
	desc = "A preppy purple skirt with a white blouse."
	icon_state = "plaid_purple"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "purple", SLOT_ID_LEFT_HAND = "purple")

obj/item/clothing/under/skirt/outfit/plaid_green
	name = "green plaid skirt"
	desc = "A preppy purple skirt with a white blouse."
	icon_state = "plaid_green"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "green", SLOT_ID_LEFT_HAND = "green")

obj/item/clothing/under/rank/cargo/skirt
	name = "quartermaster's jumpskirt"
	desc = "It's a jumpskirt worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon_state = "qmf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "qm", SLOT_ID_LEFT_HAND = "qm")

obj/item/clothing/under/rank/cargotech/skirt
	name = "cargo technician's jumpskirt"
	desc = "Skirrrrrts! They're comfy and easy to wear!"
	icon_state = "cargof"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "cargo", SLOT_ID_LEFT_HAND = "cargo")

obj/item/clothing/under/rank/engineer/skirt
	desc = "It's an orange high visibility jumpskirt worn by engineers. It has minor radiation shielding."
	name = "engineer's jumpskirt"
	icon_state = "enginef"
	armor_type = /datum/armor/engineering/jumpsuit
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "engine", SLOT_ID_LEFT_HAND = "engine")

obj/item/clothing/under/rank/chief_engineer/skirt
	desc = "It's a high visibility jumpskirt given to those engineers insane enough to achieve the rank of \"Chief engineer\". It has minor radiation shielding."
	name = "chief engineer's jumpskirt"
	icon_state = "chieff"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "chiefengineer", SLOT_ID_LEFT_HAND = "chiefengineer")

obj/item/clothing/under/rank/atmospheric_technician/skirt
	desc = "It's a jumpskirt worn by atmospheric technicians."
	name = "atmospheric technician's jumpskirt"
	icon_state = "atmosf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "atmos", SLOT_ID_LEFT_HAND = "atmos")

obj/item/clothing/under/rank/roboticist/skirt
	desc = "It's a slimming black jumpskirt with reinforced seams; great for industrial work."
	name = "roboticist's jumpskirt"
	icon_state = "roboticsf"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "robotics", SLOT_ID_LEFT_HAND = "robotics")

obj/item/clothing/under/rank/scientist/skirt
	name = "scientist's jumpskirt"
	icon_state = "sciencef"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/science/jumpsuit

obj/item/clothing/under/rank/medical/skirt
	name = "medical doctor's jumpskirt"
	icon_state = "medicalf"

obj/item/clothing/under/rank/chemist/skirt
	name = "chemist's jumpskirt"
	icon_state = "chemistryf"

obj/item/clothing/under/rank/chief_medical_officer/skirt
	desc = "It's a jumpskirt worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpskirt"
	icon_state = "cmof"

obj/item/clothing/under/rank/geneticist/skirt
	name = "geneticist's jumpskirt"
	icon_state = "geneticsf"

obj/item/clothing/under/rank/virologist/skirt
	name = "virologist's jumpskirt"
	icon_state = "virologyf"

obj/item/clothing/under/rank/security/skirt
	name = "security officer's jumpskirt"
	desc = "Standard feminine fashion for Security Officers.  It's made of sturdier material than the standard jumpskirts."
	icon_state = "securityf"
	armor_type = /datum/armor/security/jumpsuit
	siemens_coefficient = 0.9

obj/item/clothing/under/rank/warden/skirt
	desc = "Standard feminine fashion for a Warden. It is made of sturdier material than standard jumpskirts. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpskirt"
	icon_state = "wardenf"

obj/item/clothing/under/rank/head_of_security/skirt
	desc = "It's a fashionable jumpskirt worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpskirt"
	icon_state = "hosf"
