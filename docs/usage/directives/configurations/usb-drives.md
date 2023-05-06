# USB Drives Flag
huronOS allows you to control if the USB drives can be automounted or not. You can control this by using the `AllowUsbStorage` flag.

Setting the flag to:
```ini
AllowUsbStorage=true
```
Will allow the contestant to mount their portable USB drives to the system and copy content to and from the system.

Setting the flag to:
```ini
AllowUsbStorage=false
```
Will not allow the contestant user to mount any USB drive to the system. Note that USB peripheral devices are allowed such as mouses, or keyboards.

## Considerations
Note that if you switch from `AllowUsbStorage=true` to `AllowUsbStorage=false` during runtime or on a mode change, all processes using the disk will be killed and all the mounted drives will be forcefully unmounted. Be careful of setting this rule to not damage connect USB drives's filesystem.

## Post contest code-to-home for upsolving.
One of the best features of huronOS is that after a contest finishes, it can change it's modality from *contest* to *always* (default) and you can toggle the `AllowUsbStorage` from `false` during the contest to `true` on the always mode.  

By default, huronOS copy the contents of the `home/` directory of the contest to the current *home* on always mode. This directory have the format of `contest-datetime/` and this can enable contestants to copy their contest code to their USB drives, being a perfect solution for enforcing upsolving while not breaking the rules during the competition.
