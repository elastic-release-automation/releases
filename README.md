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

[Read this](MANUAL.md).