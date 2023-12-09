$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers.yaml"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager logs @island"