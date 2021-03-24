
$ENV:REASON="updating server"

$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"
$delayMinutes = 2

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will shutdown in $delayMinutes min. Reason: $ENV:REASON"
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-se "Server will shutdown in $delayMinutes min. Reason: $ENV:REASON"
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-abby "Server will shutdown in $delayMinutes min. Reason: $ENV:REASON"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server shutting down... Reason: $ENV:REASON"
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-se "Server shutting down... Reason: $ENV:REASON"
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-abby "Server shutting down... Reason: $ENV:REASON"
Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-se
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-abby
Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-se
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-abby
Write-Host "stop instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager stop @arkmanager-island
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager stop @arkmanager-se
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager stop @arkmanager-abby

