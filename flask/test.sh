#!/usr/bin/env bash

Port=5000
servers=(gunicorn meinheld uwsgi cherrypy)

stop() {
    pid=`ps aux | grep $1 | awk '{print $2}'`
    
    if [ -z "$pid" ]; then
      echo "no $1 deamon on port $Port"
    else
      kill -9 $pid
      echo "killed $1 deamon on port $Port"
    fi
}

run() {
   for server in "${servers[@]}"; do
     pid=`ps aux | grep $server | awk '{print $2}'`
     make $server &
     make test
     stop "$server"
     sleep 5
   done
}

run
