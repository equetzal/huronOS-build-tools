# Add VSCode extensions in HuronOS
So, you want to add a vscode extension to the huronOS, follow this guide and you'll succeed

## 1) Getting the extension folder
For this you have two ways

1) From the app
    - Download the extension from the vscode app
    - Locate the extension folder in the following path
        ```
        # Vscode
        ~/.vscode/extensions
        # Vscodium
        ~/./vscode-oss/extensions
        ```

2) From the extensions marketplace
    - Download the .vsix of the extension
    - Unpackage the extension
    - Rename the "extension" folder to the name of the extension

## Create the module
Now with the folder located and assumming
- you're on an HuronOS instance
- or you have access to the dir2hsm script
- and the extension is located in the current path

execute the following commands:


```
# Replace "my_extension" with the name you want to identify the extension
# Using `codium` bc under the hood huronOS uses vscodium
$ mkdir -p my_extension.hsm/usr/share/codium/resources/app/extensions/
$ mv my_extension my_extension.hsm/usr/share/codium/resources/app/extensions/
$ mksquashfs my_extension.hsm/ my_extension.hsm
```
And that should be it, move the new **my_extension.hsm** to the ***huronOS/software/vscode-extensions/*** path of either an HuronOS usb / the HuronOS instalation files.

## Note
Using this method the extensions are loaded into vscode as builtin extensions instead of user ones, thus, if you open the extensions panel the extension wouldn't appear by default, but you should be able to locate the extension by typing
```
@builtin my_extension
```