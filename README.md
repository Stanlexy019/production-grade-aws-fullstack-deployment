# 🚀 Production-Grade AWS Full-Stack Infrastructure

## 📌 Overview

This project demonstrates the design and deployment of a **production-grade full-stack application infrastructure on AWS** using modern DevOps practices.

The infrastructure is built with scalability, security, and observability in mind, simulating a real-world production environment.

Key highlights:

* Infrastructure provisioning using **Terraform**
* Containerized services using **Docker**
* CI/CD pipeline using **GitHub Actions**
* Secure secrets management with **AWS Systems Manager Parameter Store**
* Scalable compute using **Auto Scaling Groups**
* Load balancing using **Application Load Balancer (ALB)**
* Monitoring and alerting with **CloudWatch and SNS**

---

##  Architecture

Below is the high-level architecture of the system:

![Infrastructure Architecture](image/infra-image.png)

---

##  Technology Stack

### Cloud Provider

* AWS

### Infrastructure as Code

* Terraform

### Containerization

* Docker
* Docker Compose

### CI/CD

* GitHub Actions

### Container Registry

* Amazon ECR

### Monitoring & Alerting

* Amazon CloudWatch
* Amazon SNS

### Secrets Management

* AWS Systems Manager Parameter Store

---

##  Infrastructure Components

### VPC & Networking

The infrastructure is deployed inside a dedicated **Amazon VPC** with proper network segmentation:

* Public Subnets (for ALB & NAT Gateway)
* Private Subnets (for EC2 instances)
* Internet Gateway (for inbound internet traffic)
* NAT Gateway (for outbound internet access from private instances)
* Route Tables
* Security Groups

This setup ensures **secure and controlled network communication**.

---

###  Load Balancing

An **Application Load Balancer (ALB)** is used to:

* Distribute incoming traffic across EC2 instances
* Perform health checks
* Ensure high availability

---

###  Compute Layer (Auto Scaling)

Application workloads run on **EC2 instances managed by an Auto Scaling Group (ASG)**.

Each instance is launched using a **Launch Template** that automatically:

* Installs Docker and Docker Compose
* Retrieves secrets from Parameter Store
* Logs in to Amazon ECR
* Pulls application images
* Starts services using Docker Compose

This ensures **automatic scaling and self-healing infrastructure**.

---

###  Container Registry (ECR)

Docker images for the application are stored in **Amazon Elastic Container Registry (ECR)**.

Examples:

* frontend:v1
* backend:v1

EC2 instances pull these images during startup.

---

## 🔄 CI/CD Pipeline

The CI/CD workflow is implemented using **GitHub Actions**.

Flow:

Developer → GitHub → GitHub Actions → Build → Push to ECR → Deploy

This enables:

* Automated builds
* Versioned container images
* Consistent deployments

---

## 🔐 Secrets Management

Sensitive data is securely stored in **AWS Systems Manager Parameter Store**.

Examples:

* JWT_SECRET
* MONGO_URI

These values are dynamically retrieved by EC2 instances at startup.

---

##  Monitoring & Alerts

Monitoring is handled using **Amazon CloudWatch**.

Tracked metrics include:

* ALB target health
* CPU utilization
* Application performance

Alerts are configured using **CloudWatch Alarms**, which trigger:

→ Amazon SNS → Email Notifications

Example scenario:

Unhealthy target → Alarm triggered → Email sent

---

## 📁 Project Structure

```
project-root
│
├── backend
├── frontend
│
├── infra-code
│   ├── vpc
│   ├── subnets
│   ├── security-groups
│   ├── load-balancer
│   ├── auto-scaling
│   └── monitoring
│
├── .github
│   └── workflows
│
├── image
│   └── infra-image.png
│
└── README.md
```

---

##  Lessons Learned

During this project, several real-world DevOps challenges were encountered and resolved:

* Debugging EC2 launch template user-data issues
* Handling delayed container startup
* Diagnosing ALB health check failures
* Fixing unhealthy target groups
* Configuring effective monitoring and alerting

These experiences reflect real production troubleshooting scenarios.

---

##  Future Improvements

Possible enhancements include:

* Blue-green deployments
* Centralized logging (CloudWatch Logs)
* Security scanning (Trivy, tfsec)
* Canary deployments
* Observability with Prometheus & Grafana

---

## ✅ Conclusion

This project demonstrates how to design and deploy a **scalable, secure, and observable cloud infrastructure** using modern DevOps tools and practices.

It reflects real-world engineering workflows including infrastructure provisioning, deployment automation, monitoring, and troubleshooting.
