
# init-ec2-train 🚀

This repository contains an Infrastructure as Code (IaC) project using **Terraform** to automatically provision a secure Ubuntu virtual machine (EC2 instance) on AWS. It was created as a training project to learn Terraform, AWS provisioning, and security best practices.

## 📁 Project Structure

This project is organized into modular `.tf` files to keep the code clean and professional:

* `main.tf` - The core builder file where all AWS resources are defined.
* `variables.tf` - The configuration file for input variables.
* `outputs.tf` - The configuration file for what prints to the terminal after creation.
* `.gitignore` - Security file to prevent uploading sensitive Terraform states or configurations to GitLab.

---

## 🚀 Getting Started (After Git Clone)

If you just cloned this repository onto a new machine, follow these steps to initialize and deploy the infrastructure:

### 1. Enter the Project Folder
```bash
cd init-ec2-train

```

### 2. Export Your AWS Credentials

Terraform needs temporary environment variables to authenticate with your AWS account. Run these commands in your terminal, replacing the placeholders with your actual keys:

```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"

```

*(Note: If you are using an AWS Academy/Student account, remember to also export your `AWS_SESSION_TOKEN` if provided).*

### 3. Initialize Terraform

Since the `.terraform` plugin directory is ignored by Git, you must download the provider plugins locally:

```bash
terraform init

```

### 4. Review the Deployment Plan

Verify what resources Terraform intends to create in your cloud environment:

```bash
terraform plan

```

### 5. Deploy the Infrastructure

Apply the configuration to spin up the EC2 instance on AWS (type `yes` when prompted):

```bash
terraform apply

```

---

## 🛠️ Detailed File Breakdown

### 1. `main.tf` (The Core Infrastructure)

This file connects to AWS and builds the resources step-by-step.

* **`provider "aws"`**: Connects to Amazon Web Services using the region specified in our variables.
* **`resource "random_pet" "server_username"`**: Generates a random, unique name (e.g., `star_dane`) to use as an ownership tag for tracking.
* **`resource "random_password" "server_password"`**: Generates a secure, 16-character random password.
* **`resource "aws_security_group" "allow_ssh"`**: Creates a virtual firewall. It opens **Port 22 (TCP)** for incoming traffic (`ingress`) so we can connect to the machine via SSH, and allows all outgoing traffic (`egress`).
* **`resource "aws_instance" "my_server"`**: The virtual server. It provisions an Ubuntu AMI, sets the size to `t3.micro`, attaches the existing `anderson-novo` key pair, maps the security group, and attaches the tags.

### 2. `variables.tf` (The Options)

Holds the default settings for the project so `main.tf` stays clean.

* **`aws_region`**: Set to `us-east-1` (N. Virginia).
* **`instance_type`**: Set to `t3.micro` to ensure it stays within the AWS Free Tier.

### 3. `outputs.tf` (The Results)

Extracts important data from AWS after the machine is built and prints it to your terminal.

* **`server_public_ip`**: Prints the live IPv4 address needed to connect.
* **`generated_username`**: Prints the random pet name created.
* **`generated_password`**: Holds the random password but masks it on the screen (`sensitive = true`) for security.

---

## 🔒 Post-Deployment Operations

### How to Reveal the Hidden Password

Because the password output is marked as sensitive, run this command to print it cleanly when you need to copy it:

```bash
terraform output -raw generated_password

```

### Connect to the Server via SSH

Use your local private key file to securely connect to the instance:

```bash
ssh -i ~/.ssh/anderson-novo.pem ubuntu@<server_public_ip>

```

### Clean Up / Destroy Resources

When you are done practicing or testing, always tear down the infrastructure to avoid unexpected AWS costs:

```bash
terraform destroy

```

