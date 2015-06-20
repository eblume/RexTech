PARAMETER target_altitude, duration.

RUN lib_pid.

PRINT "Begin altitude hold program.".

LOCAL ascent_pid IS PID_init(0.1, 0.06, 0.06, 0, 1).
LOCAL to_throttle IS 0.
LOCAL t0 is TIME:SECONDS.
LOCK THROTTLE TO to_throttle.

UNTIL TIME:SECONDS - t0 >= duration {
    SET to_throttle TO PID_seek(ascent_pid, target_altitude, SHIP:ALTITUDE).
    wait 0.001.
}.

LOCK THROTTLE TO 0.

PRINT "Completed altitude hold program.".

