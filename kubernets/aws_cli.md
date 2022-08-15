## Configure an SSO Profile

配置 aws sso profile

```sh
aws configure sso
```

Using an SSO Profile

```sh
aws s3 ls --profile my-sso-profile
```

aws sso 登录

```sh
aws sso login --profile my-sso-profile
```
