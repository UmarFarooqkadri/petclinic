/*
  Web Servers
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
        Name = "Jenkins"
    }
}

resource "aws_instance" "jenkins" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "eu-west-1a"
    instance_type = "m1.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
	user_data = ${file("cloud-config.yaml")}


    tags {
        Name = "Jenkins"
    }
}

resource "aws_eip" "Jenkins" {
    instance = "${aws_instance.jenkins.id}"
    vpc = true
}