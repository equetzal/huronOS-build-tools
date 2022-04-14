#!/bin/sh

mkdir -p /usr/share/doc/ruby-documentation
cp -r ./documentation/* /usr/share/doc/ruby-documentation/

cp ./ruby-documentation.desktop /usr/share/applications/

savechanges /media/sdb1/huronOS/langs/ruby.hsm
