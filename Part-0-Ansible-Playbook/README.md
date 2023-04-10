# Part 0 - Lab initation with Ansible Playbook

## Edit the Ansible-Playbook vars
1. Change the `git_repo` to point to your forked git repo project
```bash
cd Part-0-Ansible-Playbook
sed -i 's,https://github.com/tommeramber/Compliance-As-Code.git,https://github.com/<YOUR_USERNAME>/Compliance-As-Code.git,g' playbook.yaml
```

## Explainer
The Ansible playbook will install the `Openshift-GitOps` operator on the ACM Hub Cluster, create an ArgoCD instance that we will use to apply our policies, and will grant it all required privileges. 

This playbook will also link the ArgoCD instance to all of the managed clusters in the ACM Hub and will link the ArgoCD instance to our Git repo with the relevant yamls.

* [Based on the following documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html-single/applications/index#gitops-config) and [upstream example](https://github.com/stolostron/multicloud-integrations/tree/main/examples/openshift-gitops)

[Back To Home](../README.md)


