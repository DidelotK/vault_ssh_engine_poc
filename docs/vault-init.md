# Vault init

## Prerequisites

### Install unzip if not already present on system (will be used for unzip vault binary archive)

```bash
sudo apt install unzip -y
```

## Init vault

### Install vault

```bash
curl -LO https://releases.hashicorp.com/vault/0.10.2/vault_0.10.2_linux_amd64.zip
unzip vault_0.10.2_linux_amd64.zip
chmod 755 vault
sudo mv vault /usr/bin/
```

### Create vault configuration file

Create a file named `config.hcl` and put the following content.

```hcl
storage "inmem" {} // Memory stockage (for demo only)

listener "tcp" {
  address     = "192.168.1.28:8200" // The ip of the vault server
  tls_disable = 1
}
```

### Start vault server

```bash
sudo vault server -config config.hcl
```

### Initialise operators

This tasks is used in order to get all token for unseal the vault and get the root token

```bash
vault operator init
```

Result:
```txt
Unseal Key 1: UoQxkYRHJp15wJ21GgSG7hh54jM3OgJM+FEqkYFP1FhH
Unseal Key 2: h4bC27o4vJfMsJX8lcSj5Rx/+qaimC/b/e44iitK73rs
Unseal Key 3: QbHjHCcuuXAImGOIZ+r0e7kyL1PSP+X2RYTHwDWOrK6d
Unseal Key 4: 6Ixs/6NYVC7nNIqhYHt7vQDXHgINAyeRNJ+t4IyaS/pc
Unseal Key 5: D0u27HC6A28qeZ+P0wsQDqFHZnPOzCc7xZN2VwC8cBBb

Initial Root Token: 23bb157b-f49b-9fc9-a9b8-381509f7a73b

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault rekey" for more information
```

Save this keys the will not be given a second time


### Unseal the vault

```bash
vault operator unseal # have to make this operation 3 times with 3 different unseal key. (Vault needs different key to reconstruct the master key to decrypt the data).
```

### Login

```bash
vautl login # Give the root token
```

Now you can make any change to the vault

### More info
Vault configuration file: https://www.vaultproject.io/docs/configuration/index.html

Vault deploy: https://www.vaultproject.io/intro/getting-started/deploy.html

## Configure ssh plugin

### Enable ssh plugin engine

```bash
vault secrets enable -path=ssh-client-signer ssh
```

### Configure vault public key

```bash
vault write ssh-client-signer/config/ca generate_signing_key=true
```

### Add public to all target host

```bash
sudo curl -o /etc/ssh/trusted-user-ca-keys.pem http://192.168.1.28:8200/v1/ssh-client-signer/public_key
```
**Note**: Replace 192.168.1.28 by your vault server ip.

### Ssh configuration

Add this line in the sshd config file
```conf
# /etc/ssh/sshd_config
# ...
TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem
```

Then restart ssh

```bash
sudo systemctl restart ssh
```

### Create vault role for signing client keys

```bash
vault write ssh-client-signer/roles/admin -<<"EOH"
{
  "allow_user_certificates": true,
  "allowed_users": "*",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "vagrant",
  "ttl": "30m0s"
}
EOH
```

## Client connexion with ssh plugin

## Generate a ssh key

```bash
ssh-keygen -t rsa -C "admin@yolo.com"
```

### More info
https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html
