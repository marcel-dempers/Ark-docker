
$ENV:REASON="updating configuration"

$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-kubeconfig.yaml"
$delayMinutes = 2
while ($delayMinutes -gt 0)
{
  if ($delayMinutes -eq 60)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 45)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 30)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 15)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 10)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 5)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 2)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  if ($delayMinutes -eq 1)
  {
    kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server will stop in $delayMinutes min. Reason: $ENV:REASON"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}


kubectl -n ark exec -it ark-server-0 -- arkmanager broadcast @arkmanager-island "Server shutting down... Reason: $ENV:REASON"
Write-Host "saving world..."
kubectl -n ark exec -it ark-server-0 -- arkmanager saveworld @arkmanager-island
Write-Host "running backup..."
kubectl -n ark exec -it ark-server-0 -- arkmanager backup @arkmanager-island
Write-Host "running restart..."
kubectl -n ark exec -it ark-server-0 -- arkmanager stop @arkmanager-island
