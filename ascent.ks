// Proportional Feedback Loop for Kerbin ascent. Assumes we are already in early ascent,
// straight vertical 'UP' profile.

// See: http://ksp-kos.github.io/KOS_DOC/tutorials/pidloops.html
PARAMETER target_apoapsis.

RUN lib_pid.

IF SHIP:ALTITUDE <= 1000 {
    PRINT "Ascending through 1000m.".
    WAIT UNTIL SHIP:ALTITUDE > 1000.
}

PRINT "Beginning automatic ascent profile program.".

LOCAL ascent_pid IS PID_init(0.01, 0.006, 0.006, 0, 1).
LOCAL to_throttle IS SHIP:CONTROL:PILOTMAINTHROTTLE.
LOCK THROTTLE TO to_throttle.

UNTIL SHIP:ALTITUDE >= target_apoapsis {
    SET to_throttle TO PID_seek(ascent_pid, target_apoapsis, SHIP:APOAPSIS).
    wait 0.001.
}.

LOCK THROTTLE TO 0.

PRINT "Completed automatic ascent profile program.".

