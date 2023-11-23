#!/bin/bash

getAllInstanceNames() {
 for f in /etc/arkmanager/instances/*.cfg; do
   if [ -f "${f}" ]; then
     instancename="${f##*/}"
     instancename="${instancename%.cfg}"
     echo $instancename


   fi
 done
}

runCommand() {
  cmd=$1
  instance=$2
  params=$3

  if [ -f "/etc/arkmanager/instances/${instance}.cfg" ]; then
    set -o allexport
    source "/etc/arkmanager/instances/${instance}.cfg"
    set +o allexport
    
    echo "running command ${cmd} on ${instance} with params: ${params}"
    /usr/local/bin/arkmanager.${cmd} ${instance} ${params}
  else
    echo "instance ${instance} does not exist"
  fi
}

runCommandOnInstance() {
  cmd=$1
  instance=$2
  params=$3
  
  if [ -z "$instance" ]
  then
    echo "must supply instance, e.g @island, or @all for all instances"
    exit
  fi

  if [ -z "$cmd" ]
  then
    echo "you must provide a command"
  exit
  fi

  instance="${instance:1}"

  if [ "$instance" = "all" ]; then
    for n in $(getAllInstanceNames); do
    (
      runCommand ${cmd} ${n} ${params}
    )
    done
  else
    runCommand ${cmd} ${instance} ${params}
  fi
}