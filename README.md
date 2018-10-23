# CircleCI Orbs (Preview)

## NOTE OCT 2018
We have moved the documentation for the new 2.1 features that are NOT about orbs specifically to our main docs site:
[https://circleci.com/docs/2.0/reusing-config/](https://circleci.com/docs/2.0/reusing-config/)

## Getting Started with Orbs Preview

Be sure to start with the [docs](/docs/README.md).

Also, you'll need to be sure to use the new [Build Processing setting](https://circleci.com/docs/2.0/build-processing/) on your projects.

Finally, be sure to get the new [circleci CLI](https://github.com/CircleCI-Public/circleci-cli/) or upgrade if you already have `circleci` installed.

## IMPORTANT: 2.1 Configuration Caveats
With the introduction of build processing we are making available version 2.1 of build configuration.

* Be sure to put `version: 2.1` at the top of your config.yml file.
* Parameter evaluation in configuration uses the syntax `<< parameters.foo >>`, so any use of `<<` in 2.1 or later will need to be escaped using a prefix of `\` if you are using it for things where you want it to be unevaluated in your shell commands, such as when used in a heredoc declaration. We may adjust this behavior in the future to do some auto-escaping, but it will always be safe to escape it when you want a literal `<<` to remain in your shell steps. 
* Local builds do not support 2.1 configuration. There is a work-around, however: You can use the new `circleci config process` command (requires upgrading your CLI to the new version) to process your configuration then save the result locally in your config.yml file and run it as a local build.
* If you use 2.1 configuration we will no longer support legacy syntax from early previews of 2.0 that no longer documented (mostly impacts companies that were very early adopters of CircleCI 2.0 during our initial previews). This includes old keys such as `shell` as a synonym for `run` and `setup_docker_engine` as a synonym for `setup_remote_docker`.
* Any code you write with 2.1 will only work with build processing on, so we recommend you work in a branch and only merge to your master once you're comfortable that you won't be turning build processing back off - if you turn off build processing any of the new configuration features introduced in 2.1 or later will cause your builds to fail.
 
## Staying informed
There are two ways to stay up-to-date with changes we make to our new configuration features:

1. Watch [this repo](https://github.com/CircleCI-Public/config-preview-sdk) on GitHub.
2. Get email updates from us about the configuration preview: [https://circle.ci/2HbCmKq](https://circle.ci/2HbCmKq).

## Giving Feedback
Add [issues](https://github.com/CircleCI-Public/config-preview-sdk/issues) to this repo.

## Documentation
The [docs](/docs/) in this repository cover the details of the new configuration features. 
