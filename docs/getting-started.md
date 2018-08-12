# Getting started

## 1. Get your project added to the config preview
As of July 2018 you will need to have your projects individually added to the configuration preview. Projects added will have their builds run through our new build ingestion and [configuration processing machinery](config-lifecycle.md). Talk to your account team at CircleCI. Once the system is stabilized we will either allow an opt-in to the new system or run all builds through config processing. 

## 2. Get the new CLI 
Follow the directions for [Getting Started](https://github.com/CircleCI-Public/circleci-cli/blob/master/README.md#getting-started) in the `circleci-cli` README.

## 3. Set the "version" property to 2.1
Set the value of the top-level "version" key in your configuration file to have the value 2.1 to enable the 2.1 features.

## 4. Write your first orb
Generally, your first orb will be [written in-line](inline-orbs.md) inside your config.yml. You can use the new CLI to validate your configuration before committing and pushing it with git.

## 5. Run builds with your new configuration
When you push to your git repo that has been added in a project in CircleCI you will trigger builds as before, but if you look at the configuration on your job pages you will see it has been processed using the new machinery. 


