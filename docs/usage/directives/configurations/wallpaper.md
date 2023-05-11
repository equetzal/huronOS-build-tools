# Wallpaper
The directives file can define which wallpaper will be used by the desktop environment while huronOS is at a selected execution mode.
The syntax is as follows:

```txt
Wallpaper=[ default | URL ]
```
Where `default` will fallback to the original huronOS wallpaper. While `URL` needs to be a network accessible image, it can be set with an IP address URL such as `http://192.168.1.32:80/wallpaper.png` or it can be set with a domain name such as `https://example.org/wallpaper.png`.

You need to be aware of the fact that the IP address of the server hosting this wallpaper will require huronOS to make an exception on the firewall to access said file. For this reason we recommend hosting the wallpaper in the same place as your directives file. In case you don't want to or are not able to, just remember that e.g. if your wallpaper is `https://raw.githubusercontent.com/someuser/somerepo/main/wallpaper.png` the contestants will have access to all of `raw.githubusercontent.com`, leading to potential code cheating during a contest.

## Wallpaper Hash
**All the wallpapers need to have the companion value `WallpaperSha256`**

If you setup a URL for the `Wallpaper` field, you will be needing to setup a `WallpaperSha256` too. This directive has its calculations done by using the `sha256sum` utility and works as a unique identifier for the wallpaper while also ensuring that the wallpaper is not corrupt.

## Wallpaper Image Type
The wallpapers need to be a file type supported by *Gnome*, but we recommend the `png` format.

## Example
Here is an example of a working wallpaper setup for your directives:
```ini
Wallpaper="https://directives.huronos.org/wallpaper1.png"
WallpaperSha256=a3cad61ee8e6ab0cce3b1b48338a36b60199c4adeb3ca7dd04802f37f6b6e8da
```
