
while ($True)
{
  kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status @arkmanager-island
  kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status @arkmanager-se
  start-sleep 5
  clear
}