FROM centos:7

# Var for first config
ENV SESSIONNAME="Ark Docker" \
    SERVERMAP="TheIsland" \
    SERVERPASSWORD="" \
    ADMINPASSWORD="adminpassword" \
    MAX_PLAYERS=70 \
    UPDATEONSTART=1 \
    BACKUPONSTART=1 \
    SERVERPORT=27015 \
    STEAMPORT=7778 \
    BACKUPONSTOP=1 \
    WARNONSTOP=1 \
    ARK_UID=1000 \
    ARK_GID=1000 \
    TZ=UTC

## Install dependencies
RUN yum -y install glibc.i686 libstdc++.i686 git lsof bzip2 cronie perl-Compress-Zlib \
 && yum clean all \
 && adduser -u $ARK_UID -s /bin/bash -U steam

# Copy & rights to folders
COPY run.sh /home/steam/run.sh
COPY user.sh /home/steam/user.sh

RUN chmod 777 /home/steam/run.sh \
 && chmod 777 /home/steam/user.sh \
 ## Always get the latest version of ark-server-tools
 && git clone -b $(git ls-remote --tags https://github.com/FezVrasta/ark-server-tools.git | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | tail -n 1) --single-branch --depth 1 https://github.com/FezVrasta/ark-server-tools.git /home/steam/ark-server-tools \
 && cd /home/steam/ark-server-tools/tools \
 && bash install.sh steam --bindir=/usr/bin \
 && mkdir /ark \
 && chown steam /ark && chmod 755 /ark \
 && mkdir /home/steam/steamcmd \
 && cd /home/steam/steamcmd \
 && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Override config files in /etc/arkmanager (delete existing defaults)
RUN rm -f  /etc/arkmanager/instances/instance.cfg.example
RUN rm -f  /etc/arkmanager/instances/main.cfg

COPY arkmanager.cfg /etc/arkmanager/arkmanager.cfg

VOLUME  /ark

# Change the working directory to /ark
WORKDIR /ark

# Update game launch the game.
ENTRYPOINT ["/home/steam/user.sh"]
