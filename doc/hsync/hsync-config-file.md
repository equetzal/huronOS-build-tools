
### Headers
The config file needs to have at least 2 headers of configurations:

- `[Global]`
    The global header will contain general configurations, such as the timezone, keyboard layout, presence of `[Event]` and/or `[Contest]` headers and their timings. 

- `[Always]` 
    The Always header will contain the rest of the configurations such as Wallpaper, Software selection, Network rules, and user permissions. 
    
### Possible Configurations

- `TimeZone=<YourTimezone>`
The time zone field must have a valid *Continent/City* format. [List of possible values](./timezones.md)