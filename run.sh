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


# check if island instance is configured and installed
if test -f "/etc/arkmanager/instances/arkmanager-island.cfg"; then
  if [ ! -d "/ark/island/ShooterGame/Binaries/Linux" ]; then
    echo "Installing  files in /ark/island..."
    arkmanager install @arkmanager-island
    # mods
    #classic flyer
    arkmanager installmod 895711211 @arkmanager-island
    #s+
    arkmanager installmod 731604991 @arkmanager-island
  else 
    echo "instance already configured and installed: arkmanager-island.cfg, starting..."
    arkmanager start @arkmanager-island
  fi
else
  echo "instance not configured: arkmanager-island.cfg"
fi


if test -f "/etc/arkmanager/instances/arkmanager-se.cfg"; then
  if [ ! -d "/ark/scorchedearth/ShooterGame/Binaries/Linux" ]; then
    echo "Installing  files in /ark/scorchedearth..."
    arkmanager install @arkmanager-se
    # mods
    #classic flyer
    arkmanager installmod 895711211 @arkmanager-se
    #s+
    arkmanager installmod 731604991 @arkmanager-se
  else 
    echo "instance already configured and installed: arkmanager-se.cfg, starting..."
    arkmanager start @arkmanager-se
  fi
else
  echo "instance not configured: arkmanager-se.cfg"
fi

if test -f "/etc/arkmanager/instances/arkmanager-abby.cfg"; then
  if [ ! -d "/ark/aberration/ShooterGame/Binaries/Linux" ]; then
    echo "Installing  files in /ark/aberration..."
    arkmanager install @arkmanager-abby
    # mods
    #classic flyer
    arkmanager installmod 895711211 @arkmanager-abby
    #s+
    arkmanager installmod 731604991 @arkmanager-abby
  else 
    echo "instance already configured and installed: arkmanager-abby.cfg, starting..."
    arkmanager start @arkmanager-abby
  fi
else
  echo "instance not configured: arkmanager-abby.cfg"
fi

if test -f "/etc/arkmanager/instances/arkmanager-ext.cfg"; then
  if [ ! -d "/ark/extinction/ShooterGame/Binaries/Linux" ]; then
    echo "Installing  files in /ark/extinction..."
    arkmanager install @arkmanager-ext
    # mods
    #classic flyer
    arkmanager installmod 895711211 @arkmanager-ext
    #s+
    arkmanager installmod 731604991 @arkmanager-ext
  else 
    echo "instance already configured and installed: arkmanager-ext.cfg, starting..."
    arkmanager start @arkmanager-ext
  fi
else
  echo "instance not configured: arkmanager-ext.cfg"
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
