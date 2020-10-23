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

#resource "aws_instance" bastion {
#  ami           = data.aws_ami.ubuntu.id
#  instance_type = "t3.micro"
#  subnet_id     = aws_subnet.public_a.id
#  key_name      = aws_key_pair.deployer.key_name
#	vpc_security_group_ids = [aws_security_group.bastion.id]
#
#  tags = {
#    Name = "bastion"
#  }
#}
#
#resource "aws_security_group" bastion {
#	vpc_id = aws_vpc.demo.id
#	description = "Access to bastion"
#  tags = {
#    Name = "bastion"
#  }
#}
#
#resource "aws_security_group_rule" ssh {
#  type              = "ingress"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.bastion.id
#}
#
#resource "aws_eip" "bastion" {
#  instance = aws_instance.bastion.id
#  vpc      = true
#}
#
#resource "aws_key_pair" "deployer" {
#  key_name   = "deployer-key"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuNSqiXtrxnRclWZqgNisEKFrft1Fg/fxVBxxrOCTI8JMQ/ORsiE7hjitLW3OBDmVwBwEdqbry+eD9im06peFt/Dt+GxncuRQ58Unho+erl1lX38nwImfaGD7FNAsd49NBbuGGktGGuIPijLGDWjtwgqoInB6jgqLl2YRAW2EB2n8EAmtrFwPCSOVVA9HMUPfbznb+hcF24WegOi+R+cIiswT3sz7Se3uPDX0kxZCC1NEimfUbs2oTQDAT73b/rPfj6lRLpGz2qoP/+AHVujIVXB2g6AB2kkUagVI6RrbWIeEE+TR8jAt5mFFipFu5hQzzvGaJhRXWyS+d9eMEG/2z costis.panagiotopoulos@reevoo.com"
#}
