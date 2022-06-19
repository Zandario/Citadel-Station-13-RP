//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantpad
	name = "implantpad"
	desc = "Used to modify implants."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	var/obj/item/implantcase/case = null
	var/broadcasting = null
	var/listening = TRUE


/obj/item/implantpad/proc/update()
	if(case)
		icon_state = "implantpad-1"
	else
		icon_state = "implantpad-0"
	return


/obj/item/implantpad/attack_hand(mob/living/user)
	if((case && user.item_is_in_hands(src)))
		user.put_in_active_hand(case)

		case.add_fingerprint(user)
		case = null

		add_fingerprint(user)
		update()
	else
		return ..()
	return


/obj/item/implantpad/attackby(obj/item/implantcase/C, mob/user)
	..()
	if(istype(C, /obj/item/implantcase))
		if(!(case))
			user.drop_item()
			C.loc = src
			src.case = C
	else
		return
	update()
	return

/obj/item/implantpad/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<B>Implant Mini-Computer:</B><HR>"
	if (case)
		if(case.imp)
			if(istype(case.imp, /obj/item/implant))
				dat += case.imp.get_data()
				if(istype(case.imp, /obj/item/implant/tracking))
					dat += {"ID (1-100):
					<A href='byond://?src=\ref[src];tracking_id=-10'>-</A>
					<A href='byond://?src=\ref[src];tracking_id=-1'>-</A> [case.imp:id]
					<A href='byond://?src=\ref[src];tracking_id=1'>+</A>
					<A href='byond://?src=\ref[src];tracking_id=10'>+</A><BR>"}
		else
			dat += "The implant casing is empty."
	else
		dat += "Please insert an implant casing!"
	user << browse(dat, "window=implantpad")
	onclose(user, "implantpad")
	return


/obj/item/implantpad/Topic(href, href_list)
	..()
	if (usr.stat)
		return
	if ((usr.contents.Find(src)) || ((in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if (href_list["tracking_id"])
			var/obj/item/implant/tracking/T = src.case.imp
			T.id += text2num(href_list["tracking_id"])
			T.id = min(1000, T.id)
			T.id = max(1, T.id)

		if(istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if(M.client)
					src.attack_self(M)
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=implantpad")
		return
	return
