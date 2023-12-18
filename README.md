# releases

Automate the release for the onboarded projects using Git tags with Semver.

## Why

Git tags act as GitHub events. Hence, there is no need to use the GitHub UI.

## How to use this?

It is as simple as creating a git tag with the format `major.minor.patch`, `i.e.`, `7.17.17`.
If the branch name contains a patch equal to `0`, it will run a minor release.

Then, the existing [GitHub action](https://github.com/elastic-release-automation/releases/actions/workflows/run-release.yml) will orchestrate the automation in all the onboarded projects.

## How to onboard a new project?

### :robot: Automatically

Grant write access to `apmmachine` in your GitHub repository and [raise this issue](https://github.com/elastic-release-automation/releases/issues/new?assignees=&labels=onboarding-automation%2Cautomation&projects=&template=onboarding-issue.yml&title=%5Brelease+onboarding%5D+request).
Then, wait for the automation to create all the scaffolding for you.

### Manually

#### 1. Minor releases

If a minor release is needed, create a GitHub action called `.github/workflows/run-minor-release.yml`.

<details><summary>Expand to view</summary>
<p>

```yaml
---
name: run-minor-release

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'The version (semver format: major.minor.patch)'
        required: true
        type: string

permissions:
  contents: read

# Avoid concurrency so we can watch the releases correctly
concurrency:
  group: ${{ github.workflow }}

jobs:
  run-minor:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo 'add your code'
```
</p>
</details>

Then, do what's required when a new minor release is requested.

#### 2. Patch releases

If a patch release is needed, then create a GitHub action called `.github/workflows/run-patch-release.yml`


<details><summary>Expand to view</summary>
<p>

```yaml
---
name: run-patch-release

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'The version (semver format: major.minor.patch)'
        required: true
        type: string

permissions:
  contents: read

# Avoid concurrency so we can watch the releases correctly
concurrency:
  group: ${{ github.workflow }}

jobs:
  run-patch:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - run: echo 'add your code'
```
</p>
</details>

Then, do what's required when a new patch release is requested.

#### 3. Enable them in the orchestrator

Add the GitHub repository name in the [minor](./minor) or [patch](./patch) files.

#### 4. Grant write access to the apmmachine

The relevant machine account should be granted write permissions.
