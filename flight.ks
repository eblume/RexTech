CLEARSCREEN.

PARAMETER height, duration.

RUN lib_pid.

PRINT "========= BEGIN FLIGHT CONTROL PROGRAM ==========".

RUN auto_gear.
RUN launch.
RUN ascent(height, 5).
RUN hold_altitude(duration).
RUN land.

PRINT "Main control sequence complete. (Abort Program to resume manual control.)".
UNTIL 0 > 1 {
    WAIT 1.
}

