$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers-v1.yaml"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager stop @all"