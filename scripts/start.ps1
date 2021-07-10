$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"

Write-Host "starting instances..."

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager start @all"