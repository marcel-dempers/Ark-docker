# Ark Survival Ascended : Docker & Kubernetes

For Ark Survival evolved, checkout the [readme](./ase/README.md) for more details. <br/>

To start all the ark servers (configured in `configs/instances`) in Docker, run:

```
docker compose up ark-asa
```

The container is configured in the `docker-compose.yml` file.

Note that if your instances are not starting you could be running out of memory. </br>
Each instance will use roughly 8-10GB, so configure virtual memory if you dont have enough. </br>
You can configure or disable instances, see the Instances section  below.

### Volumes

* The server is installed inside a volume called `ark` and inside the container mounted at `/ark` </br>
* The `Game.ini` and `GameUserSettings.ini` are defined in `configs/ini` folder and mounted into the container at `/etc/arkmanager/ini` </br>
* When the container starts, it will copy the `ini` files into the server directory and marks it as Read-Only for server to use </br>
* The `ini` files are currently shared by all instances. </br>

### Instances 

To setup a map, you need an instance `cfg` config file. </br>
Each map instance is configured under `configs/instances`

When the container starts, it will automatically run `arkmanager start @all` which will start all instances that are not disabled. </br> 
* You can disable an instance server with `DISABLED=true` in the `.cfg` file </br>
* You can prevent the game server from installing with env variable: `DISABLE_INSTALL_ON_BOOT` in the compose file</br>
* You can prevent starting maps by setting env variable `DISABLE_START_MAPS_ON_BOOT` in the compose file </br>


You can configure more instances with a new `.cfg` file. </br>

Examples: 

* SESSION_NAME=NameOfServer [which is the name of the server]
* MAP_NAME=TheIsland_WP [which is the name of the map]
* SERVER_PORT=30778 [UDP port to connect to the map] Ensure ports of maps do not conflict
* RCON_PORT=27020 [TCP port to remote admin] Ensure ports of maps do not conflict
* `arkoption_<KEY>=<VALUE>` is the `?Key=Value` option when launching
* `arkflag_<KEY>=<VALUE>` is the `-Key=Value` option when launching
* Example: `arkoption_AltSaveDirectoryName=TheIsland_WP` will result in `?AltSaveDirectoryName=TheIsland_WP` during launch
* Example: `arkflag_EasterColors=` will result in `-EasterColors`
* Example: `arkflag_mods=123,456` will result in `-mods=123,456`


## Management & Commands

To Access the server container:

```
docker exec -it ark-asa bash
```
 
 start all maps:
`arkmanager start @all`

or start individual maps:

```
arkmanager start @island
arkmanager start @se

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


kubectl -n arkmanager apply -f kubernetes/manifests/configmap.yaml
kubectl -n arkmanager apply -f kubernetes/manifests/service.yaml
kubectl -n arkmanager apply -f kubernetes/manifests/statefulset.yaml

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
kubectl apply -f kubernetes/manifests/configmap.yaml
kubectl apply -f kubernetes/manifests/restore/restore-job.yaml
```

## Cleanup backups

After testing latest backups locally, you can purge old backups with `s3cmd`:
```
# example delete old folder:

s3cmd --config /etc/s3cfg/.s3cfg del -r s3://ark-backups/island/timestamped/2024/03
s3cmd --config /etc/s3cfg/.s3cfg del -r s3://ark-backups/se/timestamped/2024/03
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
  swapBehavior: UnlimitedSwap
```

Then setup SWAP on your Kubernetes node or Virtual Machine

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

This is also all automated with a Daemonset:

```
#can be tested with kind-> kind create cluster --name ark --image kindest/node:v1.30.0
kubectl create ns arkmanager
kubectl -n arkmanager apply -f ./kubernetes/manifests/swap-daemonset.yaml
kubectl -n arkmanager logs -l name=swap-checker -f 
```