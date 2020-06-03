output "decrypted_secrets" {
  description = "A map of secret_names (as keys) and secret_plaintexts (as values)."
  value = {
    for secret_name, secret_object in data.google_kms_secret.deciphered_secrets :
    secret_name => secret_object.plaintext
  }
}
