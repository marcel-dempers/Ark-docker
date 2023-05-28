$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers.yaml"

$timestamp = get-date -f MM-dd-yyyy_HH_mm_ss
(Get-Content .\docs\kubernetes\arkmanager\configmap.yaml) -replace "#updated at: ", "$& $timestamp" | Set-Content .\docs\kubernetes\arkmanager\configmap.yaml
kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\configmap.yaml

while ($True)
{
  kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /conf/Game.ini | grep BabyCuddleIntervalMultiplier"
  Start-Sleep 2
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cp /conf/*.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini| grep bDisableStructurePlacementCollision"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini | grep EnableCryopodNerf"