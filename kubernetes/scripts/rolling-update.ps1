$ENV:KUBECONFIG="$HOME\.kube\marceldempers-v3"

#kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify maintenance"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager stop @all"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager update @ragnarok"

kubectl -n arkmanager delete po arkmanager-0

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager status @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify running"