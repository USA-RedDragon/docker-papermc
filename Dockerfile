FROM amazoncorretto:21.0.3-alpine@sha256:7e522a694566c0c6cd80b06d97bc69f4be31a518d81d6cdd30c9a854a56aa84a

ARG MC_VERSION=1.20.4
ENV MC_VERSION=${MC_VERSION}

ARG MC_VARIANT=fabric
ENV MC_VARIANT=${MC_VARIANT}

ARG FABRIC_VERSION=0.15.11
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
