---
sidebar_position: 1
---
# Creating a Directives File
A directives file is composed with different sections

## Global section
This section includes the following directives
- `TimeZone=<YourTimezone>`

    The time zone to use in the huronOS instances and, as reference, this field must have a valid *Continent/City* format. [List of possible values](./configurations/timezones.md)

- `ConfigExpirationTime=[ never || ISO8601 Time ]`

    The time in which your configuration file will be valid. After this time, the *default* configuration will be loaded instead. 
    - `never` Option should be used if the configuration file is expected to never expire.
    - `ISO8601 Time` Option should be use for setting an expiration time, it must use [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) extended time format relative to the local time. Example:`2030-01-10T11:45:01`. 

    More info on that [here](./configurations/expiration-time.md)

- `AvailableKeyboardLayouts=[layout1|...|layoutN|]`

    The available layouts allowed to be used in the huronOS instance. A list containing the possible layouts is available [here](./configurations/keyboard-layout.md)

- `DefaultKeyboardLayout=layout`

    You might also define a default layout from the ones listed in `AvailableKeyboardLayouts`

- `EventConfig=[true || false]`

    If this flag is true, it will expect the `[Event-Times]` section to not be empty having times in it.
    
- `ContestConfig=[true || false]`

    If this flag is true, it will expect the `[Contest-Times]` section to not be empty having times in it.
    
    More info on this in [here](./configurations/events-and-contests.md)

## Example
```ini
[Global]
TimeZone=America/Mexico_City
ConfigExpirationTime=2023-05-15T11:00:00
AvailableKeyboardLayouts=latam|us|
DefaultKeyboardLayout=latam
EventConfig=false
ContestConfig=true
```

# Modes sections [ Always || Event || Contest ]
Here are the different directives that allow to configure some stuff that would be active on whichever section they're defined, they'll be overridden like this

    * Contest overrides Event & Always
    * Event overrides Always
- `AllowedWebsites=[ url1|...|urlN| ]`
    
    A list of all the allowed websites while in that mode. More info on this directive [here](./configurations/web-firewall.md)

- `AllowUsbStorage=[ true || false ]`

    If the flag is true, the system will allow to access plugged USBs to read/save files outside the system.
    
    If the flag is false, the system will not allow to access any plugged USB.

    More info on that [here](./configurations/usb-drives.md)

- `AvailableSoftware=[ program1|...|programN| ]`

    The software that would be available while the system is on the current mode. [List of possible values](./configurations/software-modules.md)

- `Bookmarks=[ url1|...|urlN| ]`
    Defines the bookmarks that should appear in the browsers (at least chromium & firefox) at the time they are opened for the 1st time. More info on the bookmarks directive [here](./configurations/bookmarks.md)

- `Wallpaper=[ default || url ]`
    
    With "default" the default huronOS wallpaper would be set, otherwise, the wallpaper would be retrieved from the specified url. More info about wallpapers [here](./configurations/wallpaper.md)

- `WallpaperSha256=xxxxxxxxxx`

    The sha256 of the wallpaper defined in the url, more info on the sha [here](./configurations/wallpaper.md)

## Mode example
```ini
[Contest]
AllowedWebsites=codeforces.com|omegaup.com|
AllowUsbStorage=false
AvailableSoftware=langs/g++|programming/vscode|
Bookmarks={Codeforces^http://codeforces.com}|
Wallpaper=directives.huronOS.org/wallpaper1.png
WallpaperSha256=somerandomsha
```

# [ Event | Contest ]-Times section
These sections (if EventConfig and/or ContestConfig is true) define the times that might activate the events and/or the contests, the syntax for specifying an event time or a contest time is  
`BeginTime EndTime` 

BeginTime and EndTime must use [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) extended time format relative to the local time. Example:`2030-01-10T11:45:01`. 

More info on this in [here](./configurations/events-and-contests.md)

## Times example
```ini
[Event-Times]
2023-05-13T10:00:00 2023-05-13T19:00:00
[Contest-Times]
2023-05-13T11:00:00 2023-05-13T15:00:00
```

# Complete example
```ini
[Global]
TimeZone=America/Mexico_City
ConfigExpirationTime=2023-05-15T11:00:00
AvailableKeyboardLayouts=latam|us|
DefaultKeyboardLayout=latam
EventConfig=true
ContestConfig=true

[Always]
AllowedWebsites=all
AllowUsbStorage=true
AvailableSoftware=langs/g++|programming/vscode|
Bookmarks={Codeforces^http://codeforces.com}|
Wallpaper=default
# No wallpaper sha because we're using the default wallpaper

[Event]
AllowedWebsites=mytestsite.com
AllowUsbStorage=true
AvailableSoftware=langs/g++|programming/vscode|
Bookmarks={MySite^http://mysite.com}|
Wallpaper=directives.huronOS.org/wallpaper1.png
WallpaperSha256=somerandomsha

[Contest]
AllowedWebsites=codeforces.com|omegaup.com|
AllowUsbStorage=false
AvailableSoftware=langs/g++|programming/vscode|
Bookmarks={Codeforces^http://codeforces.com}|
Wallpaper=directives.huronOS.org/wallpaper1.png
WallpaperSha256=somerandomsha

[Event-Times]
2023-05-13T10:00:00 2023-05-13T19:00:00

[Contest-Times]
# This contest is valid even if it is inside an event
# It would look like this
# Always -> Event -> Contest -> Event
2023-05-13T11:00:00 2023-05-13T15:00:00
# Contest unrelated to an event
2023-06-12T11:00:00 2023-06-12T15:00:00
```