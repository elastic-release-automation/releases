# releases

Automate the release for the onboarded projects.

## How to use this?

Create a tag with the format `major.minor.patch`, i.e: `7.17.17`.

If the name of the branch contains a patch equal to `0` then it will run a minor release.

## How to onboard a new project?

### 1. Minor releases

If a minor release is needed then create a GitHub action called `.github/workflows/run-minor-release.yml`

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

      ...
```

Then do what's needed when a new minor release is requested.

### 2. Patch releases

If a patch release is needed then create a GitHub action called `.github/workflows/run-patch-release.yml`

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

      ...
```

Then do what's needed when a new patch release is requested.

### 3. Enable them in the orchestrator

Add the GitHub repository name in the [minor](./minor) or [patch](./patch) files.
