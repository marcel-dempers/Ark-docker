
. $PSScriptRoot\active_instances.ps1 

$ENV:REASON="routine server restart"
$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"
$delayMinutes = 10

foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify $i 'Automated routine server restart starting in $delayMinutes minutes'" }

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast $i 'Server will restart in $delayMinutes min. Reason: $ENV:REASON'" }
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

Write-Host "notifying..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify $i 'Automated routine server restart. Will be up in 20 minutes'" }

Write-Host "broadcasting..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast $i 'Server restarting... Reason: $ENV:REASON'" }

Write-Host "saving world..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld $i" }

Write-Host "running backup..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup $i" }

Write-Host "restarting active instances..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager restart $i" }



