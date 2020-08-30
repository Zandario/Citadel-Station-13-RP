/datum/residential
	var/name = "Unnamed Housing Unit"
	var/owner_name = "Unkown"
	var/owner_uid = ""			// The Owner's Unique ID

	var/category = "General"	// Probably use this to define size/type?

	var/status = "Active"		// Maybe use this to set joinability?
	var/list/blacklisted_guests = list()		// By Unique ID

	var/list/datum/job/specific_jobs = list()	// Don't think this is used by anything.

	var/associated_account_no

	var/gets_residential_tax = TRUE				// Sacrifice your Dosh for the Dosh Gods.
