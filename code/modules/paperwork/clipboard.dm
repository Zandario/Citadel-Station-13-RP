obj/item/clipboard
	name = "clipboard"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throw_force = 0
	w_class = ITEMSIZE_SMALL
	throw_speed = 3
	throw_range = 10
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.
	slot_flags = SLOT_BELT

obj/item/clipboard/Initialize(mapload)
	. = ..()
	update_icon()

obj/item/clipboard/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()
	if(toppaper)
		overlays_to_add += toppaper.icon_state
		overlays_to_add += copy_overlays(toppaper)
	if(haspen)
		overlays_to_add += "clipboard_pen"
	overlays_to_add += "clipboard_over"

	add_overlay(overlays_to_add)

	return

obj/item/clipboard/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		if(istype(W, /obj/item/paper))
			toppaper = W
		to_chat(user, "<span class='notice'>You clip the [W] onto \the [src].</span>")
		update_icon()

	else if(istype(toppaper) && istype(W, /obj/item/pen))
		toppaper.attackby(W, usr)
		update_icon()
		return

	return ..()

obj/item/clipboard/attack_self(mob/user)
	. = ..()
	if(.)
		return
	var/dat = "<title>Clipboard</title>"
	if(haspen)
		dat += "<A href='?src=\ref[src];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='?src=\ref[src];addpen=1'>Add Pen</A><BR><HR>"

	//The topmost paper. I don't think there's any way to organise contents in byond, so this is what we're stuck with.	-Pete
	if(toppaper)
		var/obj/item/paper/P = toppaper
		dat += "<A href='?src=\ref[src];write=\ref[P]'>Write</A> <A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR><HR>"

	for(var/obj/item/paper/P in src)
		if(P==toppaper)
			continue
		dat += "<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"

	user << browse(dat, "window=clipboard")
	onclose(user, "clipboard")
	add_fingerprint(usr)
	return

obj/item/clipboard/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list["pen"])
			if(istype(haspen) && (haspen.loc == src))
				haspen.loc = usr.loc
				usr.put_in_hands(haspen)
				haspen = null

		else if(href_list["addpen"])
			if(!haspen)
				var/obj/item/pen/W = usr.get_active_held_item()
				if(istype(W, /obj/item/pen))
					if(!usr.attempt_insert_item_for_installation(W, src))
						return
					haspen = W
					to_chat(usr, "<span class='notice'>You slot the pen into \the [src].</span>")

		else if(href_list["write"])
			var/obj/item/P = locate(href_list["write"])

			if(P && (P.loc == src) && istype(P, /obj/item/paper) && (P == toppaper) )

				var/obj/item/I = usr.get_active_held_item()

				if(istype(I, /obj/item/pen))

					P.attackby(I, usr)

		else if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])

			if(P && (P.loc == src) && (istype(P, /obj/item/paper) || istype(P, /obj/item/photo)) )

				P.loc = usr.loc
				usr.put_in_hands(P)
				if(P == toppaper)
					toppaper = null
					var/obj/item/paper/newtop = locate(/obj/item/paper) in src
					if(newtop && (newtop != P))
						toppaper = newtop
					else
						toppaper = null

		else if(href_list["rename"])
			var/obj/item/O = locate(href_list["rename"])

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

		else if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])

			if(P && (P.loc == src) && istype(P, /obj/item/paper) )

				if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/observer/dead) || istype(usr, /mob/living/silicon)))
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")
				else
					usr << browse("<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>", "window=[P.name]")
					onclose(usr, "[P.name]")

		else if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P, /obj/item/photo) )
				P.show(usr)

		else if(href_list["top"]) // currently unused
			var/obj/item/P = locate(href_list["top"])
			if(P && (P.loc == src) && istype(P, /obj/item/paper) )
				toppaper = P
				to_chat(usr, "<span class='notice'>You move [P.name] to the top.</span>")

		//Update everything
		attack_self(usr)
		update_icon()
	return
