# TODO: Create a Security Group for the Load Balancer
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

# TODO: Allow incoming traffic on the Load Balancer on port 80 from everywhere 
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule

# TODO: Allow outgoing traffic from the LB to everywhere
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule 


# TODO: Create the Load Balancer
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "loadbalancer" {
    name               = "loadbalancer"
    load_balancer_type = "application"
    security_groups    = [aws_security_group.allow_http.id]
    subnets            = module.vpc.public_subnets
    tags               = local.standard_tags
}

# TODO: Create a target group
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

resource "aws_lb_target_group" "app_target" {
   name                 = "apptarget"
   port                 = 80
   protocol             = "HTTP"
   vpc_id               = module.vpc.vpc_id
   deregistration_delay = 60

   health_check {
     interval = 6
     path     = "/"
     port     = 8080
     protocol = "HTTP"
   }
 }

# TODO: Create a listener
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

resource "aws_lb_listener" "lb_forward_to_app" {
    load_balancer_arn = aws_lb.loadbalancer.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app_target.arn
        }
}

