/*****************************
 * Points vendor for engineers
 * Points are aquired via crypto miners.
 *****************************/

obj/machinery/mineral/equipment_vendor/engineering
	name = "Engineering Equipment Vendor"
	desc = "An equipment vendor for engineers, point generated by the crypto miners can be spend here."
	icon_state = "engineering"
	icon_deny = "engineering-deny"
	child = TRUE
	//circuit = /obj/item/circuitboard/engineering_equip
	prize_list = list(
		//Mining vendor steals
		new /datum/data/mining_equipment("Whiskey",						    /obj/item/reagent_containers/food/drinks/bottle/whiskey,		3),
		new /datum/data/mining_equipment("Absinthe",					    /obj/item/reagent_containers/food/drinks/bottle/absinthe,	    3),
		new /datum/data/mining_equipment("Special Blend Whiskey",		    /obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,	5),
		new /datum/data/mining_equipment("Random Booze",			        /obj/random/alcohol,		                                    3),
		new /datum/data/mining_equipment("Cigar",						    /obj/item/clothing/mask/smokable/cigarette/cigar/havana,        5),
		new /datum/data/mining_equipment("Soap",						    /obj/item/soap/nanotrasen,									    2),
		new /datum/data/mining_equipment("Laser Pointer",				    /obj/item/laser_pointer,										9),
		new /datum/data/mining_equipment("Plush Toy",					    /obj/random/plushie,											3),
		new /datum/data/mining_equipment("GPS Device",					    /obj/item/gps/engineering,									    1),
		new /datum/data/mining_equipment("50 Point Transfer Card",		    /obj/item/card/mining_point_card/engineering,				    50),
		new /datum/data/mining_equipment("Umbrella",					    /obj/item/melee/umbrella/random,								20),
		new /datum/data/mining_equipment("100 Thaler",					    /obj/item/spacecash/c100,									    4),
		new /datum/data/mining_equipment("1000 Thaler",					    /obj/item/spacecash/c1000,									    40),
		new /datum/data/mining_equipment("Hardsuit - Control Module",       /obj/item/rig/industrial,									    50),
		new /datum/data/mining_equipment("Hardsuit - Plasma Cutter",	    /obj/item/rig_module/device/plasmacutter,						10),
		new /datum/data/mining_equipment("Hardsuit - Maneuvering Jets",	    /obj/item/rig_module/maneuvering_jets,							12),
		new /datum/data/mining_equipment("Hardsuit - Intelligence Storage",	/obj/item/rig_module/ai_container,								25),
		new /datum/data/mining_equipment("Injector (L) - Glucose",          /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose,	50),
		new /datum/data/mining_equipment("Injector (L) - Panacea",          /obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity,	50),
		new /datum/data/mining_equipment("Injector (L) - Trauma",           /obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute,	50),
		new /datum/data/mining_equipment("Nanopaste Tube",				    /obj/item/stack/nanopaste,										10),
		//Mining vendor steals - Ends
        //Power tools like the CE gets, if kev comes crying: https://cdn.discordapp.com/attachments/296237931587305472/956517623519141908/unknown.png
		new /datum/data/mining_equipment("Advanced Voidsuit",							/obj/item/rig/ce,									150),
        new /datum/data/mining_equipment("Power Tool - Hand Drill",                     /obj/item/tool/screwdriver/power,                   80),
        new /datum/data/mining_equipment("Power Tool - Jaws of life",                   /obj/item/tool/crowbar/power,                       80),
        new /datum/data/mining_equipment("Power Tool - Experimental Welder",            /obj/item/weldingtool/experimental,                 80),
        new /datum/data/mining_equipment("Power Tool - Upgraded T-Ray Scanner",         /obj/item/t_scanner/upgraded,                       80),
        new /datum/data/mining_equipment("Power Tool - Advanced T-Ray Scanner",         /obj/item/t_scanner/advanced,                       80),
        new /datum/data/mining_equipment("Power Tool - Long Range Atmosphere scanner",  /obj/item/analyzer/longrange,                       80),
		//new /datum/data/mining_equipment("Power Tool - Holofan Projector", 				/obj/item/holosign_creator/combifan,				80),
        new /datum/data/mining_equipment("Superior Welding Goggles",                    /obj/item/clothing/glasses/welding/superior,        50),

        //Level 2 stock parts, to make engineering kinda self sufficent for minor upgrades but the parts are also kinda expansive
        new /datum/data/mining_equipment("Stock Parts - Advanced Capacitor",        /obj/item/stock_parts/capacitor/adv,        20),
        new /datum/data/mining_equipment("Stock Parts - Advanced Scanning Module",  /obj/item/stock_parts/scanning_module/adv,  20),
        new /datum/data/mining_equipment("Stock Parts - Nano-Manipulator",          /obj/item/stock_parts/manipulator/nano,     20),
        new /datum/data/mining_equipment("Stock Parts - High-Power Micro-Laser",    /obj/item/stock_parts/micro_laser/high,     20),
        new /datum/data/mining_equipment("Stock Parts - Advanced Matter Bin",       /obj/item/stock_parts/matter_bin/adv,       20),

		//Special Resources which the vendor is the primary source off:
		new /datum/data/mining_equipment("Special Parts - Vimur Tank", 				/obj/item/tank/vimur, 25),
		new /datum/data/mining_equipment("Special Parts - TEG Voucher", 			/obj/item/engineering_voucher/teg, 20),
		new /datum/data/mining_equipment("Special Parts - SM Core Voucher", 		/obj/item/engineering_voucher/smcore, 40),
		new /datum/data/mining_equipment("Special Parts - Fusion Core Voucher",		/obj/item/engineering_voucher/fusion_core, 20),
		new /datum/data/mining_equipment("Special Parts - Fuel Injector Voucher",	/obj/item/engineering_voucher/fusion_fuel_injector, 10),
		new /datum/data/mining_equipment("Special Parts - Gyrotrons Voucher", 		/obj/item/engineering_voucher/gyrotrons, 20),
		new /datum/data/mining_equipment("Special Parts - Fuel compressor Voucher",	/obj/item/engineering_voucher/fuel_compressor, 10),
		new /datum/data/mining_equipment("Special Parts - Collector Voucher", 		/obj/item/engineering_voucher/collectors, 10),
		//voucher: Solar crate, Vimur canister
		new /datum/data/mining_equipment("???", /obj/item/engineering_mystical_tech, 1000)
    )

