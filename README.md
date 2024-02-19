# Ark Survival Ascended : Docker & Kubernetes

For Ark Survival evolved, checkout the [readme](./ase/README.md) for more details. <br/>

To start a server in Docker, apply appropriate mounts in the `docker-compose.yaml` file and run:

```
docker compose build
docker compose up ark-asa
```

This will run the container with `arkmanager` commands available. </br>
You can then start your maps by running:

```
docker exec -it ark-asa bash

#start all maps
arkmanager start @all 

#or

arkmanager start @island
arkmanager start @svartalfheim
```

Other commands

```
arkmanager stop @island
arkmanager update @island
arkmanager start @island
arkmanager backup @island
```

To backup maps you can use `arkmanager backup @island`
You will need to mount `.s3cfg` for your S3 bucket to backup to.

You can restore latest backup with `arkmanager stop @island` , then `arkmanager restore @island`

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


kubectl -n arkmanager apply -f manifests/configmap.yaml
kubectl -n arkmanager apply -f manifests/service.yaml
kubectl -n arkmanager apply -f manifests/statefulset.yaml

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

arkmanager restore @island

# restart your container
```

You should see new files using `ls` if restore is complete.

### Restoring to a new Kubernetes cluster

You can automate the restore process using a job:

```
kind create cluster --name ark
kubectl create namespace arkmanager
kubectl create secret generic ark-backup --from-file=./.s3cfg --namespace arkmanager
kubectl apply -f manifests/configmap.yaml
kubectl apply -f manifests/restore/restore-job.yaml
```

## Cleanup backups

After testing latest backups locally, you can purge old backups with `s3cmd`:
```
# example delete old folder:
s3cmd del -r s3://ark-backups/island/timestamped/2023
```

## Using Swap memory for low cost cloud machines

Ark runs reasonably well on SWAP memory for small server tribes.
SSH to your instance as root and setup SWAP memory:

### Enable SWAP in Kubernetes (1.28)

Need to tell k8s to utilise SWAP memory. Introduced in 1.28:
```
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
failSwapOn: false
featureGates:
  NodeSwap: true
memorySwap:
  swapBehavior: LimitedSwap
```

Then setup SWAP on the node

```
####################################################

#set failSwapOn: false (kubelet will not start with swap on!)
kubelet config locations :
nano /var/lib/kubelet/config.yaml
nano /etc/kubernetes/kubelet.conf

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

# how to turn off swap
swapoff -v /swapfile
rm -rf /swapfile

```