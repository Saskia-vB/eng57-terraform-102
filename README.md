# Terraform 101 :taco:

This repo and class we will explore terraform, a tool from Hashicorp. Terreform comes from the later of 'Terra' and 'forma' which means form / change. And means to create earth.

The naming convention is because the tool is used to orchestrate our infrastructure and is part of IAC (Infrastructure as Code).

IAC:
- Configuration Management tools
- Orchestration tools

### Configuration Management tools
Tools include Chef, puppet and Ansible
-> Helps us create imutable infrastructure
If we SSH into our testing server and install `sudo apt-get install type-script`
Now we need to do this all all our other machines.

If we have something, like a play or some type of configuration management tool, then we can make this change more imutable and it will be easier to replicate everywhere.

The idea is you should be able to terminate a machine, run a scrip and endup exactly at the same location / state as the previous machine.

A tool that help you do this is a configuration management tools.

--> end game should be a AMI of some sort.

### Orchestration tools
Terraform, AWScloudformation and other.

This will create the infrastructure, not only the specific machine, but the networking, security, monitoring and all the the setup around the machine that creates a production environment.


Example usage:
1) Terraform creates VPC
2) creates two subnets
3) Adds rules and security
4) Deploys AMIs and runs scripts



Example usage:
1) Automation server gets triggered
2) Test are run in machine created from AMI (configuration)
3) Passing test trigger next step on automation server
4) New AMI is created with previous AMI + new code
5) Success full creation triggers next step in automation server
6) Calls terraform script to create infrastructure and deploy new AMI (with new code)


The conjuntion of the two, allows us to define our infrastructure as code.

Along with Version control - such as git; and cloud providers, it all allows us to maintain and manipulate infrastructure in ways that where not possible beffore.

### Terraform terminology & commands

Terraform will work with a cloud provider.
You will need programatic access and api keys.

Set these in your enviroment variables using the correct naming conventions.

#### Terminology

- providers
- resources
  - ec2
- variables

#### Commands

- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`
- `terraform refresh``

### Creating modules
#### Structure
- Modules
  - app_tier
    - main.tf
    - outputs.tf
    - variables.tf
  - db_tier
    - main.tf
    - outputs.tf
    - variables.tf
##### Call modules
- in general main.tf file:

``terraform
module "app_tier" {
  source = "./modules/app_tier"
  vpc_id = aws_vpc.mainvpc.id
  name = var.name
  my-ip = var.my-ip
  internet_gateway_id = aws_internet_gateway.gw.id
  #db_private_ip = aws_instance.db.private_ip
  db_private_ip = module.db_tier.db_private_ip
  ami-web = var.ami-web
  ssh_key_var = var.ssh_key
}
``
