Terraform module for decrypting secrets (that were encrypted with KMS Keys) in GCP. Can optionally store the encrypted secrets into Secret Manager as well.

# Generating ciphertext from plaintext using KMS symmetric encryption

You can use the `gcloud kms encrypt` tool in your terminal, to create a ciphertext from a plaintext.

```bash
echo -n "my-plaintext-secret" \
| gcloud kms encrypt \
--project "my-gcp-project-id" \
--location "asia-southeast1" \
--keyring "my-kms-key-ring" \
--key "my-kms-key" \
--plaintext-file - \
--ciphertext-file - \
| base64
```

It outputs a base64 encoded ciphertext:

```
CiQAosletmGOhvZDifaX4JxkBGSwm1/5mIPtMGPhEE8xGkpii4cSLnCNaYhPP2qjEQetFwc6XMWluCsgp/6kJGBPRdT8UNu6UyhVHWguZqJ/yiUIeQ==
```

# Revealing plaintext from ciphertext using KMS symmetric decryption

You can use the `gcloud kms decrypt` tool in your terminal, to revert to the plaintext from a ciphertext.

```bash
echo "CiQAosletmGOhvZDifaX4JxkBGSwm1/5mIPtMGPhEE8xGkpii4cSLnCNaYhPP2qjEQetFwc6XMWluCsgp/6kJGBPRdT8UNu6UyhVHWguZqJ/yiUIeQ==" \
| base64 -d \
| gcloud kms decrypt \
--project "my-gcp-project-id" \
--location "asia-southeast1" \
--keyring "my-kms-key-ring" \
--key "my-kms-key" \
--plaintext-file - \
--ciphertext-file -
```

It outputs the original plaintext:

```
my-plaintext-secret
```
