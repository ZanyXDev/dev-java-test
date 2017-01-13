# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.19


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
    apt-get install -y -no-install-recommends openjdk-8-jdk \
	sudo \
	git \
	unzip \
#Need for ANdroid studio
	libxtst6:i386 \
	libc6:i386 \
	libstdc++6:i386 \
	libgcc1:i386 \
	libncurses5:i386 \
	libz1:i386 \

#Need for android emulator
	libqt5widgets5 && \

# Make info file about this build
    printf "Build of zanyxdev/dev-java:openjdk-8-jdk, date: %s\n"  `date -u +"%Y-%m-%dT%H:%M:%SZ"` > /etc/BUILDS/java && \

# fix default setting
ln -s java-8-openjdk-amd64 /usr/lib/jvm/default-jvm && \

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
