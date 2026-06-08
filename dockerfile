FROM debian:bookworm-20260518

ENV ARK_UID=1000
ENV ARK_GID=1000 
ENV ARK_DIR=/ark
ENV STEAM_HOME "/home/steam"
ENV STEAM_PATH "${STEAM_HOME}/.steam/steam"

RUN useradd -u $ARK_UID -s /bin/bash -U steam

#steamcmd    
RUN apt-get update && apt-get install -y lib32gcc-s1 curl procps iproute2 bzip2 s3cmd \
  && mkdir -p ${STEAM_HOME}/steamcmd \
  && cd ${STEAM_HOME}/steamcmd \
  && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - \
  && chmod +x ${STEAM_HOME}/steamcmd/steamcmd.sh \
  && chown -R steam:steam /home/steam \
  && su steam -c "${STEAM_HOME}/steamcmd/steamcmd.sh +quit"

# proton
RUN mkdir -p ${STEAM_HOME}/.steam/steam/compatibilitytools.d/

RUN apt-get update && apt-get install -y python3 winbind libfreetype6 dbus \
  && dbus-uuidgen --ensure=/etc/machine-id \
  && rm -rf /var/lib/apt/lists/*

ENV STEAM_APP_ID "2430930"
ENV GE_PROTON_VERSION "9-11"
ENV GE_PROTON_URL "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz"
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH="${STEAM_PATH}"
ENV STEAM_COMPAT_DATA_PATH "${STEAM_PATH}/steamapps/compatdata/${STEAM_APP_ID}"
RUN curl -o /tmp/proton${GE_PROTON_VERSION}.tar.gz -LO ${GE_PROTON_URL}
RUN tar -xf /tmp/proton${GE_PROTON_VERSION}.tar.gz -C ${STEAM_PATH}/compatibilitytools.d/
RUN rm /tmp/proton${GE_PROTON_VERSION}.tar.gz
RUN mkdir -p "${STEAM_PATH}/steamapps/compatdata/${STEAM_APP_ID}"

## install rcon
RUN set -ex; \
  cd /tmp/; \
  curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz; \
  tar xvf rcon.tar.gz; \
  mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/

# install helpers 
RUN apt-get update && apt-get install -y jq tree nano

COPY entrypoint-root.sh ${STEAM_HOME}/entrypoint-root.sh
RUN chmod +x ${STEAM_HOME}/entrypoint-root.sh
COPY entrypoint-steam.sh ${STEAM_HOME}/entrypoint-steam.sh
RUN chmod +x ${STEAM_HOME}/entrypoint-steam.sh

COPY --chown=steam --chmod=755 ./arkmanager/** /usr/local/bin/ 

# ark directory
RUN mkdir /ark && chown -R steam:steam /ark /home/steam

VOLUME  /ark
WORKDIR /ark

ENTRYPOINT ["${STEAM_HOME}/entrypoint-root.sh"]
