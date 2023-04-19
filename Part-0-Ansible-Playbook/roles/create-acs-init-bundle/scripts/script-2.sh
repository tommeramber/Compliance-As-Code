# Split the file to 3 seperated k8s secret yaml files, and remove the initial "---" from the last two so the Helm would work without problems in ArgoCD

#sed  "/sensor-key.pem/i  \ \ acs-host: $ROX_CENTRAL_ADDRESS:443" $(pwd)/init_bundle.yaml  -i

#csplit $(pwd)/init_bundle.yaml '/^---$/' '{*}' 
sed -i 's,^---$,,g' $(pwd)/xx01 
sed -i 's,^---$,,g' $(pwd)/xx02
sed -i '/^#/d' .$(pwd)/xx00 

### add namespace to all secret files
sed  '/metadata:/a  \ \ namespace: stackrox' $(pwd)/xx00 -i 
sed  '/metadata:/a  \ \ namespace: stackrox' $(pwd)/xx01 -i
sed  '/metadata:/a  \ \ namespace: stackrox' $(pwd)/xx02 -i


mv $(pwd)/{init_bundle.yaml,xx00,xx01,xx02} $(pwd)/../Part-2-Compliance-as-GitOps/policies/acs-policies/files


