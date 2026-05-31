resource "aws_ecr_repository" "this" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Environment  = var.environment
    Project      = var.project
    Created_By   = var.created_by
    Created_Date = var.created_date
  }
}

# Data source to generate an IAM policy document specifically for ECR (Elastic Container Registry)
data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "CrossAccountAccess" # Statement ID identifying the purpose of this rule
    effect = "Allow"

    # Defines who is allowed to access the ECR repository
    principals {
      type = "AWS"

      # Dynamically generates a list of AWS root account ARNs using a list of account IDs
      identifiers = [
        for account_id in var.cross_account_ids :
        "arn:aws:iam::${account_id}:root"
      ]
    }

    # The list of allowed actions, enabling pull, push, and image description capabilities
    actions = [
      "ecr:BatchCheckLayerAvailability", # Check if image layers exist
      "ecr:BatchGetImage",               # Pull image manifests
      "ecr:GetDownloadUrlForLayer",      # Download image layers
      "ecr:PutImage",                    # Push/upload final images
      "ecr:InitiateLayerUpload",         # Start the image upload process
      "ecr:UploadLayerPart",             # Upload parts of an image layer
      "ecr:CompleteLayerUpload",         # Finalize the layer upload
      "ecr:ListImages",                  # List images in the registry
      "ecr:DescribeImages"               # View image metadata/details
    ]
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep latest 10 untagged images"

        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}