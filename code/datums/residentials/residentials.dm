// Persistent residentials are saved to /maps/persistent/residentials by default, the id is the filename	~ Cassie

/datum/residential
	var/name = "Empty Apartment"
	var/id = "emptylot"
	var/desc = "A generic apartment you can buy."
	var/price = 20000
	var/rent = 300

	//owner related
	var/landlord_name = ""
	var/tenant_name
	var/company_name	"NanoTrasen"	// If owned by a company. (not implemented)

	var/tenant_uid
	var/landlord_uid
	var/company_uid		// Not in use yet

	var/company_email	// if a company has an email for contact (not implemented)
	var/landlord_email
	var/tenant_email

	var/last_payment			// Date of last time the residentials were charged, this is done monthly, goes from landlord
	var/last_payment_tnt		// Last time tenant paid their bills

	var/service_charge_warning = 15000		// How much debt landlord is in before letters start arriving. (not implemented)
	var/service_charge_possession = 20000	// How much debt landlord is in with service charges before NT come be a bitch. (not implemented)

	var/landlord_balance = 0
	var/tenant_balance = 0

	var/required_deposit = 200

	// Money related
	var/landlord_bank	// Account id of who gets charged monthly for this	// Probably set this to a static CentCom or Colony ID
	var/tenant_bank		// Account id of tenant


	/*
	// possible descriptors (for now):
	-	pest control
	-	cleaning service
	*/
	var/list/landlord_does = list()

	var/status = FOR_SALE

	var/turf/top_left			// Turf of top left
	var/turf/bottom_right		// Turf of bottom right
	var/area/residential_area

	var/path = "data/persistent/residentials/"


/datum/residential/New()
	SSresidentials.all_residentials += src
	get_coordinates()

	..()

/datum/residential/proc/get_residential_price()
	if(HOUSING_TAX)
		return get_tax_price(HOUSING_TAX, price)

	return price

/datum/residential/proc/get_residential_tax_diff()
	return (HOUSING_TAX * price)

/datum/residential/proc/get_residential_tax()
	return HOUSING_TAX


/datum/residential/proc/get_rent()
	return rent

/datum/residential/proc/get_service_charge()
	var/service_charge = 0

	// To be expanded

	return service_charge


/datum/residential/proc/set_new_ownership(uid, l_name, bank, email)
	// Transfer price of residential to old owner's bank account
	if(landlord_bank)
		charge_to_account(landlord_bank, "Landlord Management", "Payment for [name]", "Landlord Management Console", get_residential_price())
		SSeconomy.charge_head_department( get_residential_price() )

	// Buying a residential as a landlord anew.
	landlord_uid = uid
	landlord_name = l_name

	if(bank)
		landlord_bank = bank
	else
		var/datum/money_account/CC_acc = dept_acc_by_id(DEPT_COUNCIL)
		landlord_bank = CC_acc.account_number


	if(email)
		landlord_email = email
	else
		landlord_email = using_map.council_email

	landlord_balance = 0

	if(!tenant_uid)
		status = OWNED


/datum/residential/proc/make_tenant(uid, l_name, bank, email)
	// Selling a property as a landlord, to a tenant
	// Transfer price of residential to old owner's bank account

	// Buying a residential as a landlord anew.
	tenant_uid = uid
	tenant_name = l_name


	if(bank)
		tenant_bank = bank

	if(email)
		tenant_email = email
	else
		tenant_email = using_map.council_email

	status = RENTED

	return 1

/datum/residential/proc/sell_to_council()
	// Aka reset residential. Selling a property back to the bad boys
	set_new_ownership()
	status = FOR_SALE

/datum/residential/proc/remove_tenant()

	// Removes a tenant from the residential
	tenant_uid = null
	tenant_name = null
	tenant_bank = null
	tenant_email = null
	tenant_email = null

	// Resets residential status
	if(landlord_uid)
		status = OWNED
	else
		status = FOR_SALE




/datum/residential/proc/repossess_residential()
	remove_tenant()
	sell_to_council()
	return 1

/datum/residential/proc/get_coordinates()
	for(var/obj/effect/landmark/residential_data/residential_data)
		if(residential_data.residential_id == id)
			if( istype(residential_data, /obj/effect/landmark/residential_data/top_left) )
				top_left = residential_data.loc
			else if( istype(residential_data,/obj/effect/landmark/residential_data/bottom_right) )
				bottom_right = residential_data.loc

	residential_area = get_area(top_left)

	if(top_left && bottom_right && residential_area)
		return 1

	return 0


