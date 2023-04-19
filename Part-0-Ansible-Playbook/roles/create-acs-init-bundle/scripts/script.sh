export PASS=$(oc -n stackrox extract secret/central-htpasswd --to=- | tail -n 1)
export ROX_CENTRAL_ADDRESS=$(oc get route -n stackrox central -o jsonpath='{.spec.host}')

/tmp/roxctl -e "$ROX_CENTRAL_ADDRESS":443 central init-bundles generate init_bundle  --output $(pwd)/init_bundle.yaml --insecure-skip-tls-verify --password $PASS

# Split the file to 3 seperated k8s secret yaml files, and remove the initial "---" from the last two so the Helm would work without problems in ArgoCD

sed  "/sensor-key.pem/i  \ \ acs-host: $ROX_CENTRAL_ADDRESS=" $(pwd)/init_bundle.yaml  -i

#csplit $(pwd)/init_bundle.yaml '/^---$/' '{*}' 
#sed -i 's,^---$,,g' $(pwd)/xx01 
#sed -i 's,^---$,,g' $(pwd)/xx02
#sed -i '/^#/d' .$(pwd)/xx00 
#
#### add namespace to all secret files
#sed  '/metadata:/a  \ \ namespace: stackrox' $(pwd)/xx00 -i 
#sed  '/metadata:/a  \ \ namespace: stackrox' $(pwd)/xx01 -i
#sed  '/metadata:/a  \ \ namespace: stackrox' $(pwd)/xx02 -i



