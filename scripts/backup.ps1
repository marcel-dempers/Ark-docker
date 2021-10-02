$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"

. $PSScriptRoot\active_instances.ps1 

Write-Host "saving world..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld $i" }

Write-Host "running backup..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup $i" }