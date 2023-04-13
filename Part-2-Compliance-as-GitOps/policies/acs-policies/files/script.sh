# Split the file to 3 seperated k8s secret yaml files, and remove the initial "---" from the last two so the Helm would work without problems in ArgoCD

ACS_HOST="$(oc get route -n stackrox central | awk '{print $2}' | tail -n 1):443"
sed  "/sensor-key.pem/i  \ \ acs-host: $ACS_HOST" init-bundle.yaml  -i


csplit init-bundle.yaml '/^---$/' '{*}' 
sed -i 's,^---$,,g' xx01 
sed -i 's,^---$,,g' xx02
sed -i '/^#/d' xx00 

# add namespace to all secret files
sed  '/metadata:/a  \ \ namespace: stackrox' xx00 -i 
sed  '/metadata:/a  \ \ namespace: stackrox' xx01 -i
sed  '/metadata:/a  \ \ namespace: stackrox' xx02 -i



