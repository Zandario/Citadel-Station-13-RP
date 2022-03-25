
#define span(class, text) ("<span class='[class]'>[text]</span>")

#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define to_world(message) to_chat(world, message)
#define to_file(file_entry, source_var) file_entry << source_var
#define from_file(file_entry, target_var) file_entry >> target_var

#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)

#define CanInteract(user, state) (CanUseTopic(user, state) == UI_INTERACTIVE)


#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }


/// BITFLAG STUFF

/// Semantic define for a 0 int intended for use as a bitfield
#define EMPTY_BITFIELD 0

/// Right-shift of INT by BITS
#define SHIFTR(INT, BITS) ((INT) >> (BITS))

/// Left-shift of INT by BITS
#define SHIFTL(INT, BITS) ((INT) << (BITS))

/// Convenience define for nth-bit flags, 0-indexed
#define FLAG(BIT) SHIFTL(1, BIT)

/// Test bit at index BIT is set in FIELD
#define GET_BIT(FIELD, BIT) ((FIELD) & FLAG(BIT))

/// Test bit at index BIT is set in FIELD; semantic alias of GET_BIT
#define HAS_BIT(FIELD, BIT) GET_BIT(FIELD, BIT)

/// Set bit at index BIT in FIELD
#define SET_BIT(FIELD, BIT) ((FIELD) |= FLAG(BIT))

/// Unset bit at index BIT in FIELD
#define CLEAR_BIT(FIELD, BIT) ((FIELD) &= ~FLAG(BIT))

/// Flip bit at index BIT in FIELD
#define FLIP_BIT(FIELD, BIT) ((FIELD) ^= FLAG(BIT))

/// Test any bits of MASK are set in FIELD
#define GET_FLAGS(FIELD, MASK) ((FIELD) & (MASK))

/// Test all bits of MASK are set in FIELD
#define HAS_FLAGS(FIELD, MASK) (((FIELD) & (MASK)) == (MASK))

/// Set bits of MASK in FIELD
#define SET_FLAGS(FIELD, MASK) ((FIELD) |= (MASK))

/// Unset bits of MASK in FIELD
#define CLEAR_FLAGS(FIELD, MASK) ((FIELD) &= ~(MASK))

/// Flip bits of MASK in FIELD
#define FLIP_FLAGS(FIELD, MASK) ((FIELD) ^= (MASK))
