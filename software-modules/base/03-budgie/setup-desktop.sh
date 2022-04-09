#!/bin/bash

## Launch plank to create its own config files
(plank > /dev/null 2>&1 &)

## Create locked plank apps
cp -r launchers/* ~/.config/plank/dock1/launchers/

## Setup autostart of plank
mkdir -p ~/.config/autostart/
cp -r autostart/* ~/.config/autostart/

## Load the menu bar configuration 
dconf load /com/solus-project/ < /tmp/huronOS-desktop-config.dump

## Background, Icons, Preferences
gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/huronos-background.png
gsettings set org.gnome.desktop.interface icon-theme 'Moka'
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.media-handling automount-open false