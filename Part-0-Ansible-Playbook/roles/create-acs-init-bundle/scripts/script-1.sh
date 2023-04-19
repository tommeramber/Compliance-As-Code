export ROX_CENTRAL_ADDRESS=""
export PASS=""
export PASS=$(oc -n stackrox extract secret/central-htpasswd --to=- | tail -n 1)
export ROX_CENTRAL_ADDRESS=$(oc get route -n stackrox central -o jsonpath='{.spec.host}')

/tmp/roxctl -e "$ROX_CENTRAL_ADDRESS":443 central init-bundles generate init_bundle  --output-secrets $(pwd)/init_bundle.yaml --insecure-skip-tls-verify --password $PASS

sed  "/sensor-key.pem/i  \ \ acs-host: $ROX_CENTRAL_ADDRESS" $(pwd)/init_bundle.yaml  -i

