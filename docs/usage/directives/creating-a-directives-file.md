# Creating a Directives File

TODO


- `TimeZone=<YourTimezone>`
The time zone field must have a valid *Continent/City* format. [List of possible values](./available-timezones.md)
- `ConfigurationExpirationTime=[ never | ISO8601 Time ]`
    The time in which your configuration file will be valid. After this time the *default* configuration will be loaded instead. 
    -`never` Option should be used if the configuration file is expected to never expire.
    -`ISO8601 Time` Option should be use for setting an expiration time, it must use [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) extended time format relative to the local time. Example:`2030-01-10T11:45:01`. 