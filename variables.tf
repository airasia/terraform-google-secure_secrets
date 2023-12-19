# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "name_suffix" {
  description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
  type        = string
  validation {
    condition     = length(var.name_suffix) <= 14
    error_message = "A max of 14 character(s) are allowed."
  }
}

variable "kms_key" {
  description = "A KMS Key (self-link) that will be used for decrypting the secrets."
  type        = string
}

variable "secrets" {
  description = "Mapping of secret_names (as keys) and secret_ciphertexts (as values). Generate the secret_ciphertexts from your secret_plaintexts using KMS Keys first. See ReadMe for example on how to use KMS Symmetric Encryption to generate ciphertexts. The generated ciphertexts MUST BE base64-encoded. Then put the base64-encoded ciphertexts as map values in this variable. DO NOT pass plaintexts as map values in this variable."
  type        = map(string)
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

variable "copy_to_sm" {
  description = "Whether to copy the secret_ciphertexts (from var.secrets) into GCP Secret Manager. If 'true', the ciphertexts will be copied and stored in Secret Manager exactly as it is without any modification or decryption."
  type        = bool
  default     = false
}

variable "secret_id_suffix" {
  description = "Whether a suffix should be appended to the secret_id."
  type = bool
  default = true
}