#!/bin/bash

echo "starting entrypoint as $(whoami) ..."

if [[ "${DISABLE_START_MAPS_ON_BOOT,,}" == "true" ]] || [[ "${DISABLE_START_MAPS_ON_BOOT,,}" == "yes" ]] || [[ "${DISABLE_START_MAPS_ON_BOOT}" == "1" ]]; then
  echo "DISABLE_START_MAPS_ON_BOOT is set, not starting maps!"
else
  echo 'starting server ... '
  arkmanager start @all
fi 

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait

