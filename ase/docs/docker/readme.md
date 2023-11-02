## Custom server on Docker for Windows

```

# needed on windows because of file permissions
docker volume create ark

docker run -it --rm `
-p 30777:30777/udp `
-p 30778:30778/udp `
-p 30015:30015/udp `
-p 30016:30016/udp `
-p 30779:30779/udp `
-p 30780:30780/udp `
-p 30017:30017/udp `
-p 30018:30018/udp `
-e UPDATEPONSTART=0 `
-e SERVERPASSWORD= `
-e ADMINPASSWORD=test `
-e BACKUPONSTOP=0 `
-e BACKUPONSTART=0 `
-e WARNONSTOP=0 `
-e CLUSTER_ID=ThatDevOpsArkCluster `
-v ark:/ark --name ark aimvector/ark-server-tools
```



```
docker run -it --rm `
-p 30777:30777/udp `
-p 30778:30778/udp `
-p 30015:30015/udp `
-p 30016:30016/udp `
-p 30779:30779/udp `
-p 30780:30780/udp `
-p 30017:30017/udp `
-p 30018:30018/udp `
-p 30777:30777/tcp `
-p 30778:30778/tcp `
-p 30015:30015/tcp `
-p 30016:30016/tcp `
-p 30779:30779/tcp `
-p 30780:30780/tcp `
-p 30017:30017/tcp `
-p 30018:30018/tcp `
-e UPDATEPONSTART=0 `
-e SERVERPASSWORD= `
-e ADMINPASSWORD=test `
-e BACKUPONSTOP=0 `
-e BACKUPONSTART=0 `
-e WARNONSTOP=0 `
-e CLUSTER_ID=ThatDevOpsArkCluster `
-v ark:/ark --name ark aimvector/ark-server-tools
```

## Config locations WSL2

```
\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\ark\_data\server\ShooterGame\Saved\Config\LinuxServer
```
