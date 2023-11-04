# Ark Survival Ascended : Docker & Kubernetes

To start a server in Docker, apply appropriate mounts in the `docker-compose.yaml` file and run:

```
docker compose build

docker compose up ark-asa
```

# Kubernetes 

```

kubectl -n arkmanager apply -f .\asa\manifests\configmap.yaml

```

Restoring backup:

```

arkmanager stop @island

# navigate to saved folder
cd /ark/ShooterGame/Saved/SavedArks/TheIsland_WP/
rm * 

su steam
cp /s3cfg/.s3cfg /home/steam/.s3cfg
arkmanager restore @island s3://ark-backups/ark/backups/island-2023-11-02_11.01.33.bz2
```