#!/bin/bash

echo 'starting server ... '
arkmanager start @all

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait

