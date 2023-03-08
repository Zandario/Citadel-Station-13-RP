///Record list
#define MED_DATA_R_LIST  2
///Records maintenance
#define MED_DATA_MAINT   3
///Record
#define MED_DATA_RECORD  4
///Virus database
#define MED_DATA_V_DATA  5
///Medibot monitor
#define MED_DATA_MEDIBOT 6
#define FIELD(N, V, E) list(field = N, value = V, edit = E)
#define MED_FIELD(N, V, E, LB) list(field = N, value = V, edit = E, line_break = LB)

/obj/machinery/computer/med_data //TODO:SANITY
	name = "medical records console"
	desc = "Used to view, edit and maintain medical records."
	icon_keyboard = "med_key"
	icon_screen = "medcomp"
	density = TRUE
	light_color = "#315ab4"
	req_one_access = list(ACCESS_MEDICAL_MAIN, ACCESS_SECURITY_FORENSICS, ACCESS_SCIENCE_ROBOTICS)
	circuit = /obj/item/circuitboard/med_data
	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/list/temp = null
	var/printing = null
	//The below are used to make modal generation more convenient
	var/static/list/field_edit_questions
	var/static/list/field_edit_choices


/obj/machinery/computer/med_data/Initialize(mapload)
	. = ..()
	field_edit_questions = list(
		//General
		"sex" = "Please select new sex:",
		"age" = "Please input new age:",
		"fingerprint" = "Please input new fingerprint hash:",
		"p_stat" = "Please select new physical status:",
		"m_stat" = "Please select new mental status:",
		//Medical
		"id_gender" = "Please select new gender identity:",
		"blood_type" = "Please select new blood type:",
		"b_dna" = "Please input new DNA:",
		"mi_dis" = "Please input new minor disabilities:",
		"mi_dis_d" = "Please summarize minor disabilities:",
		"ma_dis" = "Please input new major disabilities:",
		"ma_dis_d" = "Please summarize major disabilities:",
		"alg" = "Please input new allergies:",
		"alg_d" = "Please summarize allergies:",
		"cdi" = "Please input new current diseases:",
		"cdi_d" = "Please summarize current diseases:",
		"notes" = "Please input new important notes:",
	)
	field_edit_choices = list(
		//General
		"sex" = all_genders_text_list,
		"p_stat" = list("*Deceased*", "*SSD*", "Active", "Physically Unfit", "Disabled"),
		"m_stat" = list("*Insane*", "*Unstable*", "*Watch*", "Stable"),
		//Medical
		"id_gender" = all_genders_text_list,
		"blood_type" = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"),
	)

/obj/machinery/computer/med_data/Destroy()
	active1 = null
	active2 = null
	return ..()

/obj/machinery/computer/med_data/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)	return

	if(scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		scan.loc = get_turf(src)
		if(!usr.get_active_held_item() && istype(usr,/mob/living/complex/human))
			usr.put_in_hands(scan)
		scan = null
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/machinery/computer/med_data/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/card/id) && !scan)
		if(!user.attempt_insert_item_for_installation(O, src))
			return
		scan = O
		to_chat(user, "You insert \the [O].")
		ui_interact(user)
	else
		..()

/obj/machinery/computer/med_data/attack_ai(user as mob)
	return attack_hand(user)

/obj/machinery/computer/med_data/attack_hand(mob/user as mob)
	if(..())
		return

	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/computer/med_data/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MedicalRecords", "Medical Records") //800, 380
		ui.open()
		ui.set_autoupdate(FALSE)


