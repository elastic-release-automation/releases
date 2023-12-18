# How to onboard a new project manually?

### 1. Minor releases

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

### 2. Patch releases

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

### 3. Enable them in the orchestrator

Add the GitHub repository name in the [minor](./minor) or [patch](./patch) files.

### 4. Grant write access to the apmmachine

The relevant machine account should be granted write permissions.
