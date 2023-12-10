# jenkins key pair
resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = var.public-key
}

# jenkins sg
resource "aws_security_group" "jenkins-sg" {
  dynamic "ingress" {
    for_each = var.jenkins-ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# role
data "aws_iam_policy_document" "jenkins-assume-role" {
  statement {
    sid     = "AllowEc2AssumeRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jenkins-instance-role" {
  name               = "jenkins-instance-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins-assume-role.json
}

resource "aws_iam_instance_profile" "jenkins-instance-profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins-instance-role.name
}

# allow jenkins instance Full privilege with ECR
resource "aws_iam_policy" "jenkins-policy" {
  name = "jenkins-policy"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # get ECR authorize, pull push images
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = [
          "ecr:*",
        ]
      },
      # check, pull, put state in s3
      {
        Effect   = "Allow"
        Resource = "*"
        Action   = [
          "s3:*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins-attachment" {
  role = aws_iam_role.jenkins-instance-role.name
  policy_arn = aws_iam_policy.jenkins-policy.arn
}

# instance
resource "aws_instance" "jenkins-instance" {
  ami           = var.ubuntu-ami
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.jenkins-instance-profile.name

  # the security group
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  # the public SSH key
  key_name = aws_key_pair.my-key.key_name

  # user data
  user_data = var.user-data
}

resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = aws_instance.jenkins-instance.availability_zone
  size              = 20
  type              = "gp2"
  tags = {
    Name = "jenkins-data"
  }
}

resource "aws_volume_attachment" "jenkins-data-attachment" {
  device_name = var.instance-device-name
  volume_id   = aws_ebs_volume.jenkins-data.id
  instance_id = aws_instance.jenkins-instance.id
}