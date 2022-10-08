// Body weight limits on a character.
#define WEIGHT_MIN 70
#define WEIGHT_MAX 500
#define WEIGHT_CHANGE_MIN 0
#define WEIGHT_CHANGE_MAX 100

// Define a place to save in character setup
/datum/preferences
	var/size_multiplier = RESIZE_NORMAL

	//! Body weight stuff
	/// bodyweight of character (pounds, because I'm not doing the math again -Spades)
	var/weight_vr = 137
	/// Weight gain rate.
	var/weight_gain = 100
	/// Weight loss rate.
	var/weight_loss = 50
	/// Preference toggle for sharp/fuzzy icon. Default sharp.
	var/fuzzy = 0

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/size
	name = "Size"
	sort_order = 2

/datum/category_item/player_setup_item/vore/size/load_character(savefile/S)
	READ_FILE(S["size_multiplier"], pref.size_multiplier)
	READ_FILE(S["weight_vr"], pref.weight_vr)
	READ_FILE(S["weight_gain"], pref.weight_gain)
	READ_FILE(S["weight_loss"], pref.weight_loss)
	READ_FILE(S["fuzzy"], pref.fuzzy)

/datum/category_item/player_setup_item/vore/size/save_character(savefile/S)
	WRITE_FILE(S["size_multiplier"], pref.size_multiplier)
	WRITE_FILE(S["weight_vr"], pref.weight_vr)
	WRITE_FILE(S["weight_gain"], pref.weight_gain)
	WRITE_FILE(S["weight_loss"], pref.weight_loss)
	WRITE_FILE(S["fuzzy"], pref.fuzzy)

/datum/category_item/player_setup_item/vore/size/sanitize_character()
	pref.weight_vr   = isnum(pref.weight_vr) ? round(clamp(pref.weight_vr, WEIGHT_MIN, WEIGHT_MAX)) : initial(pref.weight_vr)
	pref.weight_gain = sanitize_integer(pref.weight_gain, WEIGHT_CHANGE_MIN, WEIGHT_CHANGE_MAX, initial(pref.weight_gain))
	pref.weight_loss = sanitize_integer(pref.weight_loss, WEIGHT_CHANGE_MIN, WEIGHT_CHANGE_MAX, initial(pref.weight_loss))
	pref.fuzzy       = sanitize_integer(pref.fuzzy, 0, 1, initial(pref.fuzzy))
	if(pref.size_multiplier == null || pref.size_multiplier < RESIZE_TINY || pref.size_multiplier > RESIZE_HUGE)
		pref.size_multiplier = initial(pref.size_multiplier)

/datum/category_item/player_setup_item/vore/size/copy_to_mob(mob/living/carbon/human/character)
	character.weight      = pref.weight_vr
	character.weight_gain = pref.weight_gain
	character.weight_loss = pref.weight_loss
	character.fuzzy       = pref.fuzzy
	character.resize(pref.size_multiplier, animate = FALSE)

/datum/category_item/player_setup_item/vore/size/content(mob/user)
	. += "<br>"
	. += "Scale: <a href='?src=\ref[src];size_multiplier=1'>[round(pref.size_multiplier*100)]%</a><br>"
	. += "Scaled Appearance: <a [pref.fuzzy ? "" : ""] href='?src=\ref[src];toggle_fuzzy=1'>[pref.fuzzy ? "Fuzzy" : "Sharp"]</a><br>"
	. += "<br>"
	. += "Relative Weight: <a href='?src=\ref[src];weight=1'>[pref.weight_vr]</a><br>"
	. += "Weight Gain Rate: <a href='?src=\ref[src];weight_gain=1'>[pref.weight_gain]</a><br>"
	. += "Weight Loss Rate: <a href='?src=\ref[src];weight_loss=1'>[pref.weight_loss]</a><br>"

/datum/category_item/player_setup_item/vore/size/OnTopic(href, list/href_list, mob/user)
	if(href_list["size_multiplier"])
		var/new_size = input(user, "Choose your character's size, ranging from 25% to 200%", "Set Size") as num|null
		if (!ISINRANGE(new_size,25,200))
			pref.size_multiplier = 1
			to_chat(user, SPAN_NOTICE("Invalid size."))
			return TOPIC_REFRESH_UPDATE_PREVIEW
		else if(new_size)
			pref.size_multiplier = (new_size/100)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_fuzzy"])
		pref.fuzzy = pref.fuzzy ? FALSE : TRUE
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["weight"])
		var/new_weight = input(user, "Choose your character's relative body weight.\n\
			This measurement should be set relative to a normal 5'10'' person's body and not the actual size of your character.\n\
			If you set your weight to 500 because you're a naga or have metal implants then complain that you're a blob I\n\
			swear to god I will find you and I will punch you for not reading these directions!\n\
			([WEIGHT_MIN]-[WEIGHT_MAX])", "Character Preference") as num|null
		if(new_weight)
			var/unit_of_measurement = alert(user, "Is that number in pounds (lb) or kilograms (kg)?", "Confirmation", "Pounds", "Kilograms")
			if(unit_of_measurement == "Pounds")
				new_weight = round(text2num(new_weight),4)
			if(unit_of_measurement == "Kilograms")
				new_weight = round(2.20462*text2num(new_weight),4)
			pref.weight_vr = sanitize_integer(new_weight, WEIGHT_MIN, WEIGHT_MAX, pref.weight_vr)
			return TOPIC_REFRESH

	else if(href_list["weight_gain"])
		var/weight_gain_rate = input(user, "Choose your character's rate of weight gain between 100% \
			(full realism body fat gain) and 0% (no body fat gain).\n\
			(If you want to disable weight gain, set this to 0.01 to round it to 0%.)\
			([WEIGHT_CHANGE_MIN]-[WEIGHT_CHANGE_MAX])", "Character Preference") as num|null
		if(weight_gain_rate)
			pref.weight_gain = round(text2num(weight_gain_rate),1)
			return TOPIC_REFRESH

	else if(href_list["weight_loss"])
		var/weight_loss_rate = input(user, "Choose your character's rate of weight loss between 100% \
			(full realism body fat loss) and 0% (no body fat loss).\n\
			(If you want to disable weight loss, set this to 0.01 round it to 0%.)\
			([WEIGHT_CHANGE_MIN]-[WEIGHT_CHANGE_MAX])", "Character Preference") as num|null
		if(weight_loss_rate)
			pref.weight_loss = round(text2num(weight_loss_rate),1)
			return TOPIC_REFRESH

	return ..();
