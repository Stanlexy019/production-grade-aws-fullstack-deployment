resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}


# ADD GITHUB ACTIONS ROLE #
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Stanlexy019/production-grade-aws-fullstack-deployment*"
          }
        }
      }
    ]
  })
}

#  ATTACH AWS MANAGED POLICY - ECR POWER USER)
resource "aws_iam_role_policy_attachment" "github_actions_attach_ecr" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


##################################################################
#  SSM:SendCommand POLICY (FOR RUNNING COMMANDS ON EC2 INSTANCES)
##################################################################
resource "aws_iam_policy" "github_actions_ssm_send_command" {
  name = "production-grade-ssm-send-command"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:ListCommands",
          "ssm:ListCommandInvocations"
        ]
        Resource = [
          "arn:aws:ec2:${var.region}:${var.account_id}:instance/*",
          "arn:aws:ssm:${var.region}::document/AWS-RunShellScript"
        ]
      }
    ]
  })
}

##############################################################
# EC2:DescribeInstances POLICY (FOR TARGETING INSTANCES IN SSM)
###############################################################
resource "aws_iam_policy" "github_actions_ec2_describe_instances" {
  name = "production-grade-ec2-describe-instances"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:DescribeInstances"
        Resource = "arn:aws:ec2:${var.region}:${var.account_id}:instance/*"
      }
    ]
  })
}

# Attach SSM SendCommand Policy to GitHub Actions role
resource "aws_iam_role_policy_attachment" "github_actions_attach_ssm_send" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_ssm_send_command.arn
}

# Attach EC2 Describe Instances Policy to GitHub Actions role
resource "aws_iam_role_policy_attachment" "github_actions_attach_ec2_describe" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_ec2_describe_instances.arn
}

