# Inspired by: https://blog.devops.dev/developing-flutter-applications-inside-a-devcontainer-4b13de5369e2

# --- Builder Stage ---
FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_SDK_ROOT=/android-sdk
ENV FLUTTER_SDK_ROOT=/flutter

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
       curl wget unzip xz-utils ca-certificates openjdk-17-jdk git \
    && rm -rf /var/lib/apt/lists/*

# Download and install Android Command Line Tools + components
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && wget -O /tmp/commandlinetools.zip "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
    && unzip -q /tmp/commandlinetools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm /tmp/commandlinetools.zip

ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${PATH}

# Accept licenses and install SDK components
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" \
                  "platforms;android-35" \
                  "platforms;android-34" \
                  "build-tools;35.0.0" \
                  "build-tools;34.0.0" \
                  "cmake;3.22.1" \
                  "ndk;26.3.11579264"

# Flutter SDK (clone only; do not run flutter as root)
RUN git clone -b stable --depth 1 --filter=blob:none https://github.com/flutter/flutter.git "${FLUTTER_SDK_ROOT}"

# --- Final Stage ---
FROM mcr.microsoft.com/devcontainers/base:debian-12 AS final

ARG USERNAME=vscode
ARG HOME=/home/${USERNAME}
ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_SDK_ROOT=${HOME}/android-sdk
ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV FLUTTER_SDK_ROOT=${HOME}/flutter
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${FLUTTER_SDK_ROOT}/bin:${PATH}

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
       curl git unzip xz-utils zip ca-certificates \
       openjdk-17-jdk libstdc++6 libglu1-mesa sudo \
       chromium \
       clang cmake ninja-build pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Dev Containers base already provides 'vscode' user
USER ${USERNAME}

# Copy SDKs from builder stage into the user home
COPY --from=builder --chown=${USERNAME}:${USERNAME} /android-sdk ${ANDROID_SDK_ROOT}
COPY --from=builder --chown=${USERNAME}:${USERNAME} /flutter ${FLUTTER_SDK_ROOT}

# Configure Flutter to use the Android SDK and warm caches (non-fatal)
RUN flutter config --android-sdk "${ANDROID_SDK_ROOT}" \
    && flutter precache --android \
    && flutter doctor -v || true

# Ensure the mounted ~/.bashrc.extra is sourced on every shell (idempotent)
RUN bash -lc 'FILE="$HOME/.bashrc"; \
  touch "$FILE"; \
  grep -qxF "[[ -f ~/.bashrc.extra ]] && source ~/.bashrc.extra" "$FILE" \
  || echo "[[ -f ~/.bashrc.extra ]] && source ~/.bashrc.extra" >> "$FILE"'
