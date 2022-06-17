FROM centos:8

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
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum update -y

RUN yum -y install glibc.i686 git lsof bzip2 cronie perl-Compress-Zlib \
 && yum clean all \
 && adduser -u $ARK_UID -s /bin/bash -U steam

## Always get the latest version of ark-server-tools
RUN git clone -b $(git ls-remote --tags https://github.com/FezVrasta/ark-server-tools.git | awk '{print $2}' | grep -v '{}' | awk -F"/" '{print $3}' | tail -n 1) --single-branch --depth 1 https://github.com/FezVrasta/ark-server-tools.git /home/steam/ark-server-tools \
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

# Install cloud tools for backups AWS\AZURE\Linode\etc
# Install s3cmd to allow backups on s3-compatible story
# S3 secret mounted to /root/.s3cfg
RUN yum install -y python3 && \
    pip3 install linode-cli boto && \ 
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum --enablerepo=epel install -y s3cmd

COPY run.sh /home/steam/run.sh
COPY user.sh /home/steam/user.sh
RUN chmod 777 /home/steam/run.sh \
 && chmod 777 /home/steam/user.sh

COPY arkmanager.cfg /etc/arkmanager/arkmanager.cfg

COPY backup-s3.sh /home/steam/backup-s3.sh
RUN chmod 777 /home/steam/backup-s3.sh

VOLUME  /ark

# Change the working directory to /ark
WORKDIR /ark

# Update game launch the game.
ENTRYPOINT ["/home/steam/user.sh"]
