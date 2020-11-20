FROM ubuntu

ENV JAVA_HOME=/opt/android-studio/jre
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT="${ANDROID_HOME}"
ENV PATH="${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y \
        supervisor \
        libxext6 libxrender1 libxtst6 libfreetype6 libxi6 \
        python3 python3-pip \
        build-essential curl htop iftop less tree unzip vim wget \
    && apt-get clean

RUN pip3 install projector-installer \
    --upgrade \
    --trusted-host pypi.org \
    --trusted-host pypi.python.org \
    --trusted-host files.pythonhosted.org

RUN wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.2.0.16/android-studio-ide-202.6939830-linux.tar.gz \
    && tar -xvf android-studio-ide-202.6939830-linux.tar.gz -C /opt/ \
    && rm -rvf android-studio-ide-202.6939830-linux.tar.gz

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip \
    && unzip -d /opt/ commandlinetools-linux-6858069_latest.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && mv /opt/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm -rvf commandlinetools-linux-6858069_latest.zip

RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "build-tools;30.0.2" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "emulator" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "extras;android;m2repository" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "patcher;v4" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platform-tools" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platforms;android-30" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "sources;android-30" \
    && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "system-images;android-30;google_apis;x86_64"

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD [ "/usr/bin/supervisord" ]
