#!/bin/bash
USER=`whoami`

mkdir -p ~/persistent_data/
chown -R $USER:$USER ~/persistent_data/

XAUTH=~/persistent_data/.docker.xauth
echo "Building $XAUTH"
touch $XAUTH
xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run -ti \
    --privileged \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -e XAUTHORITY=$XAUTH \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v ~/persistent_data:/opt/persistent_data \
    -v ~/.android-studio-docker:/home/developer/.AndroidStudio2.2 \
    dev-test
