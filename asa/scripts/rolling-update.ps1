$ENV:KUBECONFIG="C:\Users\aimve\kube-tools\.kube\marceldempers-v1.yaml"

.${PWD}\asa\scripts\backup.ps1
.${PWD}\asa\scripts\stop.ps1
.${PWD}\asa\scripts\update.ps1
kubectl -n arkmanager delete po arkmanager-0
Sleep 8
.${PWD}\asa\scripts\logs.ps1