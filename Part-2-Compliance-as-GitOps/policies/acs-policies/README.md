# Before apply any ACS related policies
You need to link the managed clusters with ACS for remote management. 
This operation requires a single manual operation - generate init bundle in the ACS UI;
Afterwards, you can sync the `policy-acs-operator-secured-clusters` YAML (based on [upstream](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-acs-operator-secured-clusters.yaml))

## Manual Operation - Generate ACS init bundle
1. Login to ACS UI
```bash
oc get route -n stackrox central | awk '{print "https://"$2}' | tail -n 1
oc get secret -n stackrox central-htpasswd -ojsonpath='{.data.password}' | base64 --decode ; echo
```

2. Go to `Integrations` => Scroll down to the `Authentication Tokens` category, and click `Cluster Init Bundle`.
![image](https://user-images.githubusercontent.com/60185557/231579759-001efd75-c46f-4362-8b60-d6f136fa589a.png)


2. Click `Generate Bundle`.

![image](https://user-images.githubusercontent.com/60185557/231580469-9ff40eb4-4ad2-4a3b-876e-c3524c291160.png)


3. Enter a name for the token and click `Generate`.
![image](https://user-images.githubusercontent.com/60185557/231581273-86659f28-4b61-4540-8341-32ca7f154da3.png)


4. Click `Download Kubernetes secrets file`.
![image](https://user-images.githubusercontent.com/60185557/231582873-abe23f62-ce13-448a-b3e7-d03326402f9b.png)

5. Add the secrets file to you forked git repo directory, split it to single k8s secret yaml files and commit the change
```bash
cp ~/Downloads/<INIT_BUNDLE_SECRETS_FILE>.yaml ~/<PATH_TO_FORKED_REPO>/Part-2-Compliance-as-GitOps/policies/acs-policies/files/init-bundle.yaml
git add ~/<PATH_TO_FORKED_REPO>/Part-2-Compliance-as-GitOps/policies/acs-policies/files/init-bundle.yaml

csplit init-bundle.yaml '/^---$/' '{*}'

git commit -m "acs init bundle"
git push
```

> ArgoCD will automaticly detect the change in the git repo and sync the change which will cause ACM to apply the yaml file unto the managed clusters automaticly.

* Based on [Documentation](https://docs.openshift.com/acs/3.74/cli/getting-started-cli.html#cli-authentication_cli-getting-started)
