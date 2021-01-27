
$ENV:REASON="updating configuration"

$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"
$delayMinutes = 1
while ($delayMinutes -gt 0)
{
  if ($delayMinutes -eq 60)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 45)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 30)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 15)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 10)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 5)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 2)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 1)
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server will restart in $delayMinutes min. Reason: $ENV:REASON"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}


kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager broadcast @arkmanager-island "Server restarting... Reason: $ENV:REASON"
Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager saveworld @arkmanager-island
Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager backup @arkmanager-island
Write-Host "running restart..."
kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager restart @arkmanager-island

kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status @arkmanager-island