
$ENV:REASON="routine server restart"

$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"
$delayMinutes = 10

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @all 'Automated routine server restart starting in $delayMinutes minutes'"

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @all 'Server will restart in $delayMinutes min. Reason: $ENV:REASON'"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @all 'Automated routine server restart. Will be up in 20 minutes'"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @all 'Server restarting... Reason: $ENV:REASON'"

Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all" 

Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all" 

Write-Host "stop instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager restart @all" 


