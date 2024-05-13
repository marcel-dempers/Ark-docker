$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers-v1.yaml"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager stop @all"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager update @island"
kubectl -n arkmanager delete po arkmanager-0