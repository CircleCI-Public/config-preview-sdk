# Pre and post steps
_The keys `pre-steps` and `post-steps` in jobs are available in configuration version 2.1 and later_

All jobs accept two special arguments of type `steps`: `pre-steps` and
`post-steps`.

If an orb user invokes a job with one or both of these arguments,
the job will run the steps in `pre-steps` first, before any other steps run, and
then it will run the steps in `post-steps` last, after any other steps run.

## Motivation

Pre- and post- steps allow users to be execute steps in a given job's environment
without modifying the orb. This is useful, for example, when a user imports a job
and wants to upload assets after it completes, or to run some custom setup steps
before job execution. Pre- and post- steps allow the user to make these additions
without modifying the imported job.

A `steps` parameter can be used for a similar purpose, passing steps into a job,
but it requires that the job be modified with an execution site for the parameter.

## Example of using pre- and post-steps

An orb `foo` might define a job:

```
# yaml from orb `foo`
jobs:
  bar:
    machine: true
    steps:
      - checkout
      - run:
          command: echo "building"
      - run:
          command: echo "testing"
```

Then an orb user could use the job as follows:
```
# config.yml
version: 2
orbs:
  foo: somenamespace/foo@1.2
workflows:
  version: 2
  build:
    jobs:
      - foo/bar:
          pre-steps:
            - run:
                command: echo "install custom dependency"
          post-steps:
            - run:
                command: echo "upload artifact to s3"
```

The resulting configuration would look like this:

```
version: 2
jobs:
  foo/bar:
    machine: true
    steps:
      - run:
          command: echo "install custom dependency"
      - checkout
      - run:
          command: echo "building"
      - run:
          command: echo "testing"
      - run:
          command: echo "upload artifact to s3"
workflows:
  version: 2
  build:
    jobs:
      - foo/bar
```
