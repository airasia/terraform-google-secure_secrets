terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}

data "google_client_config" "google_client" {}

data "google_kms_secret" "deciphered_secrets" {
  for_each   = var.secrets
  crypto_key = var.kms_key
  ciphertext = each.value
}

locals {
  use_sm = (! var.copy_to_sm) || (length(keys(var.secrets)) == 0) ? false : true
}

resource "google_project_service" "sm_api" {
  count              = local.use_sm ? 1 : 0
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "secret_names" {
  for_each  = local.use_sm ? var.secrets : {}
  provider  = google-beta
  secret_id = var.secret_id_suffix ? "${each.key}-sec2-${var.name_suffix}" : "${each.key}" # 'sec2' implies this secret was created using the SECureSECrets module
  replication {
    user_managed {
      replicas { location = data.google_client_config.google_client.region }
    }
  }
  depends_on = [google_project_service.sm_api, data.google_kms_secret.deciphered_secrets]
}

resource "google_secret_manager_secret_version" "secret_versions" {
  for_each    = google_secret_manager_secret.secret_names
  provider    = google-beta
  secret      = each.value.id
  secret_data = var.secrets[each.key]
}
