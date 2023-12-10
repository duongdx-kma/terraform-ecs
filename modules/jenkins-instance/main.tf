resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = var.public-key
}

resource "aws_instance" "jenkins-instance" {
  ami           = var.ubuntu-ami
  instance_type = "t2.micro"
  iam_instance_profile = var.jenkins-in-profile-name
  # the VPC subnet
  subnet_id = var.public-subnet-id

  # the security group
  vpc_security_group_ids = var.jenkins-securitygroup-ids

  # the public SSH key
  key_name = aws_key_pair.my-key.key_name

  # user data
  user_data = var.user-data
}

resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = var.availability-zone
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