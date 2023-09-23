variable "alb_name" {
  type    = string
  default = "my-alb"
}

variable "security_group_name" {
  type    = string
  default = "my-security-group"
}

variable "waf_web_acl_name" {
  type    = string
  default = "my-waf-web-acl"
}

variable "waf_rule_group_name" {
  type    = string
  default = "my-waf-rule-group"
}

# Variáveis para os valores do JSON da resposta fixa
variable "json_response" {
  type = string
  default = "{\"codigo\":\"seu_codigo\",\"descricao\":\"sua_descricao\"}"
}

variable "subnets" {
  type        = list(string)
  description = "IDs das subnets para o ALB"
}

variable "aws_region" {
  type    = string
  description = "Região da AWS onde os recursos serão criados"
}