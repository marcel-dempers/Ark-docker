$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"
$delayMinutes = 40


kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @ragnarok1 'Ragnarok Server launch in $delayMinutes min!'"

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @ragnarok1 'Ragnarok Server launch in $delayMinutes min!'"
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager start @ragnarok1"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @ragnarok1 'When the server is up you can join at: ark.marceldempers.dev:30027'"

