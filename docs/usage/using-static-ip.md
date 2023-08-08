---
sidebar_position: 3
---
# About huronOS instance Static IP configuration
This feature allows you to assign each usb a static IP address, this way, you will not have to assign an IP address each time an instance has booted up if a DHCP server is not available/enabled. 

The current implementation is expected to work with too little issues, yet since testing is one of the things we lack the most, we're not sure on how smooth the use of this feature is going to be.

# How to use a static IP on an instance

To use static IP, you need to assign the instance ip address, ip gateway and network mask at the time of using the installer, for example `sudo ./install.sh -ia 192.168.1.2 -ig 192.168.1.254 -nm`

# Notes

- This feature only works on ethernet interfaces (since wifi connections are more likely to provides an IP, whereas this feature was born from the lack of dynamic ip leasing in one institution that uses HuronOS)

- If the computer has multiple network interfaces it will try on each available interface in no specific order until the configuration gets internet output through said interface, if it had no internet that interface would go back to dhcp

- If the network mask is different from the one

- If the static ip failed to be assigned to a network interface of the computer, everything would still be the same, that is, every interface would have dhcp enabled

# Troubleshooting

What would be good to add here?