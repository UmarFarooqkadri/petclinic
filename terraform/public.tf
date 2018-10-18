/*
  Jenkins Master
*/
resource "aws_security_group" "jenkins" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
   
   
    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "Jenkins Server"
    }
}

resource "aws_instance" "jenkins1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "eu-west-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.jenkins.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "Jenkins"
    }
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.jenkins1.id}"
    vpc = true
}
