variable "baseline_name" {
  description = "(Required, String) Baseline name, which must be unique. Supports only English letters, numbers, Chinese characters, and symbols @, &, _, [], -. Combination of 1-25 Chinese or English characters."
  type        = string
}

variable "baseline_config_items" {
  description = "(Optional, List) Baseline configuration, overwrite update. You can query existing baseline configurations via controlcenter:GetAccountFactoryBaseline. You can query supported baseline lists via controlcenter:ListAccountFactoryBaselineItems."
  type = list(object({
    identifier    = string # Specifies the unique identifier for account factory baseline item, can only contain `english letters`, `digits`, and `@,._[]-:()()[]+=.`, with a length of 2-128 characters.
    configuration = string # Account factory baseline item configuration, different baseline items have different configuration parameters.
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = { created_by: "terraform" }
}