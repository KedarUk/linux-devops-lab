# Add a shell syntax check with GitHub Actions

**Goal:** Run a Bash syntax check automatically when shell scripts are pushed or proposed in a pull request.

**Prerequisites:** A GitHub repository with Actions enabled and at least one `.sh` file. This check parses scripts; it does not execute them or prove that their behavior is correct.

## 1. Create the workflow file

Add a file at `.github/workflows/shell-syntax.yml` with this content:

```yaml
name: Shell syntax check

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

permissions:
  contents: read

jobs:
  syntax:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v6

      - name: Parse shell scripts
        shell: bash
        run: |
          set -euo pipefail
          mapfile -d '' scripts < <(
            find . -type f -name '*.sh' -not -path './.git/*' -print0
          )

          if (('${#scripts[@]}' == 0)); then
            echo "No shell scripts found."
            exit 0
          fi

          for script in "${scripts[@]}"; do
            echo "Checking ${script}"
            bash -n "${script}"
          done
```

The workflow checks scripts on pushes to `main`, on pull requests, and when manually started with `workflow_dispatch`. The checkout step makes repository files available to the runner. `bash -n` checks syntax without running the scripts.

## 2. Commit and view the run

Commit the workflow file and push it to GitHub. Open the repository's **Actions** tab, select **Shell syntax check**, and open the latest run to see each step's output.

Expected result: the job succeeds when all discovered shell files parse. If a script has a syntax error, the job fails and names the file being checked.

## 3. Try a controlled failure

In a throwaway branch, make a temporary copy of a script with an incomplete statement, such as:

```bash
if true; then
  echo "missing fi"
```

Push the branch and open a pull request. The workflow should fail at `bash -n`. Fix or discard the temporary change after observing the result.

## What this check does not catch

A script can have valid syntax and still behave incorrectly. Add separate tests for behavior, and use a linter such as ShellCheck to find common shell mistakes. Review third-party workflow actions and pin them according to your project's security policy.

## Key takeaway

A CI workflow gives fast feedback on proposed changes before they are merged. Keeping the check read-only and limited to syntax makes this a small first step toward testing shell automation.
