//
// Size Gun
//

/obj/item/gun/energy/sizegun
	name = "size gun"
	desc = "A highly advanced ray gun with a knob on the side to adjust the size you desire. Warning: Do not insert into mouth."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "sizegun-shrink100" // Someone can probably do better. -Ace
	item_state = null	// So the human update icon uses the icon_state instead
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 240
	projectile_type = /obj/item/projectile/beam/sizelaser
	origin_tech = list(TECH_BLUESPACE = 4)
	modifystate = "sizegun-shrink"
	no_pin_required = TRUE
	battery_lock = TRUE
	var/size_set_to = 1
	firemodes = list(
		list(mode_name		= "select size",
			projectile_type	= /obj/item/projectile/beam/sizelaser,
			modifystate		= "sizegun-grow",
			fire_sound		= 'sound/weapons/pulse3.ogg'
		))

/obj/item/gun/energy/sizegun/Initialize(mapload)
	. = ..()
	verbs += /obj/item/gun/energy/sizegun/proc/select_size

/obj/item/gun/energy/sizegun/attack_self(mob/user)
	. = ..()
	select_size()

/obj/item/gun/energy/sizegun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/sizelaser/G = .
	if(istype(G))
		G.set_size = size_set_to

/obj/item/gun/energy/sizegun/proc/select_size()
	set name = "Select Size"
	set category = "Object"
	set src in view(1)

	var/size_select = input("Put the desired size (25-200%)", "Set Size", size_set_to * 100) as num
	if(size_select > 200 || size_select < 25)
		to_chat(usr, "<span class='notice'>Invalid size.</span>")
		return
	size_set_to = (size_select/100)
	to_chat(usr, "<span class='notice'>You set the size to [size_select]%</span>")

/obj/item/gun/energy/sizegun/examine(mob/user)
	. = ..()
	var/size_examine = (size_set_to*100)
	. += "<span class='info'>It is currently set at [size_examine]%</span>"

//
// Beams for size gun
//

/obj/item/projectile/beam/sizelaser
	name = "size beam"
	icon_state = "xray"
	nodamage = TRUE
	damage = 0
	check_armour = "laser"
	var/set_size = 1 //Let's default to 100%

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/sizelaser/on_hit(var/atom/target)
	var/mob/living/M = target
	if(istype(M))
		M.resize(set_size)
		to_chat(M, "<font color='blue'> The beam fires into your body, changing your size!</font>")
		M.updateicon()
		return
	return 1

/obj/item/projectile/beam/sizelaser/shrink
	set_size = 0.5 // 50% of current size

/obj/item/projectile/beam/sizelaser/grow
	set_size = 2.0 // 200% of current size

/obj/item/gun/energy/stripper // Because it can be fun
	name = "stripper gun"
	desc = "A gun designed to remove unnessary layers from people. For external use only!"
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "sizegun-shrink100" // TODO: Get unique sprite for this to prevent confusion.
	item_state = null	// So the human update icon uses the icon_state instead
	fire_sound = 'sound/weapons/wave.ogg'
	charge_cost = 240
	projectile_type = /obj/item/projectile/bullet/stripper
	origin_tech = list(TECH_BLUESPACE = 4)
	modifystate = "sizegun-shrink"
	no_pin_required = TRUE
	battery_lock = TRUE
	firemodes = list()
