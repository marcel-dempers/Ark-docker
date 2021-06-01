$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"

Write-Host "starting instances..."

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager start @all"