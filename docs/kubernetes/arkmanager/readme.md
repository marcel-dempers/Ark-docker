# Ark Manager on Kubernetes

## Server secrets

```
# server secrets

$ENV:ADMINPASSWORD="xxxxxxxxx"
$ENV:SERVERPASSWORD="xxxxxxxxx"
$ENV:CLUSTER_ID="xxxxxxxxx"

```

## Configuration

```
# namespace 
kubectl create ns arkmanager

#secrets
kubectl -n arkmanager create secret generic ark-secrets --from-literal=ADMINPASSWORD=$ENV:ADMINPASSWORD --from-literal=SERVERPASSWORD=$ENV:SERVERPASSWORD --from-literal=CLUSTER_ID=$ENV:CLUSTER_ID

#configuration
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\configmap.yaml

```

## Deployment

```
# deploy
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\statefulset.yaml

```

# Networking

```
# service
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\service.yaml
kubectl -n arkmanager get services
```

# Troubleshooting installation

```
# pod logs
kubectl -n arkmanager logs arkmanager-0

#server status
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status

#server log
kubectl -n arkmanager exec -it arkmanager-0 -- cat /ark/log/arkserver.log

#track download size
kubectl -n arkmanager exec -it arkmanager-0 -- du -sh /ark/island/
kubectl -n arkmanager exec -it arkmanager-0 -- du -sh /ark/scorchedearth/
```

# Maintenance

```
# white list players 
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager rconcmd "AllowPlayerToJoinNoCheck xxxxxxxx"

# see white listed players 
kubectl -n arkmanager exec -it arkmanager-0 -- nano /ark/island/ShooterGame/Binaries/Linux/PlayersJoinNoCheckList.txt

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
.\docs\kubernetes\restart.ps1
```

## Graceful stop (for updates)

```
# graceful restart including a count down broadcast for players
.\docs\kubernetes\shutdown.ps1

#restart a pod (if needed)
kubectl -n ark delete po ark-server-0
```

## Graceful updates (staged)

```
# check and download updates
kubectl -n ark exec -it ark-server-0 -- arkmanager checkupdate
kubectl -n ark exec -it ark-server-0 -- arkmanager update --downloadonly

#graceful stop to apply updates
.\docs\kubernetes\shutdown.ps1

#update
kubectl -n ark exec -it ark-server-0 -- arkmanager update --no-download

#start
kubectl -n ark exec -it ark-server-0 -- arkmanager start
```

## Service details 

```
kubectl -n ark exec -it ark-server-0 -- arkmanager status
```

## Backup \ Restores

```
#get latest backups
$BACKUP_DIR = '/ark/backup'

$OUTPUT=(kubectl -n ark exec -it ark-server-0 -- bash -c "arkmanager saveworld && arkmanager backup && find $BACKUP_DIR -name *.tar.bz2 -print | sort -nr | head -n1")
$BACKUP = (echo $OUTPUT | select -Last 1)
kubectl -n ark cp ark-server-0:$BACKUP backup.tar.bz2

#extract backup locally
docker run -it -v ${PWD}:/work -w /work alpine sh -c 'apk add tar && tar -xvjf backup.tar.bz2'
```