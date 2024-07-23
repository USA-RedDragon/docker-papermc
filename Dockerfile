FROM amazoncorretto:21.0.4-alpine@sha256:acf34287ecb0d0660092d7c91d2fdff27d958a5584f5eb1b16f87b7a8afb8c83

ARG PAPER_VERSION=1.20.2
ARG PAPER_BUILD=318

ENV PAPER_VERSION="${PAPER_VERSION}"
ENV PAPER_BUILD="${PAPER_BUILD}"

# Used in entrypoint
ARG MC_VARIANT=paper
ENV MC_VARIANT=${MC_VARIANT}

WORKDIR /minecraft

RUN apk add --no-cache \
  curl \
  jq \
  nano \
  bash

SHELL [ "bash", "-c" ]

RUN <<__DOCKER_EOF__
set -eux
SHA256=$(curl -fSsL https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds | jq -r ".builds[] | select(.build==${PAPER_BUILD}).downloads.application.sha256")

curl -fSsL \
  https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar \
  -o /paper-${PAPER_VERSION}-${PAPER_BUILD}.jar

echo "${SHA256}  /paper-${PAPER_VERSION}-${PAPER_BUILD}.jar" | sha256sum -c
__DOCKER_EOF__

RUN addgroup -g 1000 minecraft
RUN adduser -u 1000 -G minecraft -s /bin/sh -D minecraft
RUN chown -R minecraft:minecraft /minecraft /paper-${PAPER_VERSION}-${PAPER_BUILD}.jar

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565

ENV ACCEPT_EULA=false
ENV EXTRA_JAVA_OPTS=""
ENV MEMORY_OPTS="-Xms128M -Xmx1G"

USER minecraft

ENTRYPOINT /entrypoint.sh
