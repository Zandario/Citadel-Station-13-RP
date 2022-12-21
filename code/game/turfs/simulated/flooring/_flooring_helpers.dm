GLOBAL_LIST_INIT(flooring_cache, populate_flooring_cache())

/proc/populate_flooring_cache()
	var/list/temp_flooring_list = list()
	for (var/flooring_path in subtypesof(/singleton/flooring))
		temp_flooring_list["[flooring_path]"] = new flooring_path
	return temp_flooring_list

/proc/get_flooring_data(flooring_path)
	if(!GLOB.flooring_cache)
		stack_trace("GLOB.flooring_cache is null, this should never happen. Please report this on the issue tracker.")

	if(!GLOB.flooring_cache["[flooring_path]"])
		GLOB.flooring_cache["[flooring_path]"] = new flooring_path
	return GLOB.flooring_cache["[flooring_path]"]
