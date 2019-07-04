provider "aws" {
  profile  = "default"
  region   = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts,
  # so this name must be changed before applying this example
  # to avoid naming conflicts.
  bucket = "terraform-gettting-started-guide-20190704"
  acl    = "private"
}

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"

  # Tells Terraform that this EC2 instance must be created only after 
  # the S3 bucket has been created.
  depends_on = [aws_s3_bucket.example]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

#resource "aws_instance" "another" {
#  ami           = "ami-b374d5a5"
#  instance_type = "t2.micro"
#}

resource "aws_eip" "ip" {
  instance = aws_instance.example.id
}
