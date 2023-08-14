FROM amazoncorretto:17.0.8-alpine@sha256:6e6f780411eae55e8dcb59391aa09dd778f0fa2c896f9c218961fdb7da52f485

ARG MC_VERSION=1.20.1
ENV MC_VERSION=${MC_VERSION}

WORKDIR /minecraft

RUN apk add --no-cache \
  curl \
  jq

RUN curl -fSsL https://api.papermc.io/v2/projects/paper/versions/${MC_VERSION}/builds -o /tmp/paper.json
RUN <<__DOCKER_EOF__
set -eux

BUILD_NUM=$(cat /tmp/paper.json | jq -r '.builds[-1].build')
SHA256=$(cat /tmp/paper.json | jq -r '.builds[-1].downloads.application.sha256')

curl -fSsL \
  https://api.papermc.io/v2/projects/paper/versions/${MC_VERSION}/builds/${BUILD_NUM}/downloads/paper-${MC_VERSION}-${BUILD_NUM}.jar \
  -o /paper-${MC_VERSION}-${BUILD_NUM}.jar

echo "${SHA256}  /paper-${MC_VERSION}-${BUILD_NUM}.jar" | sha256sum -c
echo "${BUILD_NUM}" > /build_num
__DOCKER_EOF__

RUN addgroup -g 1000 minecraft
RUN adduser -u 1000 -G minecraft -s /bin/sh -D minecraft
RUN chown -R minecraft:minecraft /minecraft /build_num /paper-${MC_VERSION}-$(cat /build_num).jar

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565

ENV ACCEPT_EULA=false
ENV EXTRA_JAVA_OPTS=""
ENV MEMORY_OPTS="-Xms128M -Xmx1G"

USER minecraft

ENTRYPOINT /entrypoint.sh
