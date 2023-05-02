/****************************
* Category Collection Setup *
****************************/
datum/category_collection/underwear
	category_group_type = /datum/category_group/underwear

/*************
* Categories *
*************/
datum/category_group/underwear

	/// Lower sort order is applied as icons first.
	var/sort_order
	/// For displaying in text.
	var/display_name
	var/gender = NEUTER

datum/category_group/underwear/dd_SortValue()
	return sort_order

datum/category_group/underwear/top
	name = "Underwear, top"
	display_name = "top piece"
	sort_order = 1
	category_item_type = /datum/category_item/underwear/top

datum/category_group/underwear/bottom
	name = "Underwear, bottom"
	display_name = "bottom piece"
	sort_order = 2
	category_item_type = /datum/category_item/underwear/bottom

datum/category_group/underwear/socks
	name = "Socks"
	display_name = "socks"
	gender = PLURAL
	sort_order = 3
	category_item_type = /datum/category_item/underwear/socks

datum/category_group/underwear/undershirt
	name = "Undershirt"
	display_name = "undershirt"
	sort_order = 4 // Undershirts currently have the highest sort order because they may cover both underwear and socks.
	category_item_type = /datum/category_item/underwear/undershirt

/*******************
* Category entries *
*******************/
datum/category_item/underwear
	/// Should this entry be sorte last?
	var/always_last = FALSE
	/// Should this entry be considered the default for its type?
	var/is_default = FALSE
	/// Which icon to get the underwear from.
	var/icon = 'icons/mob/human.dmi'
	/// And the particular item state.
	var/icon_state
	/// Underwear customizations.
	var/list/tweaks = list()
	var/has_color = FALSE

datum/category_item/underwear/New()
	if(has_color)
		tweaks += gear_tweak_free_color_choice

datum/category_item/underwear/dd_SortValue()
	if(always_last)
		return "~"+name
	return name

datum/category_item/underwear/proc/is_default(gender)
	return is_default

datum/category_item/underwear/proc/generate_image(list/metadata, layer = FLOAT_LAYER)
	if(!icon_state)
		return

	var/image/I = image(icon = icon, icon_state = icon_state, layer = layer)
	for(var/datum/gear_tweak/gt in tweaks)
		gt.tweak_item(I, metadata && metadata["[gt]"] ? metadata["[gt]"] : gt.get_default())
	return I
