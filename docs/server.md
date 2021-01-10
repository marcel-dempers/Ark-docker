
## Custom server on Docker for Windows

```
# needed on windows because of file permissions
docker volume create ark

$ENV:ADMINPASSWORD=xxxxxxxxx

docker run -it --rm \
-p 30777:30777/udp \
-p 30778:30778/udp \
-p 30015:30015/udp \
-p 30016:30016/udp \
-e STEAMPORT=30778 \
-e SERVERPORT=30015 \
-e UPDATEPONSTART=0 \
-e ADMINPASSWORD=$ADMINPASSWORD \
-e BACKUPONSTOP=1 \
-e BACKUPONSTART=0 \
-e WARNONSTOP=1 \
-e SESSIONNAME=ThatDevopsArk \
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


# install 
kubectl create ns ark

#secrets
kubectl -n ark create secret generic ark-secrets --from-literal=ADMINPASSWORD=$ENV:ADMINPASSWORD

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
```

## Service details 
