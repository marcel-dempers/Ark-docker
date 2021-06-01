
$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"

Write-Host "updating instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager update @all --update-mods" 