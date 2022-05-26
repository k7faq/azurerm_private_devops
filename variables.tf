variable "diagnostic_setting_retention_days" {
  default = 30
  description = "Days to retain Diagnostic Logs"
  type = number
}

variable "required_tags" {
  type    = map(string)
  default = {
    Application = "Diagnostics"
    Environment = "Lab"
    LOB = "Diagnostics"
    Onwer = "steven.rhodes@nuance.com"
  }
}


variable "project" {
  description = "Map of values about this Project"
  type = object({
    region_short = string
    region = string
    project = string
    environment = string
  })
}