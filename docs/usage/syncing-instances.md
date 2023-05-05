---
sidebar_position: 4
---
# Syncing Instances
So, how to sync every instance of HuronOS at the same time?, you might ask, the answer is using a directives file. Where to retrieve this file from is defined when a HuronOS usb is created, and that file is retrieved every minute for every HuronOS instance (although that might not happeen at the same time) so, if the directives file url is correctly configured and set on the usbs, every instance should be in sync with the directives file wherever that file is stored.


# Troubleshoot
### My directives do not sync
- Be sure your file is accessible from other machines.
- Check the instance you try to sync has internet available.
- Verify your expected directives file reflects the one that is retrieved from where you retrieve it.