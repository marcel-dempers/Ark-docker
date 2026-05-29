$ENV:KUBECONFIG="$HOME\.kube\marceldempers-v3"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager saveworld @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager backup @all"