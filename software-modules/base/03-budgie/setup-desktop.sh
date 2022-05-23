#!/bin/bash

#	setup-desktop.sh
#	This script configures the user preferences stored on dbus.
#	It has to be run on the contestant user.

#	Author, the huronOS team:
#		Enya Quetzalli <equetzal@huronos.org>

set -xe

## Launch plank to create its own config files
(plank > /dev/null 2>&1 &)

## Config Plank
mkdir -p ~/.config/plank/dock1/launchers/
echo -e "[PlankDockItemPreferences]\nLauncher=file:///usr/share/applications/org.gnome.Terminal.desktop" > ~/.config/plank/dock1/launchers/org.gnome.Terminal.dockitem
echo -e "[PlankDockItemPreferences]\nLauncher=file:///usr/share/applications/nautilus.desktop" > ~/.config/plank/dock1/launchers/files.dockitem
dconf load /net/launchpad/plank/docks/ < /tmp/huronOS-plank-config.dump

## Setup autostart of plank
mkdir -p ~/.config/autostart/
cp -r files/autostart/* ~/.config/autostart/

## Load the menu bar configuration 
dconf load /com/solus-project/ < /tmp/huronOS-desktop-config.dump

## Background, Icons, Preferences
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/huronos-background.png
gsettings set org.gnome.desktop.interface icon-theme 'Moka'
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'

## Time and date
gsettings set org.gnome.desktop.interface clock-format '12h' 
gsettings set org.gnome.desktop.interface clock-show-seconds true 
gsettings set org.gnome.desktop.interface clock-show-date false
