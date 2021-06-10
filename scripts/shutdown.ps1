
$ENV:REASON="updating server"

$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"
$delayMinutes = 2

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @all 'Server will shutdown in $delayMinutes min. Reason: $ENV:REASON'"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @all 'Server shutting down... Reason: $ENV:REASON'"

Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all" 

Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all" 

Write-Host "stop instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager stop @all" 


