# Verify your AWS CLI identity before working in a cloud account

**Goal:** Sign in with a named AWS IAM Identity Center profile and confirm which account and role your CLI commands will use.

**Prerequisites:** AWS CLI version 2 and access to an AWS account through IAM Identity Center. You need the organization's start URL, Identity Center Region, and an assigned account and permission set from your administrator.

This lab only checks identity. It does not create or change AWS resources.

## 1. Configure a named profile

```bash
aws configure sso --profile dev-lab
```

Follow the prompts using the start URL and Identity Center Region supplied by your organization. Choose the intended account and permission set, then set a default AWS Region for the profile. Do not put access keys or tokens in this guide or in a repository.

## 2. Sign in and verify the caller

```bash
aws sso login --profile dev-lab
aws sts get-caller-identity --profile dev-lab
```

The sign-in opens a browser to complete authentication. The identity check returns JSON containing the AWS account ID, the caller ARN, and a user or role identifier. Confirm that the account and role are the ones you intended before running any command that changes resources.

`sts get-caller-identity` does not require an IAM permission and does not change cloud resources.

## 3. Use the profile for a command

Pass the profile explicitly to avoid relying on whichever credentials happen to be the default:

```bash
aws sts get-caller-identity --profile dev-lab
```

For a short shell session, you can select it with an environment variable:

```bash
export AWS_PROFILE=dev-lab
aws sts get-caller-identity
unset AWS_PROFILE
```

The explicit `--profile` option is useful in scripts because it makes the selected identity visible in the command itself.

## Troubleshooting

- If the browser sign-in succeeds but the identity check fails, confirm you selected an account and permission set in the SSO wizard.
- If a command uses the wrong account, rerun the identity check with the exact profile you intend to use.
- If the session has expired, sign in again with `aws sso login --profile dev-lab`.
- If IAM Identity Center is unavailable for your learning account, ask the account administrator for an approved authentication method. Avoid sharing long-lived access keys or storing them in source control.

## Key takeaway

Confirm the active account and role before cloud work. Named profiles and IAM Identity Center help separate environments while avoiding hard-coded long-lived credentials.

References: [AWS CLI IAM Identity Center configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html) · [AWS STS get-caller-identity](https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html)
