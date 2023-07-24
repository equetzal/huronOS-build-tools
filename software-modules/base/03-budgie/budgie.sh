#!/bin/bash

#	budgie.sh
#	Script to build the budgie huronOS System Layer (.hsl)
#	for huronOS image. It install, and configures the graphical
#	enviroment designed for competitive programming along with the
#	activation of the huronOS contest system subsistems.
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>

set -xe

# Get the dependencies and replace every new line with a space
mapfile -t DEPENDENCIES <dependencies.txt

## Install
apt update

apt install --yes --no-install-recommends "${DEPENDENCIES[@]}"

## Delete debian lightdm configs
rm -rf /usr/share/lightdm/*
rm -rf /usr/share/images/desktop-base/*
rm /usr/share/xsessions/budgie-desktop.desktop

## Fix terminals not updating $PATH on su
echo "ALWAYS_SET_PATH	yes" >>/etc/login.defs

## Set huronOS lightdm configs
sed -i 's/#greeter-session=.*/greeter-session=lightdm-greeter/g' /etc/lightdm/lightdm.conf
sed -i 's/#greeter-hide-users=.*/greeter-hide-users=true/g' /etc/lightdm/lightdm.conf
sed -i 's/#session-wrapper=.*/session-wrapper=\/etc\/X11\/Xsession/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user=.*/autologin-user=contestant/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-user-timeout=.*/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

## Set budgie background
cp files/huronos-background.png /usr/share/backgrounds/budgie/default.jpg
cp files/huronos-lightdm.png /usr/share/backgrounds/huronos-lightdm.png
chmod 644 /usr/share/backgrounds/huronos*
echo "background=/usr/share/backgrounds/huronos-lightdm.png" >>/etc/lightdm/lightdm-gtk-greeter.conf

## Prepare budgie menu configs
cp files/huronOS-desktop-config.dump /tmp/huronOS-desktop-config.dump
chmod 777 /tmp/huronOS-desktop-config.dump
## This section below doesn't work
#cp files/gnome-applications.menu /etc/xdg/menus/gnome-applications.menu
#rm /usr/share/desktop-directories/* -rf
#mkdir -p /usr/share/desktop-directories
#cp files/directories/* /usr/share/desktop-directories/
rfkill unblock bluetooth

## Set .desktop launchers
mkdir -p /tmp/save/
cp files/nano.svg /usr/share/icons/hicolor/scalable/apps/
cp /usr/share/applications/budgie-*-panel.desktop /tmp/save/
cp /usr/share/applications/org.buddiesofbudgie.*.desktop /tmp/save/
cp /usr/share/applications/budgie-control-center.desktop /tmp/save/
cp /usr/share/applications/org.gnome.Calendar.desktop /tmp/save/
cp /usr/share/applications/org.gnome.Nautilus.desktop /tmp/save/
cp /usr/share/applications/org.gnome.Terminal.desktop /tmp/save/
rm /usr/share/applications/*.desktop -f
cp files/applications/* /usr/share/applications/
cp /tmp/save/* /usr/share/applications/
rm -rf /tmp/save

## Replace nm-applet with connman-gtk
sed -i 's/Exec=.*$/Exec=connman-gtk --tray/g' /etc/xdg/autostart/org.buddiesofbudgie.BudgieDesktopNmApplet.desktop
sed -i 's/TryExec=.*$/TryExec=connman-gtk/g' /etc/xdg/autostart/org.buddiesofbudgie.BudgieDesktopNmApplet.desktop
mv /etc/xdg/autostart/org.buddiesofbudgie.BudgieDesktopNmApplet.desktop /etc/xdg/autostart/budgie-desktop-connman-applet.desktop
rm -f /etc/xdg/autostart/nm-applet.desktop

## Add our own default mime apps
rm -rf /usr/share/applications/gnome-mimeapps.list
ln -s /etc/xdg/mimeapps.list /usr/share/applications/mimeapps.list

## Set Budgie as default desktop
sed -i 's|Name=.*|Name=Budgie|g' /usr/share/xsessions/lightdm-xsession.desktop
sed -i 's|Exec=.*|Exec=/usr/bin/budgie-desktop|g' /usr/share/xsessions/lightdm-xsession.desktop
echo "DesktopNames=Budgie;GNOME" >>/usr/share/xsessions/lightdm-xsession.desktop

## Prepare plank settings
cp files/huronOS-plank-config.dump /tmp/huronOS-plank-config.dump
chmod 777 /tmp/huronOS-plank-config.dump

## Create user for contest with no password for login
useradd -m -s /bin/bash contestant
sed -i 's/contestant:x:/contestant::/g' /etc/passwd
chown -R contestant:contestant /home/contestant/

## Activate services
rm -f "/usr/lib/systemd/system/lightdm.service"
cp -f "files/lightdm.service" "/lib/systemd/system/lightdm.service"

chmod 0644 "/lib/systemd/system/lightdm.service"

## Deactivate unwanted services
systemctl stop udisks2.service        # Will be managed by hmount
systemctl stop NetworkManager.service # Already managed with connman, and we don't want to depend on GUI
systemctl stop NetworkManager-dispatcher.service
systemctl stop NetworkManager-wait-online.service
systemctl mask udisks2.service        # Will be managed by hmount
systemctl mask NetworkManager.service # Already managed with connman, and we don't want to depend on GUI
systemctl mask NetworkManager-dispatcher.service
systemctl mask NetworkManager-wait-online.service
rm /usr/lib/udev/rules.d/*udisks2*.rules

## Compile schemas to include connman-gtk
glib-compile-schemas /usr/share/glib-2.0/schemas/
systemctl daemon-reload
systemctl enable lightdm.service
systemctl start hsync.timer

## Copy plank resolution monitor
cp -f "files/plankrm" "/usr/local/bin/plankrm"
chmod +x "/usr/local/bin/plankrm"

# Copy autostart files
cp -f setup-desktop.sh /tmp/setup-desktop.sh
mkdir -p /tmp/files/autostart
cp -f -r files/autostart/* /tmp/files/autostart

echo "Please run /tmp/setup-desktop.sh on each user will have the contestant user interface"
sleep 10

## Launch lightdm to configure desktops
systemctl start lightdm.service
