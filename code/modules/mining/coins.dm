/*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/items.dmi'
	name = "Coin"
	icon_state = "coin"
	force = 1
	throwforce = 2
	w_class = ITEMSIZE_TINY
	matter = list(MAT_IRON = 400)
	slot_flags = SLOT_EARS
	var/string_attached
	var/list/sideslist = list("heads","tails")
	var/cooldown = 0
	var/value
	var/coinflip
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/coin/Initialize(mapload)
	. = ..()
	coinflip = pick(sideslist)
	icon_state = "coin_[coinflip]"
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, SPAN_NOTICE("There already is a string attached to this coin."))
			return

		if (CC.use(1))
			overlays += image('icons/obj/items.dmi',"coin_string_overlay")
			string_attached = 1
			to_chat(user, SPAN_NOTICE("You attach a string to the coin."))
		else
			to_chat(user, SPAN_NOTICE("This cable coil appears to be empty."))
		return

	else if(W.is_wirecutter())
		if(!string_attached)
			return ..()

		new /obj/item/stack/cable_coil(drop_location(), 1)
		overlays = list()
		string_attached = null
		to_chat(user, SPAN_NOTICE("You detach the string from the coin."))
	else ..()

/obj/item/coin/attack_self(mob/user as mob)
	if(cooldown < world.time)
		if(string_attached) //does the coin have a wire attached
			to_chat(user, SPAN_WARNING("The coin won't flip very well with something attached!") )
			return FALSE//do not flip the coin
		cooldown = world.time + 15
		flick("coin_[coinflip]_flip", src)
		coinflip = pick(sideslist)
		icon_state = "coin_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, TRUE)
		var/oldloc = loc
		sleep(15)
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message(SPAN_NOTICE("[user] flips [src]. It lands on [coinflip]."), \
				SPAN_NOTICE("You flip [src]. It lands on [coinflip]."), \
				SPAN_HEAR("You hear the clattering of loose change."))
	return TRUE//did the coin flip?

/obj/item/coin/iron
	name = "iron coin"
	icon_state = "coin_iron"

/obj/item/coin/copper
	name = "copper coin"
	icon_state = "coin_copper"

/obj/item/coin/silver
	name = "silver coin"
	icon_state = "coin_silver"

/obj/item/coin/gold
	name = "gold coin"
	icon_state = "coin_gold"

/obj/item/coin/phoron
	name = "solid phoron coin"
	icon_state = "coin_phoron"

/obj/item/coin/uranium
	name = "uranium coin"
	icon_state = "coin_uranium"

/obj/item/coin/diamond
	name = "diamond coin"
	icon_state = "coin_diamond"

/obj/item/coin/platinum
	name = "platinum coin"
	icon_state = "coin_platinum"

/obj/item/coin/durasteel
	name = "adamantine coin"
	icon_state = "coin_adamantine"

/obj/item/coin/mhydrogen
	name = "mythril coin"
	icon_state = "coin_mythril"

/obj/item/coin/bananium
	name = "bananium coin"
	icon_state = "coin_clown"

/obj/item/coin/supermatter
	name = "supermatter coin"
	icon_state = "coin_supermatter"

/obj/item/coin/twoheaded
	desc = "Hey, this coin's the same on both sides!"
	sideslist = list("heads")

/obj/item/coin/antagtoken
	name = "antag token"
	desc = "A novelty coin that helps the heart know what hard evidence cannot prove."
	icon_state = "coin_valid"
	matter = list(MAT_PLASTIC = 400)
	sideslist = list("valid", "salad")
	//material_flags = NONE

/obj/item/coin/gold/debug
	matter = list(MAT_GOLD = 400)
	desc = "If you got this somehow, be aware that it will dust you. Almost certainly."

/obj/item/coin/gold/debug/attack_self(mob/user)
	if(cooldown < world.time)
		if(string_attached) //does the coin have a wire attached
			to_chat(user, SPAN_WARNING("The coin won't flip very well with something attached!") )
			return FALSE//do not flip the coin
		cooldown = world.time + 15
		flick("coin_[coinflip]_flip", src)
		coinflip = pick(sideslist)
		icon_state = "coin_[coinflip]"
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, TRUE)
		var/oldloc = loc
		sleep(15)
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message(SPAN_NOTICE("[user] flips [src]. It lands on [coinflip]."), \
				SPAN_NOTICE("You flip [src]. It lands on [coinflip]."), \
				SPAN_HEAR("You hear the clattering of loose change."))
	return TRUE//did the coin flip? useful for suicide_act
