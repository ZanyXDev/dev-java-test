#!/bin/bash
docker run -it \
    --rm \
    -e DISPLAY \
    --net=host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $HOME/.Xauthority:/home/developer/.Xauthority \
    -v $HOME/.AndroidStudio2.2:/home/developer/.AndroidStudio2.2 \
    -v $HOME/AndroidStudioProjects:/home/developer/AndroidStuioProjects \
    -v $HOME/persistent_data:/home/developer/data \
    zanyxdev/dev-java-test:0.1
