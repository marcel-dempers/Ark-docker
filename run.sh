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

# #check 1 instance for files
# if [ ! -d /ark/island  ] || [ ! -f /ark/island/version.txt ];then
# 	echo "No game files found. Installing..."
# 	mkdir -p /ark/server/ShooterGame/Saved/SavedArks
# 	mkdir -p /ark/server/ShooterGame/Content/Mods
# 	mkdir -p /ark/server/ShooterGame/Binaries/Linux/
# 	touch /ark/server/ShooterGame/Binaries/Linux/ShooterGameServer
# 	arkmanager install
# fi

# check if island instance is installed
if [ ! -d "/ark/island/ShooterGame/Binaries/Linux" ]; then
  echo "Installing  files in /ark/island..."
  arkmanager install @arkmanager-island
  # mods
  #classic flyer
  arkmanager installmod 895711211 @arkmanager-island
  #s+
  arkmanager installmod 731604991 @arkmanager-island
fi

if [ ! -d "/ark/scorchedearth/ShooterGame/Binaries/Linux" ]; then
  echo "Installing  files in /ark/scorchedearth..."
  arkmanager install @arkmanager-se
  # mods
  #classic flyer
  arkmanager installmod 895711211 @arkmanager-se
  #s+
  arkmanager installmod 731604991 @arkmanager-se
fi


if test -f "/etc/arkmanager/instances/arkmanager-island.cfg"; then
  echo "arkmanager-island.cfg exists, starting instance..."
  arkmanager start @arkmanager-island
fi

if test -f "/etc/arkmanager/instances/arkmanager-se.cfg"; then
  echo "arkmanager-se.cfg exists, starting instance..."
  arkmanager start @arkmanager-se
fi

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait
