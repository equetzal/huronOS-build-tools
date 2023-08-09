---
sidebar_position: 2
---
# Directives File Syntax

The directives file syntax heavily relies on the *INI config* syntax, but with several modifications tailored to suit huronOS' requirements. As explained in the [introduction to directives](introduction-to-directives), the directives are primarily governed by their *execution modes* (*contest*, *event*, *default*). However, some directives, such as keyboard distributions and timezone settings, are considered mode-independent, while others are mode-dependent. The directives are divided into two sections: Global Directives and Specific Directives.

For specific directives, we have three sections (case-sensitive):
- "**Always**" for the default mode.
- "**Event**" for the event mode.
- "**Contest**" for the contest mode.

When dealing with *Event* and *Contest* modes, we also expect the sections "**Event-Times**" and "**Contest-Times**" (respectively) to be present, resulting in a file structure similar to this:

```ini
[Global]

[Always]

[Event]

[Contest]

[Event-Times]

[Contest-Times]

```

## Global Directives

The global directives, applied at all times, support various configurations. Each specific syntax is detailed in its own [config documents](./configurations/). This section includes the following directives (click on the title link to view the specific syntax documentation):

- [`TimeZone=<YourTimezone>`](./configurations/timezones.md)  
    This directive allows you to set the system's local timezone using IANA standard timezones.

- [`ConfigExpirationTime=[ never || ISO8601 Time ]`](./configurations/expiration-time.md)  
    Use this directive to ensure that a set of rules (directives file) expires after a certain time. You can set an ISO 8601 time-date to specify the expiration time.

- [`AvailableKeyboardLayouts=[layout1|...|layoutN|]`](./configurations/keyboard-layout.md)  
    Here, you can define XKB keyboard layouts available for quick switching via the system tray button. Other configurations can be set via the system configuration. A list containing the possible layouts is available [here](https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee).

- [`DefaultKeyboardLayout=layout`](./configurations/keyboard-layout.md)  
    This directive allows you to specify the XKB keyboard layout to be set as the default on each mode change or at boot.

- [`EventConfig=[true || false]`](./configurations/events-and-contests.md)  
    Set this flag to expect the `[Event]` and `[Event-Times]` sections to be non-empty and properly configured.

- [`ContestConfig=[true || false]`](./configurations/events-and-contests.md)  
    Set this flag to expect the `[Contest]` and `[Contest-Times]` sections to be non-empty and properly configured.

### Global section example
```ini
[Global]
TimeZone=America/Mexico_City
ConfigExpirationTime=2023-05-15T11:00:00
AvailableKeyboardLayouts=latam|us|
DefaultKeyboardLayout=latam
EventConfig=false
ContestConfig=true
```

## Specific Directives

The specific directives are only applied when their time-window is active and the system is NTP-synced. Although the section is not explicitly named *Specific*, it uses the mode names as section titles: [Always], [Event], and [Contest]. Please refer to the [mode priorities](introduction-to-directives.md#mode-priorities) to understand which mode will be selected. All these sections share the same specific directives listed here:

- [`AllowedWebsites=[ domain1|...|domainN ]`](./configurations/web-firewall.md)  
    This directive configures a *Domain name* DNS-based firewall to set a list of all the allowed websites (HTTP, HTTPS access) for the configured mode.

- [`AllowUsbStorage=[ true || false ]`](./configurations/usb-drives.md)  
    When set to true, this directive allows the system to auto-mount plugged USBs to read/save files outside the system. When set to false, the system will not allow access to any plugged USB.

- [`AvailableSoftware=[ pkg1|...|pkgN ]`](./configurations/software-modules.md)  
    This directive defines a list of software packages to enable for the user during the execution mode.

- [`Bookmarks=[ bookmark1|...|bookmarkN| ]`](./configurations/bookmarks.md)  
    Set the initial browser bookmarks\* (supported only in Chromium and Firefox).
    > Please note that updates after the first open are not yet supported.

- [`Wallpaper=[ default || wallpaperURL ]`](./configurations/wallpaper.md)  
    By setting this directive to `default`, the [huronOS wallpaper](https://github.com/equetzal/huronOS-build-tools/blob/development/software-modules/base/03-budgie/files/huronos-background.png) will be used. Otherwise, the image will be retrieved from the specified URL.

- [`WallpaperSha256=xxxxxxxxxx`](./configurations/wallpaper.md)  
    This directive requires the SHA256 of the image defined in the wallpaper URL (except for default).

### Specific section example
```ini
[Contest]
AllowedWebsites=codeforces.com|omegaup.com|
AllowUsbStorage=false
AvailableSoftware=langs/g++|programming/vscode|
Bookmarks={Codeforces^http://codeforces.com}|
Wallpaper=https://directives.huronOS.org/wallpaper1.png
WallpaperSha256=somerandomsha
```

# Specific-Times Directives
These sections ([Event-Times], [Contest-Times]) define the beginning and end date-times for the event and contest modes. The syntax is as follows:
```ini
[Section-Times]
BeginTime1  EndTime1
BeginTime2  EndTime2
...
BeginTimeN  EndTimeN
```

The date-times must use [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) extended time format relative to the local time. For example: `2030-01-10T11:45:01`. 

For more information, please refer to [here](./configurations/events-and-contests.md).

### Times section example
```ini
[Event-Times]
2023-05-13T10:00:00 2023-05-13T19:00:00
[Contest-Times]
2023-05-13T11:00:00 2023-05-13T15:00:00
```

## Directives File Example
This example was used during the ICPC Mexico Qualification Rounds of 2023.

```ini
[Global]
TimeZone=America/Mexico_City
ConfigExpirationTime=2023-05-29T12:00:00
AvailableKeyboardLayouts=latam|us|es|dvorak|
DefaultKeyboardLayout=latam
EventConfig=false
ContestConfig=true

[Always]
AllowedWebsites=all
AllowUsbStorage=true
AvailableSoftware=internet/chromium|internet/crow|internet/firefox|langs/g++|langs/gcc|langs/javac|langs/kotlinc|langs/pypy3|langs/python3|tools/konsole|programming/atom|programming/codeblocks|programming/eclipse|programming/emacs|programming/geany|programming/gedit|programming/gvim|programming/intellij|programming/kate|programming/kdevelop|programming/pycharm|programming/sublime|programming/vim|programming/vscode|
Bookmarks={Contest^https://boca.icpcmexico.org}|{BOCA_User_Manual^https://directives.huronos.org/icpcmx/boca_manual_teams.en.html}|
Wallpaper=https://directives.huronos.org/icpcmx/gpmx2023_round1_always_mode.png
WallpaperSha256=c382c20791695176be47257ec924c9df39e40534d4ac02fb23c4f3c823334fd8

[Event]
AllowedWebsites=all
AllowUsbStorage=true
AvailableSoftware=internet/chromium
Bookmarks=huronOS^https://huronos.org|
Wallpaper=default

[Contest]
AllowedWebsites=boca.icpcmexico.org|score.icpcmexico.org|icpcmexico.org|
AllowUsbStorage=false
AvailableSoftware=internet/chromium|internet/crow|internet/firefox|langs/g++|langs/gcc|langs/javac|langs/kotlinc|langs/pypy3|langs/python3|tools/konsole|programming/atom|programming/codeblocks|programming/eclipse|programming/emacs|programming/geany|programming/gedit|programming/gvim|programming/intellij|programming/kate|programming/kdevelop|programming/pycharm|programming/sublime|programming/vim|programming/vscode|
Bookmarks={Contest^https://boca.icpcmexico.org}|{BOCA_User_Manual^https://directives.huronos.org/icpcmx/boca_manual_teams.en.html}|
Wallpaper=https://directives.huronos.org/icpcmx/gpmx2023_round1_contest_mode.png
WallpaperSha256=824d8560d35ec070589a5b72f2da85aff38203a7f6b1aee8bae7900c608d4369

[Event-Times]

[Contest-Times]
2023-05-13T13:40:00 2023-05-13T19:02:00
2023-05-27T10:50:00 2023-05-27T16:12:00
```