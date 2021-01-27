# ARK: Survival Evolved - That DevOps Ark

Docker build for managing an ARK: Survival Evolved server.
Kubernetes deployment for running ARK server manager on Kubernetes

See [Kubernetes Docs](./docs/kubernetes/arkmanager/readme.md) for more details on how to run it on k8s. <br/>

This image uses [Ark Server Tools](https://github.com/FezVrasta/ark-server-tools) to manage an ark server and is forked from [turzam/ark](https://hub.docker.com/r/turzam/ark/).


## Usage
Fast & Easy server setup :   
`docker-compose up`

You can check your server with :  
`docker exec ark arkmanager status` 

You can manually update your mods:  
`docker exec ark arkmanager update --update-mods` 

You can manually update your server:  
`docker exec ark arkmanager update --force` 

You can force save your server :  
`docker exec ark arkmanager saveworld` 

You can backup your server :  
`docker exec ark arkmanager backup` 

You can upgrade Ark Server Tools :  
`docker exec ark arkmanager upgrade-tools` 

You can use rcon command via docker :  
`docker exec ark arkmanager rconcmd ListPlayers`  
*Full list of available command [here](http://steamcommunity.com/sharedfiles/filedetails/?id=454529617&searchtext=admin)*

__You can check all available command for arkmanager__ [here](https://github.com/FezVrasta/ark-server-tools/blob/master/README.md)
