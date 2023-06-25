$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers.yaml"

Write-Host "starting instances..."

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager start @all"