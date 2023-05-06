# Enabling Events and Contests
To enable events, the `EventConfig` flag must be set to true

To enable contests, the `ContestConfig` flag must be set to true

# Defining event and contest hours
The syntax for specify an event time or a contest time is  
`BeginTime EndTime` 

BeginTime and EndTime must use [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) extended time format relative to the local time. Example:`2030-01-10T11:45:01`. 

More info on this in [here](./configurations/events-and-contests.md)

## Times example
```
[Event-Times]
2023-05-13T10:00:00 2023-05-13T19:00:00
[Contest-Times]
2023-05-13T11:00:00 2023-05-13T15:00:00
```