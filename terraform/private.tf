/*
  Web Servers
*/
resource "aws_security_group" "petapp" {
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
        Name = "Petapp"
    }
}

resource "aws_instance" "Petapp" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "eu-west-1a"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.petapp.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false


    tags {
        Name = "Petapp"
    }
}

resource "aws_eip" "Petapp" {
    instance = "${aws_instance.jenkins.id}"
    vpc = true
}