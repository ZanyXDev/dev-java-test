# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.19
MAINTAINER ZanyXDev <zanyxdev@gmail.com>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

# set default java environment variable
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=111 \
    JAVA_HOME=/usr/lib/jvm/default-jvm \
PATH=${PATH}:/usr/lib/jvm/default-jvm/bin/


RUN DEBIAN_FRONTEND=noninteractive \
    dpkg --add-architecture i386 && \
    add-apt-repository ppa:openjdk-r/ppa -y &&\
    apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
	openjdk-8-jdk \
	sudo \
	git \
	unzip \
	wget \
#Need for ANdroid studio
	libxtst6:i386 \
	libc6:i386 \
	libstdc++6:i386 \
	libgcc1:i386 \
	libncurses5:i386 \
	libz1:i386 \

#Need for android emulator
	libqt5widgets5 && \

# fix default setting
ln -s java-8-openjdk-amd64 /usr/lib/jvm/default-jvm

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

#Installs Android Studio
ENV ANDROID_STUDIO_FILENAME android-studio-ide-145.3537739-linux.zip
ENV ANDROID_STUDIO_URL https://dl.google.com/dl/android/studio/ide-zips/2.2.3.0/${ANDROID_STUDIO_FILENAME}
ENV ANDROID_STUDIO_HOME /home/developer/android-studio

RUN mkdir -p ${ANDROID_STUDIO_HOME}  && \
    wget -q ${ANDROID_STUDIO_URL} && \
    unzip -q ${ANDROID_STUDIO_FILENAME} -d  /home/developer && \
    rm -f  ${ANDROID_STUDIO_FILENAME}&& \
    chown -R developer:developer ${ANDROID_STUDIO_HOME} 
# ------------------------------------------------------

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

# Make info file about this build
    printf "Build of zanyxdev/dev-java:openjdk-8-jdk, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /var/log/java_install
