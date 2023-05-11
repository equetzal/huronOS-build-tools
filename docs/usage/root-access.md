---
sidebar_position: 2
---
# Accessing the root user

**-> Default `root` password is `toor`**

By default, the *contestant* user has no password, it is logged automatically on boot and that's the user designed for any contestant during any competition or event. But in some cases it's necessary to access the root user to solve certain issues.

## How to change the root password
We've worked hard on creating an easy way to change the root password, please check which method is best for you. 

### For a single installation
Add the following flag to the installer command line:
```bash
# `my_password` is your chosen password.
./install.sh --root-password my_password
```

### For multiple installations
Keep in mind that if you want to change the password for every latter installations you might create, instead of manually typing the password each time in the installer, you can follow the steps mentioned below:

1. Copy all the contents of the ISO somewhere where you have RW access, let's call this path `iso-data/`
2. Navigate to `iso-data/utils`
3. From there, execute
	```bash
	# 'my_password' is your password, replace it please.
	./change-password my_password
	```
	Be sure to change ***my_password*** with the password you want to set as the root password
4. You're all set. Every other installation you make will have the password you defined.
5. You can re-pack your changes with the `make-iso.sh` tool in case you want to easily move your custom build.
