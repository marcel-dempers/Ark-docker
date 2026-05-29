$ENV:KUBECONFIG="$HOME\.kube\marceldempers-v3"

kubectl -n arkmanager apply -f kubernetes\manifests\configmap.yaml