/obj/machinery/computer/med_data/ui_data(mob/user)
	var/data[0]
	data["temp"] = temp
	data["scan"] = scan ? scan.name : null
	data["authenticated"] = authenticated
	data["rank"] = rank
	data["screen"] = screen
	data["printing"] = printing
	data["isAI"] = isAI(user)
	data["isRobot"] = isrobot(user)
	if(authenticated)
		switch(screen)
			if(MED_DATA_R_LIST)
				if(!isnull(data_core.general))
					var/list/records = list()
					data["records"] = records
					for(var/datum/data/record/R in sortRecord(data_core.general))
						records[++records.len] = list("ref" = "\ref[R]", "id" = R.fields["id"], "name" = R.fields["name"])
			if(MED_DATA_RECORD)
				var/list/general = list()
				data["general"] = general
				if(istype(active1, /datum/data/record) && data_core.general.Find(active1))
					var/list/fields = list()
					general["fields"] = fields
					fields[++fields.len] = FIELD("Name", active1.fields["name"], null)
					fields[++fields.len] = FIELD("ID", active1.fields["id"], null)
					fields[++fields.len] = FIELD("Sex", active1.fields["sex"], "sex")
					fields[++fields.len] = FIELD("Age", active1.fields["age"], "age")
					fields[++fields.len] = FIELD("Fingerprint", active1.fields["fingerprint"], "fingerprint")
					fields[++fields.len] = FIELD("Physical Status", active1.fields["p_stat"], "p_stat")
					fields[++fields.len] = FIELD("Mental Status", active1.fields["m_stat"], "m_stat")
					var/list/photos = list()
					general["photos"] = photos
					photos[++photos.len] = active1.fields["photo-south"]
					photos[++photos.len] = active1.fields["photo-west"]
					general["has_photos"] = (active1.fields["photo-south"] || active1.fields["photo-west"] ? 1 : 0)
					general["empty"] = 0
				else
					general["empty"] = 1

				var/list/medical = list()
				data["medical"] = medical
				if(istype(active2, /datum/data/record) && data_core.medical.Find(active2))
					var/list/fields = list()
					medical["fields"] = fields
					fields[++fields.len] = MED_FIELD("Gender identity", active2.fields["id_gender"], "id_gender", TRUE)
					fields[++fields.len] = MED_FIELD("Blood Type", active2.fields["b_type"], "blood_type", FALSE)
					fields[++fields.len] = MED_FIELD("DNA", active2.fields["b_dna"], "b_dna", TRUE)
					fields[++fields.len] = MED_FIELD("Brain Type", active2.fields["brain_type"], "brain_type", TRUE)
					if(!active2.fields["comments"] || !islist(active2.fields["comments"]))
						active2.fields["comments"] = list()
					medical["notes"] = active2.fields["notes"]
					medical["comments"] = active2.fields["comments"]
					medical["empty"] = 0
				else
					medical["empty"] = 1
			if(MED_DATA_V_DATA)
				data["virus"] = list()
				for(var/ID in virusDB)
					var/datum/data/record/v = virusDB[ID]
					data["virus"] += list(list("name" = v.fields["name"], "D" = "\ref[v]"))
			if(MED_DATA_MEDIBOT)
				data["medibots"] = list()
				for(var/mob/living/bot/medibot/M in GLOB.mob_list)
					if(M.z != z)
						continue
					var/turf/T = get_turf(M)
					if(T)
						var/medibot = list()
						var/area/A = get_area(T)
						medibot["name"] = M.name
						medibot["area"] = A.name
						medibot["x"] = T.x
						medibot["y"] = T.y
						medibot["on"] = M.on
						if(!isnull(M.reagent_glass) && M.use_beaker)
							medibot["use_beaker"] = 1
							medibot["total_volume"] = M.reagent_glass.reagents.total_volume
							medibot["maximum_volume"] = M.reagent_glass.reagents.maximum_volume
						else
							medibot["use_beaker"] = 0
						data["medibots"] += list(medibot)

	data["modal"] = ui_modal_data(src)
	return data

