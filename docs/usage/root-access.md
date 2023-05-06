---
sidebar_position: 2
---
# Accessing the root user

**-> Default `root` password is `toor`**

By default, the *contestant* user has no password, it is logged automatically on boot and it is the user designed for any contestant during any contest or event. But in certain cases it's necessary to access the root user to solve certain issues.

## How to change the root password
We've worked hard for brining an easy to change root password, please check which method better fits for you. 

### For a single installation
For installing huronOS, execute:
```bash
# `my_password` is your chosen password.
./install.sh --root-password my_password
```

### For multiple installations
Keep in mind that if you want to change the password for every latter installations that you might create, instead of manually passing the password each time in the installer, follow the steps mentioned below

1. Copy all the contents of the ISO somewhere where you have RW access, let's call this path `iso-data/`
2. Navigate to `iso-data/utils`
3. From there execute
	```bash
	# 'my_password' is your password, replace it please.
	./change-password my_password
	```
	Be sure to change ***my_password*** with the password that you want to set as the root password
4. You're all set. Every other installation you make will have the password you defined.
5. You can re-pack your changes with the `make-iso.sh` tool in case you want to easily move your custom build.
