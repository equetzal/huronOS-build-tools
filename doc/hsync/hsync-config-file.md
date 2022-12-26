
### Headers
The config file needs to have at least 2 headers of configurations:

- `[Global]`
    The global header will contain general configurations, such as the timezone, keyboard layout, presence of `[Event]` and/or `[Contest]` headers and their timings. 

- `[Always]` 
    The Always header will contain the rest of the configurations such as Wallpaper, Software selection, Network rules, and user permissions. 
    
### Possible Configurations

- `TimeZone=<YourTimezone>`
The time zone field must have a valid *Continent/City* format. [List of possible values](./timezones.md)
- `ConfigurationExpirationTime=[ never | ISO8601 Time ]`
    The time in which your configuration file will be valid. After this time the *default* configuration will be loaded insead. 
    -`never` Option should be used if the configuration file is expected to never expire.
    -`ISO8601 Time` Option should be use for setting an expiration time, it must use [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) extended time format relative to the local time. Example:`2030-01-10T11:45:01`. 