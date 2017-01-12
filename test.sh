#!/bin/bash
USER=`whoami`

mkdir -p `pwd`/persistent_data/
chown -R $USER:$USER `pwd`/persistent_data/

docker run -ti \
    --privileged \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v `pwd`/persistent_data:/opt/persistent_data \
    dev-test

