FROM zanyxdev/dev-java-tools:latest

RUN apt-get update && apt-get install -y sudo git apt-utils unzip

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer


# ------------------------------------------------------
# --- Download Android SDK tools into $ANDROID_HOME
ENV PERSISTENT_DATA /opt/persistent_data

#RUN mkdir -p ${PERSISTENT_DATA} && dpkg --get-selections > ${PERSISTENT_DATA}/package.list

# Installs Android SDK
#ENV ANDROID_SDK_FILENAME tools_r25.2.3-linux.zip
#ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILENAME}
#ENV ANDROID_API_LEVELS android-15,android-16,android-17,android-18,android-19,android-20,android-21 
#ENV ANDROID_BUILD_TOOLS_VERSION 21.1.0
#ENV ANDROID_HOME /home/developer/android-sdk-linux
#ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

#RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
#     wget -c ${ANDROID_SDK_URL} && \
#     unzip -q ${ANDROID_SDK_FILENAME} && \
#     rm ${ANDROID_SDK_FILENAME}
#RUN mv tools ${ANDROID_HOME}/tools
#RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) \
#    | android update sdk --no-ui --filter platform-tool ${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} --no-https

RUN chown -R developer:developer ${ANDROID_HOME} 

#Installs Android Studio
ENV ANDROID_STUDIO_FILENAME android-studio-ide-145.3537739-linux.zip
ENV ANDROID_STUDIO_URL https://dl.google.com/dl/android/studio/ide-zips/2.2.3.0/${ANDROID_STUDIO_FILENAME}
ENV ANDROID_STUDIO_HOME /home/developer/android-studio

RUN mkdir -p ${ANDROID_STUDIO_HOME} && cd ${ANDROID_STUDIO_HOME} && \ 
    wget -q ${ANDROID_STUDIO_URL} && \
    unzip -q ${ANDROID_STUDIO_FILENAME} && \
    rm -f  ${ANDROID_STUDIO_FILENAME}
#RUN mv android-studio ${ANDROID_STUDIO_HOME}
RUN chown -R developer:developer ${ANDROID_STUDIO_HOME} 

# ------------------------------------------------------


ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
USER developer
ENV HOME /home/developer
#CMD ${ANDROID_STUDIO_HOME}/bin/studio.sh
CMD /bin/bash