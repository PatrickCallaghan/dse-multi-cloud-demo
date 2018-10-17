#!/bin/bash

usage="--------------------------------------------------------------------------
Deploys vms in GCP based on parameters in ./gcp/clusterParameters.yaml
using Google Deployment Manager (deployment-manager).

Usage:
deploy.sh [-h] [-d deployment-name]

Options:

 -h       : display this message and exit
 -d		    : name of GCP gcloud deployment [required]

--------------------------------------------------------------------------"

while getopts 'hd:' opt; do
  case $opt in
    h) echo -e "$usage"
       exit 0
    ;;
    d) deploy="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        exit 1
    ;;
  esac
done

echo "Deploying 'clusterParameters.yaml' in GCP gcloud deployment: $deploy"
gcloud deployment-manager deployments create $deploy --config ./iaas/gcp/clusterParameters.yaml

# gather the IP addresses and store them in the main directory file
./iaas/gather_ips.sh -d $deploy >> $deploy
