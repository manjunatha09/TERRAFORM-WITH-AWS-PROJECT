# 🚀 AWS Infrastructure with Terraform

Provisioning a highly available AWS web infrastructure with Terraform — VPC, public subnets, EC2 instances, Application Load Balancer, S3, and IAM using Infrastructure as Code.

---

## 📐 Architecture Overview

![AWS Terraform Infrastructure](AWS_Terraform_Infra.jpg)

The infrastructure spans **two Availability Zones** (`us-east-1a` and `us-east-1b`) for high availability, with an Application Load Balancer distributing traffic across two EC2 web servers. Static web content is served from S3 via IAM role-based access.

---

## 🛠️ Resources Provisioned

| Resource | Details |
|---|---|
| **VPC** | Custom VPC with configurable CIDR block |
| **Subnets** | 2 public subnets across `us-east-1a` and `us-east-1b` |
| **Internet Gateway** | Enables public internet access |
| **Route Table** | Routes all traffic (`0.0.0.0/0`) through the IGW |
| **Security Group** | Allows HTTP (80) and SSH (22) inbound traffic |
| **EC2 Instances** | 2x `t3.micro` Ubuntu instances (one per subnet) |
| **Application Load Balancer** | Distributes HTTP traffic across both EC2 instances |
| **Target Group + Listener** | Health-checked target group on port 80 |
| **S3 Bucket** | Hosts `index.html` and `index1.html` web pages |
| **IAM Role + Profile** | Grants EC2 instances read-only access to S3 |

---

## 📁 Project Structure

```
.
├── main.tf              # Core infrastructure resources
├── provider.tf          # AWS provider configuration
├── variables.tf         # Input variables (e.g., CIDR block)
├── .terraform.lock.hcl  # Provider dependency lock file
├── userdata.sh          # Bootstrap script for webserver1
├── userdata1.sh         # Bootstrap script for webserver2
├── index.html           # Web page served by webserver1
├── index1.html          # Web page served by webserver2
└── AWS_Terraform_Infra.jpg  # Architecture diagram
```

---

## ⚙️ How It Works

1. **Terraform** provisions the entire AWS infrastructure from code.
2. Two **EC2 instances** are launched with Apache web server installed via user data scripts.
3. Each instance pulls its respective HTML file from **S3** using an **IAM instance profile** (no hardcoded credentials).
4. An **Application Load Balancer** sits in front of both instances, health-checks them, and routes incoming HTTP traffic between them.

---

## 🚦 Getting Started

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- AWS CLI configured (`aws configure`)
- An existing EC2 Key Pair named `awspem` in your AWS account

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/terraform-with-aws-project.git
cd terraform-with-aws-project

# 2. Initialize Terraform
terraform init

# 3. Preview the plan
terraform plan

# 4. Apply the infrastructure
terraform apply

# 5. Access your app via the ALB DNS output
# Look for: loadbalancerdns = "myalb-xxxx.us-east-1.elb.amazonaws.com"
```

### Tear Down

```bash
terraform destroy
```

---

## 🔑 Variables

| Variable | Description | Default |
|---|---|---|
| `cidr` | CIDR block for the VPC | Defined in `variables.tf` |

---

## 📤 Output

After a successful `terraform apply`, the ALB DNS name is printed:

```
Outputs:
loadbalancerdns = "myalb-xxxx.us-east-1.elb.amazonaws.com"
```

Open this URL in your browser to see the load-balanced web application.

---

## 🔒 Security Notes

- EC2 instances access S3 using an **IAM role** — no AWS credentials are stored on the instances.
- SSH access (port 22) is open to `0.0.0.0/0` in this demo — restrict to your IP in production.
- The `.pem` key file is **not** committed to this repository.

---

## 🧰 Tech Stack

- **Infrastructure as Code:** Terraform
- **Cloud Provider:** AWS
- **Web Server:** Apache2
- **Storage:** Amazon S3
- **Compute:** Amazon EC2 (t3.micro, Ubuntu)
- **Networking:** VPC, IGW, Route Tables, Security Groups, ALB
