#!/usr/bin/env bash
echo "###########################################################################"
echo "# Ark Server - " `date`
echo "# UID $ARK_UID - GID $ARK_GID"
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

# Change working directory to /ark to allow relative path
cd /ark

# Creating directory tree && symbolic link
[ ! -d /ark/log ] && mkdir /ark/log
[ ! -d /ark/backup ] && mkdir /ark/backup
[ ! -d /ark/staging ] && mkdir /ark/staging

if [ ! -d "/ark/server/ShooterGame/Binaries/Linux" ]; then
  echo "Installing  files in /ark/server..."

  # get first instance & install if available
  # only need one instance available to install the game
  instance=$(arkmanager list-instances | grep -o -P '(?<=@).*(?=:)' | head -n 1)
  if [ -z "$instance" ]
  then
      echo "No instance configured, please configure instance and restart the container..."
  else
      arkmanager install "@$instance"
  fi
  # mods
  #classic flyer
  #arkmanager installmod 895711211 @island
  #s+
  #arkmanager installmod 731604991 @island
else 
  echo "installation already exists..."
fi

echo "checking install..."
if [ -d "/ark/server/ShooterGame/Binaries/Linux" ]; then
  arkmanager start @all
else 
  echo "central install does not exist, continuing..."
fi

# configure s3 backups if specified 
if test -f "/s3cfg/.s3cfg"; then
  cp /s3cfg/.s3cfg /home/steam/.s3cfg
  echo "s3cmd configured"
else
  echo "s3cmd is not configured" 
fi 

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait
