$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"
while ($True)
{
  kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager status @all"
  start-sleep 5
  clear
}