# Getting started

## 1. Ensure that build processing is enabled
As of September 2018 any new projects already have this enabled.
For existing projects you may need to enable this setting. Projects added will have their builds
run through our new build ingestion and [configuration processing machinery](config-lifecycle.md).

To enabled this, goto your project settings => "Advanced Settings" and ensure that "Enable build processing" is set to "On"

## 2. Get the new CLI
Follow the directions for [Getting Started](https://github.com/CircleCI-Public/circleci-cli/blob/master/README.md#getting-started) in the `circleci-cli` README.

## 3. Set the "version" property to 2.1
Set the value of the top-level "version" key in your configuration file to have the value 2.1 to enable the 2.1 features.

## 4. Write your first orb
Generally, your first orb will be [written in-line](inline-orbs.md) inside your config.yml. You can use the new CLI to validate your configuration before committing and pushing it with git.

## 5. Run builds with your new configuration
When you push to your git repo that has been added in a project in CircleCI you will trigger builds as before, but if you look at the configuration on your job pages you will see it has been processed using the new machinery.
