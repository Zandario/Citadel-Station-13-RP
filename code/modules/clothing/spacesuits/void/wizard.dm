//Wizard Rig
/obj/item/clothing/head/helmet/space/void/wizard
	name = "gem-encrusted voidsuit helmet"
	desc = "A bizarre gem-encrusted helmet that radiates magical energies."
	icon_state = "rig0-wiz"
	item_state_slots = list(slot_r_hand_str = "wiz_helm", slot_l_hand_str = "wiz_helm")
	unacidable = TRUE //No longer shall our kind be foiled by lone chemists with spray bottles!
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	sprite_sheets_refit = null
	sprite_sheets_obj = null
	wizard_garb = 1

/obj/item/clothing/suit/space/void/wizard
	icon_state = "rig-wiz"
	name = "gem-encrusted voidsuit"
	desc = "A bizarre gem-encrusted suit that radiates magical energies."
	item_state_slots = list(slot_r_hand_str = "wiz_voidsuit", slot_l_hand_str = "wiz_voidsuit")
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	unacidable = TRUE
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.7
	sprite_sheets_refit = null
	sprite_sheets_obj = null
	wizard_garb = 1

//Chaos Berserker "Costume" Armor
/obj/item/clothing/head/helmet/space/void/wizard/berserk_knight
	name = "berserk knight helmet"
	desc = "A bulky helmet that radiates ravenous magical energies."
	icon_state = "knight_berserker"
	item_state_slots = list(slot_r_hand_str = "syndie_helm", slot_l_hand_str = "syndie_helm")
	armor = list(melee = 70, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
	light_overlay = "bk_overlay"

/obj/item/clothing/suit/space/void/wizard/berserk_knight
	name = "berserk knight voidsuit"
	desc = "A bloodsoaked suit that emits a nauseating aura of hatred."
	icon_state = "knight_berserker"
	item_state_slots = list(slot_r_hand_str = "syndie_voidsuit", slot_l_hand_str = "syndie_voidsuit")
	armor = list(melee = 70, bullet = 20, laser = 20,energy = 20, bomb = 35, bio = 100, rad = 60)
