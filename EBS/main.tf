data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data = file("entryscript.sh")

  tags = {
    Name       = "my_instance"
    Department = "Finance"
  }
}

resource "aws_ebs_volume" "my_vol" {
  availability_zone = var.default_az
  size              = 1
  encrypted = true
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.my_vol.id
  instance_id = aws_instance.web.id
}

resource "aws_ebs_snapshot" "test_snapshot" {
  volume_id = aws_ebs_volume.my_vol.id

  tags = {
    Name = "test_snapshot"
  }
}

resource "aws_ebs_volume" "restored_vol" {
  availability_zone = "us-east-1a"
  snapshot_id       = aws_ebs_snapshot.test_snapshot.id
}

resource "aws_ami_from_instance" "my_ami" {
  name               = "my_ami"
  source_instance_id = aws_instance.web.id
}

resource "aws_instance" "apache_server" {
  ami           = aws_ami_from_instance.my_ami.id
  instance_type = var.instance_type

  tags = {
    Name       = "apache_server"
  }
}