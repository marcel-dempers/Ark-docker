$ENV:KUBECONFIG="$HOME\.kube\marceldempers-v3"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all"