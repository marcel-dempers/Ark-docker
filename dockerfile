FROM debian:bookworm@sha256:1aadfee8d292f64b045adb830f8a58bfacc15789ae5f489a0fedcd517a862cb9

ENV ARK_UID=1000 \
    ARK_GID=1000 \
    ARK_DIR=/ark
RUN useradd -u $ARK_UID -s /bin/bash -U steam

#steamcmd    
RUN apt-get update && apt-get install -y lib32gcc-s1 curl procps iproute2 bzip2 s3cmd \
  && mkdir -p /home/steam/steamcmd \
  && cd /home/steam/steamcmd \
  && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - \
  && chmod +x /home/steam/steamcmd/steamcmd.sh

# proton
RUN apt-get install -y python3
ENV PROTON_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton8-21/GE-Proton8-21.tar.gz"
RUN curl -o /tmp/proton.tar.gz -LO ${PROTON_URL}
RUN tar -xzf /tmp/proton.tar.gz -C /usr/local/bin/ --strip-components=1;
RUN rm /tmp/proton.tar.gz
RUN apt-get install -y libfreetype6
RUN mkdir -p /home/steam/.steam/steam/steamapps/compatdata/2430930
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/steam/.steam/steam"
ENV STEAM_COMPAT_DATA_PATH="/home/steam/.steam/steam/steamapps/compatdata/2430930"

## install rcon
RUN set -ex; \
  cd /tmp/; \
  curl -sSL https://github.com/gorcon/rcon-cli/releases/download/v0.10.3/rcon-0.10.3-amd64_linux.tar.gz > rcon.tar.gz; \
  tar xvf rcon.tar.gz; \
  mv rcon-0.10.3-amd64_linux/rcon /usr/local/bin/

# install helpers 
RUN apt-get install -y jq tree 

COPY entrypoint-root.sh /home/steam/entrypoint-root.sh
RUN chmod +x /home/steam/entrypoint-root.sh
COPY entrypoint-steam.sh /home/steam/entrypoint-steam.sh
RUN chmod +x /home/steam/entrypoint-steam.sh

COPY --chown=steam --chmod=755 ./arkmanager/** /usr/local/bin/ 

# TODO: proton fix machine-id
# RUN set -ex; \
#   rm -f /etc/machine-id; \
#   dbus-uuidgen --ensure=/etc/machine-id; \
#   rm /var/lib/dbus/machine-id; \
#   dbus-uuidgen --ensure

# ark directory
RUN mkdir /ark && chown -R steam:steam /ark /home/steam

VOLUME  /ark
WORKDIR /ark

ENTRYPOINT ["/home/steam/entrypoint-root.sh"]

# docker build . -t asa
# docker run -it -v ${PWD}/.data/:/ark --entrypoint bash asa
# /home/steam/entrypoint.sh