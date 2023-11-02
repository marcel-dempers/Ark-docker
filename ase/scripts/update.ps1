
$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"

Write-Host "updating instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager update @all --update-mods" 