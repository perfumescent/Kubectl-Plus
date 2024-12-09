#!/bin/bash
namespace=$1
sed -i "s/dev/${namespace}/g" *

cat autocomplete >> ~/.bashrc
source ~/.bashrc

cp l /usr/bin
chmod 755 /usr/bin/l
cp f /usr/bin
chmod 755 /usr/bin/f
cp into /usr/bin
chmod 755 /usr/bin/into
cp p /usr/bin
chmod 755 /usr/bin/p
