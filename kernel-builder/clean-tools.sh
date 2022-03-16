

# Remove all installed tools used too compilation of kernel as they will not be used on final system
apt remove --yes $PACKAGES
apt autoremove --purge --yes
apt clean --yes
