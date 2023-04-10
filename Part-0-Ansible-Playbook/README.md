# Part 0 - Lab initation with Ansible Playbook

## Edit & Run the Ansible-Playbook 
1. Change the `git_repo` to point to your forked git repo project
```bash
cd Part-0-Ansible-Playbook
sed -i 's,https://github.com/tommeramber/Compliance-As-Code.git,https://github.com/<YOUR_USERNAME>/Compliance-As-Code.git,g' playbook.yaml
```
2. Run the Playbook
```bash
ansible-playbook playbook.yaml
```
3. Git add, commit and push all of your changes so ArgoCD will see the new `ArgoCD Applications` and `ArgoCD ApplicationSets` that are in your forked repo
```bash
git add --all :/
git commit -m "updated yamls"
git push
```

## Explainer
The Ansible playbook will install the `Openshift-GitOps` operator on the ACM Hub Cluster, create an ArgoCD instance that we will use to apply our policies, and will grant it all required privileges. 

This playbook will also link the ArgoCD instance to all of the managed clusters in the ACM Hub (using the built-in `global` `ManagedClusterSet`) and will link the ArgoCD instance to our Git repo with the relevant yamls.

* [Based on the following documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html-single/applications/index#gitops-config) and [upstream example](https://github.com/stolostron/multicloud-integrations/tree/main/examples/openshift-gitops)

And finally, this playbook will generate the app-of-apps gitops yaml files for us based on your forked git repo URL; It will generate the initial `ArgoCD Application` that will point ArgoCD to all of our `ArgoCD ApplicationSets` - that will deploy everything on the ACM Hub Cluster for us automaticly. The ArgoCD ApplicationSets also requires a git repo url so they are too auto-generated for you by the ansible playbook with your forked project as the git repo. 

Note that the ArgoCD app-of-apps also generates an ArgoCD Application that points to all of the yamls that are related to the integration between ACM and the Openshift-Gitops operator so our ArgoCD instanace literaly manages itself as well.

[Back To Home](../README.md)


