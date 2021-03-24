
$ENV:REASON="scheduled restart"

$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"
$delayMinutes = 1
while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-se "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-abby "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}


kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server restarting... Reason: $ENV:REASON"
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-se "Server restarting... Reason: $ENV:REASON"
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-abby "Server restarting... Reason: $ENV:REASON"
Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-se
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-abby
Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-se
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-abby
Write-Host "running restart..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager restart @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager restart @arkmanager-se
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager restart @arkmanager-abby
