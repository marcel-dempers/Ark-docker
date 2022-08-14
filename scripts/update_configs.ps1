$ENV:KUBECONFIG="C:\Users\aimve\Downloads\marceldempers-dev-2-kubeconfig.yaml"

kubectl apply -n arkmanager -f .\docs\kubernetes\arkmanager\configmap.yaml

while ($True)
{
  kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /conf/GameUserSettings.ini | grep EnableCryopodNerf"
  Start-Sleep 2
}

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cp /conf/GameUserSettings.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cp /conf/Game.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini"


kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini| grep BabyMatureSpeedMultiplier"
kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "cat /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini | grep EnableCryopodNerf"