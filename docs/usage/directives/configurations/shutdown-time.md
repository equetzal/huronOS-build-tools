# Shutdown time

`ShutdownTime=[ ISO8601_TIME | none ]`

In the "ShutdownTime" section, you can specify the exact time when you want the instances to shut down. This only works if your system clock is accurately synchronized with an NTP server.

Example:

`ShutdownTime=2023-06-02T13:58:00`

Keep in mind that even though the shutdown command will be sent to all machines, they might not all shut down at the exact same time. This is because the shutdown command isn't perfectly precise, so some machines might power off in groups or one after the other.

Furthermore, the specified shutdown time is rooted in the time zone selected for your system. This implies that the shutdown time aligns with the local time of the chosen time zone.