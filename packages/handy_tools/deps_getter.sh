#!/bin/bash

## Simulate the installation of the specified packages
## and get the required dependencies.
## Also get stderr in a file just in case
ERR_TEMP_FILE=$(mktemp)
DEPENDENCIES=$(apt install -s "$@" 2>"$ERR_TEMP_FILE" | sed -n -r '
    # Work only between "The following NEW"
    # and the counting of packages to update, install, remove, etc.
	/The following NEW/,/[0-9]+ upgraded/ {
        /The following NEW/n # Skip printing the first line
        /[0-9]+ upgraded/q # Skip last line being printed by quiting sed
        s/ *([-.+a-z0-9]+) /\1\n/gp # If a package name is matched, print it
	}')
## Remove the requested packages from the dependencies
for PACKAGE in "$@"; do
    DEPENDENCIES=$(echo "$DEPENDENCIES" | sed "/^$PACKAGE$/ d")
done

ERROR=$(sed -e 's/WARNING: apt does not have a stable CLI interface. Use with caution in scripts.//' -e '/^$/d' < "$ERR_TEMP_FILE")
if [ -n "$ERROR" ]; then
    echo "Error:"
    echo "$ERROR"
fi

## Print the final dependencies list
if [ -z "$DEPENDENCIES" ]; then
    echo "No dependencies found,"
    echo "either the package is already installed"
    echo "or it does not exists"
fi
echo "$DEPENDENCIES"