$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers.yaml"

kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\configmap.yaml

while ($True)
{
  kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /conf/GameUserSettings.ini | grep EnableCryopodNerf"
  Start-Sleep 2
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cp /conf/*.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini| grep bDisableStructurePlacementCollision"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini | grep EnableCryopodNerf"