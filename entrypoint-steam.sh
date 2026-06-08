#!/bin/bash

echo "starting entrypoint as $(whoami) ..."

echo "setting steam symlinks"
export HOME=/home/steam

ln -s "${HOME}/steamcmd/linux32" "${HOME}/.steam/sdk32" \
&& ln -s "${HOME}/steamcmd/linux64" "${HOME}/.steam/sdk64" \
&& ln -s "${HOME}/.steam/sdk32/steamclient.so" "${HOME}/.steam/sdk32/steamservice.so" \
&& ln -s "${HOME}/.steam/sdk64/steamclient.so" "${HOME}/.steam/sdk64/steamservice.so"

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

