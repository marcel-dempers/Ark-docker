
while ($True)
{
  kubectl -n arkmanager exec -it arkmanager-0 -- arkmanager status @all
  start-sleep 5
  clear
}