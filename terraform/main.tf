provider "aws" {
  region = var.aws_region
}

resource "aws_lb" "my_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  enable_deletion_protection = false
}

resource "aws_security_group" "my_security_group" {
  name        = var.security_group_name
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "application/json"
      status_code     = "200"
      content         = "{\"codigo\":\"42200030332\",\"descricao\":\"Produto não disponivel\"}"
    }
  }
}

resource "aws_wafv2_web_acl" "my_waf_web_acl" {
  name        = var.waf_web_acl_name
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
}

resource "aws_wafv2_rule_group" "my_waf_rule_group" {
  name        = var.waf_rule_group_name
  scope       = "REGIONAL"
  capacity    = 1
  rule {
    action {
      allow {}
    }
    name     = "AllowIfCodigoBarraStartsWith8"
    priority = 1

    rule_action {
      block {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "codigo_barra"
          }
        }
        positional_constraint = "STARTS_WITH"
        search_string        = "8"
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "my_web_acl_association" {
  web_acl_arn = aws_wafv2_web_acl.my_waf_web_acl.arn
  resource_arn = aws_lb.my_alb.arn
}