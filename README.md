# INFRASTRUCTURE AS CODE - DEPLOY WEBAPP USING AZURE
----------

# TABLE OF CONTENT

## CHAPTER 1	OBJECTIVES	1
    1.1	Infrastructure Deployment requirements	1
    1.2	CI/CD Tools Deployment requirements	1
    1.3	Configuration requirements	1
    1.4	Microservice/Application Deployment requirements	1
    1.5	New Relic Deployment requirements	1

## CHAPTER 2	INTRODUCTION	2
    2.1	Get Started	2
    2.2	Prerequisites	3

## CHAPTER 3	HOW TO DEPLOY	6
    3.1	Create main.tf	6
    3.2	File Separation	7
    3.3	Create Terraform Module	10
    3.4	Create Inventory & Playbook	11
    3.5	Create Ansible Role Docker, Jenkins, Gitlab	13
    3.6	Create a connection to ansible	14
    3.7	Output	15

## CHAPTER 4	TROUBLESHOOTING	17
    4.1	Troubleshooting in ansible	17
    4.2	Troubleshooting in Azure-CLI	17
    4.3	Troubleshooting in AKS	19
    4.4	Troubleshooting in Helm Chart	19
    
 
CHAPTER 1 	OBJECTIVES
	In my project. I will use terraform and ansible to build an infrastructure as code and deploy infrastructure in Azure Cloud
1.1	Infrastructure Deployment requirements
1.	Azure Virtual Machine: provision (Terraform CLI, AWX – Ansible Tower, Jenkins, Gitlab CE) 
2.	Azure Application Gateway
3.	Azure Web Application Firewall (WAF)
4.	Azure Load Balancer
5.	Azure Kubernetes Service (AKS) – Setup scale set
1.2	CI/CD Tools Deployment requirements
1.	Install Terraform CLI and use it to build Infrastructure As Code
2.	Deploy gitlab CE
3.	Deploy Jenkins Server – Jenkins Slave
1.3	Configuration requirements
1.	Configure Terraform to deploy Infrastructure As Code
2.	Configure Ansible to install tools (Jenkins, Gitlab, etc.) on Virtual Machine 
3.	At Frontend Gitlab repository, add Jenkinsfile file to automate build and deployments. Apply for master branch with released tag.
4.	At Backend Gitlab repository, add Jenkinsfile to automate build and deployments. Apply for master branch with released tag.
5.	Configure NGINX to listen http/https protocol. 
6.	Configure TLS/SSL
7.	Configure NGINX to allow http/https protocol access via any IP
8.	Configure Jenkins Server connect Jenkins Slave
1.4	Microservice/Application Deployment requirements
1.	Deploy postgres
2.	Deploy phppgadmin
3.	Deploy Frontend (Angular)
4.	Deploy Backend (Nodejs)
1.5	New Relic Deployment requirements
1.	Deploy New Relic Infra Agent
2.	Deploy New Relic Logging Agent
3.	Deploy New Relic APM Agent


 
## CHAPTER 2 	INTRODUCTION 
### 2.1	Get Started
    This assignment includes 5 main components: 
        1.	Setup Enviroments
        2.	Microservice/Application Deployment
        3.	CI/CD Jenkins & Ingress
        4.	Deploy in Azure Cloud
        5.	New Relic Deployment

    Architecture of assignment:
![image](https://user-images.githubusercontent.com/98753976/162356085-78145619-a5b5-4683-9928-d93de956b78d.png)


 
### 2.2	Prerequisites
### 2.2.1	Software version information
![image](https://user-images.githubusercontent.com/98753976/162356069-a596669c-1a6e-4cbc-8397-786766450940.png)


### 2.2.2	Install Ansible, Terraform and AzureCLI
    First of all, we will install AzureCLI, Ansible and Terraform using documentation below:
    1.	https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
    2.	https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
    3.	https://learn.hashicorp.com/tutorials/terraform/install-cli
    
### 2.2.3	Setup Environments
### 2.2.3.1	Login to Azure
	Run the following command to log into Azure:
o	az login


### 2.2.3.2	Terraform Init
	Run the following command to init terraform:
o	terraform init

### 2.2.3.3	Set host_key_checking=false in ansible inventory file
	Ansible has host key checking enabled by default.
	If a host is reinstalled and has a different key in ‘known_hosts’, this will result in an error message until corrected. If a host is not initially in ‘known_hosts’ this will result in prompting for confirmation of the key, which results in an interactive experience if using Ansible, from say, cron. You might not want this.
	If you understand the implications and wish to disable this behavior, you can do so by editing /etc/ansible/ansible.cfg or ~/.ansible.cfg:
o	[defaults]
o	host_key_checking = False
	Alternatively this can be set by the ANSIBLE_HOST_KEY_CHECKING environment variable:
o	$ export ANSIBLE_HOST_KEY_CHECKING=False
	Also note that host key checking in paramiko mode is reasonably slow, therefore switching to ‘ssh’ is also recommended when using this feature.
	Ansible will log some information about module arguments on the remote system in the remote syslog, unless a task or play is marked with a “no_log: True” attribute. This is explained later.
	To enable basic logging on the control machine see Configuring Ansible document and set the ‘log_path’ configuration file setting. Enterprise users may also be interested in Ansible Tower. Tower provides a very robust database logging feature where it is possible to drill down and see history based on hosts, projects, and particular inventories over time –
 


