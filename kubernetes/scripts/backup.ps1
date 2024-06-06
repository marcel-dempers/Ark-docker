$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers-v2.yaml"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all"