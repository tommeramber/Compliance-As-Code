# Part 1 - App-of-Apps
## On the previous episodes of this demo
So in the first Part of the lab, our Ansible Automation generated all the YAMLs for our compliance-as-code project.

As you can see in this directory's content, this is actually an Helm Chart.

## Behind the magic
Our Ansible Automation "manually" applyed the initial [app-of-apps YAML file](../Part-0-Ansible-Playbook/roles/deploy-app-of-apps/yamls/app.yaml) on our ACM Openshift-GitOps namespace.

This YAML points our ArgoCD instance to look at this Helm Chart directory in the git repo (in your case it's the forked repo), and from that point forward ArgoCD will apply all the other YAMLs for us.

## So what's up with all the "app-of-apps"?
This Helm Chart directory actually holds `ArgoCD Applications` & `ApplicationSets`, that once applied (by our ArgoCD itself after the initial app-of-apps creation by the Ansible Automation) - will generate all the YAMLs in the [Part-2-Compliance-as-GitOps](../Part-2-Compliance-as-GitOps/) directory one by one:


| Policy Name                                                                     | Explainer                                                                                                                                                                                                                           | Created by                                                      |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| [install-security-tools](../Part-2-Compliance-as-GitOps/install-security-tools) | 1. Install `ACS` on ACM  <br>2. Install `Kyverno` + `Policy-Reporter` (Kyverno UI) on all managed clusters with the label `"install-kyvenro=true"`                                            | [ArgoCD Application](templates/app-install-security-tools.yaml) |
| [acm-policies](../Part-2/-Compliance-as-GitOps/policies/acm-policies)           | Install our ACM-natvie custom policies that ACM uses to enforce/inform roles on the managed clusters                                                                                                                                |                                                                |
| [acs-policies](../Part-2/-Compliance-as-GitOps/policies/acs-policies)           | Import our ACS-native custom Policies into the installed ACS                                                                                                                                                                        |                                                                 |
| [kyverno-policies](../Part-2/-Compliance-as-GitOps/policies/kyverno-policies)   | Apply our Kyverno-k8s-native custom policies that will be installed on our managed clusters that has a specific label. You can see the required label in the [README.md](../Part-2/-Compliance-as-GitOps/policies/kyverno-policies) |                                                                 |
| acm-argo-objects                                                                | Link the YAMLs our Ansible Automation generated  & applied to link between our ACM and ArgoCD instance; From that point our ArgoCD literally manages itself and every change to our Argo instance will be applied by our ArgoCD     | [ArgoCD Application ](templates/app-acm-argo-objects.yaml       )                                                        |
