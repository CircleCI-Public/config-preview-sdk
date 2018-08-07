# What's new in 2.1 configuration?

1. **Build pre-processing** - We are refactoring our build ingestion system to pre-process configuration before running workflows or jobs. Centralizing configuration processing will allow us to provide much better and much earlier feedback on problems with the configuration itself, such as syntax errors or malformed semantics. This will also allow us to add various configuration "sugaring" techniques and make reusable, parameterizable configuration a reality. To use 2.1 configuration you must turn on the Build Processing option under the Advanced tab in your project settings.
2. **Reusable custom commands** - [Commands](commands.md) are parameterized sets of steps you declare that can be invoked as a step in a job. This will allow you to reduce repetitiveness in your code and encapsulate common set of steps, including the ability to call them with different parameters.
3. **Parameters in jobs** - Jobs can now declare [parameters](parameters.md) that can be passed in when invoking the job in a workflow. This allows you to reuse jobs or call them differently based on parameter inputs. You can also now run the same job multiple times with different parameter values on each.
4. **Reusable executors** - [Executors](executors.md) define the environment and other settings for executing jobs. They allow you to reuse configuration of your execution environment across jobs.
5. **Conditional steps in jobs** - The new `when` clause under steps allows you to run [conditionally run steps](conditional-steps.md) only when certain parameter values are true.
6. **Orbs** - Orbs are packages of CircleCI configuration that can be shared across projects. Orbs allow you to make a single bundle of jobs, commands, and executors that can reference each other and can be imported into a CircleCI build configuration and invoked in their own namespace. Orbs are registered with CircleCI, with revisions expressed using the [semver](https://semver.org/) pattern.

## Basic example
Using an orb in your build configuration might look something like:

```yaml
version: 2
orbs:
  s3: circleci/aws-s3@1

jobs:
  deploy:
    executor: s3/default
    steps:
      - s3/deploy:
          from: "somepath/somefile"
          to: $S3BUCKETURI
          overwrite: false
```

The above imports the `circleci/aws-tools` orb at revision 1.4.2, then invokes a command called `deploy` from that orb, passing in three parameters.

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
