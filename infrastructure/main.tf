terraform {
  backend "s3" {
    bucket = "io.cribl.sandbox.tfbackend"
    key = "ecr-windows"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_ecr_repository" "edge-windows" {
  name = "edge-windows"

  encryption_configuration {
    encryption_type = "AES256"
  }
}

data "tls_certificate" "github-actions-token" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github-actions-token.certificates[0].sha1_fingerprint]
  url             = "https://token.actions.githubusercontent.com"

  lifecycle {
    prevent_destroy = true
    ignore_changes = [tags, tags_all, thumbprint_list]
  }
}

resource "aws_iam_role" "github_actions" {
  name = "Github-Actions-Edge-Windows-ECR-Builder"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:sub" : "repo:bdalpe/cribl-edge-win32-image-builder:ref:refs/heads/main",
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  inline_policy {
    // https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-policy-examples.html#IAM_allow_other_accounts
    name = "ecr_build_and_push"

    policy = jsonencode({
      Version: "2012-10-17"
      Statement = [
        {
          "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ]
          Effect = "Allow"
          Resource = [
            aws_ecr_repository.edge-windows.arn,
          ]
        }
      ]
    })
  }
}
