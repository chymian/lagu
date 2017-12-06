#!/bin/bash

# initialise lagu-rig software

BASEDIR="$HOME/lagu"

echo "PATH=\$PATH:$BASEDIR/bin" >> ~/.profile

# create initial configs
cd $BASEDIR
cp templates/local.conf .
cp templates/remote.conf .


# enable mining watchdog
cd $BASEDIR/bin
chmod +x *

./mining enable

exit 0
