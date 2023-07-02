# Shutdown time

`ShutdownTime=[ ISO8601_TIME | none ]`

Allows to set a specific time in the global section when the instances should shutdown (only if the system clock is properly sync with an NTP server).

Example:

`ShutdownTime=2023-06-02T13:58:00`

Note:
It might happen that (although every machine will turn off) not every machine will shut down at the same time because the shutdown command used doesn't have an accuracy of seconds, so it is expected that some computers power off in groups or one after another.