# Part 0 - Lab initation with Ansible Playbook

## Explainer
The Ansible playbook will install the `Openshift-GitOps` operator on the ACM Hub Cluster, create an ArgoCD instance that we will use to apply our policies, and will grant it all required privileges. 

This playbook will also link the ArgoCD instance to all of the managed clusters in the ACM Hub (using the built-in `global` `ManagedClusterSet`) and will link the ArgoCD instance to our Git repo with the relevant yamls.

* [Based on the following documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html-single/applications/index#gitops-config) and [upstream example](https://github.com/stolostron/multicloud-integrations/tree/main/examples/openshift-gitops)

And finally, this playbook will generate the app-of-apps gitops yaml files for us based on your forked git repo URL; It will generate the initial `ArgoCD Application` that will point ArgoCD to all of our `ArgoCD ApplicationSets` - that will deploy everything on the ACM Hub Cluster for us automaticly. The ArgoCD ApplicationSets also requires a git repo url so they are too auto-generated for you by the ansible playbook with your forked project as the git repo. 

Note that the ArgoCD app-of-apps also generates an ArgoCD Application that points to all of the yamls that are related to the integration between ACM and the Openshift-Gitops operator so our ArgoCD instanace literaly manages itself as well.

# Manual Operations

![image](https://user-images.githubusercontent.com/60185557/231435160-1a3ec640-c63a-4b49-8781-6ddc403b5b4d.png)


![image](https://user-images.githubusercontent.com/60185557/231435268-03541753-3d85-4b62-8103-0e615950086a.png)

# Automation (after editing the Playbook Variables)

![image](https://user-images.githubusercontent.com/60185557/231435450-151e1246-693b-424c-be3b-481ad83af415.png)

![image](https://user-images.githubusercontent.com/60185557/231438966-913e4112-2efb-46b8-a898-413f91220a02.png)

![image](https://user-images.githubusercontent.com/60185557/231439012-fd8eafab-a489-4709-b107-293057eab8f6.png)

![image](https://user-images.githubusercontent.com/60185557/231439068-ff19485a-119b-4087-b034-dc7ee1b9572b.png)


# [Back To Home](../README.md)


## Cool for Geeks
### Ansible templating & Helm YAML double curly braces escaping
When creating this lab with ansible as the initiation tool, I came across a problem; 
I wanted to make the project as generic as possiable, so I based the yaml files creation on Ansible templateing - they can be found [here](roles/deploy-app-of-apps/templates/). This is not a problem in most cases, but I also use argocd application/applicationset objects inside of helm chart - both are using curly braces as part of their mechanisem; To escape the issue I figured I need to use escaping methods for both mechanisems. 

If you would take a look in [this template file](roles/deploy-app-of-apps/templates/applicationset-policies.yaml.j2) you will see the following line:

```
{% raw %}path: {{`'{{path}}'`}}{% endraw %}
```

This line in a standard ApplicationSet object should look like that:
```path: '{{path}}'```

So what did I do to make it work?
1. ```{%raw%} + {%endraw%}``` + newline == Ansible template escape from rendering the "{{ }}"
2. ```{{` + `}}``` == Helm escape from rendering the "{{ }}"

So as you can see in the recorded demo, when ArgoCD fetches the helm chart and renders it after the ansible playbook generated it, the line is perfectly as we wanted it to be.
