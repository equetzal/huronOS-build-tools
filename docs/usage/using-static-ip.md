---
sidebar_position: 3
---
# Setting static IP
This feature is introduced as an experimental addition, designed to work exclusively with ethernet interfaces, allowing you to assign each USB device a static IP address. With this approach, the need to assign an IP address for each instance upon booting up is eliminated, particularly in cases where a DHCP server is unavailable or disabled.  

The current implementation is anticipated to function with minimal issues. However, due to limited testing, uncertainties surround the seamless utilization of this feature that might arise. 

If you encounter difficulties not addressed here, or if you have further questions, don't hesitate to seek assistance by mentioning the issue in [this GitHub issue](https://github.com/equetzal/huronOS-build-tools/issues/182). We value your feedback and are dedicated to enhancing the feature's usability and resilience.

## How to use a static IP on an instance

To use static IP, you need to assign the instance ip address, ip gateway and network mask at the time of using the installer, for example `sudo ./install.sh --instance-ip-address 192.168.1.2 --instance-ip-gateway 192.168.1.254 --instance-ip-mask`

## How it works
This feature works the following way
- The system will scan all the network interfaces and select the ethernet ones 
- On each ethernet interface in no specific order will try setting the static IP address with the configured data. 
- The first ethernet interface to set up link and access to the directives file will be the interface to be used by the system. 
- If no interface could be configured, then the system will set all interfaces to use DHCP instead.

## Troubleshooting

When setting up the system in various scenarios, sysadmins might encounter challenges that could impact the successful configuration of static IP addresses. Here are some common issues to consider along with possible solutions:

- **Incorrect Network Mask Configuration:** If the network mask is configured incorrectly, it can lead to connectivity issues. To resolve this, ensure that the network mask aligns with the intended IP address range. Double-check the subnet mask values during setup.

- **IP Address Conflict:** If the assigned static IP address is already in use on the network, conflicts can arise. If you experience connectivity problems, verify that the IP address you're assigning is available and not already assigned to another device. You might want to perform a network scan to identify active IP addresses.

- **Detecting Malformed or Invalid IP Addresses:** If an IP address is malformed or invalid, the system might not function as expected. Pay close attention to the IP format during setup and ensure it adheres to the standard IPv4 format (e.g., 192.168.1.2).

- **Missing Directives URL / Server IP:** Both the Directives URL and Server IP are crucial for proper configuration. If either of these is missing, the system won't have the necessary data to operate correctly. Ensure that you provide both the URL pointing to the configuration file and the IP address that should respond to pings.

- **Malformed Directives URL / Server IP:** If the provided Directives URL or Server IP is malformed or incorrectly formatted, the system won't be able to process them. Verify that both the URL and IP address are accurate and properly structured to avoid configuration issues.


These suggestions cover some common scenarios, but keep in mind that real-world situations can be diverse. As you work with the system, consider various use cases and potential pitfalls. Think beyond the development perspective to anticipate challenges that sysadmins might encounter in different environments.
