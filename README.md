# CircleCI Build Processing & 2.1 Configuration (Preview)

## Getting Started
You can turn on build processing at the bottom of the "Advanced" section of your project's settings. If you don't see this setting, it should appear in the next few days for you as we roll it out to more and more organizations.

You should also consider upgrading your `circleci` CLI to the new version. To do so, follow the instructions on the [circleci-cli repository](https://github.com/CircleCI-Public/circleci-cli/blob/master/README.md) for upgrading if you already have `circleci` installed, or installing from scratch if you haven't yet installed it.

## Why turn on build processing?
We will soon turn on build processing for all CircleCI 2.0 builds, but we are providing this opt-in period to provide earlier access to some new features that build processing will enable and to help us make transitions to the new system more gradual and less risky.

The new build processing feature enables the following:

1. Use of the [new configuration version 2.1 features](docs/whats-new.md)
2. Use of the new [API endpoint to trigger builds with workflows](https://circleci.com/docs/api/v1-reference/#new-project-build)
3. Auto-cancelation of redundant builds containing workflows (coming soon).

A few highlight links to get going:

* [What's new in version 2.1 of configuration](docs/whats-new.md).
* [Docs on new version 2.1 configuration features](docs/README.md)
* [Design of the new build processing system](docs/design-approach.md)

## IMPORTANT: Preview Caveats
We are committed to achieving backwards compatibility in almost all cases, and we expect for most projects turning on build processing will have no effect on existing builds. Please let us know if you experience breaking builds that worked before you turned on build processing but broke once you turned it on.  

We are considering the new build processing system in preview until we have solved (crossed off) all of the following use cases (all of which are under development or slated soon as of August 2018):

* ~Builds can use the 2.1 config features~
* ~Works with GitHub webhooks~
* ~New API endpoint to trigger builds, including running all workflows in the build~
* ~All jobs run inside a Workflow part 1: workflow auto-wrapping for jobs called `build`~
* ~Solve for full BitBucket support - API and webhooks~
* TODO: All jobs run inside a Workflow part 2: Fully backwards-compatible with existing API calls to trigger arbitrary jobs
* TODO: Make the new build triggering API endpoint accept parameters and workflow/job filters
* TODO: Auto-cancel redundant builds (including workflows)
* TODO: Solve UI for Rerun of a job (rerun the workflow of the job)

## IMPORTANT: 2.1 Configuration Caveats
With the introduction of build processing we are making available version 2.1 of build configuration.

* Parameter evaluation in configuration uses the syntax `<< parameters.foo >>`, so any use of `<<` in 2.1 or later will need to be escaped using a prefix of `\` if you are using it for things where you want it to be unevaluated in your shell commands, such as when used in a heredoc declaration. We may adjust this behavior in the future to do some auto-escaping, but it will always be safe to escape it when you want a literal `<<` to remain in your shell steps. 
* Local builds do not support 2.1 configuration. There is a work-around, however: You can use the new `circleci config expand` command (requires upgrading your CLI to the new version) to process your configuration then save the result locally in your config.yml file and run it as a local build.
* If you use 2.1 configuration we will no longer support legacy syntax from early previews of 2.0 that no longer documented (mostly impacts companies that were very early adopters of CircleCI 2.0 during our initial previews). This includes old keys such as `shell` as a synonym for `run` and `setup_docker_engine` as a synonym for `setup_remote_docker`.
* Any code you write with 2.1 will only work with build processing on, so we recommend you work in a branch and only merge to your master once you're comfortable that you won't be turning build processing back off - if you turn off build processing any of the new configuration features introduced in 2.1 or later will cause your builds to fail.
 
## Staying informed
There are two ways to stay up-to-date with changes we make to our new configuration features:

1. Watch [this repo](https://github.com/CircleCI-Public/config-preview-sdk) on GitHub.
2. Get email updates from us about the configuration preview: [https://circle.ci/2HbCmKq](https://circle.ci/2HbCmKq).

## Giving Feedback
1. Come to [CircleCI Discuss](https://discuss.circleci.com/t/2-1-config-and-build-processing/24102) to post feedback.
2. Tweet @circleci with thoughts
3. Add [issues](https://github.com/CircleCI-Public/config-preview-sdk/issues) to this repo.
4. Vote or add to our [Ideas board](https://circleci.com/ideas/)

## Documentation
The [docs](/docs/) in this repository cover the details of the new configuration features. 
