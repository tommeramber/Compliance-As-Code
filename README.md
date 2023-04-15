# Intro
This lab has been created for RH Summit 2023 Compliance-as-code interactive session by [Tommer Amber](https://www.linkedin.com/in/tommeramber/?originalSubdomain=il). 

This session provides a demonstration of how to manage compliance policies for multiple Kubernetes clusters across disciplines, including configuration management, image vulnerability detection, continuous integration and continuous delivery (CI/CD) pipelines, and cluster misconfiguration mutation. During this session, you’ll get an overview of how to use with Red Hat Advanced Cluster Management for Kubernetes, Red Hat Advanced Cluster Security for Kubernetes, ArgoCD, and Kyverno to:

* Design end-to-end solutions for multicloud environments.
* Manage Red Hat OpenShift (Kubernetes) clusters using GitOps.
* Implement security best practices in Red Hat OpenShift and Kubernetes.
* Deploy and manage popular open source tools for microservices and security.

## Prerequisits
0. ACM Hub Cluster available
1. Install:
    - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    - [Helm](https://helm.sh/docs/intro/install/)
    - [Python3](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/assembly_installing-and-using-python_configuring-basic-system-settings)
    - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
    - [Ansible module for kubernetes](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/index.html#plugins-in-kubernetes-core) - ```ansible-galaxy collection install kubernetes.core``` 
    - [Relevant python modules](https://stackoverflow.com/questions/60866755/ansible-k8s-module-failed-to-import-the-required-python-library-openshift-on) - ```pip3 install openshift pyyaml kubernetes --user```
    - [oc](https://console.redhat.com/openshift/downloads)

## HowTo
0. Fork this project
1. Clone
```bash
git clone https://github.com/<YOUR_USERNAME>/Compliance-As-Code.git
cd Compliance-As-Code
export BASE=$(pwd)
```
2. Login to Hub cluster from your local machine
3. [Register/Import or provision Openshift clusters to ACM](https://www.youtube.com/watch?v=DId5fVzBv7E)
4. [Edit & Run the initation Ansible-Playbook](Part-0-Ansible-Playbook/README.md) + git push the changes
5. Login to the new ArgoCD instance and see that (almost) everything is ready

## How everything is installed on the managed clusters?
The ArgoCD is synced with our Git Repo, and it deploys ACM policies on ACM, they are based on ACM's built-in Governance feature.

ACM Policies defines for ACM what is the desired state of K8s objects on the managed clusters (or the Hub itself) and in case they are adsent - it (ACM) will create them on the relevant cluster. 

Several examples on how this being used in this lab:
1. Install kyverno on the managed clusters that includes the `install-kyverno=true` label in the ACM Hub + kyverno `policy-reporter UI` for better observability.
2. Install ACS on the Hub cluster itself.
3. Install "pure" ACM compliance policies on the managed clusters such as encypt the etcd.
4. By integrate kyverno policies inside ACM policies, ACM deploys the kyverno policies compliance policies on the managed clusters that has kyverno installed.


## About ACS in this demo
This lab will install ACS for you on the ACM Hub.
It will also preper almost everything for auto importing of the mangaed clusters to the ACS complete scanning **BUT** you need to do one manual operation before that.
Read the instructions in [this page](Part-2-Compliance-as-GitOps/policies/acs-policies/README.md)