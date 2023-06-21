# aws-terraform

## Infrastructure (Terraform Code)
This is an example of modular Terraform code to deploy resources include a VPC (Virtual Private Cloud), an ASG (Auto Scaling Group), and an ALB (Application Load Balancer) along with the existing compute instance resources on AWS using a GitHub Actions pipeline.

If you want to use this code Remember to modify the VPC CIDR block, subnet CIDR block, availability zone, min/max/desired capacity and other resource configurations in terraform.tfvars file based on your specific requirements.

## pipeline (Github Action)
The pipeline triggers on pushes to the main branch and pull requests targeting the main branch.
The pipeline consists of a single job named terraform that runs on an Ubuntu environment.
The steps of the job are as follows:
- Check out the repository using the actions/checkout action.
- Set up Terraform using the hashicorp/setup-terraform action. You can specify the desired Terraform version.
- Initialize Terraform by running terraform init.
- Validate the Terraform code by running terraform validate.
- Plan the Terraform changes and store the plan in a file named tfplan using terraform plan -out=tfplan.
- Apply the Terraform changes automatically (terraform apply -auto-approve tfplan) when a push event occurs on the main branch.