GLOBAL_EMPTY_LIST(flooring_types)


/proc/populate_flooring_types()
	GLOB.flooring_types = list()
	for (var/flooring_path in typesof(/singleton/flooring))
		GLOB.flooring_types["[flooring_path]"] = new flooring_path


/proc/get_flooring_data(flooring_path)
	if(!GLOB.flooring_types)
		GLOB.flooring_types = list()
	if(!GLOB.flooring_types["[flooring_path]"])
		GLOB.flooring_types["[flooring_path]"] = new flooring_path
	return GLOB.flooring_types["[flooring_path]"]
