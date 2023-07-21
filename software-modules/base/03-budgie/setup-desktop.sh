#!/bin/bash

#	setup-desktop.sh
#	Script that configures the user default user preferences
#	for the graphical enviroment.
#	It has to be run on the contestant user
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Enya Quetzalli <equetzal@huronos.org>
#		Daniel Cerna <equetzal@huronos.org>

set -xe

## Setup autostart of plank & systembus-notifications
mkdir -p ~/.config/autostart/
cp -r /tmp/files/autostart/* ~/.config/autostart/
## Launch plank (from the monitor script) to create its own config files
(plankrm >/dev/null 2>&1 &)

## Config Plank
mkdir -p ~/.config/plank/dock1/launchers/
echo -e "[PlankDockItemPreferences]\nLauncher=file:///usr/share/applications/org.gnome.Terminal.desktop" >~/.config/plank/dock1/launchers/org.gnome.Terminal.dockitem
echo -e "[PlankDockItemPreferences]\nLauncher=file:///usr/share/applications/org.gnome.Nautilus.desktop" >~/.config/plank/dock1/launchers/org.gnome.Nautilus.dockitem
dconf load /net/launchpad/plank/docks/ </tmp/huronOS-plank-config.dump

## Load the budgie configuration
dconf load / </tmp/huronOS-desktop-config.dump

## Restart budgie to reflect dconf changes
budgie-panel --replace &