/datum/residential/proc/map_file()
	var/complete_map = map_to_file(test_map_write(), path, id)

	return complete_map


/datum/residential/proc/test_map_write()
	var/CHUNK = make_chunk()

	var/e_map = map_write(CHUNK, 1, 0)

	return e_map

/datum/residential/proc/make_chunk()
	var/map_turfs = get_map_turfs(top_left, bottom_right)

	return map_turfs

/datum/residential/proc/maptofile()
	var/mfile = map_to_file(mapwrite())
	return mfile

/datum/residential/proc/mapwrite()
	var/mapw = map_write(make_chunk(), 1, 1)
	return mapw

/datum/residential/proc/save_residential_data()
	if(!top_left || !bottom_right)
		return 0
//	var/map = SSmapping.maploader.save_map(top_left, bottom_right, id, path, DMM_IGNORE_MOBS)
	var/map = save_map(top_left, bottom_right, id, path, TRUE, FALSE)

	return map

/datum/residential/proc/load_residential()
	if(!top_left || !bottom_right)
		return 0

	var/full_path = "[path][id].sav"
	if(fexists(full_path))
		for(var/obj/O in residential_area)
			QDEL_NULL(O)

		// One more time, as some things that delete leave things behind.
		for(var/obj/O in residential_area)
			QDEL_NULL(O)
//		SSmapping.maploader.load_map_tg(file(full_path), top_left.x, bottom_right.y, top_left.z, 1, 0)
//		SSmapping.maploader.load_map(file(full_path), top_left.x, bottom_right.y, top_left.z, 1, 0)
		restore_map(id, path)
		for(var/obj/O in residential_area)
			O.on_persistence_load()

/*
		// Some things don't initialize at all after being loaded, it's weird, but this is needed too.
		for(var/obj/O in residential_area)
			O.persistence_save = FALSE
			sleep(1)
			if(!O.initialized || istype(O,/obj/structure))
				O.initialize()
		return 1
*/
	return 1


/datum/controller/subsystem/residentials/proc/monthly_payroll()
	for(var/datum/residential/L in all_residentials)
		if(!(Days_Difference(L.last_payment , full_game_time() ) > 30 ) )
			if(!L.status == FOR_SALE)
				if(L.status == RENTED)
					L.tenant_balance += L.rent
			L.landlord_balance += L.get_service_charge()

			L.last_payment = full_game_time()

	return 1



// Lot signs, if a residential is vacant, it'll spawn a for rent sign on round start. Else, it'll delete itself. It'll copy the pixel_x and pixel_y of itself to the for rent sign, too.

/obj/effect/landmark/lotsign
	name = "rent sign spawner"
	icon = 'icons/obj/signs.dmi'
	desc = "Spawns a rent sign."
	icon_state = "rent"

	var/residential_id		// Associated residential ID
	dont_save = FALSE

/obj/effect/landmark/lotsign/initialize()
	SSlots.lotsigns += src

/obj/effect/landmark/lotsign/proc/get_residential_data()
	if(!residential_id)
		var/area/_area = loc.loc
		residential_id = _area.residential_id

	var/datum/residential/residential = SSlots.get_residential_by_id(residential_id)

	if(residential && !(residential.status == RENTED))
		var/obj/structure/sign/rent/R = new /obj/structure/sign/rent (src.loc)

		if(residential.status == FOR_RENT)
			R.icon_state = "rent"

			R.name = "[residential.name] - For Rent ([residential.rent]cr per month)"
			R.desc = "This rent sign says <b>[residential.name] - For Rent ([residential.price]cr)</b><br>\
			Underneath, the sign notes the housing is owned by <b>[residential.landlord_name ? residential.landlord_name : "City Council"]</b>. Contact them for more details or buy from the Landlord Management Program on the computers in the library."

		if(residential.status == FOR_SALE)
			R.icon_state = "sale"

			R.name = "[residential.name] - For Sale ([residential.price]cr)"
			R.desc = "This rent sign says <b>[residential.name] - For Sale ([residential.price]cr)</b><br>\
			Underneath, the sign notes the housing is owned by <b>[residential.landlord_name ? residential.landlord_name : "City Council"]</b>. Contact them for more details or buy from the Landlord Management Program on the computers in the library."

		if(residential.status == LOT_HELD)
			R.icon_state = "held"

			R.name = "[residential.name] - Held"
			R.desc = "This residential has been seized by city council."


		// Copy over mapping values.
		R.pixel_z = pixel_z
		R.pixel_x = pixel_x
		R.pixel_y = pixel_y

	delete_me = 1
	qdel(src)
