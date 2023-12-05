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

echo 'passing ownership to steam ...'
chown -R steam:steam ${ARK_DIR}


su -p -c /home/steam/entrypoint-steam.sh steam 


