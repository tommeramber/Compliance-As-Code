# Intro
This lab has been created for RH Summit 2023 Compliance-as-code interactive session by [Tommer Amber](https://www.linkedin.com/in/tommeramber/?originalSubdomain=il). 

This session provides a demonstration of how to manage compliance policies for multiple Kubernetes clusters across disciplines, including configuration management, image vulnerability detection, continuous integration and continuous delivery (CI/CD) pipelines, and cluster misconfiguration mutation. During this session, you’ll get an overview of how to use with Red Hat Advanced Cluster Management for Kubernetes, Red Hat Advanced Cluster Security for Kubernetes, ArgoCD, and Kyverno to:

* Design end-to-end solutions for multicloud environments.
* Manage Red Hat OpenShift (Kubernetes) clusters using GitOps.
* Implement security best practices in Red Hat OpenShift and Kubernetes.
* Deploy and manage popular open source tools for microservices and security.

## Prerequisits
0. Fork this project + `git clone` it locally
1. Install:
    - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - [Helm](https://helm.sh/docs/intro/install/)
    - [Python3](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/assembly_installing-and-using-python_configuring-basic-system-settings)
    - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
    - [Ansible module for kubernetes](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/index.html#plugins-in-kubernetes-core) - ```ansible-galaxy collection install kubernetes.core``` 
    - [Relevant python modules](https://stackoverflow.com/questions/60866755/ansible-k8s-module-failed-to-import-the-required-python-library-openshift-on) - ```pip3 install openshift pyyaml kubernetes --user```
    - [oc](https://console.redhat.com/openshift/downloads)

2. ACM Hub Cluster available
3. Login to Hub cluster from your local machine
4. [Register/Import or provision Openshift clusters](https://www.linkedin.com/in/tommeramber/?originalSubdomain=il)

# HOWTO
## [Part 0 - Lab initation with Ansible Playbook](Part-0-Ansible-Playbook/README.md)
The Ansible playbook will install the `Openshift GitOps` operator on the ACM Hub Cluster, create an ArgoCD instance that we will use to apply our policies, and will grant it all required privileges. 

This playbook will also link the ArgoCD instance to all of the managed clusters in the ACM Hub and will link the ArgoCD instance to our Git repo with the relevant yamls.

* [Based on the following documentation](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html-single/applications/index#gitops-config) and [upstream example](https://github.com/stolostron/multicloud-integrations/tree/main/examples/openshift-gitops)

