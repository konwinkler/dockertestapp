#FROM runmymind/docker-android-sdk
#FROM frolvlad/alpine-bash

# based on https://medium.com/@elye.project/intro-to-docker-building-android-app-cb7fb1b97602
FROM openjdk:8
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=26 \
    ANDROID_BUILD_TOOLS_VERSION=26.0.2

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

ENV PATH="${ANDROID_HOME}/platform-tools:${PATH}"
ENV PATH="${ANDROID_HOME}/tools:${PATH}"
ENV PATH="${ANDROID_HOME}/tools/bin:${PATH}"

RUN $ANDROID_HOME/tools/bin/sdkmanager "system-images;android-25;google_apis;armeabi-v7a"
RUN echo "no" | $ANDROID_HOME/tools/bin/avdmanager create avd -n test2 -k "system-images;android-25;google_apis;armeabi-v7a"
RUN $ANDROID_HOME/tools/emulator -avd test2 -noaudio -no-boot-anim -no-window &

ADD . /dockertestapp
WORKDIR /dockertestapp


