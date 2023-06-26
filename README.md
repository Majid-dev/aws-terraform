# AWS-Terraform

![Untitled Diagram drawio](https://github.com/Majid-dev/aws-terraform/assets/43570120/02f43937-37d5-49a0-b02a-7fa43ebdb6fd)

## Three-Tier Architecture
The three-tier architecture is the most popular implementation of a multi-tier architecture and consists of a single presentation tier, logic tier, and data tier. This sample project shows an example of a simple, generic three-tier application that is writen by terraform to deploy resources include a VPC (Virtual Private Cloud), an ASG (Auto Scaling Group), and an ALB (Application Load Balancer) along with the existing compute instance resources on AWS whit help of a GitHub Actions pipeline.
If you want to use this code Remember to modify the VPC CIDR block, subnet CIDR block, availability zone, min/max/desired capacity and other resource configurations in terraform.tfvars file based on your specific requirements.

## Pipeline (Github Action)
The pipeline triggers on pushes to the main branch and pull requests targeting the main branch.
The pipeline consists of a single job named terraform that runs on an Ubuntu environment.
The steps of the job are as follows:
- Check out the repository using the actions/checkout action.
- Set up Terraform using the hashicorp/setup-terraform action. You can specify the desired Terraform version.
- Initialize Terraform by running terraform init.
- Validate the Terraform code by running terraform validate.
- Plan the Terraform changes and store the plan in a file named tfplan using terraform plan -out=tfplan.
- Apply the Terraform changes automatically (terraform apply -auto-approve tfplan) when a push event occurs on the main branch.
