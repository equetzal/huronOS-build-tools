#!/bin/bash

declare "$(head -n 1 ./create.sh)"

for PKG in $PACKAGES; do
	apt -s install $PKG | tee dependencies/$PKG.log
done