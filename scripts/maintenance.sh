active_instances="@ragnarok1"
instances=$(su -p -c "arkmanager list-instances" steam | grep -o -P '(?<=@).*(?=:)')
echo "instances: "
echo "$instances"

# for active_instance in ${active_instances//,/ }
# do
#   su -p -c "arkmanager broadcast ${active_instance} 'Server shutting down soon for maintenance!'" steam
# done

while IFS= read -r instance; do
  instance="@$instance"
  echo "performing maintenance on: ${instance} ..."
  arkmanager notify ${instance} 'preparing instance for patching...'

  echo "starting: ${instance} ..."
  su -p -c "arkmanager start ${instance}" steam
  
  #################################
  echo "waiting: ${instance} ..."
  instance_status=
  instance_status=$(su -p -c "arkmanager status ${instance}" steam | grep "Server online:" | grep "Yes")
  while [ -z "${instance_status}" ]; do
    echo "waiting: ${instance} ..."
    instance_status=$(su -p -c "arkmanager status ${instance}" steam | grep "Server online:" | grep "Yes")
    sleep 20
  done
  echo "${instance}: ${instance_status}"
  #################################
  
  echo "saving: ${instance} ..."
  su -p -c "arkmanager saveworld ${instance}" steam

  echo "backup: ${instance} ..."
  su -p -c "arkmanager backup ${instance}" steam

  echo "stop: ${instance} ..."
  su -p -c "arkmanager stop ${instance}" steam

done <<< "$instances"

echo "updating..."
arkmanager update @ragnarok1 --force --update-mods --no-autostart

for active_instance in ${active_instances//,/ }
do
  echo "starting: ${active_instance}"
  su -p -c "arkmanager start ${active_instance}" steam
done