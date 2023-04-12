# Before apply any ACS related policies
You need to link the managed clusters with ACS for remote management. 
This operation requires a single manual operation - generate init certificates in the ACS UI;
Afterwards, you can sync the `policy-acs-operator-secured-clusters` YAML (based on [upstream](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-acs-operator-secured-clusters.yaml))

## Manual Operation - Generate ACS sensors init-certificates



* Based on [Documentation](https://docs.openshift.com/acs/3.74/cli/getting-started-cli.html#cli-authentication_cli-getting-started)