
## Custom server on Docker for Windows

```
# needed on windows because of file permissions
docker volume create ark

ADMINPASSWORD=xxxxxxxxx

#instance 1 = Ark Island

docker run -it --rm \
-p 30777:30777/udp \
-p 30778:30778/udp \
-p 30015:30015/udp \
-p 30016:30016/udp \
-e ALT_SAVE_DIRECTORY_NAME="ArkTheIslandSave" \
-e STEAMPORT=30778 \
-e SERVERPORT=30015 \
-e UPDATEPONSTART=0 \
-e ADMINPASSWORD=$ADMINPASSWORD \
-e BACKUPONSTOP=1 \
-e BACKUPONSTART=0 \
-e WARNONSTOP=1 \
-e SESSIONNAME=ThatDevopsArk \
-v /data/ark:/ark --name ark aimvector/ark

#instance 2 = Ark ScorchedEarth (optional)

docker run -it --rm \
-p 30779:30779/udp \
-p 30780:30780/udp \
-p 30017:30017/udp \
-p 30018:30018/udp \
-e ALT_SAVE_DIRECTORY_NAME="ArkScorchedEarthSave" \
-e STEAMPORT=30780 \
-e SERVERPORT=30017 \
-e UPDATEPONSTART=0 \
-e ADMINPASSWORD=$ADMINPASSWORD \
-e BACKUPONSTOP=1 \
-e BACKUPONSTART=0 \
-e WARNONSTOP=1 \
-e SESSIONNAME=ThatDevopsArk-02 \
-v /data/ark:/ark --name ark aimvector/ark

```

## Config locations WSL2

```
\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\ark\_data\server\ShooterGame\Saved\Config\LinuxServer
```

## Kubernetes 

```
# server secrets

$ENV:ADMINPASSWORD=xxxxxxxxx
$ENV:SERVERPASSWORD=xxxxxxxxx


# install 
kubectl create ns ark

#secrets
kubectl -n ark create secret generic ark-secrets --from-literal=ADMINPASSWORD=$ENV:ADMINPASSWORD --from-literal=SERVERPASSWORD=$ENV:SERVERPASSWORD

#configuration
kubectl apply -n ark -f .\docs\kubernetes\configmap.yaml

# deploy
kubectl apply -n ark -f .\docs\kubernetes\statefulset.yaml

# service
kubectl apply -n ark -f .\docs\kubernetes\service.yaml
kubectl -n ark get services

```

## Commands 

```

# check pod
kubectl -n ark get pod

# server logs
kubectl -n ark logs ark-server-0

# check ark size
kubectl -n ark exec -it ark-server-0 -- du -sh /ark

kubectl -n ark exec -it ark-server-0 -- arkmanager status

kubectl -n ark exec -it ark-server-0 -- cat /ark/log/arkserver.log

# check settings
kubectl -n ark exec -it ark-server-0 -- cat /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini 

# white list players 
kubectl -n ark exec -it ark-server-0 -- arkmanager rconcmd "AllowPlayerToJoinNoCheck xxxxxxxx"

#list players 
kubectl -n ark exec -it ark-server-0 -- arkmanager rconcmd 'ListPlayers'

```

## Graceful save+backup+restart

This script will countdown broadcast to all that server shutdown will occur in provided minutes.

```
# graceful restart including a count down broadcast for players
.\docs\kubernetes\update.ps1
```

Shutting down & restart pod if needed

```

Write-Host "saving world..."
kubectl -n ark exec -it ark-server-0 -- arkmanager saveworld
Write-Host "running backup..."
kubectl -n ark exec -it ark-server-0 -- arkmanager backup
Write-Host "running restart..."
kubectl -n ark exec -it ark-server-0 -- arkmanager shutdown

kubectl -n ark delete po ark-server-0
```

## Service details 
