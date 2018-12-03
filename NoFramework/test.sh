#!/usr/bin/env bash

Port=5000
servers=(gunicorn meinheld uwsgi cherrypy)
connections=(500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000)

stop() {
    pid=`ps aux | grep $1 | awk '{print $2}'`
    
    if [ -z "$pid" ]; then
        echo "no $1 deamon on port $Port"
    else
        kill -9 $pid
        echo "killed $1 deamon on port $Port"
    fi
}

for connection in "${connections[@]}"; do
    for server in "${servers[@]}"; do
        pid=`ps aux | grep $server | awk '{print $2}'`
        make $server &
        make test connection=$connection result="$server.$connection.log"
        stop "$server"
        sleep 5
   done
done
