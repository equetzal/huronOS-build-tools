---
sidebar_position: 4
---
# Syncing Instances

**Remote syncing** is one of the flagship features of huronOS, allowing you to synchronize preferences, configurations, and behavior directives with **several huronOS instances** (running installations of huronOS) using something we call *the directives file*. This is a plain text file with a specific syntax known as *huronOS Directives File Syntax*, resulting in a *.hdf* file.

To sync an instance, you need to specify a directives file URL that can be accessed via HTTP or HTTPS. This URL can be a domain name or an IP address. The huronOS **sync manager** polls this file every minute, comparing it to the local version. If any changes are detected, the sync manager processes them and triggers the necessary updates to align the system with the new rules. Be aware you can expect up to 2 minutes from the edition to the full propagation.

To prevent firewall issues, the IP address of the specified directives file URL is added to the exceptions list when the firewall is set to *DROP* mode. If the directives' URL contains a domain name instead of an IP address, the system relies on the DNS system to resolve the domain to all IP addresses hosting that domain.

> **WARNING:**   
> Please be aware that if your DHCP-provided DNS server fails, the system may enter a *softlock* state when using the firewall in *DROP* mode, as it will block all connectivity, including access to the directives file's server. To avoid this, it is recommended to add a *directives server IP* to bypass the need for DNS resolution and ensure that the directives' server remains accessible for system synchronization.

For detailed guidelines on hosting your directives file appropriately, please refer to our [directives server doc](./directives/directives-server.md).

## Configuring the Directives URL

During the **huronOS' installation**, you will be prompted to specify the directives URL. Please **carefully** follow the instructions in our [installation guide](./how-to-install.md). It is advisable to prepare your directives file before installing huronOS to streamline contest preparation. Alternatively, you can choose not to specify a directives URL, in which case the system will utilize the default directives. You can always change the URL later.

### Changing the URL of an Installed Instance

The directives file URL is stored in a file called `sync-server.conf`, which is created during the system installation. Contestants using a running huronOS instance **cannot directly access this file** unless they switch to the *root* user (so please, take care of the password). The file is located at `/run/initramfs/memory/system/huronOS/data/config/sync-server.conf`. Its content will appear as follows:

```ini
[Server]
IP=
DOMAIN=
DIRECTIVES_ENDPOINT=
SERVER_ROOM=
DIRECTIVES_FILE_URL=https://somerandomurl.internet/directives.hdf
DIRECTIVES_SERVER_IP=300.300.300.300
```

Please refrain from modifying variables other than `DIRECTIVES_FILE_URL` and `DIRECTIVES_SERVER_IP`, as they are still experimental features. Adjust these variables according to your specific requirements.

## Troubleshooting Sync Problems

Most issues related to synchronization are typically attributed to internet connectivity and firewall settings. Follow these troubleshooting steps:

1. Ensure that your computer is physically connected and has an active internet connection. Verify the network status using the connman applet in the tray to confirm a stable link.

2. Check connectivity with your directives server by pinging it to ensure it is reachable within your network.

3. Confirm that the directives server functions as a web server with open *http* (port 80) and *https* (port 443) protocols. Download the directives file to verify its accessibility, for example: `wget https://directives.huronos.org/testing/directives.hdf`.

4. If you encounter firewall issues, refer to our [requirements](../start/requirements.md) documentation and ensure that all the stated rules are properly configured. Pay particular attention to NTP requirements when not using the directives' default mode.

5. For troubleshooting sync manager issues, consult the human-readable logs found in the `/var/log/hsync.log` file.

6. If the problem persists, please notify us via a GitHub Issue. Attach a copy of the journal by running the following commands:


```bash
echo "HSYNC" > sync.log
journalctl -u hsync.service >> sync.log
echo "HAPPLY" >> sync.log
journalctl -u happly.service >> sync.log
```

Upload the `sync.log` file and provide detailed documentation of the problem on GitHub.
