$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers.yaml"

$timestamp = get-date -f MM-dd-yyyy_HH_mm_ss
$content = Get-Content .\docs\kubernetes\arkmanager\configmap.yaml

for ($i = 0; $i -lt $content.count; $i++) {
  $index = $content[$i].IndexOf("#updated")
  if ($index -ne -1) {
    $content[$i] = "    #updated at : " + $timestamp
  }
}
Set-Content -Path .\docs\kubernetes\arkmanager\configmap.yaml -Value $content

echo "applying config..."
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\configmap.yaml

echo "waiting for configmap to propagate..."
$continue = $True
while ($continue)
{
  $current_config = (kubectl -n arkmanager exec -it arkmanager-0 -c ark -- bash -c "cat /conf/arkmanager.cfg | grep $timestamp")
  
  if ($current_config -ne $NULL) {
    if ($current_config.Contains($timestamp)){
      $continue = $False
      $current_config

      echo "configmap propagated"
    }
  }
  
  Start-Sleep 2
}

echo "copying configs to game directory..."
kubectl -n arkmanager exec -it arkmanager-0 -c ark -- bash -c "cp /conf/*.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/"
kubectl -n arkmanager exec -it arkmanager-0 -c ark -- bash -c "cp /conf/island.cfg /etc/arkmanager/instances/"
kubectl -n arkmanager exec -it arkmanager-0 -c ark -- bash -c "cp /conf/scorchedearth.cfg /etc/arkmanager/instances/"
kubectl -n arkmanager exec -it arkmanager-0 -c ark -- bash -c "cp /conf/aberration.cfg /etc/arkmanager/instances/"