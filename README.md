# CircleCI Config Preview SDK

_Caveat Emptor: This is preview software intended for those interested in seeing what we are working on with next-gen configuration. Use the configurations generated by this software at your own risk._

## Thank you for participating in our preview of config improvements
As we prepare to launch a set of new configuration features we appreciate the opportunity to work with you in validating and improving on our design choices for the next major wave of CircleCI configuration improvements. If you were invited to the preview by your CircleCI account team, please arrange with them to get on our discussion forum. If you have stumbled upon this repository we welcome you to look around and give us feedback by submitting issues on this repo.

## What problems are we trying to solve?
1. **Better [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) support:** CircleCI 2.0 original configuration was highly deterministic but also highly verbose and forced too much boiler plate or repeated code blocks. We aim to provide better first-class semantics to dramatically improve the DRY aspects of CircleCI configuration.

2. **Code Reuse across projects:** We hear from a lot of customers that they want better ways to share configuration across projects. This repo introduces Orbs, reusable packages of parameterizable CircleCI configuration elements.

3. **Easier path to common configuration:** We hear often that people want more off-the-shelf options to get their first useful builds flowing, especially for common platforms like Rails, Node, and they want better encapsulation of common tasks like deploying to Heroku or pushing to an S3 bucket.

## Major Features Previewed Here

1. **Configuration processing** - We are refactoring our build ingestion system to pre-process configuration before running workflows or jobs. Centralizing configuration processing will allow us to provide much better and much earlier feedback on problems with the configuration itself, such as syntax errors or malformed semantics. This will also allow us to add various configuration "sugaring" techniques and make reusable, parameterizable configuration a reality.
2. **Reusable Custom Commands** - Commands are parameterized sets of steps you declare that can be invoked as a step in a job. This will allow you to reduce repetitiveness in your code and encapsulate common set of steps, including the ability to call them with different parameters.
3. **Parameters in Jobs** - Jobs can now declare parameters that can be passed in when invoking the job in a workflow. This allows you to reuse jobs or call them differently based on parameter inputs. You can also now run the same job multiple times with different parameter values on each.
4. **Reusable Executors** - Executors define the environment and other settings for executing jobs. They allow you to reuse configuration of your execution environment across jobs.
5. **Orbs** - Orbs are packages of CircleCI configuration that can be shared across projects. Orbs allow you to make a single bundle of jobs, commands, and executors that can reference each other and can be imported into a CircleCI build configuration and invoked in their own namespace. Orbs are registered with CircleCI, with revisions expressed using the [semver](https://semver.org/) pattern.

## Basic Example
To use an orb in your build configuration it might look something like:

```
version: 2
import:
  s3: circleci/aws-tools@1.4.2

jobs:
  deploy:
    docker:
      - image: circleci/node:latest
    steps:
      - s3/deploy:
          from: "somepath/somefile"
          to: $S3BUCKETURI
          overwrite: "false"
```

The above imports the `circleci/aws-tools` orb at revision 1.4.2, then invokes a command called `deploy` from that orb, passing in three parameters.

The code in the orb for the `deploy` command might look like:

```
description: "A simple encapsulation of doing an s3 sync"
parameters:
  from:
    type: string
    description: A directory path local to the job to deploy to S3
  to:
    type: string
    description: A URI to an S3 bucket
  overwrite:
    type: boolean
    default: "false"
    description: Boolean value for whether to overwrite the files
steps:
  - run:
      name: Deploy to S3
      command: "aws s3 sync << parameters.from >> << parameters.to >><<# parameters.overwrite >> --delete<</ parameters.overwrite >>"
```


## Staying Informed
There are two ways to stay up-to-date with changes we make to our new configuration features:

1. Watch [this repo](https://github.com/CircleCI-Public/config-preview-sdk) on GitHub 
2. Get email updates from us: [https://circle.ci/2HbCmKq](https://circle.ci/2HbCmKq)

## Getting Started
Please look over the [docs](/docs/) on orbs to understand how they are authored. To develop your first orb we recommend creating a separate repository for it, though that is not strictly necessary.

We will soon post instructions for downloading the tooling to try writing your own orbs.

