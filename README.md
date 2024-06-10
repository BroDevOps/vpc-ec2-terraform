# vpc-ec2-terraform

**Download Terraform 
**


sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

sudo apt update

sudo apt-get install terraform



**Verify Dry Run 
**


terraform plan
terraform validate

**Execution
**


terraform apply
