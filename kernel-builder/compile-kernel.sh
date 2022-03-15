#!/bin/bash

#	compile-kernel.sh
#	Compile AUFS Kernel
#	Author: Enya Quetzalli <enya@quetza.ly>

make -j8 bzImage
make -j8 modules

