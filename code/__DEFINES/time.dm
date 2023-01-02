
#define INFINITE -1 //? -1 is commonly used to indicate an infinite time duration.

#define MILLISECOND  *0.01
#define MILLISECONDS *0.01

/// The base unit all of these defines are scaled by, because byond uses that as a unit of measurement for some fucking reason.
#define DECISECOND  *1
#define DECISECONDS *1

#define SECOND  *10
#define SECONDS *10

#define MINUTE  SECONDS*60
#define MINUTES SECONDS*60

#define HOUR  MINUTES*60
#define HOURS MINUTES*60

#define DAY  HOURS*24
#define DAYS HOURS*24

#define TICK  *world.tick_lag
#define TICKS *world.tick_lag


/// Convert deciseconds to ticks.
#define DS2TICKS(DS) ((DS)/world.tick_lag)
/// Convert ticks to deciseconds.
#define TICKS2DS(T) ((T) TICKS)
/// Convert miliseconds to deciseconds.
#define MS2DS(T) ((T) MILLISECONDS)
/// Convert deciseconds to miliseconds.
#define DS2MS(T) ((T) * 100)


#define GAMETIMESTAMP(format, wtime) time2text(wtime, format)
#define WORLDTIME2TEXT(format) GAMETIMESTAMP(format, world.time)
#define WORLDTIMEOFDAY2TEXT(format) GAMETIMESTAMP(format, world.timeofday)
#define TIME_STAMP(format, showds) showds ? "[WORLDTIMEOFDAY2TEXT(format)]:[world.timeofday % 10]" : WORLDTIMEOFDAY2TEXT(format)
#define STATION_TIME(display_only, wtime) ((((wtime - SSticker.SSticker.round_start_time) * SSticker.station_time_rate_multiplier) + SSticker.gametime_offset) % 864000) - (display_only? GLOB.timezoneOffset : 0)
#define STATION_TIME_TIMESTAMP(format, wtime) time2text(STATION_TIME(TRUE, wtime), format)

#define JANUARY   1
#define FEBRUARY  2
#define MARCH     3
#define APRIL     4
#define MAY       5
#define JUNE      6
#define JULY      7
#define AUGUST    8
#define SEPTEMBER 9
#define OCTOBER   10
#define NOVEMBER  11
#define DECEMBER  12

/// use for rapid actions that make messages to throttle messages
#define CHATSPAM_THROTTLE_DEFAULT (!(world.time % 5))
/// ditto
#define CHATSPAM_THROTTLE(every) (!(world.time % every))
