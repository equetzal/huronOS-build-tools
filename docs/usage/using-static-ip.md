---
sidebar_position: 3
---
# Setting static IP
This feature is introduced as an experimental addition, designed to work exclusively with ethernet interfaces, allowing you to assign each USB device a static IP address. With this approach, the need to assign an IP address for each instance upon booting up is eliminated, particularly in cases where a DHCP server is unavailable or disabled.  

The current implementation is anticipated to function with minimal issues. However, due to limited testing, uncertainties surround the seamless utilization of this feature that might arise. 

If you encounter difficulties not addressed here, or if you have further questions, don't hesitate to seek assistance by mentioning the issue in [this GitHub issue](https://github.com/equetzal/huronOS-build-tools/issues/182). We value your feedback and are dedicated to enhancing the feature's usability and resilience.

## How to use a static IP on an instance

To use static IP, you need to assign the instance ip address, ip gateway and network mask:
- **During installation:**  
    At the time of using the installer, add the following flags `sudo ./install.sh --instance-ip-address 192.168.1.2 --instance-ip-gateway 192.168.1.254 --instance-ip-mask`; This will configure the system automatically with the data provided.

- **After installation:**
    To set or modify this configuration, connect the USB to modify to a booted computer and edit the file `huronOS/data/configs/sync-server.conf` to change the values of:
    ```ini
    [Server]
    INSTANCE_IP_ADDRESS=$INSTANCE_IP_ADDRESS
    INSTANCE_IP_MASK=$INSTANCE_IP_MASK
    INSTANCE_IP_GATEWAY=$INSTANCE_IP_GATEWAY
    ```
    Replace the content after the `=` with your configuration, e.g.
    ```ini
    [Server]
    INSTANCE_IP_ADDRESS=192.168.0.23
    INSTANCE_IP_MASK=255.255.255.0
    INSTANCE_IP_GATEWAY=192.168.0.1
    ```

## How it works
This feature works the following way
- The system will scan all the network interfaces and select the ethernet ones 
- On each ethernet interface in no specific order will try setting the static IP address with the configured data. 
- The first ethernet interface to set up link and get a successful ping to the gateway will be the interface to be used by the system. 
- If no interface could be configured, then the system will set all interfaces to use DHCP instead.

## Troubleshooting

When setting up the system in various scenarios, sysadmins might encounter challenges that could impact the successful configuration of static IP addresses. Here are some common issues to consider along with possible solutions:

- **Incorrect Network Mask Configuration:** If the network mask is configured incorrectly, it can lead to connectivity issues. To resolve this, ensure that the network mask aligns with the intended IP address range. Double-check the subnet mask values during setup.

- **Incorrect Gateway IP Configuration:** If the gateway IP address is configured incorrectly, the tool may not work since the ping to the gateway will fail leading to no ip assigned to any interface. To resolve this, ensure that the gateway IP is correct.

- **IP Address Conflict:** If the assigned static IP address is already in use on the network, conflicts can arise. If you experience connectivity problems, verify that the IP address you're assigning is available and not already assigned to another device. You might want to perform a network scan to identify active IP addresses.

- **Detecting Malformed or Invalid IP Addresses:** If an IP address is malformed or invalid, the system might not function as expected. Pay close attention to the IP format during setup and ensure it adheres to the standard IPv4 format (e.g., 192.168.1.2).

These suggestions cover some common scenarios, but keep in mind that real-world situations can be diverse. As you work with the system, consider various use cases and potential pitfalls. Think beyond the development perspective to anticipate challenges that sysadmins might encounter in different environments.