/obj/machinery/computer/med_data/ui_act(action, params)
	if(..())
		return TRUE

	if(!data_core.general.Find(active1))
		active1 = null
	if(!data_core.medical.Find(active2))
		active2 = null

	. = TRUE
	if(ui_act_modal(action, params))
		return

	switch(action)
		if("cleartemp")
			temp = null
		if("scan")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(usr) && !usr.get_active_held_item())
					usr.put_in_hands(scan)
				scan = null
			else
				var/obj/item/I = usr.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					if(!usr.attempt_insert_item_for_installation(I, src))
						return
					scan = I
		if("login")
			var/login_type = text2num(params["login_type"])
			if(login_type == LOGIN_TYPE_NORMAL && istype(scan))
				if(check_access(scan))
					authenticated = scan.registered_name
					rank = scan.assignment
			else if(login_type == LOGIN_TYPE_AI && isAI(usr))
				authenticated = usr.name
				rank = "AI"
			else if(login_type == LOGIN_TYPE_ROBOT && isrobot(usr))
				authenticated = usr.name
				var/mob/living/silicon/robot/R = usr
				rank = "[R.modtype] [R.braintype]"
			if(authenticated)
				active1 = null
				active2 = null
				screen = MED_DATA_R_LIST
		else
			. = FALSE

	if(.)
		return

	if(authenticated)
		. = TRUE
		switch(action)
			if("logout")
				if(scan)
					scan.forceMove(loc)
					if(ishuman(usr) && !usr.get_active_held_item())
						usr.put_in_hands(scan)
					scan = null
				authenticated = null
				screen = null
				active1 = null
				active2 = null
			if("screen")
				screen = clamp(text2num(params["screen"]) || 0, MED_DATA_R_LIST, MED_DATA_MEDIBOT)
				active1 = null
				active2 = null
			if("vir")
				var/datum/data/record/v = locate(params["vir"])
				if(!istype(v))
					return FALSE
				ui_modal_message(src, "virus", "", null, v.fields["tgui_description"])
			if("del_all")
				for(var/datum/data/record/R in data_core.medical)
					qdel(R)
				set_temp("All medical records deleted.")
			if("del_r")
				if(active2)
					set_temp("Medical record deleted.")
					qdel(active2)
			if("d_rec")
				var/datum/data/record/general_record = locate(params["d_rec"] || "")
				if(!data_core.general.Find(general_record))
					set_temp("Record not found.", "danger")
					return

				var/datum/data/record/medical_record
				for(var/datum/data/record/M in data_core.medical)
					if(M.fields["name"] == general_record.fields["name"] && M.fields["id"] == general_record.fields["id"])
						medical_record = M
						break

				active1 = general_record
				active2 = medical_record
				screen = MED_DATA_RECORD
			if("new")
				if(istype(active1, /datum/data/record) && !istype(active2, /datum/data/record))
					var/datum/data/record/R = new /datum/data/record()
					R.fields["name"] = active1.fields["name"]
					R.fields["id"] = active1.fields["id"]
					R.name = "Medical Record #[R.fields["id"]]"
					R.fields["b_type"] = "Unknown"
					R.fields["b_dna"] = "Unknown"
					R.fields["mi_dis"] = "None"
					R.fields["mi_dis_d"] = "No minor disabilities have been declared."
					R.fields["ma_dis"] = "None"
					R.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
					R.fields["alg"] = "None"
					R.fields["alg_d"] = "No allergies have been detected in this patient."
					R.fields["cdi"] = "None"
					R.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
					data_core.medical += R
					active2 = R
					screen = MED_DATA_RECORD
					set_temp("Medical record created.", "success")
			if("del_c")
				var/index = text2num(params["del_c"] || "")
				if(!index || !istype(active2, /datum/data/record))
					return

				var/list/comments = active2.fields["comments"]
				index = clamp(index, 1, length(comments))
				if(comments[index])
					comments.Cut(index, index + 1)
			if("search")
				active1 = null
				active2 = null
				var/t1 = lowertext(params["t1"] || "")
				if(!length(t1))
					return

				for(var/datum/data/record/R in data_core.medical)
					if(t1 == lowertext(R.fields["name"]) || t1 == lowertext(R.fields["id"]) || t1 == lowertext(R.fields["b_dna"]))
						active2 = R
						break
				if(!active2)
					set_temp("Medical record not found. You must enter the person's exact name, ID or DNA.", "danger")
					return
				for(var/datum/data/record/E in data_core.general)
					if(E.fields["name"] == active2.fields["name"] && E.fields["id"] == active2.fields["id"])
						active1 = E
						break
				screen = MED_DATA_RECORD
			if("print_p")
				if(!printing)
					printing = TRUE
					// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, TRUE)
					SStgui.update_uis(src)
					addtimer(CALLBACK(src, .proc/print_finish), 5 SECONDS)
			else
				return FALSE

/**
  * Called in ui_act() to process modal actions
  *
  * Arguments:
  * * action - The action passed by tgui
  * * params - The params passed by tgui
  */
/obj/machinery/computer/med_data/proc/ui_act_modal(action, params)
	. = TRUE
	var/id = params["id"] // The modal's ID
	var/list/arguments = istext(params["arguments"]) ? json_decode(params["arguments"]) : params["arguments"]
	switch(ui_modal_act(src, action, params))
		if(UI_MODAL_OPEN)
			switch(id)
				if("edit")
					var/field = arguments["field"]
					if(!length(field) || !field_edit_questions[field])
						return
					var/question = field_edit_questions[field]
					var/choices = field_edit_choices[field]
					if(length(choices))
						ui_modal_choice(src, id, question, arguments = arguments, value = arguments["value"], choices = choices)
					else
						ui_modal_input(src, id, question, arguments = arguments, value = arguments["value"])
				if("add_c")
					ui_modal_input(src, id, "Please enter your message:")
				else
					return FALSE
		if(UI_MODAL_ANSWER)
			var/answer = params["answer"]
			switch(id)
				if("edit")
					var/field = arguments["field"]
					if(!length(field) || !field_edit_questions[field])
						return
					var/list/choices = field_edit_choices[field]
					if(length(choices) && !(answer in choices))
						return

					if(field == "age")
						answer = text2num(answer)

					if(istype(active2) && (field in active2.fields))
						active2.fields[field] = answer
					else if(istype(active1) && (field in active1.fields))
						active1.fields[field] = answer
				if("add_c")
					if(!length(answer) || !istype(active2) || !length(authenticated))
						return
					active2.fields["comments"] += list(list(
						header = "Made by [authenticated] ([rank]) at [worldtime2stationtime(world.time)]",
						text = answer
					))
				else
					return FALSE
		else
			return FALSE


