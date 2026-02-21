############################################
# EC2 IAM ROLE (Trust Policy)
############################################

resource "aws_iam_role" "production_grade_ec2_role" {
  name = "production-grade-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

################################################
# ATTACH AWS MANAGED POLICY - ECR READ ACCESS
################################################

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.production_grade_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

############################################
#  ATTACH AWS MANAGED POLICY - SSM CORE
############################################

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.production_grade_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


############################################
# CUSTOM POLICY - SSM PARAMETER ACCESS
############################################

resource "aws_iam_role_policy" "ssm_parameter_read" {
  name = "production-grade-ssm-parameter-read"
  role = aws_iam_role.production_grade_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:eu-north-1:969759464709:parameter/production-grade-aws-fullstack/*"
      }
    ]
  })
}


############################################
#  INSTANCE PROFILE (VERY IMPORTANT)
############################################

resource "aws_iam_instance_profile" "production_grade_instance_profile" {
  name = "production-grade-ec2-instance-profile"
  role = aws_iam_role.production_grade_ec2_role.name
}