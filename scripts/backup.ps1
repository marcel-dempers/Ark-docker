$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"

Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all" 

Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all"