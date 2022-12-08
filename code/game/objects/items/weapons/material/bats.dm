/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	throw_force = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	material = MAT_WOOD
	force_divisor = 1				// 20 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7	// 15 when unwielded based on above.
	dulled_divisor = 0.8			// A "dull" bat is still gonna hurt
	slot_flags = SLOT_BACK

// Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal
	material = MAT_STEEL

/obj/item/material/twohanded/baseballbat/uranium
	material = MAT_URANIUM

/obj/item/material/twohanded/baseballbat/gold
	material = MAT_GOLD

/obj/item/material/twohanded/baseballbat/platinum
	material = MAT_PLATINUM

/obj/item/material/twohanded/baseballbat/diamond
	material = MAT_DIAMOND

/obj/item/material/twohanded/baseballbat/plasteel
	material = MAT_PLASTEEL

/obj/item/material/twohanded/baseballbat/durasteel
	material = MAT_DURASTEEL

/obj/item/material/twohanded/baseballbat/penbat
	name = "penetrator"
	desc = "The letter E has been lovingly engraved into the handle. When this wobbles, it sounds exactly like shame."
	icon_state = "penbat0"
	base_icon = "penbat"
	force = 0
	throw_force = 0
	attack_verb = list("smacked", "slapped", "thwapped", "struck", "bapped", "bonked")
	material = MAT_PLASTIC
	force_divisor = 0
	unwielded_force_divisor = 0
	dulled_divisor = 0
