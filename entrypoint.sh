#!/bin/bash

case $MODE in

server)

    envsubst </conf/server.yaml.tmpl >/etc/gost.yaml

    ;;

client)

    services=""
    i=0
    for phrase in ${MAP//[;,]/ }; do
        IFS=">" read -r remote_dest local_dest <<<"$phrase"
        export number="$i" remote_dest local_dest
        service=$(envsubst </conf/client-service.yaml.tmpl)
        services+="$service"$'\n'
        ((i++))
    done
    export services
    envsubst </conf/client.yaml.tmpl >/etc/gost.yaml

    ;;

esac

if [ "$LOG_LEVEL" == "debug" ]; then

    echo "Using config file: "
    sed 's/^/\t/' </etc/gost.yaml

fi

exec "$@"