obj/machinery/mineral/equipment_vendor/engineering/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat +="<div class='statusDisplay'>"
	if(istype(inserted_id))
		dat += "You have [inserted_id.engineer_points] engineering points collected. <A href='?src=\ref[src];choice=eject'>Eject ID.</A><br>"
	else
		dat += "No ID inserted.  <A href='?src=\ref[src];choice=insert'>Insert ID.</A><br>"
	dat += "</div>"
	dat += "<br><b>Equipment point cost list:</b><BR><table border='0' width='100%'>"
	for(var/datum/data/mining_equipment/prize in prize_list)
		dat += "<tr><td>[prize.equipment_name]</td><td>[prize.cost]</td><td><A href='?src=\ref[src];purchase=\ref[prize]'>Purchase</A></td></tr>"
	dat += "</table>"
	var/datum/browser/popup = new(user, "miningvendor", "Engineering Equipment Vendor", 400, 600)
	popup.set_content(dat)
	popup.open()

obj/machinery/mineral/equipment_vendor/engineering/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["choice"])
		if(istype(inserted_id))
			if(href_list["choice"] == "eject")
				to_chat(usr, "<span class='notice'>You eject the ID from [src]'s card slot.</span>")
				if(ishuman(usr))
					usr.put_in_hands_or_drop(inserted_id)
					inserted_id = null
				else
					inserted_id.forceMove(get_turf(src))
					inserted_id = null
		else if(href_list["choice"] == "insert")
			var/obj/item/card/id/I = usr.get_active_held_item()
			if(istype(I) && !inserted_id)
				if(!usr.attempt_insert_item_for_installation(I, src))
					return
				inserted_id = I
				interact(usr)
				to_chat(usr, "<span class='notice'>You insert the ID into [src]'s card slot.</span>")
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
				flick(icon_deny, src)

	if(href_list["purchase"])
		if(istype(inserted_id))
			var/datum/data/mining_equipment/prize = locate(href_list["purchase"])
			if (!prize || !(prize in prize_list))
				to_chat(usr, "<span class='warning'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > inserted_id.engineer_points)
				to_chat(usr, "<span class='warning'>Error: Insufficent points for [prize.equipment_name]!</span>")
				flick(icon_deny, src)
			else
				inserted_id.engineer_points -= prize.cost
				to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
				new prize.equipment_path(drop_location())
		else
			to_chat(usr, "<span class='warning'>Error: Please insert a valid ID!</span>")
			flick(icon_deny, src)
	updateUsrDialog()

obj/item/tank/vimur
	name = "Vimur tank"
	desc = "Contains Vimur. A gas with very high thermal capacity. Probably not so smart to breath."
	icon = 'icons/obj/tank_vr.dmi'
	icon_state = "coolant"
	gauge_icon = null
	slot_flags = null	//they have no straps!
	volume = 500//Standard tanks have 70, we up that alot, a cannister has 1000, but we want this to be worth our points.

obj/item/tank/vimur/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/vimur, (10*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return .

obj/item/engineering_voucher
	name = "equipment voucher"
	desc = "An used voucher that could be used to be redeemed for something at the cargo console"
	icon = 'icons/obj/vouchers.dmi'
	icon_state = "engineering_voucher_used"
	w_class = ITEMSIZE_SMALL
	var/datum/supply_pack/redeemable_for = null

obj/item/engineering_voucher/proc/redeem(var/mob/user)
	if(!redeemable_for)
		to_chat(user, SPAN_WARNING("[src] has already been used"))
		return
	var/datum/supply_order/order = new /datum/supply_order

	var/idname = "*None Provided*"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
	else if(issilicon(user))
		idname = user.real_name

	order.ordernum = ++SSsupply.ordernum		// Ordernum is used to track the order between the playerside list of orders and the adminside list
	order.index = order.ordernum	// Index can be fabricated, or falsified. Ordernum is a permanent marker used to track the order
	order.object = redeemable_for
	order.name = redeemable_for.name
	order.cost = 0
	order.ordered_by = idname
	order.comment = "Voucher redemption"
	order.ordered_at = stationdate2text() + " - " + stationtime2text()
	order.status = SUP_ORDER_APPROVED		//auto approved
	order.approved_by = "[src]"
	order.approved_at = stationdate2text() + " - " + stationtime2text()

	SSsupply.order_history += order//tell supply the order exists.
	SSsupply.adm_order_history += order

	name = "used " + name
	redeemable_for = null
	icon_state = "engineering_voucher_used"
	desc = "An used voucher that was used to redeem for something at the cargo console"

obj/item/engineering_voucher/teg
	name = "Thermo-Electric Generator voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a Thermo-Electric Generator"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/teg

obj/item/engineering_voucher/collectors
	name = "Radiation Collector voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of crate of radiation collectors"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/engine/collector

obj/item/engineering_voucher/smcore
	name = "Supermatter Core voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a Supermatter core"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/smbig

obj/item/engineering_voucher/fusion_core
	name = "Fusion Core voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a fusion core"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/fusion_core

obj/item/engineering_voucher/fusion_fuel_injector
	name = "Fuel Injector voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a fusion fuel injector"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/fusion_fuel_injector

obj/item/engineering_voucher/gyrotrons
	name = "Gyrotron voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of Gyrotrons"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/gyrotron

obj/item/engineering_voucher/fuel_compressor
	name = "Fuel compressor voucher"
	desc = "A voucher redeemable, at any NT cargo department, for shipment of a Fuel rod compressor"
	icon_state = "engineering_voucher"
	redeemable_for = new /datum/supply_pack/eng/fusion_fuel_compressor

obj/item/engineering_mystical_tech
	name = "XYE"
	desc = "???"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "circuit"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_PRECURSOR = 1)
