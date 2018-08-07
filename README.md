# CircleCI Build Config 2.1 (Preview)

## Getting Started
To use the new 2.1 configuration please turn on the "Build Processing" setting under "Advanced" on your project's Settings page. If you don't see this setting, it should appear in the next few days for you as we roll it out to more and more organizations.

A few highlight links to get going:

* [What's new in 2.1 config](docs/whats-new.md).
* [Docs on new 2.1 config](docs/README.md)
* [Design of the new build processing system](docs/design-approach.md)

## IMPORTANT: Preview Caveats
We are committed to achieving backwards compatibility in almost all cases, and we expect for most projects turning on build processing will have no effect on existing builds. Please let us know if you experience breaking builds that worked before you turned on build processing but broke once you turned it on.  

We are considering the new build processing system in preview until we have solved (crossed off) all of the following use cases (all of which are under development or slated soon as of August 2018):

* ~Builds can use the v2.1 config features~
* ~Works with GitHub webhooks~
* ~New API endpoint to trigger builds, including running all workflows in the build~
* ~All jobs run inside a Workflow part 1: workflow auto-wrapping for jobs called `build`~
* TODO: All jobs run inside a Workflow part 2: Fully backwards-compatible with existing API calls to trigger arbitrary jobs
* TODO: Auto-cancel redundant builds (including workflows)
* TODO: Solve UI for Rerun of a job (rerun the workflow of the job)
* TODO: Solve for full BitBucket support - API and webhooks

## Configuration version 2.1
With the introduction of build processing we are making available version 2.1 of build configuration.

A few things to keep in mind:

* If you use v2.1 configuration we will no longer support legacy syntax no longer documented (mostly impacts companies that were very early adopters of CircleCI 2.0 during our initial previews).

* Any code you write with v2.1 will only work with build processing on, so we recommend you work in a branch and only merge to your master once you're comfortable that you won't be turning build processing back off - if you turn off build processing any of the new config features introduced in 2.1 or later will cause your builds to fail.
 
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