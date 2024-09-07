FROM amazoncorretto:21.0.4-alpine@sha256:6a98c4402708fe8d16e946b4b5bac396379ec5104c1661e2a27b2b45cf9e2d16

ARG MC_VERSION=1.20.3
ENV MC_VERSION=${MC_VERSION}

ARG MC_VARIANT=fabric
ENV MC_VARIANT=${MC_VARIANT}

ARG FABRIC_VERSION=0.16.5
ENV FABRIC_VERSION=${FABRIC_VERSION}

ARG INSTALLER_VERSION=1.0.1
ENV INSTALLER_VERSION=${INSTALLER_VERSION}

WORKDIR /minecraft

RUN apk add --no-cache \
  curl \
  jq \
  nano \
  bash

RUN curl -fsL https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${FABRIC_VERSION}/${INSTALLER_VERSION}/server/jar -o /fabric-${MC_VERSION}-${FABRIC_VERSION}-${INSTALLER_VERSION}.jar

RUN addgroup -g 1000 minecraft
RUN adduser -u 1000 -G minecraft -s /bin/sh -D minecraft
RUN chown -R minecraft:minecraft /minecraft /fabric-${MC_VERSION}-${FABRIC_VERSION}-${INSTALLER_VERSION}.jar

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565

ENV ACCEPT_EULA=false
ENV EXTRA_JAVA_OPTS=""
ENV MEMORY_OPTS="-Xms128M -Xmx1G"

USER minecraft

ENTRYPOINT /entrypoint.sh
