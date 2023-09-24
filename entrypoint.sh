#!/bin/sh

trap "exit" INT TERM ERR
trap "kill 0" EXIT

if [ "${ACCEPT_EULA}" = "true" ]; then
    echo "eula=true" > /minecraft/eula.txt
fi

MEMORY_OPTS=${MEMORY_OPTS:-"-Xms128M -Xmx1G"}

JAVA_OPTS="${MEMORY_OPTS} ${EXTRA_JAVA_OPTS}"

JARPATH=""
if [ "${MC_VARIANT}" = "paper" ]; then
    JARPATH="/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar"
elif [ "${MC_VARIANT}" = "fabric" ]; then
    JARPATH="/fabric-${MC_VERSION}-${FABRIC_VERSION}-${INSTALLER_VERSION}.jar"
else
    echo "Unknown variant: ${MC_VARIANT}"
    exit 1
fi

exec java ${JAVA_OPTS} -jar "${JARPATH}" --nogui
