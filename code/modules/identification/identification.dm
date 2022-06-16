// This is a datum attached to objects to make their 'identity' be unknown initially.
// The identitiy and properties of an unidentified object can be determined in-game through a specialized process or by potentially risky trial-and-error.
// This is very similar to a traditional roguelike's identification system, and as such will use certain terms from those to describe them.
// Despite this, unlike a roguelike, objects that do the same thing DO NOT have the same name/appearance/etc.

/datum/identification
	var/obj/holder = null				// The thing the datum is 'attached' to.
	// Holds the true information.
	var/true_name = null				// The real name of the object. It is copied automatically from holder, on the datum being instantiated.
	var/true_desc = null				// Ditto, for desc.
	var/true_description_info = null	// Ditto, for helpful examine panel entries.
	var/true_description_fluff = null	// Ditto, for lore.
	var/true_description_antag = null	// Ditto, for antag info (this probably won't get used).
	var/identified = IDENTITY_UNKNOWN	// Can be IDENTITY_UNKNOWN, IDENTITY_PROPERTIES, IDENTITY_QUALITY, or IDENTITY_FULL.

	// Holds what is displayed when not identified sufficently.
	var/unidentified_name = null		// The name given to the object when not identified. Generated by generate_unidentified_name()
	var/unidentified_desc = "You're not too sure what this is."
	var/unidentified_description_info = "This object is unidentified, and as such its properties are unknown. Using this object may be dangerous."

	// Lists of lists for generating names by combining one from each.
	var/list/naming_lists = list()

	// What 'identification type' is needed to identify this.
	var/identification_type = IDENTITY_TYPE_NONE

/datum/identification/New(obj/new_holder)
	ASSERT(new_holder)
	holder = new_holder
	record_true_identity() // Get all the identifying features from the holder.
	update_name() // Then hide them for awhile if needed.

/datum/identification/Destroy()
	holder = null
	return ..()

// Records the object's inital identifiying features to the datum for future safekeeping.
/datum/identification/proc/record_true_identity()
	true_name = holder.name
	true_desc = holder.desc
	true_description_info = holder.description_info
	true_description_fluff = holder.description_fluff
	true_description_antag = holder.description_antag

// Formally identifies the holder.
/datum/identification/proc/identify(new_identity = IDENTITY_FULL, mob/user)
	if(new_identity & identified) // Already done.
		return
	identified |= new_identity // Set the bitflag.
	if(user)
		switch(identified)
			if(IDENTITY_QUALITY)
				to_chat(user, "<span class='notice'>You've identified \the [holder]'s quality.</span>")
			if(IDENTITY_PROPERTIES)
				to_chat(user, "<span class='notice'>You've identified \the [holder]'s functionality as a [true_name].</span>")
			if(IDENTITY_FULL)
				to_chat(user, "<span class='notice'>You've identified \the [holder] as a [true_name], and its quality.</span>")
		update_name()
		holder.update_icon()

// Reverses identification for whatever reason.
/datum/identification/proc/unidentify(new_identity = IDENTITY_UNKNOWN, mob/user)
	identified &= ~new_identity // Unset the bitflag.
	update_name()
	holder.update_icon()
	if(user)
		switch(identified) // Give a message based on what's left.
			if(IDENTITY_QUALITY)
				to_chat(user, SPAN_WARNING( "You forgot what \the [holder] actually did..."))
			if(IDENTITY_PROPERTIES)
				to_chat(user, SPAN_WARNING( "You forgot \the [holder]'s quality..."))
			if(IDENTITY_UNKNOWN)
				to_chat(user, SPAN_WARNING( "You forgot everything about \the [holder]."))

// Sets the holder's name to the real name if its properties are identified, or obscures it otherwise.
/datum/identification/proc/update_name()
	if(identified & IDENTITY_PROPERTIES)
		holder.name = true_name
		holder.desc = true_desc
		holder.description_info = true_description_info
		holder.description_fluff = true_description_fluff
		holder.description_antag = true_description_antag
		return

	if(!unidentified_name)
		unidentified_name = generate_unidentified_name()

	holder.name = unidentified_name
	holder.desc = unidentified_desc
	holder.description_info = unidentified_description_info
	holder.description_fluff = null
	holder.description_antag = null

// Makes a name for an object that is not identified. It picks one string out of each list inside naming_list.
/datum/identification/proc/generate_unidentified_name()
	if(!LAZYLEN(naming_lists))
		return "unidentified object"

	var/list/new_name = list()
	for(var/i in naming_lists)
		var/list/current_list = i
		new_name += pick(current_list)
	return new_name.Join(" ")

// Used for tech-based objects.
// Unused for now pending Future Stuff(tm).
/datum/identification/mechanical
	naming_lists = list(
		list("unidentified", "unknown", "strange", "weird", "unfamiliar", "peculiar", "mysterious", "bizarre", "odd"),
		list("device", "apparatus", "gadget", "mechanism", "appliance", "machine", "equipment", "invention", "contraption")
	)
	identification_type = IDENTITY_TYPE_TECH

// Used for unidentified hypos.
// Their contents can range from genuine medication, expired medicine, illicit drugs, toxins and poisons, and more.
// They are the analog for potions in a traditional roguelike.
/datum/identification/hypo
	naming_lists = list(
		list("unidentified", "unknown", "unmarked", "blank", "refilled", "custom", "modified", "questionable", "suspicious"),
		list("hypospray", "autoinjector")
	)
	unidentified_desc = "An autoinjector that does not give any indication towards what is inside. \
	The case is also sealed tight and the liquids contained cannot be removed except by injecting it into someone. \
	Do you feel lucky?"
	unidentified_description_info = "A skilled chemist with a specialized machine can identify this autoinjector. \
	Blindly using the autoinjector is risky and can be dangerous."
	identification_type = IDENTITY_TYPE_CHEMICAL
