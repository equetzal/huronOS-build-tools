#!/bin/bash

## Launch plank to create its own config files
(plank > /dev/null 2>&1 &)

## Config Plank
cp files/huronOS-plank-config.dump /tmp/huronOS-plank-config.dump
chmod 777 /tmp/huronOS-plank-config.dump
mkdir -p ~/.config/plank/dock1/launchers/
echo -e "[PlankDockItemPreferences]\nLauncher=file:///usr/share/applications/gnome-terminal.desktop" > ~/.config/plank/dock1/launchers/terminal.dockitem
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

## Time and date
gsettings set org.gnome.desktop.interface clock-format '12h' 
gsettings set org.gnome.desktop.interface clock-show-date false