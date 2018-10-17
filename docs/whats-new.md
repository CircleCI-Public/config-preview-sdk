# What's new with build processing? 

1. **Build processing** - CircleCI is currently in the process of refactoring the build ingestion system to pre-process configurations before running workflows or jobs. The new single-point-of-entry configuration processing enables CircleCI to provide better feedback much earlier related to problems with the configuration itself, such as syntax errors or malformed semantics. This new build process will enable CircleCI to add various configuration "sugaring" techniques and make reusable, parameterizable configuration a reality. To use a 2.1 configuration, you must turn on the Build Processing option under the "Advanced" tab in your project settings. If you look under the "Configuration" tab on a job detail page you will see both the configuration originally used and the configuration after it has been processed.
1. **All jobs run in workflows** - With this new build processing system, if you run an individual job CircleCI will automatically wrap that job in a workflow. This is performed in order to create a more consistent experience in both the UI and the underlying data and execution paths for jobs coming through the system. There are some subtle changes in the UI as a result; the most striking of which is that rather than re-running an individual job you will have the option to re-run the workflow that originally ran the job. For single-job builds, this change alters what is displayed when you choose to rebuild, but it should be functionally equivalent to the previous behaviors.

# What's new in 2.1 configuration?
1. **Workflows now share the config version with the rest of the config** - You no longer need a separate version under the `workflows` stanza in a configuration. This is because the config version only needs to be specified once at the top of your configuration file.
2. **Deprecation of some previous beta syntax** - For the very few people who used very early alpha versions of CircleCI 2.0, there were different names for certain built-in commands and parameters. There was an alternate syntax for steps - for example `type: run ...` instead of `run: ...`. These are deprecated, and some of these now display warnings while others are disallowed (including the legacy step syntax). (TODO: get the specific list.)
3. **Reusable custom commands** - [Commands](commands.md) are parameterized lists of steps you declare that can be invoked as a step in a job. This will allow you to reduce repetitiveness in your code and encapsulate common lists of steps, including the ability to call them with different parameters.
4. **Parameters in jobs** - Jobs can now declare [parameters](parameters.md) that can be passed in when invoking the job in a workflow. This allows you to reuse jobs or call them differently based on parameter inputs. You can also now run the same job multiple times with different parameter values for each.
5. **Reusable executors** - [Executors](executors.md) define the environment and other settings for executing jobs. They allow you to reuse a configuration of your execution environment across jobs.
6. **Conditional steps in jobs** - The new `when` clause under steps allows you to run [conditionally run steps](conditional-steps.md) only when certain parameter values are true.
7. **Orbs** - Orbs are packages of CircleCI configuration that can be shared across projects. Orbs allow you to make a single bundle of jobs, commands, and executors that can reference each other and can be imported into a CircleCI build configuration and invoked in their own namespace. Orbs are registered with CircleCI, with revisions expressed using the [semver](https://semver.org/) pattern.

## Basic example
Using an orb in your build configuration might look something like:

```yaml
version: 2.1
orbs:
  s3: circleci/aws-s3@1.4.2

jobs:
  deploy:
    executor: s3/default
    steps:
      - s3/deploy:
          from: "somepath/somefile"
          to: $S3BUCKETURI
          overwrite: false
```

The example shown above imports the `circleci/aws-tools` orb at revision 1.4.2, then invokes a command called `deploy` from that orb, passing in three parameters.

The code in the orb might look like:

```yaml
executors:
  default:
    parameters:
      tag:
        type: string
        default: "1.15"
    docker:
      - image: cibuilds/aws:<< parameters.tag >>
commands:
  deploy:
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
        default: false
        description: Boolean value for whether to overwrite the files
    steps:
      - run:
          name: Deploy to S3
          command: "aws s3 sync << parameters.from >> << parameters.to >><<# parameters.overwrite >> --delete<</ parameters.overwrite >>"
```
