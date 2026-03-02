resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow ssh and http"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  userdata = <<-EOF
    #!/bin/bash
    apt update -y 
    apt install nginx -y 

    rm -f /var/www/html/index.nginx-debian.html
    rm -f /var/www/html/index.html

    mkdir -p /var/www/html/css
    mkdir -p /var/www/html/js

    cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>My First EC2 Website</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <h1>Hello from Amith's EC2 Website!</h1>
    <p>This website is hosted on an EC2 instance.</p>

    <button id="btn">Click Me</button>
    <p id="message"></p>

    <script src="js/script.js"></script>
</body>
</html>
HTML

    cat <<CSS > /var/www/html/css/style.css
body {
    font-family: Arial, sans-serif;
    background: #f0f0f0;
    text-align: center;
    padding-top: 60px;
}
h1 {
    color: #333;
}
button {
    padding: 12px 20px;
    font-size: 16px;
    cursor: pointer;
    background: #007bff;
    color: white;
    border: none;
    border-radius: 6px;
}
button:hover {
    background: #0056b3;
}
CSS

    cat <<JS > /var/www/html/js/script.js
document.getElementById("btn").addEventListener("click", function() {
    document.getElementById("message").textContent = "Button clicked! Welcome Amith 🚀";
});
JS

    systemctl restart nginx
    systemctl enable nginx
  EOF
}

resource "aws_instance" "web" {
  ami                         = "ami-0ad21ae1d0696ad58"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data                   = local.userdata

  tags = {
    Name = "Hosting a static website"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
