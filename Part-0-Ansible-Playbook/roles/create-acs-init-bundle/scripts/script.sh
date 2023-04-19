export PASS=$(oc -n stackrox extract secret/central-htpasswd --to=- | tail -n 1)
export ROX_CENTRAL_ADDRESS=$(oc get route -n stackrox central -o jsonpath='{.spec.host}')

/tmp/roxctl -e "$ROX_CENTRAL_ADDRESS":443 central init-bundles generate init_bundle  --output ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/init_bundle.yaml --insecure-skip-tls-verify --password $PASS

# Split the file to 3 seperated k8s secret yaml files, and remove the initial "---" from the last two so the Helm would work without problems in ArgoCD

ACS_HOST="$(oc get route -n stackrox central | awk '{print $2}' | tail -n 1):443"
sed  "/sensor-key.pem/i  \ \ acs-host: $ACS_HOST" ../Part-2-Compliance-as-GitOps/policies/acs-policies/files/init_bundle.yaml  -i

#csplit ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/init_bundle.yaml '/^---$/' '{*}' 
#sed -i 's,^---$,,g' ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/xx01 
#sed -i 's,^---$,,g' ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/xx02
#sed -i '/^#/d' ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/xx00 
#
## add namespace to all secret files
#sed  '/metadata:/a  \ \ namespace: stackrox' ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/xx00 -i 
#sed  '/metadata:/a  \ \ namespace: stackrox' ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/xx01 -i
#sed  '/metadata:/a  \ \ namespace: stackrox' ../../../../Part-2-Compliance-as-GitOps/policies/acs-policies/files/xx02 -i
#


