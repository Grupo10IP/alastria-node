#!/bin/bash

_term() {
    pkill -f geth
    wait
}

trap _term SIGTERM

if [ ! -f ~/alastria/data/IDENTITY ]; then
    ./init.sh auto $NODE_TYPE $NODE_NAME
elif [ ! -f ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION ]; then
    echo "[*] Updating static-nodes and permissioned-nodes"
    ./updatePerm.sh $NODE_TYPE
    rm -f ~/alastria/data/DOCKER_VERSION_* 2> /dev/null
    touch ~/alastria/data/DOCKER_VERSION_$DOCKER_VERSION
fi

ARGS="--watch"
if [ ! $MONITOR_ENABLED -eq 1 ]; then
    AGRS="--watch --no-monitor"
fi
exec ENABLE_CONSTELLATION=$ENABLE_CONSTELLATION ./start.sh $ARGS

child=$!
wait "$child"
