@LAZYGLOBAL OFF.

PARAMETER duration.

LOCAL t0 is TIME:SECONDS.
LOCAL target_altitude IS SHIP:ALTITUDE.

PRINT "Holding altitude " + target_altitude + " for " + duration + " seconds.".

// THROTTLE PID
LOCAL throttle_pid IS PID_init(0.1, 0.06, 0.06, 0, 1).
LOCAL to_throttle IS 0.
LOCK THROTTLE TO to_throttle.
LOCK STEERING TO UP.

UNTIL TIME:SECONDS - t0 >= duration {
    SET to_throttle TO PID_seek(throttle_pid, target_altitude, SHIP:ALTITUDE).
    
    // Re-update t0 until we're 'hovering'
    if abs(ship:verticalspeed) > 2 {
        SET t0 TO TIME:SECONDS.
    }
    
    wait 0.001.
}.

PRINT "Finished altitude hold progragram.".

LOCK THROTTLE TO 0.

