datum/power/changeling/space_suit
	name = "Organic Space Suit"
	desc = "We grow an organic suit to protect ourselves from space exposure."
	helptext = "To remove the suit, use the ability again."
	ability_icon_state = "ling_space_suit"
	genomecost = 1
	verbpath = /mob/proc/changeling_spacesuit

mob/proc/changeling_spacesuit()
	set category = "Changeling"
	set name = "Organic Space Suit (20)"
	if(changeling_generic_armor(/obj/item/clothing/suit/space/changeling,/obj/item/clothing/head/helmet/space/changeling,/obj/item/clothing/shoes/magboots/changeling, 20))
		return 1
	return 0

datum/power/changeling/armor
	name = "Chitinous Spacearmor"
	desc = "We turn our skin into tough chitin to protect us from damage and space exposure."
	helptext = "To remove the armor, use the ability again."
	ability_icon_state = "ling_armor"
	genomecost = 3
	verbpath = /mob/proc/changeling_spacearmor

mob/proc/changeling_spacearmor()
	set category = "Changeling"
	set name = "Organic Spacearmor (20)"

	if(changeling_generic_armor(/obj/item/clothing/suit/space/changeling/armored,/obj/item/clothing/head/helmet/space/changeling/armored,/obj/item/clothing/shoes/magboots/changeling/armored, 20))
		return 1
	return 0

//Space suit

obj/item/clothing/suit/space/changeling
	name = "flesh mass"
	icon_state = "lingspacesuit"
	desc = "A huge, bulky mass of pressure and temperature-resistant organic tissue, evolved to facilitate space travel."
	clothing_flags = NONE
	item_flags = ITEM_DROPDEL
	allowed = list(/obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/tank/oxygen)
	armor_type = /datum/armor/none //No armor at all.

obj/item/clothing/suit/space/changeling/Initialize(mapload)
	. = ..()
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh rapidly inflates, forming a bloated mass around their body!</span>",
		"<span class='warning'>We inflate our flesh, creating a spaceproof suit!</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>")

obj/item/clothing/head/helmet/space/changeling
	name = "flesh mass"
	icon_state = "lingspacehelmet"
	desc = "A covering of pressure and temperature-resistant organic tissue with a glass-like chitin front."
	clothing_flags = NONE
	inv_hide_flags = BLOCKHAIR
	item_flags = ITEM_DROPDEL
	armor_type = /datum/armor/none
	body_cover_flags = HEAD|FACE|EYES

obj/item/clothing/shoes/magboots/changeling
	desc = "A suction cupped mass of flesh, shaped like a foot."
	name = "fleshy grippers"
	icon_state = "lingspacesuit"
	action_button_name = "Toggle Grippers"
	clothing_flags = NONE
	item_flags = ITEM_DROPDEL

obj/item/clothing/shoes/magboots/changeling/set_slowdown()
	slowdown = worn_over? max(SHOES_SLOWDOWN, worn_over.slowdown): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown += 1		//It's already tied to a slowdown suit, 6 slowdown is huge.

obj/item/clothing/shoes/magboots/changeling/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(magpulse)
		clothing_flags &= ~NOSLIP
		magpulse = 0
		set_slowdown()
		damage_force = 3
		to_chat(user, "We release our grip on the floor.")
	else
		clothing_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		damage_force = 5
		to_chat(user, "We cling to the terrain below us.")

//Armor

obj/item/clothing/suit/space/changeling/armored
	name = "chitinous mass"
	desc = "A tough, hard covering of black chitin."
	icon_state = "lingarmor"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/changeling/chitin
	siemens_coefficient = 0.3
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	slowdown = 3

obj/item/clothing/suit/space/changeling/armored/Initialize(mapload)
	. = ..()
	if(ismob(loc))
		loc.visible_message("<span class='warning'>[loc.name]\'s flesh turns black, quickly transforming into a hard, chitinous mass!</span>",
		"<span class='warning'>We harden our flesh, creating a suit of armor!</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>")

obj/item/clothing/head/helmet/space/changeling/armored
	name = "chitinous mass"
	desc = "A tough, hard covering of black chitin with transparent chitin in front."
	icon_state = "lingarmorhelmet"
	armor_type = /datum/armor/changeling/chitin
	siemens_coefficient = 0.3
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

obj/item/clothing/shoes/magboots/changeling/armored
	desc = "A tough, hard mass of chitin, with long talons for digging into terrain."
	name = "chitinous talons"
	icon_state = "lingarmor"
	action_button_name = "Toggle Talons"

obj/item/clothing/gloves/combat/changeling //Combined insulated/fireproof gloves
	name = "chitinous gauntlets"
	desc = "Very resilient gauntlets made out of black chitin.  It looks very durable, and can probably resist electrical shock in addition to the elements."
	icon_state = "lingarmorgloves"
	armor_type = /datum/armor/changeling/chitin
	siemens_coefficient = 0

obj/item/clothing/shoes/boots/combat/changeling //Noslips
	desc = "chitinous boots"
	name = "Footwear made out of a hard, black chitinous material.  The bottoms of these appear to have spikes that can protrude or extract itself into and out \
	of the floor at will, granting the wearer stability."
	icon_state = "lingboots"
	armor_type = /datum/armor/changeling/chitin
	siemens_coefficient = 0.3
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
