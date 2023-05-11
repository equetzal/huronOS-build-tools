---
sidebar_position: 4
---
# Syncing Instances
So, how to sync every instance of HuronOS at the same time?, you might ask. The answer is: using a directives file. Where to retrieve this file from is defined when a HuronOS usb is created, and that file is retrieved every minute for every HuronOS instance (although that might not happen at the same time) so, if the directives file url is correctly configured and set on the usbs, every instance should be in sync with the directives file wherever that file is stored.


# Troubleshoot
### My directives do not sync
- Be sure your file is accessible from other machines.
- Verify the instance you're trying to sync has an internet connection available.
- Verify that your expected directives file reflects the one stored at your server.