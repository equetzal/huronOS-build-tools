# Wallpaper
The directives file can define what wallpaper will be used by the desktop environment while huronOS is a selected execution mode.
The syntax is as follows:

```txt
Wallpaper=[ default | URL ]
```
Where `default` will fallback to the original huronOS wallpaper. While `URL` needs to be a network accessible image, it can be set with an IP address URL such as `http://192.168.1.32:80/wallpaper.png` or it can be set with a domain name such as `https://example.org/wallpaper.png`.

You need to be aware and the IP address of the server hosting this wallpaper will require huronOS to make an exception on the firewall to access the file. For this reason we do recommend hosting the wallpaper in the same place as your directives file. In case you don't want to follow, just remember that e.g. if you wallpaper is `https://raw.githubusercontent.com/someuser/somerepo/main/wallpaper.png` the contestants will have access to all `raw.githubusercontent.com`, leading to potential code cheating during a contest.

## Wallpaper Hash
**All the wallpapers needs to have the companion value `WallpaperSha256`**

If you setup a URL for the `Wallpaper` field, you will be needing to setup a `WallpaperSha256` too. This has it's calculated using the `sha256sum` utility and works as a unique identifier of the wallpaper while also ensuring that the wallpaper is not corrupt.

## Wallpaper Image Type
The wallpapers needs to be a file type supported by *Gnome*, but we to recommend the `png` format.

## Example
Here is an example of a working wallpaper setup for your directives:
```ini
Wallpaper="https://directives.huronos.org/wallpaper1.png"
WallpaperSha256=a3cad61ee8e6ab0cce3b1b48338a36b60199c4adeb3ca7dd04802f37f6b6e8da
```
