# Ark Survival Ascended : Docker & Kubernetes

To start a server in Docker, apply appropriate mounts in the `docker-compose.yaml` file and run:

```
docker compose build
docker compose up ark-asa
```

# Kubernetes 

See Virtual Memory section below if you need more memory on Kubernetes clusters or Cloud VMs with low memory

```
kubectl create ns arkmanager

# server secrets

export ADMINPASSWORD="xxxxxxxxx"
export SERVERPASSWORD="xxxxxxxxx"
export CLUSTER_ID="xxxxxxxxx"

kubectl -n arkmanager create secret generic ark-secrets --from-literal=ADMINPASSWORD=${ADMINPASSWORD} --from-literal=SERVERPASSWORD=${SERVERPASSWORD} --from-literal=CLUSTER_ID=${CLUSTER_ID}

# optional s3 backup secrets

kubectl -n arkmanager create secret generic ark-backup --from-file=./.s3cfg


kubectl -n arkmanager apply -f .\asa\manifests\configmap.yaml
kubectl -n arkmanager apply -f .\asa\manifests\service.yaml
kubectl -n arkmanager apply -f .\asa\manifests\statefulset.yaml

```

## Restoring from backup

You can start your server pod or container with environment variable `DISABLE_START_MAPS_ON_BOOT=true` to stop it from starting the map. </br>
Then start up the container or pod and `exec` inside to `bash`
```

# if the server is running
arkmanager stop @island

# navigate to saved folder and remove old save data
example: cd /ark/ShooterGame/Saved/TheIsland_WP/TheIsland_WP/
rm * 

su steam
arkmanager restore @island
```

You should see new files using `ls` if restore is complete.

## Using Swap memory for low cost cloud machines

Ark runs reasonably well on SWAP memory for small server tribes.
SSH to your instance as root and setup SWAP memory:

```
####################################################

#set failSwapOn: false (kubelet will not start with swap on!)
nano /var/lib/kubelet/config.yaml

dd if=/dev/zero of=/swapfile count=32384 bs=1MiB
ls -lh /swapfile
chmod 600 /swapfile
ls -lh /swapfile
mkswap /swapfile
swapon /swapfile
swapon --show
free -h

#ensure reboot persistence
cp /etc/fstab /etc/fstab.bak

echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
####################################################

# turn off swap
swapoff -v /swapfile
rm -rf /swapfile

```