$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers-v3"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager status @all"