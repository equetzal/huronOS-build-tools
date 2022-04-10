PACKAGES="xserver-xorg xserver-xorg-video-intel xinit xterm xinput libdrm-intel1 libgl1-mesa-dri libglu1-mesa x11-utils lightdm apparmor budgie-desktop budgie-network-manager-applet moka-icon-theme plank nautilus gnome-terminal libglib2.0-bin dconf-cli okular gnome-calculator"

#### Missing PDF Viewer, Calculator

#set -x

## Install
apt update
apt install --yes --no-install-recommends $PACKAGES

## Remove non used moka-icons
#ICONS="atom vim codeblocks eclipse emacs geany accessories-calculator accessories-clipboard accessories-document-viewer accessories-text-editor intellij-idea sublime-text firefox gnome-software gnome-tweak-tool utilities-terminal utilities-system-monitor terminix byobu pycharm clion visual-studio-code libreoffice-base libreoffice-calc libreoffice-main libreoffice-math libreoffice-write system-lock-screen system-log-out system-restart system-run system-shutdown system-sleep system-suspend system-users calendar brave vivaldi opera"
#EXCLUDE="-name *.png"
#for ICON in $ICONS; do
#	EXCLUDE+=" -a -not -name *$ICON.png*"
#done
#find /usr/share/icons/Moka/ -type f $EXCLUDE -delete

## Copy user root files
pushd usrroot && cp --parents -afr * / && popd
cp huronOS-desktop-config.dump /tmp/huronOS-desktop-config.dump
chmod 777 /tmp/huronOS-desktop-config.dump

## Delete debian lightdm configs
rm -rf /usr/share/lightdm/*
rm -rf /usr/share/images/desktop-base/*
rm /usr/share/xsessions/budgie-desktop.desktop

## Set huronOS lightdm configs
sed -i 's/#greeter-session=.*/greeter-session=lightdm-greeter/g' /etc/lightdm/lightdm.conf
sed -i 's/#greeter-hide-users=.*/greeter-hide-users=true/g' /etc/lightdm/lightdm.conf
sed -i 's/#session-wrapper=.*/session-wrapper=\/etc\/X11\/Xsession/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user=.*/autologin-user=contestant/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user-timeout=.*/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

chmod 644 /usr/share/backgrounds/huronos*
echo "background=/usr/share/backgrounds/huronos-lightdm.png" >> /etc/lightdm/lightdm-gtk-greeter.conf
## Set Budgie as default desktop
sed -i 's/Name=.*/Name=Budgie/g' /usr/share/xsessions/lightdm-xsession.desktop
sed -i 's/Exec=.*/Exec=budgie-desktop/g' /usr/share/xsessions/lightdm-xsession.desktop
echo "DesktopNames=Budgie;GNOME" >> /usr/share/xsessions/lightdm-xsession-desktop

## Create user for contest with no password for login
useradd -m -s /bin/bash contestant
sed -i 's/contestant:x:/contestant::/g' /etc/passwd

## Activate lightdm
systemctl enable lightdm.service

echo "Please run setup-desktop.sh on each user will have the contestant user interface"
sleep 3

## Launch lightdm to configure desktops
systemctl start lightdm.service

## Configure Menu Launcher of /usr/share/applications/*
	## Basic Tools

## Configure Menu Directories on /usr/share/desktop-directories and /etc/xdg/menus/gnome-applications.menu