#!/bin/bash

echo "starting entrypoint as $(whoami) ..."

[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

echo "checking install..."
if [ -d "${ARK_DIR}/ShooterGame/Binaries/Win64/" ]; then
  echo "install exists..."
else 
  if [[ "${DISABLE_INSTALL_ON_BOOT,,}" == "true" ]] || [[ "${DISABLE_INSTALL_ON_BOOT,,}" == "yes" ]] || [[ "${DISABLE_INSTALL_ON_BOOT}" == "1" ]]; then
    echo "DISABLE_INSTALL_ON_BOOT is set, not installing!"
  else
    echo "installation not found, installing ..."
    mkdir -p ${ARK_DIR}
    su steam -c "/home/steam/steamcmd/steamcmd.sh +force_install_dir ${ARK_DIR} +login anonymous +app_update 2430930 +quit"
  fi 
fi

echo "passing ownership to steam on dir ${ARK_DIR} ..."
chown -R steam:steam ${ARK_DIR}

echo "copying server ini files..."

# Destination directory
CONFIG_TARGET_DIR="$ARK_DIR/ShooterGame/Saved/Config/WindowsServer"

# create the target config directory if it doesn't exist
mkdir -p ${CONFIG_TARGET_DIR}

# Check if .ini files exist in the source directory
if ls /etc/arkmanager/ini/*.ini 1> /dev/null 2>&1; then
    # If they do, copy them to the destination directory
    cp -v /etc/arkmanager/ini/*.ini ${CONFIG_TARGET_DIR}

    echo "changing ini to read-only..."
    chmod 444 ${CONFIG_TARGET_DIR}/GameUserSettings.ini
    chmod 444 ${CONFIG_TARGET_DIR}/Game.ini
else
    echo "No .ini files found in /etc/arkmanager/ini"
fi

echo "entrypoint-root done, continuing as steam user..."
su -p -c /home/steam/entrypoint-steam.sh steam 


