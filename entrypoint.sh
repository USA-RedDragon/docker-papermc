#!/bin/sh

trap "exit" INT TERM ERR
trap "kill 0" EXIT

if [ "${ACCEPT_EULA}" = "true" ]; then
    echo "eula=true" > /minecraft/eula.txt
fi

MEMORY_OPTS=${MEMORY_OPTS:-"-Xms128M -Xmx1G"}

JAVA_OPTS="${MEMORY_OPTS} ${EXTRA_JAVA_OPTS}"

exec java ${JAVA_OPTS} -jar /paper-${MC_VERSION}-$(cat /build_num).jar --nogui --universe /minecraft/worlds
