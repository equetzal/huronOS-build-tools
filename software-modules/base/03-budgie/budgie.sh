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

PACKAGES="apparmor budgie-desktop budgie-desktop-view budgie-countdown-applet budgie-extras-daemon connman-gtk dconf-cli eog gnome-calculator gnome-calendar gnome-terminal gnome-themes-extra libdrm-intel1 libgl1-mesa-dri libglib2.0-bin libglu1-mesa lightdm moka-icon-theme nautilus nautilus-extension-gnome-terminal okular plank x11-xserver-utils x11-utils xdg-user-dirs xinit xinput xserver-xorg xserver-xorg-input-all xserver-xorg-video-amdgpu xserver-xorg-video-ati xserver-xorg-video-intel xserver-xorg-video-nvidia xserver-xorg-video-radeon xserver-xorg-video-vesa xterm"

## Install
apt update
# shellcheck disable=SC2086
apt install --yes --no-install-recommends $PACKAGES

## Delete debian lightdm configs
rm -rf /usr/share/lightdm/*
rm -rf /usr/share/images/desktop-base/*
rm /usr/share/xsessions/budgie-desktop.desktop

## Replace debian logo branding with huronOS
rm -rf /usr/share/wallpapers/
rm -rf /usr/share/icons/desktop-base/*
rm -rf /usr/share/desktop-base/
rm -rf /usr/share/plymouth/
rm -rf /usr/share/pixmaps/debian*
cp -rf files/vendor/* /usr/share/icons/desktop-base
ln -sf /usr/share/icons/desktop-base/scalable/emblems/emblem-huronos.svg /etc/alternatives/emblem-vendor-scalable
ln -sf /usr/share/icons/desktop-base/scalable/emblems/emblem-huronos-symbolic.svg /etc/alternatives/emblem-vendor-symbolic-scalable
ln -sf /usr/share/icons/desktop-base/scalable/emblems/emblem-huronos-white.svg /etc/alternatives/emblem-vendor-white-scalable
ln -sf /usr/share/icons/desktop-base/64/emblems/emblem-huronos.png /etc/alternatives/emblem-vendor-64
ln -sf /usr/share/icons/desktop-base/64/emblems/emblem-huronos-symbolic.png /etc/alternatives/emblem-vendor-symbolic-64
ln -sf /usr/share/icons/desktop-base/64/emblems/emblem-huronos-white.png /etc/alternatives/emblem-vendor-white-64
ln -sf /usr/share/icons/desktop-base/128/emblems/emblem-huronos.png /etc/alternatives/emblem-vendor-128
ln -sf /usr/share/icons/desktop-base/128/emblems/emblem-huronos-symbolic.png /etc/alternatives/emblem-vendor-symbolic-128
ln -sf /usr/share/icons/desktop-base/128/emblems/emblem-huronos-white.png /etc/alternatives/emblem-vendor-white-128
ln -sf /usr/share/icons/desktop-base/256/emblems/emblem-huronos.png /etc/alternatives/emblem-vendor-256
ln -sf /usr/share/icons/desktop-base/256/emblems/emblem-huronos-symbolic.png /etc/alternatives/emblem-vendor-symbolic-256
ln -sf /usr/share/icons/desktop-base/256/emblems/emblem-huronos-white.png /etc/alternatives/emblem-vendor-white-256

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
rfkill unblock bluetooth

## Set .desktop launchers
mkdir -p /tmp/save/
cp files/nano.svg /usr/share/icons/hicolor/scalable/apps/
cp /usr/share/applications/gnome-*-panel.desktop /tmp/save/
cp /usr/share/applications/budgie-*.desktop /tmp/save/
cp /usr/share/applications/gnome-control-center.desktop /tmp/save/
cp /usr/share/applications/org.gnome.Calendar.desktop /tmp/save/
cp /usr/share/applications/org.gnome.Nautilus.desktop /tmp/save/
cp /usr/share/applications/org.gnome.Terminal.desktop /tmp/save/
rm /usr/share/applications/*.desktop -f
cp files/applications/* /usr/share/applications/
cp /tmp/save/* /usr/share/applications/
rm -rf /tmp/save

## Replace nm-applet with connman-gtk
sed -i 's/Exec=.*$/Exec=connman-gtk --tray/g' /etc/xdg/autostart/budgie-desktop-nm-applet.desktop
sed -i 's/TryExec=.*$/TryExec=connman-gtk/g' /etc/xdg/autostart/budgie-desktop-nm-applet.desktop
mv /etc/xdg/autostart/budgie-desktop-nm-applet.desktop /etc/xdg/autostart/budgie-desktop-connman-applet.desktop

## Add our own default mime apps
rm -rf /usr/share/applications/gnome-mimeapps.list
ln -s /etc/xdg/mimeapps.list /usr/share/applications/mimeapps.list

## Set Budgie as default desktop
sed -i 's/Name=.*/Name=Budgie/g' /usr/share/xsessions/lightdm-xsession.desktop
sed -i 's/Exec=.*/Exec=budgie-desktop/g' /usr/share/xsessions/lightdm-xsession.desktop
echo "DesktopNames=Budgie;GNOME" >> /usr/share/xsessions/lightdm-xsession-desktop

## Set default dconf settings
cp files/huronOS-plank-config.dump /tmp/huronOS-plank-config.dump
chmod 777 /tmp/huronOS-plank-config.dump
mkdir -p /etc/dconf/
cp -rf files/dconf/* /etc/dconf/
chmod -R 755 /etc/dconf/
dconf update

## Create user for contest with no password for login
useradd -m -s /bin/bash contestant
sed -i 's/contestant:x:/contestant::/g' /etc/passwd
mkdir -p /home/contestant/.config/JetBrains
chown -R contestant:contestant /home/contestant/

## Activate services
rm -f "/usr/lib/systemd/system/lightdm.service"
cp -f "files/lightdm.service" "/lib/systemd/system/lightdm.service"

chmod 0644 "/lib/systemd/system/lightdm.service"

## Deactivate unwanted services
systemctl stop udisks2.service # Will be managed by hmount
systemctl stop NetworkManager.service # Already managed with connman, and we don't want to depend on GUI
systemctl stop NetworkManager-dispatcher.service
systemctl stop NetworkManager-wait-online.service
systemctl mask udisks2.service # Will be managed by hmount
systemctl mask NetworkManager.service # Already managed with connman, and we don't want to depend on GUI
systemctl mask NetworkManager-dispatcher.service
systemctl mask NetworkManager-wait-online.service
rm /usr/lib/udev/rules.d/*udisks2*.rules

systemctl daemon-reload
systemctl enable lightdm.service
systemctl enable hsync.timer

## Set default resolution for VGA unknown displays
#cp -f "files/10-unknown.conf" "/usr/share/X11/xorg.conf.d/10-unknown.conf"

echo "Please run setup-desktop.sh on each user will have the contestant user interface"
sleep 10

## Launch lightdm to configure desktops
systemctl start lightdm.service
