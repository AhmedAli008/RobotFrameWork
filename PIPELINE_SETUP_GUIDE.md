# Pipeline Setup Guide - Auto Trigger Automation Tests

## Architecture

```
DEV REPO (push to main / release tag)
    |
    |  Bitbucket API call
    v
AUTOMATION REPO (runs all Robot Framework tests)
    |
    v
Test Results (Output/report.html, Output/log.html)
```

## Setup Steps

### Step 1: Enable Pipelines in Both Repos

1. Go to each repo in Bitbucket
2. **Repository Settings > Pipelines > Settings**
3. Toggle **Enable Pipelines** ON

### Step 2: Create Bitbucket App Password

1. Go to **Bitbucket > Personal Settings > App Passwords**
2. Click **Create App Password**
3. Name: `pipeline-trigger`
4. Permissions:
   - **Pipelines**: Read, Write
   - **Repositories**: Read
5. Copy the generated password

### Step 3: Add Variables to DEV Repo

Go to **DEV repo > Repository Settings > Pipelines > Repository Variables**

| Variable           | Value                        | Secured |
|--------------------|------------------------------|---------|
| `BB_AUTH_USER`     | your_bitbucket_username      | No      |
| `BB_AUTH_PASSWORD` | app_password_from_step_2     | Yes     |
| `BB_WORKSPACE`     | your-workspace-slug          | No      |
| `BB_AUTOMATION_REPO` | automation-repo-slug       | No      |

### Step 4: Update Automation Repo Pipeline

The `bitbucket-pipelines.yml` in this automation repo is already configured.
Just push it to the `main` branch.

### Step 5: Update Dev Repo Pipeline

Share the `dev-team-pipeline-snippet.yml` file with the dev team.
They need to add the trigger steps to their `bitbucket-pipelines.yml`.

**Key parts they need to add:**
- The `trigger-automation-tests` step definition
- The `trigger-automation-tests-release` step definition
- Add these steps after their build/deploy steps in `branches > main` and `tags > v*`

## How It Works

| Event                        | What Happens                                          |
|------------------------------|-------------------------------------------------------|
| Dev pushes to `main`         | Dev pipeline runs, then triggers `triggered-by-dev`   |
| Dev creates tag `v*`         | Dev pipeline runs, then triggers `triggered-by-release`|
| Push to automation repo main | Tests run automatically                               |
| Manual trigger               | Default pipeline runs all tests                       |

## Step 6: Configure Email Notifications (SendGrid)

Email notifications are sent to `Ahmed.Ali@originsysglobal.com` after every test run using [SendGrid](https://sendgrid.com/) SMTP.

### Bitbucket Pipelines

Go to **Automation repo > Repository Settings > Pipelines > Repository Variables** and add:

| Variable        | Value                          | Secured |
|-----------------|--------------------------------|---------|
| `SMTP_PASSWORD` | SendGrid API Key (SG.xxxxx...) | Yes     |

> `SMTP_SERVER`, `SMTP_PORT`, and `SMTP_USER` are already set in `bitbucket-pipelines.yml`.

### Jenkins

1. Go to **Manage Jenkins > Credentials > System > Global credentials**
2. Click **Add Credentials**
3. Configure:
   - **Kind**: Secret text
   - **Secret**: Your SendGrid API Key (`SG.xxxxx...`)
   - **ID**: `SENDGRID_API_KEY`
   - **Description**: SendGrid API Key for email notifications
4. Click **Save**

> `SMTP_SERVER`, `SMTP_PORT`, `SMTP_USER`, and `SMTP_PASSWORD` are already configured in the `Jenkinsfile` environment block.

### SendGrid Setup

1. Create a SendGrid account at [sendgrid.com](https://sendgrid.com/)
2. Go to [API Keys](https://app.sendgrid.com/settings/api_keys) and create a new key with **Mail Send** permission
3. Copy the generated key (starts with `SG.`)
4. Add `Ahmed.Ali@originsysglobal.com` as a [Verified Sender](https://app.sendgrid.com/settings/sender_auth/senders)

> **Note:** The `SMTP_USER` for SendGrid is always the literal string `apikey`. The `SMTP_PASSWORD` is your SendGrid API Key.

### Email Content

The email includes:
- Pass/Fail status with color-coded header
- Total, Passed, Failed, Skipped counts
- Failed test names and error messages
- Trigger info (branch, commit, release tag)
- Link to pipeline details

---

## Troubleshooting

### Pipeline not triggering?
- Verify Pipelines is enabled in both repos
- Check that `BB_AUTH_PASSWORD` app password has correct permissions
- Verify `BB_WORKSPACE` and `BB_AUTOMATION_REPO` slugs are correct (lowercase, hyphens)

### Tests failing with Chrome errors?
- The pipeline installs Chrome automatically
- Tests run in headless mode by default

### How to check trigger logs?
- Go to **Automation repo > Pipelines** tab
- Look for pipelines with "custom" trigger type
