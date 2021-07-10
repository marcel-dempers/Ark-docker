# Ark Manager on Kubernetes

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

## Namespace 

```
kubectl create ns arkmanager
```

## Server secrets

```
# server secrets

$ENV:ADMINPASSWORD="xxxxxxxxx"
$ENV:SERVERPASSWORD="xxxxxxxxx"
$ENV:CLUSTER_ID="xxxxxxxxx"
$ENV:DISCORD_URL="xxxxxxxxx"

#secrets
kubectl -n arkmanager create secret generic ark-secrets --from-literal=ADMINPASSWORD=$ENV:ADMINPASSWORD --from-literal=SERVERPASSWORD=$ENV:SERVERPASSWORD --from-literal=CLUSTER_ID=$ENV:CLUSTER_ID --from-literal=DISCORD_URL=$ENV:DISCORD_URL

# optional s3 backup secrets

kubectl -n arkmanager create secret generic ark-backup --from-file=./.s3cfg
```

## Configuration

```
#configuration
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\configmap.yaml

```

## Optional: Restore Server from S3 to filesystem

```
kubectl apply -n arkmanager -f .\docs\kubernetes\restore-aws\job.yaml
kubectl -n arkmanager get pods
```

## Deployment

```
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\statefulset.yaml

```

# Networking

```
# service
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\service.yaml
kubectl -n arkmanager get services
```

# Monitoring installation

It will take a while for the server to download binaries for the first time.

```
# track download (roughly 17GB!)
kubectl -n arkmanager exec -it arkmanager-0 -- ls -l /ark/
kubectl -n arkmanager exec -it arkmanager-0 -- du -sh /ark/island/

# pod logs
kubectl -n arkmanager logs arkmanager-0

#server status
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status

#server log
kubectl -n arkmanager exec -it arkmanager-0 -- cat /ark/log/arkserver.log


```

# Maintenance

```
# white list players on all servers
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager rconcmd @all 'AllowPlayerToJoinNoCheck xxxxxxxx'"

# white list players on 1 instance:
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager rconcmd @arkmanager-island 'AllowPlayerToJoinNoCheck xxxxxxxx'"

# see white listed players 
kubectl -n arkmanager exec -it arkmanager-0 -- nano /ark/island/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt
kubectl -n arkmanager cp arkmanager-0:/ark/island/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt PlayersJoinNoCheckList.txt 
```

# Restore

```
#copy backup
kubectl -n arkmanager cp .\backup.tar.bz2 arkmanager-0:/tmp/backup.tar.bz2

#extract
mkdir -p /tmp/restore/
tar -xvjf /tmp/backup.tar.bz2 -C /tmp/restore/

#NOTE: cd to the restore files and clear existing save first!
rm /ark/island/ShooterGame/Saved/ArkTheIslandSave/*

#copy files to save
cp * /ark/island/ShooterGame/Saved/ArkTheIslandSave/
```

## Graceful save+backup+restart

This script will countdown broadcast to all that server shutdown will occur in provided minutes.

```
# graceful restart including a count down broadcast for players
.\scripts\restart.ps1
```

## Graceful stop (for updates)

```
# graceful restart including a count down broadcast for players
.\scripts\shutdown.ps1

#restart a pod (if needed)
kubectl -n arkmanager delete po arkmanager-0
```

## Graceful updates (staged)

```
# check and download updates
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager checkupdate @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager update --update-mods

#graceful stop to apply updates
.\scripts\shutdown.ps1

#update
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager update --no-download --update-mods

#start
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager start @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager start @arkmanager-se
```

## Service details 

```
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status

Watch 
.\scripts\watch.ps1
```

## Backup \ Restores

```
#get latest backups
$BACKUP_DIR = '/ark/backup'

$OUTPUT=(kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld && arkmanager backup && find $BACKUP_DIR -name *.tar.bz2 -print | sort -nr | head -n1")
$BACKUP = (echo $OUTPUT | select -Last 1)
kubectl -n arkmanager cp arkmanager-0:$BACKUP backup.tar.bz2

#extract backup locally
docker run -it -v ${PWD}:/work -w /work alpine sh -c 'apk add tar && tar -xvjf backup.tar.bz2'
```