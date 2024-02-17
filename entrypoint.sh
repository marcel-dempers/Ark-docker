#!/bin/bash
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

echo "checking install..."
if [ -d "${ARK_DIR}/ShooterGame/Binaries/Win64/" ]; then
  echo "install exists..."
else 
  if [ -z "${DISABLE_INSTALL_ON_BOOT}" ]
  then
    echo "installation not found, installing ..."
    mkdir -p ${ARK_DIR}
    su steam -c "/home/steam/steamcmd/steamcmd.sh +force_install_dir ${ARK_DIR} +login anonymous +app_update 2430930 +quit"
  else
    echo "DISABLE_INSTALL_ON_BOOT set to true, not installing!"
  fi 
fi

echo "copying server ini files..."

# Destination directory
CONFIG_TARGET_DIR="$ARK_DIR/ShooterGame/Saved/Config/WindowsServer/"

# create the target config directory if it doesn't exist
mkdir -p ${CONFIG_TARGET_DIR}

# Check if .ini files exist in the source directory
if ls /etc/arkmanager/ini/*.ini 1> /dev/null 2>&1; then
    # If they do, copy them to the destination directory
    cp /etc/arkmanager/ini/*.ini ${CONFIG_TARGET_DIR}
else
    echo "No .ini files found in /etc/arkmanager/ini"
fi

echo 'passing ownership to steam ...'
chown -R steam:steam ${ARK_DIR}

su -p -c /home/steam/entrypoint-steam.sh steam 


