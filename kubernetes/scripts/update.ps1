$ENV:KUBECONFIG="$HOME\.kube\marceldempers-v3"

kubectl -n arkmanager exec -it arkmanager-0 -- bash -c "arkmanager update @island"


# if you see "Error! App '2430930' state is 0x6 after update job."
# try this before updating:  rm -rf /ark/steamapps/appmanifest_2430930.acf 