PACKAGES="apparmor budgie-desktop budgie-countdown-applet budgie-network-manager-applet dconf-cli eog gnome-calculator gnome-terminal libdrm-intel1 libgl1-mesa-dri libglib2.0-bin libglu1-mesa lightdm moka-icon-theme nautilus okular plank x11-utils xinit xinput xserver-xorg xserver-xorg-video-intel xterm"

set -x

## Install
apt update
apt install --yes --no-install-recommends $PACKAGES

## Delete debian lightdm configs
rm -rf /usr/share/lightdm/*
rm -rf /usr/share/images/desktop-base/*
rm /usr/share/xsessions/budgie-desktop.desktop

## Fix terminals not updating $PATH on su
echo "ALWAYS_SET_PATH	yes" >> /etc/login.defs

## Set huronOS lightdm configs
sed -i 's/#greeter-session=.*/greeter-session=lightdm-greeter/g' /etc/lightdm/lightdm.conf
sed -i 's/#greeter-hide-users=.*/greeter-hide-users=true/g' /etc/lightdm/lightdm.conf
sed -i 's/#session-wrapper=.*/session-wrapper=\/etc\/X11\/Xsession/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user=.*/autologin-user=contestant/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user-timeout=.*/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

## Set budgie background
mkdir -p /usr/share/backgrounds/
cp files/huronos-background.png /usr/share/backgrounds/huronos-background.png
cp files/huronos-lightdm.png /usr/share/backgrounds/huronos-lightdm.png
chmod 644 /usr/share/backgrounds/huronos*
echo "background=/usr/share/backgrounds/huronos-lightdm.png" >> /etc/lightdm/lightdm-gtk-greeter.conf

## Set budgie menu configs
cp files/huronOS-desktop-config.dump /tmp/huronOS-desktop-config.dump
chmod 777 /tmp/huronOS-desktop-config.dump
cp files/gnome-applications.menu /etc/xdg/menus/gnome-applications.menu
rm /usr/share/desktop-directories/* -rf
cp files/directories/* /usr/share/desktop-directories/

## Set .desktop launchers
mkdir -p /tmp/save/ 
cp /usr/share/applications/gnome-*-panel.desktop /tmp/save/
cp /usr/share/applications/budgie-*.desktop /tmp/save/
rm /usr/share/applications/*.desktop -f
cp files/applications/* /usr/share/applications/
cp /tmp/save/* /usr/share/applications/
rm -rf /tmp/save

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
sleep 10

## Launch lightdm to configure desktops
systemctl start lightdm.service