/**
  * Called when the print timer finishes
  */
/obj/machinery/computer/med_data/proc/print_finish()
	var/obj/item/paper/P = new(loc)
	P.info = "<center><b>Medical Record</b></center><br>"
	if(istype(active1, /datum/data/record) && data_core.general.Find(active1))
		P.info += {"Name: [active1.fields["name"]] ID: [active1.fields["id"]]
		<br>\nSex: [active1.fields["sex"]]
		<br>\nAge: [active1.fields["age"]]
		<br>\nFingerprint: [active1.fields["fingerprint"]]
		<br>\nPhysical Status: [active1.fields["p_stat"]]
		<br>\nMental Status: [active1.fields["m_stat"]]<br>"}
	else
		P.info += "<b>General Record Lost!</b><br>"
	if(istype(active2, /datum/data/record) && data_core.medical.Find(active2))
		P.info += {"<br>\n<center><b>Medical Data</b></center>
		<br>\nGender Identity: [active2.fields["id_gender"]]
		<br>\nBlood Type: [active2.fields["b_type"]]
		<br>\nDNA: [active2.fields["b_dna"]]<br>\n
		<br>\nMinor Disabilities: [active2.fields["mi_dis"]]
		<br>\nDetails: [active2.fields["mi_dis_d"]]<br>\n
		<br>\nMajor Disabilities: [active2.fields["ma_dis"]]
		<br>\nDetails: [active2.fields["ma_dis_d"]]<br>\n
		<br>\nAllergies: [active2.fields["alg"]]
		<br>\nDetails: [active2.fields["alg_d"]]<br>\n
		<br>\nCurrent Diseases: [active2.fields["cdi"]] (per disease info placed in log/comment section)
		<br>\nDetails: [active2.fields["cdi_d"]]<br>\n
		<br>\nMedical Notes Summary:
		<br>\n\t[active2.fields["notes"]]<br>\n
		<br>\n
		<center><b>Comments/Log</b></center><br>"}
		for(var/c in active2.fields["comments"])
			P.info += "[c["header"]]<br>[c["text"]]<br>"
	else
		P.info += "<b>Medical Record Lost!</b><br>"
	P.info += "</tt>"
	P.name = "paper - 'Medical Record: [active1.fields["name"]]'"
	printing = FALSE
	SStgui.update_uis(src)

/**
 * Sets a temporary message to display to the user
 *
 * Arguments:
 * * text - Text to display, null/empty to clear the message from the UI
 * * style - The style of the message: (color name), info, success, warning, danger, virus
 */
/obj/machinery/computer/med_data/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

/obj/machinery/computer/med_data/emp_act(severity)
	if(machine_stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/data/record/R in data_core.medical)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields["name"] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields["sex"]	= pick("Male", "Female")
				if(3)
					R.fields["age"] = rand(5, 85)
				if(4)
					R.fields["b_type"] = pick("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
				if(5)
					R.fields["p_stat"] = pick("*SSD*", "Active", "Physically Unfit", "Disabled")
					if(GLOB.PDA_Manifest.len)
						GLOB.PDA_Manifest.Cut()
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			qdel(R)
			continue

	..(severity)


/obj/machinery/computer/med_data/laptop //TODO: Change name to PCU and update mapdata to include replacement computers
	name = "\improper Medical Laptop"
	desc = "A personal computer unit. It seems to have only the medical records program installed."
	icon_screen = "pcu_generic"
	icon_state = "pcu_med"
	icon_keyboard = "pcu_key"
	light_color = "#5284e7"
	circuit = /obj/item/circuitboard/med_data/pcu
	density = FALSE


#undef FIELD
#undef MED_FIELD
