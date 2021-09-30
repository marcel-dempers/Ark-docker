$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"
$delayMinutes = 30
$ENV:REASON="updating server"

. $PSScriptRoot\active_instances.ps1 

# start all inactive servers for backups and wait for up countdown
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager start @all"

foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify $i 'Automated routine server maintenance starting in $delayMinutes minutes'" }

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast $i 'Server will shutdown in $delayMinutes min. Reason: $ENV:REASON'" }
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @all 'Automated routine server maintenance. Will be up in 20 minutes'"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @all 'Server shutting down... Reason: $ENV:REASON'"

Write-Host "saving world..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @all" 

Write-Host "running backup..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @all" 

Write-Host "stop instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager stop @all" 

Write-Host "updating instances..."
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager update @all --update-mods"

Write-Host "starting active instances..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager start $i" }