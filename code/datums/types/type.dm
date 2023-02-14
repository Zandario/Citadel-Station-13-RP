/**
 * Generic value holder.
 * This is not /datum/type just to make people think of it as a value holder...
 */
/type
	parent_type = /datum
	abstract_type = /type

	/// Read-only, this is determined by the last portion of the derived entry type
	var/name
	/// The configured value for this entry. This shouldn't be initialized in code, instead set default
	var/type_value
	/// Read-only default value for this config entry, used for resetting value to defaults when necessary. This is what config_entry_value is initially set to
	var/default
	/// Set to TRUE if the default has been overridden by a config entry
	var/modified = FALSE

/type/New(input)
	if(type == abstract_type)
		CRASH("Abstract config entry [type] instatiated!")
	name = lowertext(type2top(type))
	set_default(input)

/**
 * Returns the value of the type to its default, used for resetting a value.
 */
/type/proc/set_default(input)
	if(islist(default))
		var/list/L = input || default
		type_value = L.Copy()
	else
		type_value = input || default
	modified = FALSE

/type/proc/ValidateAndSet(str_val)
	CRASH("Invalid type entry!")

/type/string
	default = ""
	abstract_type = /type/string
	var/auto_trim = TRUE

/type/string/ValidateAndSet(str_val, during_load)
	type_value = auto_trim ? trim(str_val) : str_val
	return TRUE

/type/number
	default = 0
	abstract_type = /type/number
	var/integer = TRUE
	var/max_val = INFINITY
	var/min_val = -INFINITY

/type/number/ValidateAndSet(str_val)
	var/temp = text2num(trim(str_val))
	if(!isnull(temp))
		type_value = clamp(integer ? round(temp) : temp, min_val, max_val)
		return TRUE
	return FALSE

/type/flag
	default = FALSE
	abstract_type = /type/flag

/type/flag/ValidateAndSet(str_val)
	type_value = text2num(trim(str_val)) != 0
	return TRUE

/type/number_list
	abstract_type = /type/number_list
	default = list()

/type/number_list/ValidateAndSet(str_val)
	str_val = trim(str_val)
	var/list/new_list = list()
	var/list/values = splittext(str_val," ")
	for(var/I in values)
		var/temp = text2num(I)
		if(isnull(temp))
			return FALSE
		new_list += temp
	if(!new_list.len)
		return FALSE
	type_value = new_list
	return TRUE
