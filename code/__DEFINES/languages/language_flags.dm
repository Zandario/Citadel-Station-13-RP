//! ## LANGUAGE_FLAGS
/// Language can only be acquired by spawning or an admin.
#define LANGUAGE_FLAG_RESTRICTED   (1<<0)
/// Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define LANGUAGE_FLAG_NONVERBAL    (1<<1)
/// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define LANGUAGE_FLAG_SIGNLANG     (1<<2)
/// Broadcast to all mobs with this language.
#define LANGUAGE_FLAG_HIVEMIND     (1<<3)
/// Do not add to general languages list.
#define LANGUAGE_FLAG_NONGLOBAL    (1<<4)
/// All mobs can be assumed to speak and understand this language. (audible emotes)
#define LANGUAGE_FLAG_INNATE       (1<<5)
/// Do not show the "\The [speaker] talks into \the [radio]" message
#define LANGUAGE_FLAG_NO_TALK_MSG  (1<<6)
/// No stuttering, slurring, or other speech problems.
#define LANGUAGE_FLAG_NO_STUTTER   (1<<7)
/// Language is not based on vision or sound. //TODO: Add this into the say code and use it for the rootspeak languages.
#define LANGUAGE_FLAG_ALT_TRANSMIT (1<<8)
