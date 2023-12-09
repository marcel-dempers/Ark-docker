$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers.yaml"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @island"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @island"