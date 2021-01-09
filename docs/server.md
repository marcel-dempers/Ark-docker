
## Custom server on Docker for Windows

```
# needed on windows because of file permissions
docker volume create ark

$ENV:ADMINPASSWORD=xxxxxxxxx

docker run -it --rm `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27016:27016/udp `
-e UPDATEPONSTART=0 `
-e ADMINPASSWORD=$ENV:ADMINPASSWORD `
-e BACKUPONSTOP=1 `
-e BACKUPONSTART=0 `
-e WARNONSTOP=1 `
-e SESSIONNAME=thatdevopsark `
-v ark:/ark --name ark aimvector/ark
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


```

## Service details 
