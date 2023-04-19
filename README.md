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
1. SSH Clone (A must for the automation)

   1.1. Create SSH Key on you machine
   ```bash
   ssh-keygen
   cat ~/.ssh/id_rsa.pub
   ```
   
   1.2. Copy the public key and create new repo SSH key here - https://github.com/settings/ssh/new
   
   1.3. Clone the repo
   ```bash
   export USERNAME=<YOUR_GIT_REPO_USERNAME>
   git clone git@github.com:$USERNAME/Compliance-As-Code.git
   cd Compliance-As-Code
   export BASE=$(pwd)
   ```

   1.4. Change the Playbook to point to your git forked repo
   ```bash
   sed -i "s,tommeramber,$USERNAME,g" Part-0-Ansible-Playbook/playbook.yaml
   ```

2. Login to Hub cluster from your local machine
3. [Register/Import or provision Openshift clusters to ACM](https://www.youtube.com/watch?v=DId5fVzBv7E)
4. [Edit & Run the initation Ansible-Playbook](Part-0-Ansible-Playbook/README.md)
```bash
cd Part-0-Ansible-Playbook
ansible-playbook playbook.yaml
```

5. Login to the new ArgoCD instance and see that (almost) everything is ready

## How everything is installed on the managed clusters?
The ArgoCD is synced with our Git Repo, and it deploys ACM policies on ACM, they are based on ACM's built-in Governance feature.

ACM Policies defines for ACM what is the desired state of K8s objects on the managed clusters (or the Hub itself) and in case they are adsent - it (ACM) will create them on the relevant cluster. 

ACM relies on managed clusters labels to decide which policy should be installed on which cluster.

By integrate kyverno policies inside ACM policies, ACM deploys the kyverno policies compliance policies on the managed clusters that has kyverno installed.

### Label-to-Policy Legend
| Policy Name                                                                                                                                     | Explainer                                                                                                                                                | Requires Label                     | Type            | Source                                                                                                                                                            |
|-------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [Install Kyverno](Part-2-Compliance-as-GitOps/install-security-tools/templates/policy-install-kyverno.yaml)                                     | Install `kyverno` on the managed cluster/s                                                                                                               | `install-kyverno=true`             | ACM Policy      | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-install-kyverno.yaml)               |
| [Install Kyverno's Policy Reporter](Part-2-Compliance-as-GitOps/install-security-tools/templates/policy-install-kyverno-reporter.yaml)          | Install `policy-reporter UI` on the managed cluster/s                                                                                                    | `install-kyverno=true`             | ACM Policy      | Tommer Amber Original                                                                                                                                             |
| [Install ACS](Part-2-Compliance-as-GitOps/install-security-tools/templates/policy-acs-operator-central.yaml)                                    | Install ACS on Hub Cluster                                                                                                                               | None                               | ACM Policy      | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-acs-operator-central.yaml)          |
| [Link ACS to Managed Cluster](Part-2-Compliance-as-GitOps/policies/acs-policies/templates/policy-acs-operator-secured-clusters.yaml)            | Link ACS to all managed clusters, [requires a manual operation described here](Part-2-Compliance-as-GitOps/policies/acs-policies/README.md)              | None                               | ACM Policy      | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-acs-operator-secured-clusters.yaml) |
| [Etcd Backup](Part-2-Compliance-as-GitOps/policies/acm-policies/templates/policy-etcd-backup.yaml)                                              | Deploy a CronJob on that managed cluster that will backup Etcd periodically                                                                              | `etcd-backup=true`                 | ACM Policy      | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-etcd-backup.yaml)                   |
| [Etcd Encryption](Part-2-Compliance-as-GitOps/policies/acm-policies/templates/policy-enforce-etcd-encryption.yaml)                              | Enable `etcd encryption` for your cluster to provide an additional layer of data security (data at rest)                                                 | `enforce-etcd-encryption=true`     | ACM Policy      | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/stable/SC-System-and-Communications-Protection/policy-etcdencryption.yaml)       |
| [Validate Kyverno Reports](Part-2-Compliance-as-GitOps/install-security-tools/templates/policy-check-kyverno-policyreports.yaml)                | Display in ACM any drift from Kyverno policies on managed clusters                                                                                       | `install-kyverno=true`             | ACM Policy      | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-check-policyreports.yaml)           |
| [Disallow "Latest" Tag for a Pod](Part-2-Compliance-as-GitOps/policies/kyverno-policies/templates/policy-kyverno-disallow-latest-tag.yaml)      | Validates that the image specifies a tag and that it is not called `latest`. <br>* Requires Kyverno to be installed on the managed cluster.              | `kyverno-disallow-latest-tag=true` | Kyverno Policy  | [Link](https://kyverno.io/policies/best-practices/disallow_latest_tag/disallow_latest_tag/)                                                                       |
| [Add Quota by default to new Namespaces](Part-2-Compliance-as-GitOps/policies/kyverno-policies/templates/policy-kyverno-add-default-quota.yaml) | Control quota limits in new namespaces.<br>* Requires Kyverno to be installed on the managed cluster. <br> * Can be edited to allow namespace exceptions | `kyverno-add-default-quota=true`   | Kyverno Policy  | [Link](https://github.com/open-cluster-management-io/policy-collection/blob/main/stable/CM-Configuration-Management/policy-kyverno-add-quota.yaml)                |


## About ACS in this demo
This lab will install ACS for you on the ACM Hub.
It will also preper almost everything for auto importing of the mangaed clusters to the ACS complete scanning **BUT** you need to do one manual operation before that.
Read the instructions in [this page](Part-2-Compliance-as-GitOps/policies/acs-policies/README.md)
