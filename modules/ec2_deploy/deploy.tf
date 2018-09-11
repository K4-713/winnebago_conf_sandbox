
/***
*    Variables
***/

# These get poked through from the outside
variable "instance_ami" {}
variable "deployer_username" {}
variable "deployer_key" {}

# The locals block, defines variables that only exist in this module 
# (because screw default local scoping? yep okay)
# This whole user-data variable is just passed to the aws_instance resource.

locals {
    # This user_data stuff will run when launching the instance, if you pass it 
    # in a user_data parameter when defining the resource. We'll do that below.
  user_data = <<USERDATA
#!/bin/bash -xe

create_user() {
  USER=$1
  KEY=$2
  adduser $USER
  sudo -u $USER mkdir -p /home/$USER/.ssh/
  sudo -u $USER touch /home/$USER/.ssh/authorized_keys
  sudo -u $USER chmod 700 /home/$USER/.ssh
  sudo -u $USER chmod 600 /home/$USER/.ssh/authorized_keys
  sudo -u $USER bash -c 'echo -n "'"$KEY"'" >> /home/$USER/.ssh/authorized_keys'
}

create_user '${var.deployer_username}' "${var.deployer_key}"

/sbin/service sshd restart

USERDATA
}



/***
*    Security groups
***/
resource "aws_security_group" "deploy-server" {
  name        = "deploy-ssh-access"
  description = "Allow ssh access to the deploy server"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "deploy-ssh-access"
  }
}

# Just summoning preexisting data here, to prevent removal from default groups
data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}


/***
*    Deploy Server
***/

# deploy server
resource "aws_instance" "deploy" {
  ami = "${var.instance_ami}"
  instance_type = "t2.micro"
  user_data = "${local.user_data}"

# add the deploy server to the deploy server security group we created above
  vpc_security_group_ids = [
    "${aws_security_group.deploy-server.id}",
    "${data.aws_security_groups.default.ids}",
  ]

}