$ENV:KUBECONFIG="$HOME\.kube\marceldempers-v3"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager saveworld @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager backup @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager stop @all"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager update @extinction"

kubectl -n arkmanager delete po arkmanager-0

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager status @all"

#kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "su steam arkmanager notify running"