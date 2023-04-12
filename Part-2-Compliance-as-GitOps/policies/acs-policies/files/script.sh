# Split the file to 3 seperated k8s secret yaml files, and remove the initial "---" from the last two so the Helm would work without problems in ArgoCD
csplit init-bundle.yaml '/^---$/' '{*}' 
sed -i 's,^---$,,g' xx01 
sed -i 's,^---$,,g' xx02

# add namespace to all secret files
sed  '/metadata:/a  \ \ namespace: stackrox' xx00 -i 
sed  '/metadata:/a  \ \ namespace: stackrox' xx01 -i
sed  '/metadata:/a  \ \ namespace: stackrox' xx02 -i

