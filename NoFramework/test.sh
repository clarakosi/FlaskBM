#!/usr/bin/env bash

PORT=5000
SERVERS=(gunicorn meinheld uwsgi cherrypy)
CONNECTIONS=(500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000)

stop() {
    pid=`ps aux | grep $1 | awk '{print $2}'`
    
    if [ -z "$pid" ]; then
        echo "no $1 deamon on port $PORT"
    else
        kill -9 $pid
        echo "killed $1 deamon on port $PORT"
    fi
}

for connection in "${CONNECTIONS[@]}"; do
    for server in "${SERVERS[@]}"; do
        pid=`ps aux | grep $server | awk '{print $2}'`
        make $server &
        make test CONNECTIONS=$connection RESULTS="$server.$connection.log"
        stop "$server"
        sleep 5
   done
done
