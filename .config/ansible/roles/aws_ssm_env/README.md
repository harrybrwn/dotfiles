# aws-ssm-env

Fetch multiple AWS Systems Manager Parameter Store parameters and write them to
a single `.env` file. The role checks the file first and does not contact AWS
for parameters whose target environment variables are already present.

The role uses the `amazon.aws.aws_ssm` lookup, so install the collection before
using it:

```sh
ansible-galaxy collection install amazon.aws
```

## Variables

- `aws_ssm_env_parameters` (required): List of mappings containing `name` (the
  Parameter Store name), `env` (the environment variable name), and optional
  `export` (default `false`). When `export` is true, the output line starts
  with `export`. Environment variable names must be unique and valid shell
  variable names. Values containing a space, semicolon, double quote, dollar
  sign, or equals sign are automatically wrapped in single quotes.
- `aws_ssm_env_file`: Destination file. Defaults to `~/.env` for the remote
  user. Paths beginning with `~/` are expanded using the remote user's home
  directory.
- `aws_ssm_env_decrypt`: Decrypt `SecureString` parameters (default `true`).
- `aws_ssm_env_profile`: Optional boto3/AWS profile. It defaults to an empty
  value, which deliberately ignores `AWS_PROFILE` for this lookup so explicit
  AWS credential environment variables can be used. Set it when using a
  configured AWS profile, and do not also provide explicit AWS credential
  variables.
- `aws_ssm_env_file_mode`: Mode used when the destination is created (default
  `0600`). Existing file permissions are not changed.

## Example

```yaml
- name: Configure application secret
  hosts: app
  roles:
    - role: aws-ssm-env
      vars:
        aws_ssm_env_parameters:
          - name: /production/api/database-password
            env: DATABASE_PASSWORD
            export: true
          - name: /staging/email/api-key
            env: EMAIL_API_KEY
        aws_ssm_env_file: /srv/api/.env
```

AWS credentials and region are resolved by the normal AWS SDK credential chain.
The remote host must have credentials available and the `amazon.aws` collection
installed on the controller.
