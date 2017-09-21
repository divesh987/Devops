provider "aws" {
  region  = "eu-west-2"
}

# Creating a VPC
resource "aws_vpc" "public-private" {
  tags {
      Name = "Divesh - VPC"
  }
  cidr_block = "11.3.0.0/16"
  
}

resource "aws_subnet" "web" {
  vpc_id = "${aws_vpc.public-private.id}"
  cidr_block = "11.3.1.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "Web - Public"
  }
}

resource "aws_subnet" "db" {
  vpc_id = "${aws_vpc.public-private.id}"
  cidr_block = "11.3.2.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "DB - Private"
  }
}

resource "aws_security_group" "web" {
  name        = "Web Security Group"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.public-private.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags {
    Name = "Web"
  }
}

resource "aws_security_group" "db" {
  name        = "DB Security Group"
  description = "Allow only web "
  vpc_id = "${aws_vpc.public-private.id}"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = ["${aws_security_group.web.id}"] 
    # cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags {
    Name = "Div Web"
  }
}
data "aws_ami" "web" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["div-web-prod*"]
  }

  most_recent = true
}



resource "aws_instance" "div-web-instance" {
  ami           = "${data.aws_ami.web.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids= ["${aws_security_group.web.id}"] 
  subnet_id = "${aws_subnet.web.id}"
  user_data = "${data.template_file.init_script.rendered}"

  depends_on = ["aws_instance.div-db-instance"]


  tags {
    Name = "web-div"
  }
}


resource "aws_instance" "div-db-instance" {
  ami           = "ami-d0c1d2b4"
  instance_type = "t2.micro"
  vpc_security_group_ids= ["${aws_security_group.db.id}"] 
  subnet_id = "${aws_subnet.db.id}"
  private_ip = "11.3.2.55"
  
  tags {
    Name = "db-div"
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}
data "template_file" "init_script" {
  template = "${file("${path.module}/init.sh")}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.public-private.id}"
}

# Add route to internet gateway in route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.public-private.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table" "local" {
 vpc_id = "${aws_vpc.public-private.id}"
}

resource "aws_route_table_association" "db" {
  subnet_id = "${aws_subnet.db.id}"
  route_table_id = "${aws_route_table.local.id}"
}