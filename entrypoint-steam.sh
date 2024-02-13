#!/bin/bash

if [ -z "${DISABLE_START_MAPS_ON_BOOT}" ]
then
  echo 'starting server ... '
  arkmanager start @all
fi 

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait

