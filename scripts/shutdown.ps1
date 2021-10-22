$ENV:REASON="updating server"
$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"

. $PSScriptRoot\active_instances.ps1 

$delayMinutes = 5

foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @$i 'Automated routine server maintenance starting in $delayMinutes minutes'" }

while ($delayMinutes -gt 0)
{
  if (($delayMinutes -eq 60) -or ($delayMinutes -eq 45) -or ($delayMinutes -eq 30) -or ($delayMinutes -eq 15) -or ($delayMinutes -eq 10) -or ($delayMinutes -eq 5) -or ($delayMinutes -eq 2) -or ($delayMinutes -eq 1))
  {
    foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @$i 'Server will shutdown in $delayMinutes min. Reason: $ENV:REASON'" }
  }

  Write-Host "Minutes Remaining: $($delayMinutes)"
  start-sleep 60
  $delayMinutes -= 1
}

foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager notify @$i 'Automated routine server maintenance. Will be up in 20 minutes'" }

foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager broadcast @$i 'Server shutting down... Reason: $ENV:REASON'" }

Write-Host "saving world..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager saveworld @$i" }

Write-Host "running backup..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager backup @$i" }

Write-Host "stop instances..."
foreach ( $i in $instances ){ kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager stop @$i" }


